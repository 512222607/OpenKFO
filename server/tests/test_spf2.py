import struct
import tempfile
import unittest
import zlib
from pathlib import Path
from server.kk_local.maps import ClientConfig
from server.kk_local.spf2 import CONFIG_KEY, decode_config, parse_paths


class Spf2Tests(unittest.TestCase):
    def test_real_reader_with_synthetic_package_and_rejections(self):
        raw = b'<?xml version="1.0"?><MapInfo/>'
        compressed = zlib.compress(raw)
        encoded = bytes(v ^ 255 ^ CONFIG_KEY[i % len(CONFIG_KEY)] for i, v in enumerate(compressed))
        tree = struct.pack('<I8sI', 1, b'/mapmgr.', 16) + struct.pack('<I8sI', 1, b'xml', 0xff000000)
        header = bytearray(64)
        header[:18] = b'SGDP Package File.'
        struct.pack_into('<II', header, 32, 32, 2)
        tree_offset = 68 + len(encoded)
        table_offset = tree_offset + len(tree)
        struct.pack_into('<4I', header, 40, tree_offset, table_offset, table_offset + 8, 1)
        table = struct.pack('<II', 64, len(encoded))
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'config.spf2'
            path.write_bytes(header + struct.pack('<I', 0x2200) + encoded + tree + table * 2)
            self.assertEqual(ClientConfig(path).xml('mapmgr.xml').tag, 'MapInfo')
        for malformed in (tree[:10], struct.pack('<I8sI', 1, b'/mapmgr.', 0),
                          struct.pack('<I8sI', 1, b'/mapmgr', 0xff000001)):
            with self.assertRaises(ValueError):
                parse_paths(malformed, 1)
        with self.assertRaises(ValueError):
            decode_config(encoded, limit=4)
        with self.assertRaises(ValueError):
            decode_config(encoded[:-1])


if __name__ == '__main__':
    unittest.main()

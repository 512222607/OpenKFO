"""Bounded reader for the installed SGDP v2 configuration package.

The 8-byte radix labels, 0xff leaf tag and repeating transform were checked
against all 898 entries of the local Data/config.spf2. No client DLL is loaded.
"""
import struct
import zlib


CONFIG_KEY = b'F48A715746514613BD70EF276119128F'


def parse_paths(data, count):
    pending = [(0, b'')]
    seen = set()
    paths = {}
    intervals = []
    while pending:
        offset, prefix = pending.pop()
        if offset in seen or not 0 <= offset <= len(data) - 4:
            raise ValueError('invalid_config_tree_pointer')
        seen.add(offset)
        size = struct.unpack_from('<I', data, offset)[0]
        end = offset + 4 + size * 12
        if not 1 <= size <= count or end > len(data):
            raise ValueError('invalid_config_tree_node')
        intervals.append((offset, end))
        for position in range(offset + 4, end, 12):
            label, target = struct.unpack_from('<8sI', data, position)
            path = prefix + label.split(b'\0', 1)[0]
            if not path or len(path) > 1024:
                raise ValueError('invalid_config_path_length')
            if target >> 24 == 0xff:
                index = target & 0xffffff
                if index >= count or index in paths:
                    raise ValueError('invalid_config_entry_index')
                paths[index] = path.decode('gb18030')
            else:
                pending.append((target, path))
        if len(seen) + len(pending) > len(data) // 16:
            raise ValueError('invalid_config_tree_size')
    intervals.sort()
    if any(a[1] > b[0] for a, b in zip(intervals, intervals[1:])):
        raise ValueError('overlapping_config_tree_nodes')
    if len(paths) != count:
        raise ValueError('incomplete_config_index')
    return paths


def decode_config(data, limit=8 * 1024 * 1024):
    compressed = bytes(value ^ 0xff ^ CONFIG_KEY[i % len(CONFIG_KEY)]
                       for i, value in enumerate(data))
    decoder = zlib.decompressobj()
    try:
        result = decoder.decompress(compressed, limit + 1)
    except zlib.error as error:
        raise ValueError('invalid_config_compression') from error
    if len(result) > limit or not decoder.eof or decoder.unused_data:
        raise ValueError('invalid_config_decompressed_size_or_stream')
    return result

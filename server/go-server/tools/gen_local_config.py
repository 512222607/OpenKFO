"""One-time read-only generation of config.json from the installed client.

Reuses server.kk_local.maps.MapCatalog so map IDs, groups and the
config.spf2 hash come from the actual client, never hand-written.
Run:  python tools/gen_local_config.py <client_root> <output_json>
"""
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))
from server.kk_local.maps import MapCatalog


def main():
    client = Path(sys.argv[1]).resolve()
    output = Path(sys.argv[2])
    catalog = MapCatalog.from_client(client)
    package = client / "Data" / "config.spf2"
    # Character choices mirror cmd/protocol-tester/character_tls_test.go,
    # whose seven-slot table passed the native naming flow end to end.
    items = [152002, 132002, 122001, 172002, 162003, 142002, 253002]
    config = {
        "config_hash": hashlib.sha256(package.read_bytes()).hexdigest(),
        "pools": {
            f"{mode}:{capacity}": list(catalog.eligible(mode, capacity))
            for mode in (0, 1, 2, 3, 5)
            for capacity in (2, 4, 6, 8)
        },
        "groups": {str(key): sorted(value) for key, value in catalog.groups.items()},
        "character_choices": [
            {"gender": 2, "slot": slot, "choice": 900 + slot, "item": item}
            for slot, item in enumerate(items)
        ],
        "settlement": {
            "win_gold": 5, "loss_gold": 2, "draw_gold": 0,
            "win_experience": 10, "loss_experience": 5, "draw_experience": 0,
        },
    }
    summary = catalog.summary()
    print(f"registered maps: {summary['registered']}, resource ready: {summary['resource_ready']}")
    print(f"unavailable: {[m['id'] for m in summary['unavailable']]}")
    print(f"config_hash: {config['config_hash']}")
    output.write_text(json.dumps(config, indent=2), encoding="utf-8")
    print(f"written: {output}")


if __name__ == "__main__":
    main()

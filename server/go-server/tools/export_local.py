"""One-time read-only export; Python is not used by the online service."""
import base64
import hashlib
import json
from pathlib import Path
import sqlite3
import sys

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))
from server.kk_local.maps import MapCatalog
from server.kk_local import packets, wire


def encoded(raw):
    return base64.b64encode(raw).decode("ascii")


def export():
    output = ROOT / "runtime-local/go-online"
    output.mkdir(parents=True, exist_ok=True)
    source = sqlite3.connect((ROOT / "runtime-local/accounts.sqlite3").as_uri() + "?mode=ro", uri=True)
    database = sqlite3.connect(":memory:")
    source.backup(database)
    source.close()
    accounts = []
    for row in database.execute("""SELECT a.uid,a.account,a.nickname,a.profile,
        c.salt,c.digest,l.salt,l.digest,COALESCE(g.balance,0),COALESCE(t.balance,0)
        FROM accounts a JOIN auth_credentials c ON a.uid=c.uid
        JOIN auth_legacy_credentials l ON a.uid=l.uid
        LEFT JOIN gold_wallet g ON a.uid=g.uid LEFT JOIN ticket_wallet t ON a.uid=t.uid"""):
        account = dict(zip(("uid", "account", "nickname", "profile", "salt", "digest", "legacy_salt", "legacy_digest", "gold", "tickets"), row))
        for field in ("profile", "salt", "digest", "legacy_salt", "legacy_digest"):
            account[field] = encoded(account[field])
        account["inventory"] = [encoded(record) for record, in database.execute("SELECT record FROM inventory WHERE uid=? ORDER BY instance", (account["uid"],))]
        accounts.append(account)
    offers = []
    for key, category, variant, record, grant in database.execute("""SELECT s.catalog_key,s.category,s.variant,s.record,g.grant_template
        FROM shop_catalog s JOIN gold_offers g ON s.catalog_key=g.catalog_key
        WHERE s.record=g.catalog_record ORDER BY s.catalog_key"""):
        offers.append(dict(key=key, category=category, variant=variant, record=encoded(record), grant=encoded(grant)))
    if len({offer["key"] for offer in offers}) != len(offers):
        raise ValueError("duplicate catalog keys require explicit normalization")
    if database.execute("SELECT COUNT(*) FROM shop_catalog").fetchone()[0] != len(offers):
        raise ValueError("not all catalog rows have qualified grant templates")
    if not accounts:
        raise ValueError("no password accounts to migrate")
    (output / "accounts-export.json").write_text(json.dumps(dict(accounts=accounts, offers=offers)), encoding="utf-8")
    client = ROOT / "runtime-local/client"
    catalog = MapCatalog.from_client(client)
    config = dict(config_hash=hashlib.sha256((client / "Data/config.spf2").read_bytes()).hexdigest(),
                  pools={f"{mode}:{capacity}": catalog.eligible(mode, capacity) for mode in (0, 1, 2, 3, 5) for capacity in (2, 4, 6, 8)},
                  groups={str(key): sorted(value) for key, value in catalog.groups.items()})
    (output / "config.json").write_text(json.dumps(config, indent=2), encoding="utf-8")
    database.close()
    print(f"Exported {len(accounts)} accounts and {len(offers)} offers; secrets not printed.")


def vectors():
    fixtures = []
    for key in range(11):
        for length in (0, 1, 7, 8, 9, 68, 360):
            message = wire.Message(1151, bytes((index * 29 + key) % 256 for index in range(length)))
            fixtures.append(dict(id=message.id, payload=encoded(message.payload), key=key, frame=encoded(wire.encode_game(message, key))))
    messages = [packets.login_ack("localtest", 1003), packets.login_directory(18001), *packets.catalog(18001), packets.lobby_context(18001)]
    path = ROOT / "server/go-server/internal/protocol/testdata/python-vectors.json"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(dict(frames=fixtures, packets=[dict(id=message.id, payload=encoded(message.payload)) for message in messages])), encoding="utf-8")
    print(f"Generated {len(fixtures)} native wire reference vectors.")


if __name__ == "__main__":
    vectors()
    export()

"""Run only the UDP 5136 SDP2P listener beside an already running v4 TCP lab."""

from __future__ import annotations

from pathlib import Path
import sys
import threading
import time


PROJECT = Path(__file__).resolve().parents[4]
LAB = PROJECT / "research" / "2026-09-06" / "work" / "login-to-world"
sys.path.insert(0, str(LAB))

import lab_server_v4 as lab_server  # noqa: E402


def main() -> int:
    stop_file = LAB / "lab-stop-v4"
    server = lab_server.P2PUDPServer(("127.0.0.1", 5136), lab_server.P2PUDPHandler)
    server.role_uid = 1001

    def stop_when_requested() -> None:
        while not stop_file.exists():
            time.sleep(0.25)
        server.shutdown()

    threading.Thread(target=stop_when_requested, daemon=True).start()
    print("P2P UDP sidecar ready on 127.0.0.1:5136; synthetic UID 1001", flush=True)
    try:
        server.serve_forever(poll_interval=0.25)
    finally:
        server.server_close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

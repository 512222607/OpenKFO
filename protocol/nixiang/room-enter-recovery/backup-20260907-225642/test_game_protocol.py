import json
from pathlib import Path
import struct
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parent))
from game_protocol import GameFrameStream, decode_frame, encode_frame, header_guard
from role_protocol import (
    DEFAULT_ROOM_ID,
    ROOM_CREATE_REQUEST_SIZE,
    ROOM_CONTEXT_SLOT_SIZE,
    ROOM_CONTEXT_SLOT_VALUE,
    ROOM_CONTEXT_WIRE_SIZE,
    ROOM_CREATE_ACK_SIZE,
    ROOM_ENTER_ACK_OK,
    ROOM_ENTER_REQUEST_SIZE,
    ROOM_ENTER_ACK_SIZE,
    ROOM_ID_OFFSET,
    ROOM_LIST_ENTRY_FLAG,
    ROOM_LIST_ENTRY_SIZE,
    ROOM_LIST_WIRE_SIZE,
    ROOM_LIST_FLAG_OFFSET,
    ROOM_MODE_OFFSET,
    ROOM_MODE_STATUS_FIELD_COUNT,
    ROOM_MODE_STATUS_VALUE,
    ROOM_MODE_STATUS_WIRE_SIZE,
    ROOM_PAGE_HEADER_SIZE,
    ROOM_POST_ENTER_2540_REQUEST_SIZE,
    ROOM_POST_ENTER_2560_REQUEST_SIZE,
    ROOM_POST_ENTER_DEFAULT_NAME,
    ROOM_POST_ENTER_NAME_OFFSET,
    ROOM_POST_ENTER_PLAYER_SIZE,
    ROOM_STATE_SIZE,
    ROOM_STATUS_COLOR,
    RoleSession,
    build_room_context_payload,
    build_room_create_ack_payload,
    build_room_enter_ack_payload,
    build_room_list_payload,
    build_room_mode_status_payload,
    build_room_page_payload,
    build_room_post_enter_player_payload,
    build_room_state_payload,
)


CAPTURED_BLOCK = bytes.fromhex(
    "eeaaa88870000000a02f4e617e31666731308e1a0f3b95ef0113cde00f3b95ef0713e5a6962c0384e"
    "c968a2adb749e49a8b944eec2765397a9c70de90f3b95ef0113c5609b3b952f125d066d5e7098a24d5"
    "e81eb1e76de220d93d1e054a3cd32598ac9ac033b95ef0113cde00f3b95ef00134d617e316664"
    "eeaa88881000000030304e614631666430304e617e316664"
)


class GameProtocolTests(unittest.TestCase):
    def test_decodes_real_login_and_heartbeat(self):
        stream = GameFrameStream()
        frames = stream.feed(CAPTURED_BLOCK)
        self.assertEqual(len(frames), 2)

        login = decode_frame(frames[0])
        self.assertEqual((login.message_id, login.key_index, len(login.payload)), (1010, 0, 96))
        self.assertEqual(int.from_bytes(login.payload[:8], "little"), 1001)
        self.assertIn(b"C8-7F-54-51-D4-53", login.payload)
        self.assertIn(b"labuser01", login.payload)

        heartbeat = decode_frame(frames[1])
        self.assertEqual((heartbeat.message_id, heartbeat.key_index, heartbeat.payload), (0, 7, b""))

    def test_round_trip_all_keys_and_padding_boundaries(self):
        for key_index in range(11):
            for size in (0, 1, 7, 8, 9, 37, 96):
                payload = bytes((i * 37 + size) & 0xFF for i in range(size))
                decoded = decode_frame(encode_frame(1020, payload, key_index))
                self.assertEqual((decoded.message_id, decoded.key_index, decoded.payload), (1020, key_index, payload))

    def test_stream_reassembles_fragmented_and_concatenated_frames(self):
        expected = [encode_frame(1010, b"abc", 2), encode_frame(0, b"", 5)]
        wire = b"garbage" + b"".join(expected)
        stream = GameFrameStream()
        actual = []
        for byte in wire:
            actual.extend(stream.feed(bytes([byte])))
        self.assertEqual(actual, expected)
        self.assertEqual(stream.discarded_bytes, len(b"garbage"))

    def test_outer_guard_matches_capture(self):
        self.assertEqual(header_guard(0x70), 0x88A8)
        self.assertEqual(header_guard(0x10), 0x8888)

    def test_configured_login_sequence_sizes(self):
        control = json.loads((Path(__file__).parent / "lab-control.json").read_text(encoding="utf-8-sig"))
        responses = control["game"]["1010"]
        enabled = [item for item in responses if item.get("enabled", True)]
        self.assertEqual([item["message_id"] for item in enabled], [1020, 1125])
        self.assertEqual(len(bytes.fromhex(responses[0]["payload_hex"])), 37)
        create_options = bytes.fromhex(responses[1]["payload_hex"])
        self.assertEqual(len(create_options), 56 * 16)
        records = [create_options[i : i + 16] for i in range(0, len(create_options), 16)]
        actual_records = [
            tuple(int.from_bytes(record[j : j + 4], "little") for j in range(0, 16, 4))
            for record in records
        ]
        appearance_ids = {
            1: [
                [151000, 151001, 151002, 151003],
                [131000, 131001, 131003, 131004],
                [121000, 121001, 121002, 121003],
                [171000, 171001, 171002, 171003],
                [161000, 161001, 161002, 161003],
                [141000, 141001, 141002, 141003],
                [253000, 253001, 253002, 253003],
            ],
            2: [
                [152000, 152001, 152002, 152003],
                [132000, 132001, 132002, 132003],
                [122000, 122001, 122002, 122003],
                [172000, 172001, 172002, 172003],
                [162001, 162002, 162003, 162004],
                [142000, 142001, 142002, 142003],
                [253000, 253001, 253002, 253003],
            ],
        }
        expected_records = [
            (gender, slot, appearance_id, appearance_id)
            for gender in (1, 2)
            for slot, slot_ids in enumerate(appearance_ids[gender])
            for appearance_id in slot_ids
        ]
        self.assertEqual(actual_records, expected_records)
        self.assertFalse(responses[2].get("enabled", True))
        self.assertEqual(len(bytes.fromhex(responses[2]["payload_hex"])), 360)
        self.assertEqual(int.from_bytes(bytes.fromhex(responses[2]["payload_hex"])[:4], "little"), 1001)

    def test_sdk_server_list_uses_nonzero_selectable_id_and_full_metadata(self):
        control = json.loads((Path(__file__).parent / "lab-control.json").read_text(encoding="utf-8-sig"))
        wire = bytes.fromhex(control["sdo"]["1011"])
        payload = wire[8:]
        self.assertEqual(struct.unpack_from("<H", payload, 0)[0], 1012)
        self.assertEqual(struct.unpack_from(">H", payload, 2)[0], 1)
        server_id, ip_value, port, players, flag, extra_size = struct.unpack_from(">IIHHBB", payload, 4)
        self.assertEqual(server_id, 1)
        self.assertEqual(ip_value, 0x0100007F)
        self.assertEqual((port, players, flag, extra_size), (10035, 0, 1, 44))
        extra = payload[18:]
        self.assertEqual(len(extra), 44)
        self.assertEqual(struct.unpack_from("<H", extra, 0)[0], 1000)
        self.assertEqual(extra[24:].split(b"\0", 1)[0].decode("gbk"), "本地测试服")

    def test_create_request_uses_safe_observation_response(self):
        control = json.loads((Path(__file__).parent / "lab-control.json").read_text(encoding="utf-8-sig"))
        response = control["game"]["1150"]
        self.assertEqual(response["message_id"], 1152)
        self.assertEqual(response["key_index"], 0)
        self.assertEqual(bytes.fromhex(response["payload_hex"]), b"\x00\x00")
        self.assertNotEqual(response["message_id"], 1151)

    def test_room_create_response_matches_3020_room_id_ack_builder(self):
        control = json.loads((Path(__file__).parent / "lab-control.json").read_text(encoding="utf-8-sig"))
        response = control["game"]["3010"]
        payload = bytes.fromhex(response["payload_hex"])

        self.assertEqual(response["message_id"], 3020)
        self.assertEqual(response["key_index"], 0)
        self.assertEqual(payload, build_room_create_ack_payload())
        self.assertEqual(len(payload), ROOM_CREATE_ACK_SIZE)
        self.assertEqual(struct.unpack_from("<I", payload, 0)[0], DEFAULT_ROOM_ID)

    def test_room_state_payload_matches_3030_candidate_builder(self):
        payload = build_room_state_payload()

        self.assertEqual(len(payload), ROOM_STATE_SIZE)
        self.assertEqual(struct.unpack_from("<I", payload, ROOM_MODE_OFFSET)[0], ROOM_STATUS_COLOR)
        self.assertEqual(payload[ROOM_LIST_FLAG_OFFSET], ROOM_LIST_ENTRY_FLAG)
        self.assertEqual(struct.unpack_from("<I", payload, ROOM_ID_OFFSET)[0], DEFAULT_ROOM_ID)

    def test_room_create_session_pushes_3020_ack_then_3030_state(self):
        session = RoleSession(store=None, uid=1001, options={})
        replies = session.handle(
            3010,
            bytes(ROOM_CREATE_REQUEST_SIZE),
            {"room_stage": {"push_room_state_3030_after_create": True}},
        )

        self.assertEqual([reply["message_id"] for reply in replies], [3020, 3030])
        self.assertEqual(bytes.fromhex(replies[0]["payload_hex"]), build_room_create_ack_payload())
        self.assertEqual(bytes.fromhex(replies[1]["payload_hex"]), build_room_state_payload())
        self.assertEqual(len(bytes.fromhex(replies[1]["payload_hex"])), ROOM_STATE_SIZE)

    def test_room_create_session_can_push_20564_context_after_create(self):
        session = RoleSession(store=None, uid=1001, options={})
        replies = session.handle(
            3010,
            bytes(ROOM_CREATE_REQUEST_SIZE),
            {
                "room_stage": {
                    "push_room_state_3030_after_create": False,
                    "push_room_context_20564_after_create": True,
                }
            },
        )

        self.assertEqual([reply["message_id"] for reply in replies], [3020, 20564])
        self.assertEqual(bytes.fromhex(replies[0]["payload_hex"]), build_room_create_ack_payload())
        self.assertEqual(bytes.fromhex(replies[1]["payload_hex"]), build_room_context_payload())
        self.assertEqual(len(bytes.fromhex(replies[1]["payload_hex"])), ROOM_CONTEXT_WIRE_SIZE)

    def test_room_enter_ack_payload_matches_20560_success_candidate(self):
        payload = build_room_enter_ack_payload()

        self.assertEqual(payload, bytes([ROOM_ENTER_ACK_OK]))
        self.assertEqual(len(payload), ROOM_ENTER_ACK_SIZE)

    def test_room_create_session_can_push_20560_enter_ack_after_create(self):
        session = RoleSession(store=None, uid=1001, options={})
        replies = session.handle(
            3010,
            bytes(ROOM_CREATE_REQUEST_SIZE),
            {
                "room_stage": {
                    "push_room_state_3030_after_create": False,
                    "push_room_context_20564_after_create": True,
                    "push_room_enter_ack_20560_after_create": True,
                }
            },
        )

        self.assertEqual([reply["message_id"] for reply in replies], [3020, 20564, 20560])
        self.assertEqual(bytes.fromhex(replies[0]["payload_hex"]), build_room_create_ack_payload())
        self.assertEqual(bytes.fromhex(replies[1]["payload_hex"]), build_room_context_payload())
        self.assertEqual(bytes.fromhex(replies[2]["payload_hex"]), build_room_enter_ack_payload())
        self.assertEqual(len(bytes.fromhex(replies[2]["payload_hex"])), ROOM_ENTER_ACK_SIZE)

    def test_room_enter_session_answers_20540_with_20560_success(self):
        session = RoleSession(store=None, uid=1001, options={})
        replies = session.handle(20540, bytes(ROOM_ENTER_REQUEST_SIZE), {"room_stage": {}})

        self.assertEqual([reply["message_id"] for reply in replies], [20560])
        self.assertEqual(bytes.fromhex(replies[0]["payload_hex"]), build_room_enter_ack_payload())

    def test_room_post_enter_player_payload_matches_25xx_candidate(self):
        payload = build_room_post_enter_player_payload(uid=1001)

        self.assertEqual(len(payload), ROOM_POST_ENTER_PLAYER_SIZE)
        self.assertEqual(struct.unpack_from("<Q", payload, 0)[0], 1001)
        self.assertEqual(struct.unpack_from("<I", payload, 29)[0], DEFAULT_ROOM_ID)
        encoded_name = ROOM_POST_ENTER_DEFAULT_NAME.encode("gbk")
        self.assertEqual(
            payload[ROOM_POST_ENTER_NAME_OFFSET:ROOM_POST_ENTER_NAME_OFFSET + len(encoded_name)],
            encoded_name,
        )

    def test_room_post_enter_session_answers_2540_and_2560(self):
        session = RoleSession(store=None, uid=1001, options={})
        room_stage = {"room_stage": {"enable_post_enter_25xx": True}}

        ready = session.handle(2540, bytes(ROOM_POST_ENTER_2540_REQUEST_SIZE), room_stage)
        sync = session.handle(2560, bytes(ROOM_POST_ENTER_2560_REQUEST_SIZE), room_stage)

        self.assertEqual([reply["message_id"] for reply in ready], [2550])
        self.assertEqual([reply["message_id"] for reply in sync], [2570])
        self.assertEqual(bytes.fromhex(ready[0]["payload_hex"]), build_room_post_enter_player_payload(uid=1001))
        self.assertEqual(bytes.fromhex(sync[0]["payload_hex"]), build_room_post_enter_player_payload(uid=1001))

    def test_room_list_response_matches_2500_padded_list_builder(self):
        control = json.loads((Path(__file__).parent / "lab-control.json").read_text(encoding="utf-8-sig"))
        response = control["game"]["2250"]
        payload = bytes.fromhex(response["payload_hex"])

        self.assertEqual(response["message_id"], 2500)
        self.assertEqual(response["key_index"], 0)
        self.assertEqual(payload, build_room_list_payload())
        self.assertEqual(len(payload), ROOM_LIST_WIRE_SIZE)
        self.assertEqual(ROOM_LIST_WIRE_SIZE, 4 + 100 * ROOM_LIST_ENTRY_SIZE)
        self.assertEqual(struct.unpack_from("<I", payload, 0)[0], 1)
        room_id, first_value, second_value = struct.unpack_from("<III", payload, 4)
        self.assertEqual((room_id, first_value, second_value, payload[16]), (DEFAULT_ROOM_ID, 0, 0, ROOM_LIST_ENTRY_FLAG))
        self.assertEqual(payload[17:], bytes(ROOM_LIST_WIRE_SIZE - 17))

    def test_room_page_response_matches_2580_empty_page_builder(self):
        control = json.loads((Path(__file__).parent / "lab-control.json").read_text(encoding="utf-8-sig"))
        response = control["game"]["2260"]
        payload = bytes.fromhex(response["payload_hex"])

        self.assertFalse(response.get("enabled", True))
        self.assertEqual(response["message_id"], 2580)
        self.assertEqual(response["key_index"], 0)
        self.assertEqual(payload, build_room_page_payload())
        self.assertEqual(len(payload), ROOM_PAGE_HEADER_SIZE)
        self.assertEqual(struct.unpack_from("<II", payload, 0), (0, 1))

    def test_room_context_response_matches_20564_builder(self):
        control = json.loads((Path(__file__).parent / "lab-control.json").read_text(encoding="utf-8-sig"))
        response = control["game"]["20544"]
        payload = bytes.fromhex(response["payload_hex"])

        self.assertEqual(response["message_id"], 20564)
        self.assertEqual(response["key_index"], 0)
        self.assertEqual(payload, build_room_context_payload())
        self.assertEqual(len(payload), ROOM_CONTEXT_WIRE_SIZE)
        self.assertEqual(ROOM_CONTEXT_WIRE_SIZE, 5 * ROOM_CONTEXT_SLOT_SIZE)
        self.assertEqual(struct.unpack_from("<II", payload, 0), (DEFAULT_ROOM_ID, ROOM_CONTEXT_SLOT_VALUE))
        self.assertEqual(payload[ROOM_CONTEXT_SLOT_SIZE:], bytes(ROOM_CONTEXT_WIRE_SIZE - ROOM_CONTEXT_SLOT_SIZE))

    def test_room_mode_status_response_matches_20566_candidate_builder(self):
        payload = build_room_mode_status_payload()

        self.assertEqual(len(payload), ROOM_MODE_STATUS_WIRE_SIZE)
        fields = struct.unpack("<" + "I" * ROOM_MODE_STATUS_FIELD_COUNT, payload)
        self.assertEqual(fields, (ROOM_MODE_STATUS_VALUE, 0, 0, 0, 0, 0, 0))

    def test_room_mode_status_session_can_answer_20546(self):
        session = RoleSession(store=None, uid=1001, options={})
        replies = session.handle(20546, b"", {"room_stage": {"enable_room_mode_20566": True}})

        self.assertEqual([reply["message_id"] for reply in replies], [20566])
        self.assertEqual(bytes.fromhex(replies[0]["payload_hex"]), build_room_mode_status_payload())
        self.assertEqual(len(bytes.fromhex(replies[0]["payload_hex"])), ROOM_MODE_STATUS_WIRE_SIZE)


if __name__ == "__main__":
    unittest.main()

package protocol

// Native room_requests.py layouts, reference e2c61c4.
const (
	MsgRoomInvite          uint32 = 3500
	MsgRoomInviteAccept    uint32 = 3501
	MsgRoomInviteDecline   uint32 = 3502
	MsgRoomWaitingTimeout  uint32 = 4031
	MsgRoomWaitingExpired  uint32 = 4032
	RoomInviteSize                = 39
	RoomInviteAcceptSize          = 18
	RoomInviteDeclineSize         = 37
	RoomInviteNameOffset          = 8
	RoomInviteTargetOffset        = 29
	RoomInviteRoomOffset          = 37
)

package protocol

// 8263A0/81EBB0 consume a uint32 count followed by expired instance IDs.
const (
	MsgExpiredItemsRequest uint32 = 2110
	MsgExpiredItems        uint32 = 2120
)

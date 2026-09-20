package protocol

import "fmt"

// RoomType is the native room-mode byte. Team modes remain distinct game rules.
type RoomType byte

const (
	SoloSurvival    RoomType = 0   // 个人生存
	TeamSurvival    RoomType = 1   // 团队生存
	SoloDeathmatch  RoomType = 2   // 个人死亡竞赛
	TeamDeathmatch  RoomType = 3   // 团队死亡竞赛
	NewPlayerGuide  RoomType = 4   // 新手引导
	FreePractice    RoomType = 5   // 自由练习
	FosterMode      RoomType = 10  // 地图脚本PVE；98C1B0创建CFosterMode。
	StageAssault    RoomType = 21  // 波次PVE；98C1B0创建CStageAssaultMode。
	UnknownRoomType RoomType = 255 // 缺失或无法读取房间请求
)

func (t RoomType) String() string {
	switch t {
	case SoloSurvival:
		return "个人生存"
	case TeamSurvival:
		return "团队生存"
	case SoloDeathmatch:
		return "个人死亡竞赛"
	case TeamDeathmatch:
		return "团队死亡竞赛"
	case NewPlayerGuide:
		return "新手引导"
	case FreePractice:
		return "自由练习"
	case FosterMode:
		return "地图脚本PVE（尚未开放）"
	case StageAssault:
		return "波次PVE（尚未开放）"
	default:
		return fmt.Sprintf("未确认房型%d", byte(t))
	}
}

func (t RoomType) IsTeam() bool        { return t == TeamSurvival || t == TeamDeathmatch }
func (t RoomType) IsCompetitive() bool { return t <= TeamDeathmatch }

const (
	RoleProfileSize        = 360
	InventoryRecordSize    = 68
	RoomRequestSize        = 81
	RoomCapacityOffset     = 37
	RoomMapOffset          = 38
	RoomSuggestedMapOffset = 42
	RoomTypeOffset         = 46
	TutorialMapID          = 1201
	InventoryFirstInstance = 1048576
)

func RoomTypeFromRequest(p []byte) RoomType {
	if len(p) != RoomRequestSize {
		return UnknownRoomType
	}
	return RoomType(p[RoomTypeOffset])
}

// Item kinds and equipment slots are different namespaces, even when values match.
const (
	ItemWeapon              = 25 // 武器
	ItemTalisman            = 30 // 法宝
	ItemDecorativeTitle     = 31 // 装饰称号物品；不等同角色成长称号
	ItemConsumable          = 64 // 消耗品
	ItemExperienceCard      = 72 // 经验卡
	ItemVIPCard             = 73 // VIP 卡
	SlotUnequipped          = 0
	SlotPrimaryWeapon       = 8 // 主武器槽
	SlotSecondaryWeapon     = 9 // 副武器槽
	SlotPrimaryTalisman     = 37
	SlotSecondaryTalisman   = 38
	SlotPrimaryConsumable   = 27
	SlotSecondaryConsumable = 28
	SlotDecorativeTitle     = 42
)

// Native message IDs. Values are explicit wire contracts, never iota indexes.
const (
	MsgSDKLoginResponse     = 1002 // SDK 登录响应
	MsgGameLogin            = 1010 // 游戏登录请求
	MsgLoginCore            = 1020
	MsgInventoryList        = 1120
	MsgCharacterOptions     = 1125
	MsgCharacterList        = 1130
	MsgClientSettings       = 1131
	MsgCreateCharacter      = 1150
	MsgCharacterCreated     = 1151
	MsgCharacterCreateError = 1152
	MsgPeerBind             = 1156
	MsgPeerHeartbeat        = 1157
	MsgEnterLobby           = 2010
	MsgLobbyEntered         = 2030
	MsgLogout               = 2060
	MsgEquipItem            = 2080
	MsgEquipmentChanged     = 2090
	MsgEquipError           = 2100
	MsgItemAdded            = 2160
	MsgItemUpdated          = 2161
	MsgPlayerListRequest    = 2250
	MsgRoomListRequest      = 2260 // 请求房间列表
	MsgPlayerList           = 2270
	MsgRoomList             = 2280
	MsgUnequipItem          = 2300
	MsgItemUnequipped       = 2310
	MsgCreateRoom           = 3010
	MsgRoomCreated          = 3020
	MsgRoomCreateError      = 3030
	MsgJoinRoom             = 3070
	MsgWatchGameRequest     = 3071 // A_WATCH_GAME_REQ; payload layout not yet confirmed
	MsgWatchGameAck         = 3072 // A_WATCH_GAME_ACK; result layout not yet confirmed
	MsgRoomEntered          = 3100 // 进入房间数据
	MsgRoomMemberUpdated    = 3090 // 房间成员及装备外观
	MsgLeaveRoom            = 3110
	MsgRoomLeft             = 3115
	MsgPlayerLeftRoom       = 3130
	MsgKickRoomPlayer       = 3140
	MsgRoomPlayerKicked     = 3150
	MsgRoomOwner            = 3160
	MsgRoomAcknowledgement  = 3550
	MsgReady                = 4030 // 准备请求
	MsgPlayerReady          = 4050 // 玩家准备通知
	MsgCancelReady          = 4060
	MsgPlayerNotReady       = 4070
	MsgBattleLoading        = 4080
	MsgBattleStartFailed    = 4081
	MsgTutorialComplete     = 4124
	MsgTitleAward           = 4125
	MsgClaimTitleReward     = 4126
	MsgNetworkDelayReply    = 4140
	MsgNetworkDelayProbe    = 4150
	MsgResourceReady        = 4160
	MsgPlayerResourceReady  = 4170
	MsgAllResourcesReady    = 4180
	MsgBattleInputReady     = 8040
	MsgBattleStarted        = 8070
	MsgBattleEvent          = 8071
	MsgBattleClock          = 8090
	BattleEventMovement     = 8120
	BattleEventHealth       = 8121
	BattleEventState        = 8122
	BattleEventSkillEffect  = 8126
	BattleEventMana         = 8127
	BattleEventAction       = 8140
	BattleEventBuff         = 8150
	BattleEventScoreboard   = 8155
)

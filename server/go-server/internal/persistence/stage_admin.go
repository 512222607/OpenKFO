package persistence

import "fmt"

func (s *Store) AdminStages(request AdminRequest, activeHash string) (any, error) {
	if len(activeHash) != 64 {
		return nil, fmt.Errorf("无法确认目标服务器资源版本，暂不允许编辑关卡")
	}
	var a StageAccess
	var err error
	if request.Operation == "stages_save" {
		if request.StageAccess == nil {
			return nil, ErrDenied
		}
		if request.StageAccess.ClientHash != "" && request.StageAccess.ClientHash != activeHash {
			return nil, fmt.Errorf("关卡目录与目标服务器资源版本不一致；请先同步版本，不要关闭校验")
		}
		a, err = s.SaveStageAccess(*request.StageAccess)
	} else {
		a, err = s.StageAccess()
	}
	return struct {
		StageAccess
		ServerClientHash string `json:"server_client_hash"`
	}{a, activeHash}, err
}

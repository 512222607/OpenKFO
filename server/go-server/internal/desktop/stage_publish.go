package desktop

import (
	"fmt"
	"reflect"
)

// VerifyStageCompatibility compares interpreted map rules and all attached
// scripts/templates, not just map IDs. Weapon-only edits must not reset gates.
func VerifyStageCompatibility(oldPath, newPath string) error {
	a, ap, _, err := ReadStageCatalogue(oldPath)
	if err != nil {
		return fmt.Errorf("读取旧地图目录：%w", err)
	}
	b, bp, _, err := ReadStageCatalogue(newPath)
	if err != nil {
		return fmt.Errorf("读取新地图目录：%w", err)
	}
	return compareStageCatalogues(a, ap, b, bp)
}

func compareStageCatalogues(a []StageRequirement, ap []StageMap, b []StageRequirement, bp []StageMap) error {
	if !reflect.DeepEqual(a, b) || !reflect.DeepEqual(ap, bp) {
		return fmt.Errorf("地图目录、关卡脚本或怪物模板发生变化，已阻止发布；请先核对关卡配置，不能沿用旧版本权限")
	}
	return nil
}

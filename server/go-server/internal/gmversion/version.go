// Package gmversion defines the exact GM command contract accepted by this build.
package gmversion

import "fmt"

const Current = "1.1.0"

func Check(version string) error {
	if version != Current {
		return fmt.Errorf("版本不符合，请更新代码并编译最新版本（需要 %s）", Current)
	}
	return nil
}
func Info() map[string]string { return map[string]string{"version": Current} }

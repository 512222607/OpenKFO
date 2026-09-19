package desktop

import (
	"reflect"
	"testing"
)

func TestComboInputPrefixesAndBranches(t *testing.T) {
	root, err := parseXML(`<ComboTips><Sequence Name="branch"><ActNode State="2011"><Icon Name="C"/></ActNode><!--ignored--><ActNode State="2012"><Icon Name="C"/></ActNode><ActNode State="2021"><Icon Name="X"/></ActNode></Sequence><Sequence Name="run"><ActNode State="2031"><Icon Name="跑"/><Icon Name="C"/></ActNode><ActNode State="2041"><Icon Name="X*"/></ActNode></Sequence><Sequence Name="missing"><ActNode State="2071"><Icon Name=""/></ActNode><ActNode State="2072"><Icon Name="X"/></ActNode></Sequence></ComboTips>`)
	if err != nil {
		t.Fatal(err)
	}
	got := readComboSequences(root)
	if !reflect.DeepEqual(got[0].Nodes, []ComboNode{{"2011", "C"}, {"2012", "CC"}, {"2021", "CCX"}}) || !reflect.DeepEqual(got[1].Nodes, []ComboNode{{"2031", "跑C"}, {"2041", "跑CX*"}}) {
		t.Fatalf("incorrect input paths: %+v", got)
	}
	for _, n := range got[2].Nodes {
		if n.Keys != "按键提示不完整（missing）" {
			t.Fatal("invented input for incomplete sequence", n)
		}
	}
}

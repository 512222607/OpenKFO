import 'package:flutter_test/flutter_test.dart';
import 'package:kungfu_item_manager/reward_table.dart';
void main(){
 test('CSV round-trip keeps 150 levels and zero values',(){
  final rows=rewardRows({'win_gold':20});
  rows[149]['win_gold']=0;
  expect(rewardsFromCsv(rewardsToCsv(rows)),rows);
  expect(()=>rewardsFromCsv(rewardsToCsv(rows).replaceFirst('150,0,','149,0,')),throwsFormatException);
  expect(()=>validateRewardRows(rows,growth:true),throwsFormatException);
 });
 test('diff includes exact level, field and growth toggle',(){
  final a={'levels':rewardRows({'win_gold':20}),'growth_enabled':false};
  final b={'levels':rewardRows({'win_gold':20}),'growth_enabled':true};
  (b['levels'] as List<Map<String,int>>)[9]['loss_gold']=7;
  final diff=rewardDiff(a,b);
  expect(diff.length,2);
  expect(diff.last,'10 级 失败金币：7 → 0');
 });
}

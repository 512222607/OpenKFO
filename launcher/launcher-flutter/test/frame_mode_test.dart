import 'package:flutter_test/flutter_test.dart';
import 'package:openkfo_launcher/frame_mode.dart';

void main() {
  test('config experiment resets when switching back; unrelated settings survive', () {
    const source = '<Settings><RenderIntervel Intervel="1"></RenderIntervel><LoginServer Index="0"/></Settings>';
    final experimental = applyFrameMode(source, FrameMode.configZero);
    expect(experimental, contains('Intervel="0"'));
    expect(applyFrameMode(experimental, FrameMode.high125), source);
    expect(applyFrameMode(experimental, FrameMode.normal), source);
    expect(() => applyFrameMode('<Settings/>', FrameMode.configZero), throwsStateError);
  });
}

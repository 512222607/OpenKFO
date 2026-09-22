enum FrameMode { normal, high125, configZero }

String applyFrameMode(String settings, FrameMode mode) {
  final pattern = RegExp(r'(<RenderIntervel\b[^>]*\bIntervel\s*=\s*")[^"]*(")');
  if (!pattern.hasMatch(settings)) {
    throw StateError('Settings.xml 缺少 RenderIntervel，未更改帧率配置');
  }
  final interval = mode == FrameMode.configZero ? '0' : '1';
  return settings.replaceAllMapped(pattern, (m) => '${m[1]}$interval${m[2]}');
}

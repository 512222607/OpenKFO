import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:openkfo_launcher/launcher_service.dart';
Future<void> main(List<String> args)async {
 final root=await Directory.systemTemp.createTemp('launcher-smoke-');
 try {
  for(final file in Directory(p.join(args.single,'launcher-files')).listSync(recursive:true).whereType<File>()) {final to=File(p.join(root.path,'launcher-files',p.relative(file.path,from:p.join(args.single,'launcher-files'))));await to.parent.create(recursive:true);await file.copy(to.path);}
  await File(p.join(args.single,'LauncherSupport.exe')).copy(p.join(root.path,'LauncherSupport.exe'));
  final service=LauncherService(root.path);await service.init();
  final timing=await service.health();
  final created=await service.native({'Op':'info','PID':pid,'Image':Platform.resolvedExecutable});
  var restored=0;
  for(var n=1;n<=8;n++) {final value=await service.loadAccount(n);if((value['Account'] as String).isNotEmpty)restored++;}
  stdout.writeln(jsonEncode({'health':timing,'native_identity_valid':created is int&&created>0,'saved_accounts_read':restored,'credentials_modified':false}));
 }finally {await root.delete(recursive:true);}
}

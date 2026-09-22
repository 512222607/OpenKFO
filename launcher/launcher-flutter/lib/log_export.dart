import 'dart:convert';
import 'dart:io';
import 'launcher_service.dart';

// Snapshot the current length so a busy server log cannot extend the export forever.
Future<void> exportLog(File source, String destination) async {
  final file=File(destination);await file.parent.create(recursive:true);
  final temp=File('$destination.${DateTime.now().microsecondsSinceEpoch}.tmp');
  final output=temp.openWrite();
  try {
    output.add([0xef,0xbb,0xbf]);
    if(await source.exists()) {
      final length=await source.length();
      await for(final line in source.openRead(0,length).transform(const Utf8Decoder(allowMalformed:true)).transform(const LineSplitter())) {
        output.write('${publicError(line)}\r\n');
      }
    } else {output.write('暂无窗口日志\r\n');}
    await output.flush();await output.close();await temp.rename(destination);
  } catch (_) {await output.close();if(await temp.exists())await temp.delete();rethrow;}
}

import 'package:flutter/material.dart';
import 'update_service.dart';
String byteSize(int value) => value >= 1024*1024 ? '${(value/(1024*1024)).toStringAsFixed(1)} MB' : value >= 1024 ? '${(value/1024).toStringAsFixed(1)} KB' : '$value B';
class UpdateProgressView extends StatelessWidget {
 final UpdateProgress progress;
 const UpdateProgressView(this.progress,{super.key});
 @override Widget build(BuildContext context) {
  final v=progress;
  return Card(child:Padding(padding:const EdgeInsets.all(12),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,mainAxisSize:MainAxisSize.min,children:[
   Row(children:[Expanded(child:Text(v.phase,style:Theme.of(context).textTheme.titleSmall)),Text('文件 ${v.index} / ${v.count}')]),
   Tooltip(message:v.file,child:Text(v.file.isEmpty?'正在处理…':v.file,maxLines:1,overflow:TextOverflow.ellipsis)),
   const SizedBox(height:6),LinearProgressIndicator(value:v.fileFraction),
   Text('${byteSize(v.received)} / ${byteSize(v.size)}',textAlign:TextAlign.end),
   const SizedBox(height:4),Row(children:[const Text('当前阶段总进度'),const SizedBox(width:12),Expanded(child:LinearProgressIndicator(value:v.overallFraction)),const SizedBox(width:12),Text(v.overallFraction==null?'…':'${(v.overallFraction!*100).toStringAsFixed(0)}%')]),
  ])));
 }
}

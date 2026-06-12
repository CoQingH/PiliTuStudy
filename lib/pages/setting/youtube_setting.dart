import 'package:flutter/material.dart';
import 'package:pilistudy/app/theme.dart';
import 'package:pilistudy/utils/storage.dart';
import 'package:pilistudy/utils/storage_key.dart';
import 'package:hive/hive.dart';

class YoutubeSettingPage extends StatefulWidget {
  const YoutubeSettingPage({super.key});

  @override
  State<YoutubeSettingPage> createState() => _YoutubeSettingPageState();
}

class _YoutubeSettingPageState extends State<YoutubeSettingPage> {
  bool _get(String key, bool def) => GStorage.setting.get(key, defaultValue: def);
  int _getInt(String key, int def) => GStorage.setting.get(key, defaultValue: def);
  void _set(String key, dynamic v) => setState(() => GStorage.setting.put(key, v));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('设置', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          const _Sec('反沉迷'),
          _Sw(icon: Icons.school_outlined, title: '学习模式',
            subtitle: '一键：知识分区 + 关推荐 + 纯净播放',
            value: _get(SettingBoxKey.enableStudyMode, false),
            onChanged: (v) { _set(SettingBoxKey.enableStudyMode, v); if (v) { GStorage.setting..put(SettingBoxKey.enableKnowledgeMode, true)..put(SettingBoxKey.disableRcmdFeed, true)..put(SettingBoxKey.enableShowDanmaku, false)..put(SettingBoxKey.alwaysExapndIntroPanel, true)..put(SettingBoxKey.showRelatedVideo, false)..put(SettingBoxKey.defaultShowComment, false); } }),
          _Sw(icon: Icons.visibility_off_outlined, title: '关闭全部推荐流', subtitle: '首页隐藏推荐/热门/排行榜（需重启）', value: _get(SettingBoxKey.disableRcmdFeed, false), onChanged: (v) { _set(SettingBoxKey.disableRcmdFeed, v); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已生效，重启 app 后刷新首页布局'), duration: Duration(seconds: 2))); }),
          _Sw(icon: Icons.filter_list_outlined, title: '知识模式', subtitle: '推荐仅保留白名单分区（需重启）', value: _get(SettingBoxKey.enableKnowledgeMode, false), onChanged: (v) { _set(SettingBoxKey.enableKnowledgeMode, v); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已生效，重启 app 后刷新推荐流'), duration: Duration(seconds: 2))); }),
          const _Sec('每日限额'),
          _Sel(icon: Icons.timer_outlined, title: '每日时长上限', cur: _getInt(SettingBoxKey.dailyTimeLimitMinutes, 0), opts: const [0,15,30,45,60], labs: const ['不限','15min','30min','45min','60min'], onSel: (v) => _set(SettingBoxKey.dailyTimeLimitMinutes, v)),
          _Sel(icon: Icons.videocam_outlined, title: '每日视频数上限', cur: _getInt(SettingBoxKey.dailyVideoCountLimit, 0), opts: const [0,3,5,8,10,15], labs: const ['不限','3个','5个','8个','10个','15个'], onSel: (v) => _set(SettingBoxKey.dailyVideoCountLimit, v)),
          const _Sec('护眼'),
          _Sw(icon: Icons.remove_red_eye_outlined, title: '护眼提醒', subtitle: '连续播放后强制休息', value: _get(SettingBoxKey.enableEyeCare, false), onChanged: (v) => _set(SettingBoxKey.enableEyeCare, v)),
          _Sel(icon: Icons.schedule, title: '护眼间隔', cur: _getInt(SettingBoxKey.eyeCareIntervalMinutes, 20), opts: const [15,20,25,30,40], labs: const ['15min','20min','25min','30min','40min'], onSel: (v) => _set(SettingBoxKey.eyeCareIntervalMinutes, v)),
          _Sel(icon: Icons.bedtime_outlined, title: '休息时长', cur: _getInt(SettingBoxKey.eyeCareRestSeconds, 20), opts: const [10,20,30,60], labs: const ['10s','20s','30s','60s'], onSel: (v) => _set(SettingBoxKey.eyeCareRestSeconds, v)),
          const _Sec('内容过滤'),
          _Sw(icon: Icons.wc_outlined, title: '过滤性别对立', value: _get(SettingBoxKey.contentFilterGender, false), onChanged: (v) => _set(SettingBoxKey.contentFilterGender, v)),
          _Sw(icon: Icons.remove_moderator_outlined, title: '过滤擦边内容', value: _get(SettingBoxKey.contentFilterNsfw, false), onChanged: (v) => _set(SettingBoxKey.contentFilterNsfw, v)),
          _Sw(icon: Icons.gavel_outlined, title: '过滤政治敏感', value: _get(SettingBoxKey.contentFilterPolitical, false), onChanged: (v) => _set(SettingBoxKey.contentFilterPolitical, v)),
          _Sw(icon: Icons.block, title: '搜索词拦截', value: _get(SettingBoxKey.enableSearchKeywordBlock, false), onChanged: (v) => _set(SettingBoxKey.enableSearchKeywordBlock, v)),
          const _Sec('首页显示'),
          _Sw(icon: Icons.subscriptions_outlined, title: '关注动态入口', value: _get(SettingBoxKey.showHomeSubscriptions, true), onChanged: (v) => _set(SettingBoxKey.showHomeSubscriptions, v)),
          _Sw(icon: Icons.history, title: '历史记录入口', value: _get(SettingBoxKey.showHomeHistory, true), onChanged: (v) => _set(SettingBoxKey.showHomeHistory, v)),
          _Sw(icon: Icons.watch_later_outlined, title: '稍后再看入口', value: _get(SettingBoxKey.showHomeWatchLater, true), onChanged: (v) => _set(SettingBoxKey.showHomeWatchLater, v)),
          const _Sec('评论/弹幕'),
          _Sw(icon: Icons.comments_disabled_outlined, title: '全局关闭评论', value: _get(SettingBoxKey.disableAllComments, false), onChanged: (v) { _set(SettingBoxKey.disableAllComments, v); if (v) GStorage.setting..put(SettingBoxKey.showVideoReply, false)..put(SettingBoxKey.showBangumiReply, false)..put(SettingBoxKey.defaultShowComment, false); }),
          _Sw(icon: Icons.subtitles_off_outlined, title: '全局关闭弹幕', value: _get(SettingBoxKey.disableAllDanmaku, false), onChanged: (v) { _set(SettingBoxKey.disableAllDanmaku, v); if (v) GStorage.setting.put(SettingBoxKey.enableShowDanmaku, false); }),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _Sec extends StatelessWidget { final String t; const _Sec(this.t);
  @override Widget build(c) => Padding(padding: const EdgeInsets.fromLTRB(12,20,12,4), child: Text(t, style: TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:Theme.of(c).textTheme.bodySmall!.color,letterSpacing:0.5))); }

class _Sw extends StatelessWidget { final IconData icon; final String title, subtitle; final bool value; final ValueChanged<bool> onChanged;
  const _Sw({required this.icon, required this.title, this.subtitle='', required this.value, required this.onChanged});
  @override Widget build(c) { final t1=Theme.of(c).colorScheme.onSurface; final t3=Theme.of(c).textTheme.bodySmall!.color; return ListTile(leading:Icon(icon,color:t1,size:22), title:Text(title,style:TextStyle(fontSize:15,color:t1)), subtitle: subtitle.isNotEmpty?Text(subtitle,style:TextStyle(fontSize:12,color:t3)):null, trailing:Switch(value:value,onChanged:onChanged,activeColor:YTTheme.red), shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12))); }}

class _Sel extends StatelessWidget { final IconData icon; final String title; final int cur; final List<int> opts; final List<String> labs; final ValueChanged<int> onSel;
  const _Sel({required this.icon, required this.title, required this.cur, required this.opts, required this.labs, required this.onSel});
  String get val => labs[opts.indexOf(cur)];
  @override Widget build(c) { final t1=Theme.of(c).colorScheme.onSurface; final t2=Theme.of(c).colorScheme.outline; final t3=Theme.of(c).textTheme.bodySmall!.color; final surf=Theme.of(c).colorScheme.surface; return ListTile(leading:Icon(icon,color:t1,size:22), title:Text(title,style:TextStyle(fontSize:15,color:t1)), trailing:Row(mainAxisSize:MainAxisSize.min,children:[Text(val,style:TextStyle(fontSize:14,color:t2)),const SizedBox(width:4),Icon(Icons.chevron_right,color:t3,size:20)]), onTap:()=>showModalBottomSheet(context:c,backgroundColor:surf,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(16))),builder:(_)=>ListView(shrinkWrap:true,children:List.generate(opts.length,(i)=>ListTile(title:Text(labs[i],style:TextStyle(color:opts[i]==cur?YTTheme.red:t1,fontWeight:opts[i]==cur?FontWeight.w600:FontWeight.normal)),trailing:opts[i]==cur?const Icon(Icons.check,color:YTTheme.red):null,onTap:(){Navigator.pop(c);onSel(opts[i]);})))), shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12))); }}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilistudy/app/theme.dart';
import 'package:pilistudy/services/usage_limit_service.dart';
import 'package:pilistudy/utils/storage_pref.dart';
import 'package:pilistudy/utils/watch_time_tracker.dart';

class YoutubeHomePage extends StatefulWidget {
  const YoutubeHomePage({super.key});
  @override
  State<YoutubeHomePage> createState() => _YoutubeHomePageState();
}

class _YoutubeHomePageState extends State<YoutubeHomePage> {
  Timer? _tick;

  @override
  void initState() { super.initState(); _tick = Timer.periodic(const Duration(seconds: 1), (_) { if (mounted) setState(() {}); }); }
  @override
  void dispose() { _tick?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t1 = context.ytT1; final t2 = context.ytT2; final t3 = context.ytT3;
    return Scaffold(
      backgroundColor: context.ytBg,
      appBar: AppBar(
        backgroundColor: context.ytBg,
        title: Row(children: [
          Container(width: 28, height: 28, decoration: BoxDecoration(color: YTTheme.red, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.play_arrow, color: Colors.white, size: 20)),
          const SizedBox(width: 8),
          Text('PiliTuStudy', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.5, color: t1)),
        ]),
        actions: [
          IconButton(icon: Icon(Icons.account_circle_outlined, color: t1, size: 24), tooltip: '登录/个人', onPressed: () => Get.toNamed('/login')),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(padding: const EdgeInsets.symmetric(horizontal: 12), children: [
        const SizedBox(height: 8),
        _StatusCard(),
        const SizedBox(height: 24),
        Builder(builder: (ctx) {
          final items = <Widget>[];
          if (Pref.showHomeSubscriptions) items.add(_QuickAction(icon: Icons.subscriptions_outlined, label: '关注动态', onTap: () => Get.toNamed('/dynamics'), t1: t1, t2: t2, surf: context.ytSurf));
          if (Pref.showHomeHistory) items.add(_QuickAction(icon: Icons.history, label: '历史记录', onTap: () => Get.toNamed('/history'), t1: t1, t2: t2, surf: context.ytSurf));
          if (Pref.showHomeWatchLater) items.add(_QuickAction(icon: Icons.watch_later_outlined, label: '稍后再看', onTap: () => Get.toNamed('/later'), t1: t1, t2: t2, surf: context.ytSurf));
          if (items.isEmpty) return const SizedBox.shrink();
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('快捷入口', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t2)),
            const SizedBox(height: 10),
            Row(children: items.map((w) => Expanded(child: w)).expand((w) => [w, const SizedBox(width: 10)]).toList()..removeLast()),
          ]);
        }),
        const SizedBox(height: 32),
        Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Column(children: [
          Icon(Icons.auto_awesome, size: 48, color: t3.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Text('推荐流已关闭', style: TextStyle(fontSize: 15, color: t2)),
          const SizedBox(height: 4),
          Text('上面点分类芯片直接搜索', style: TextStyle(fontSize: 12, color: t3)),
        ]))),
      ]),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap; final Color t1, t2, surf;
  const _QuickAction({required this.icon, required this.label, required this.onTap, required this.t1, required this.t2, required this.surf});
  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(10),
      child: Container(padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: surf, borderRadius: BorderRadius.circular(10)),
        child: Column(children: [Icon(icon, color: t1, size: 24), const SizedBox(height: 6), Text(label, style: TextStyle(fontSize: 12, color: t2))]),
      ),
    ),
  );
}

class _StatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WatchTimeTracker.checkReset();
    final t1 = context.ytT1; final t2 = context.ytT2; final t3 = context.ytT3;
    final today = WatchTimeTracker.todayFormatted;
    final secs = WatchTimeTracker.todaySeconds;
    final timeLimit = Pref.dailyTimeLimitMinutes;
    final countLimit = Pref.dailyVideoCountLimit;
    final count = WatchTimeTracker.todayVideoCount;
    final over = (timeLimit > 0 && secs >= timeLimit * 60) || (countLimit > 0 && count >= countLimit);
    final isNear = !over && ((timeLimit > 0 && secs >= (timeLimit * 60 * 0.8)) || (countLimit > 0 && count >= (countLimit * 0.8)));

    final parts = <String>[];
    if (timeLimit > 0) parts.add('${today} / ${timeLimit}min');
    if (countLimit > 0) parts.add('$count / $countLimit 个');
    if (parts.isEmpty && secs == 0) parts.add('今天还没开始学习');
    if (parts.isEmpty) parts.add('今日: $today');

    final pct = timeLimit > 0 ? (secs / (timeLimit * 60)).clamp(0.0, 1.0) : 0.0;
    final barColor = over ? YTTheme.red : isNear ? Colors.orange : YTTheme.red;

    return Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: over ? YTTheme.red.withValues(alpha: 0.12) : isNear ? Colors.orange.withValues(alpha: 0.1) : context.ytSurf,
        borderRadius: BorderRadius.circular(12),
        border: over ? Border.all(color: YTTheme.red.withValues(alpha: 0.4)) : isNear ? Border.all(color: Colors.orange.withValues(alpha: 0.3)) : null,
      ),
      child: Column(children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: YTTheme.red.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(over ? Icons.block : isNear ? Icons.hourglass_bottom : Icons.timer_outlined, color: barColor, size: 22)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('今日学习', style: TextStyle(fontSize: 12, color: t2)),
            const SizedBox(height: 3),
            Text(parts.join('  |  '), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: over ? YTTheme.red : isNear ? Colors.orange : t1)),
          ])),
          Icon(Icons.chevron_right, color: t3, size: 22),
        ]),
        if (timeLimit > 0) ...[
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: pct, minHeight: 6, backgroundColor: context.ytSurf.withValues(alpha: 0.5), valueColor: AlwaysStoppedAnimation(barColor))),
        ],
      ]),
    );
  }
}

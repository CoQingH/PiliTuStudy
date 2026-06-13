import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilistudy/app/theme.dart';
import 'package:pilistudy/utils/storage_pref.dart';
import 'package:pilistudy/utils/watch_time_tracker.dart';

class YoutubeHomePage extends StatelessWidget {
  const YoutubeHomePage({super.key});

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
          IconButton(icon: Icon(Icons.account_circle_outlined, color: t1, size: 24), tooltip: '登录/个人', onPressed: () => Get.toNamed('/loginPage')),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(padding: const EdgeInsets.symmetric(horizontal: 12), children: [
        const SizedBox(height: 8),
        const _StatusCard(),
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

/// 状态卡 — 自带 1s 定时器，只重建自己不影响整页
class _StatusCard extends StatefulWidget {
  const _StatusCard();
  @override
  State<_StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<_StatusCard> {
  Timer? _tick;

  @override
  void initState() { super.initState(); _tick = Timer.periodic(const Duration(seconds: 1), (_) { if (mounted) setState(() {}); }); }
  @override
  void dispose() { _tick?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    // checkReset() 已内置在 todaySeconds/todayFormatted 等 getter 中，无需额外调用
    final t1 = context.ytT1; final t2 = context.ytT2; final t3 = context.ytT3;
    final today = WatchTimeTracker.todayFormatted;
    final secs = WatchTimeTracker.todaySeconds;
    final timeLimit = Pref.dailyTimeLimitMinutes;
    final countLimit = Pref.dailyVideoCountLimit;
    final count = WatchTimeTracker.todayVideoCount;

    final over = (timeLimit > 0 && secs >= timeLimit * 60) || (countLimit > 0 && count >= countLimit);
    final isNear = !over && ((timeLimit > 0 && secs >= (timeLimit * 60 * 0.8)) || (countLimit > 0 && count >= (countLimit * 0.8)));
    // 正常→绿色  接近→橙色  超限→红色
    final barColor = over ? YTTheme.red : isNear ? Colors.orange : const Color(0xFF4CAF50);

    // 已用 / 总额
    final parts = <String>[];
    if (timeLimit > 0) parts.add('$today / ${timeLimit}min');
    if (countLimit > 0) parts.add('$count / $countLimit 个');
    if (parts.isEmpty) parts.add('今天还没开始学习');

    // 剩余额度
    String? remainingText;
    if (!over) {
      final rem = <String>[];
      if (timeLimit > 0) {
        final rm = timeLimit * 60 - secs;
        final rmin = rm > 0 ? (rm ~/ 60) : 0;
        final rsec = rm > 0 ? (rm % 60) : 0;
        if (rmin > 0) {
          rem.add(rsec > 0 ? '剩 ${rmin}min${rsec}s' : '剩 ${rmin}min');
        } else {
          rem.add('剩 ${rsec}s');
        }
      }
      if (countLimit > 0) {
        final rc = countLimit - count;
        rem.add('剩 ${rc}个');
      }
      if (rem.isNotEmpty) remainingText = rem.join('  ');
    }

    final pct = timeLimit > 0 ? (secs / (timeLimit * 60)).clamp(0.0, 1.0) : 0.0;

    return Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: over ? YTTheme.red.withValues(alpha: 0.12) : isNear ? Colors.orange.withValues(alpha: 0.1) : context.ytSurf,
        borderRadius: BorderRadius.circular(12),
        border: over ? Border.all(color: YTTheme.red.withValues(alpha: 0.4)) : isNear ? Border.all(color: Colors.orange.withValues(alpha: 0.3)) : null,
      ),
      child: Column(children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: barColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(over ? Icons.block : isNear ? Icons.hourglass_bottom : Icons.timer_outlined, color: barColor, size: 22)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('今日学习', style: TextStyle(fontSize: 12, color: t2)),
            const SizedBox(height: 3),
            Text(parts.join('  |  '), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: over ? YTTheme.red : isNear ? Colors.orange : t1)),
            if (remainingText != null) ...[
              const SizedBox(height: 2),
              Text(remainingText, style: TextStyle(fontSize: 12, color: t3)),
            ],
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

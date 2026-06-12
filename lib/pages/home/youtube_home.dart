import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilistudy/app/theme.dart';
import 'package:pilistudy/services/usage_limit_service.dart';
import 'package:pilistudy/utils/storage_pref.dart';
import 'package:pilistudy/utils/watch_time_tracker.dart';

class YoutubeHomePage extends StatelessWidget {
  const YoutubeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YTTheme.background,
      appBar: AppBar(
        backgroundColor: YTTheme.background,
        title: Row(
          children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: YTTheme.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'PiliTuStudy',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.5),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cast, color: YTTheme.textPrimary, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: YTTheme.textPrimary, size: 22),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          const SizedBox(height: 8),
          // Category chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _Chip(label: '全部'),
                _Chip(label: '知识', selected: true),
                _Chip(label: '科技'),
                _Chip(label: '编程'),
                _Chip(label: '数学'),
                _Chip(label: '数码'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DailyStatusCard(),
          const SizedBox(height: 24),
          // Quick actions
          Builder(builder: (context) {
            final items = <Widget>[];
            if (Pref.showHomeSubscriptions) items.add(_QuickAction(icon: Icons.subscriptions_outlined, label: '关注动态', onTap: () => Get.toNamed('/dynamics')));
            if (Pref.showHomeHistory) items.add(_QuickAction(icon: Icons.history, label: '历史记录', onTap: () => Get.toNamed('/history')));
            if (Pref.showHomeWatchLater) items.add(_QuickAction(icon: Icons.watch_later_outlined, label: '稍后再看', onTap: () => Get.toNamed('/later')));
            if (items.isEmpty) return const SizedBox.shrink();
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('快捷入口', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: YTTheme.textSecondary)),
              const SizedBox(height: 10),
              Row(children: items.map((w) => Expanded(child: w)).expand((w) => [w, const SizedBox(width: 10)]).toList()..removeLast()),
            ]);
          }),
          const SizedBox(height: 32),
          // Empty feed
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.auto_awesome, size: 48, color: YTTheme.textTertiary.withValues(alpha: 0.3)),
                  const SizedBox(height: 12),
                  const Text('推荐流已关闭', style: TextStyle(fontSize: 15, color: YTTheme.textSecondary)),
                  const SizedBox(height: 4),
                  const Text('上面是主动获取，下面是被动投喂', style: TextStyle(fontSize: 12, color: YTTheme.textTertiary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  const _Chip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {},
        selectedColor: YTTheme.chipSelected,
        backgroundColor: YTTheme.chipBg,
        labelStyle: TextStyle(
          color: selected ? YTTheme.background : YTTheme.textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: YTTheme.surfaceLight, borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            Icon(icon, color: YTTheme.textPrimary, size: 24),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, color: YTTheme.textSecondary)),
          ]),
        ),
      ),
    );
  }
}

class _DailyStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WatchTimeTracker.checkReset();
    final status = usageLimitService.statusText;
    final isNear = (usageLimitService.remainingTimeMinutes() > 0 && usageLimitService.remainingTimeMinutes() <= 30) ||
        (usageLimitService.remainingVideoCount() > 0 && usageLimitService.remainingVideoCount() <= 3);

    if (status.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNear ? YTTheme.red.withValues(alpha: 0.1) : YTTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: isNear ? Border.all(color: YTTheme.red.withValues(alpha: 0.3)) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: YTTheme.red.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(isNear ? Icons.hourglass_bottom : Icons.timer_outlined, color: isNear ? Colors.orange : YTTheme.red, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('今日', style: TextStyle(fontSize: 12, color: YTTheme.textSecondary)),
                const SizedBox(height: 3),
                Text(status,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700,
                    color: isNear ? Colors.orange : YTTheme.textPrimary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: YTTheme.textTertiary, size: 22),
        ],
      ),
    );
  }
}

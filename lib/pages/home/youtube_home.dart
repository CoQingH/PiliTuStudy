import 'package:flutter/material.dart';
import 'package:pilistudy/app/theme.dart';
import 'package:pilistudy/services/usage_limit_service.dart';
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
          // Empty feed state
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  Icon(Icons.auto_awesome, size: 56, color: YTTheme.textTertiary.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  const Text('推荐流已关闭', style: TextStyle(fontSize: 17, color: YTTheme.textSecondary)),
                  const SizedBox(height: 6),
                  const Text('主动搜索 = 主动学习', style: TextStyle(fontSize: 13, color: YTTheme.textTertiary)),
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

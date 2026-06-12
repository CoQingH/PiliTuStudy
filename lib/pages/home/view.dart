import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilistudy/app/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YTTheme.background,
      appBar: AppBar(
        backgroundColor: YTTheme.background,
        title: Row(
          children: [
            Icon(Icons.play_circle_filled, color: YTTheme.red, size: 32),
            const SizedBox(width: 4),
            const Text(
              'StudyTube',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: YTTheme.textPrimary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          // Category chips
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _CategoryChip(label: '全部'),
                _CategoryChip(label: '知识', selected: true),
                _CategoryChip(label: '科技'),
                _CategoryChip(label: '编程'),
                _CategoryChip(label: '数学'),
                _CategoryChip(label: '物理'),
                _CategoryChip(label: '数码'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Status card
          _StatusCard(),
          const SizedBox(height: 24),
          // Empty state
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  Icon(Icons.live_tv_off, size: 64, color: YTTheme.textTertiary.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    '推荐流已关闭',
                    style: TextStyle(fontSize: 18, color: YTTheme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '使用搜索功能主动获取知识内容',
                    style: TextStyle(fontSize: 14, color: YTTheme.textTertiary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _CategoryChip({required this.label, this.selected = false});

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
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder — will integrate UsageLimitService later
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: YTTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: YTTheme.red.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.timer_outlined, color: YTTheme.red, size: 24),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '今日学习',
                style: TextStyle(fontSize: 13, color: YTTheme.textSecondary),
              ),
              SizedBox(height: 2),
              Text(
                '0min / 60min',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: YTTheme.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.chevron_right, color: YTTheme.textTertiary),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pilistudy/app/theme.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YTTheme.background,
      appBar: AppBar(
        backgroundColor: YTTheme.background,
        title: const Text(
          '媒体库',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          const SizedBox(height: 8),
          _LibraryTile(
            icon: Icons.history,
            title: '观看历史',
            onTap: () {},
          ),
          _LibraryTile(
            icon: Icons.bookmark_outline,
            title: '收藏夹',
            onTap: () {},
          ),
          _LibraryTile(
            icon: Icons.watch_later_outlined,
            title: '稍后再看',
            onTap: () {},
          ),
          _LibraryTile(
            icon: Icons.thumb_up_outlined,
            title: '点赞视频',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              '离线',
              style: TextStyle(fontSize: 13, color: YTTheme.textTertiary, fontWeight: FontWeight.w600),
            ),
          ),
          _LibraryTile(
            icon: Icons.download_outlined,
            title: '离线缓存',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _LibraryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _LibraryTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: YTTheme.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: YTTheme.textPrimary, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, color: YTTheme.textPrimary)),
      trailing: const Icon(Icons.chevron_right, color: YTTheme.textTertiary),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t1 = Theme.of(context).colorScheme.onSurface;
    final t3 = Theme.of(context).textTheme.bodySmall!.color!;
    final surf = Theme.of(context).colorScheme.surface;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('媒体库', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: t1)),
      ),
      body: ListView(padding: const EdgeInsets.symmetric(horizontal: 12), children: [
        const SizedBox(height: 8),
        _Tile(icon: Icons.history, title: '观看历史', onTap: () => Get.toNamed('/history'), t1: t1, t3: t3, surf: surf),
        _Tile(icon: Icons.bookmark_outline, title: '收藏夹', onTap: () => Get.toNamed('/fav'), t1: t1, t3: t3, surf: surf),
        _Tile(icon: Icons.watch_later_outlined, title: '稍后再看', onTap: () => Get.toNamed('/later'), t1: t1, t3: t3, surf: surf),
        _Tile(icon: Icons.thumb_up_outlined, title: '点赞视频', onTap: () {}, t1: t1, t3: t3, surf: surf),
        const SizedBox(height: 16),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('离线', style: TextStyle(fontSize: 13, color: t3, fontWeight: FontWeight.w600))),
        _Tile(icon: Icons.download_outlined, title: '离线缓存', onTap: () {}, t1: t1, t3: t3, surf: surf),
      ]),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap; final Color t1, t3, surf;
  const _Tile({required this.icon, required this.title, required this.onTap, required this.t1, required this.t3, required this.surf});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: surf, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: t1, size: 22)),
    title: Text(title, style: TextStyle(fontSize: 15, color: t1)),
    trailing: Icon(Icons.chevron_right, color: t3),
    onTap: onTap,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}

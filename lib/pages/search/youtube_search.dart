import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilistudy/app/theme.dart';
import 'package:pilistudy/utils/content_filter.dart';
import 'package:pilistudy/utils/storage_pref.dart';

class YoutubeSearchPage extends StatefulWidget {
  const YoutubeSearchPage({super.key});
  @override
  State<YoutubeSearchPage> createState() => _YoutubeSearchPageState();
}

class _YoutubeSearchPageState extends State<YoutubeSearchPage> {
  final _ctrl = TextEditingController();
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _submit() {
    final kw = _ctrl.text.trim();
    if (kw.isEmpty) return;
    if (Pref.enableSearchKeywordBlock && ContentFilter.isKeywordBlocked(kw)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('搜索词命中屏蔽规则'), backgroundColor: YTTheme.red));
      return;
    }
    Get.toNamed('/searchResult', parameters: {'tag': 'yt', 'keyword': kw});
  }

  @override
  Widget build(BuildContext context) {
    final t1 = Theme.of(context).colorScheme.onSurface;
    final t2 = Theme.of(context).colorScheme.outline;
    final t3 = Theme.of(context).textTheme.bodySmall!.color!;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: TextField(
          controller: _ctrl, autofocus: true,
          style: TextStyle(color: t1, fontSize: 16),
          decoration: InputDecoration(
            hintText: '搜索知识内容', hintStyle: TextStyle(color: t3), border: InputBorder.none,
            suffixIcon: IconButton(icon: Icon(Icons.search, color: t2), onPressed: _submit),
          ),
          onSubmitted: (_) => _submit(),
        ),
      ),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.search, size: 64, color: t3.withValues(alpha: 0.3)),
        const SizedBox(height: 16),
        Text('主动搜索，主动获取', style: TextStyle(fontSize: 16, color: t2)),
        const SizedBox(height: 8),
        Text('没有推荐算法的干扰', style: TextStyle(fontSize: 13, color: t3)),
      ])),
    );
  }
}

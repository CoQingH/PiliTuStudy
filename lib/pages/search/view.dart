import 'package:flutter/material.dart';
import 'package:studytube/app/theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YTTheme.background,
      appBar: AppBar(
        backgroundColor: YTTheme.background,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: YTTheme.textPrimary, fontSize: 16),
          decoration: InputDecoration(
            hintText: '搜索知识内容',
            hintStyle: const TextStyle(color: YTTheme.textTertiary),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: YTTheme.textSecondary),
              onPressed: _onSearch,
            ),
          ),
          onSubmitted: (_) => _onSearch(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: YTTheme.textTertiary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            const Text(
              '主动搜索，主动获取',
              style: TextStyle(fontSize: 16, color: YTTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            const Text(
              '没有推荐算法的干扰',
              style: TextStyle(fontSize: 13, color: YTTheme.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearch() {
    if (_controller.text.trim().isEmpty) return;
    // TODO: navigate to search results using backend
  }
}

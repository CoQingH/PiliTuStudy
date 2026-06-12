import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studytube/app/theme.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YTTheme.background,
      appBar: AppBar(
        backgroundColor: YTTheme.background,
        title: const Text(
          '设置',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          const _SectionHeader('反沉迷'),
          _SettingSwitch(
            icon: Icons.school_outlined,
            title: '学习模式',
            subtitle: '知识分区 + 关闭推荐 + 纯净播放',
            value: false,
            onChanged: (_) {},
          ),
          _SettingSwitch(
            icon: Icons.visibility_off_outlined,
            title: '关闭推荐流',
            subtitle: '首页隐藏推荐/热门/排行榜',
            value: true,
            onChanged: (_) {},
          ),
          _SettingSwitch(
            icon: Icons.filter_list_outlined,
            title: '知识模式',
            subtitle: '推荐仅保留白名单分区',
            value: false,
            onChanged: (_) {},
          ),
          const _SectionHeader('限额'),
          _SettingTile(
            icon: Icons.timer_outlined,
            title: '每日时长上限',
            trailing: '60min',
            onTap: () {},
          ),
          _SettingTile(
            icon: Icons.videocam_outlined,
            title: '每日视频数上限',
            trailing: '10个',
            onTap: () {},
          ),
          const _SectionHeader('护眼'),
          _SettingSwitch(
            icon: Icons.remove_red_eye_outlined,
            title: '护眼提醒',
            subtitle: '每20min休息20s',
            value: false,
            onChanged: (_) {},
          ),
          const _SectionHeader('过滤'),
          _SettingSwitch(
            icon: Icons.wc_outlined,
            title: '过滤性别对立',
            value: false,
            onChanged: (_) {},
          ),
          _SettingSwitch(
            icon: Icons.remove_moderator_outlined,
            title: '过滤擦边内容',
            value: true,
            onChanged: (_) {},
          ),
          _SettingSwitch(
            icon: Icons.gavel_outlined,
            title: '过滤政治敏感',
            value: true,
            onChanged: (_) {},
          ),
          _SettingSwitch(
            icon: Icons.block,
            title: '搜索词拦截',
            value: true,
            onChanged: (_) {},
          ),
          const _SectionHeader('评论/弹幕'),
          _SettingSwitch(
            icon: Icons.comments_disabled_outlined,
            title: '全局关闭评论',
            value: true,
            onChanged: (_) {},
          ),
          _SettingSwitch(
            icon: Icons.subtitles_off_outlined,
            title: '全局关闭弹幕',
            value: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: YTTheme.textTertiary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String trailing;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: YTTheme.textPrimary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, color: YTTheme.textPrimary)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailing, style: const TextStyle(fontSize: 14, color: YTTheme.textSecondary)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: YTTheme.textTertiary, size: 20),
        ],
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingSwitch({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: YTTheme.textPrimary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, color: YTTheme.textPrimary)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(fontSize: 12, color: YTTheme.textTertiary))
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: YTTheme.red,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

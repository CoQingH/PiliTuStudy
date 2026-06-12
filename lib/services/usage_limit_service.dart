/// 每日使用限额服务
///
/// 配合 WatchTimeTracker 实现:
/// - 每日观看时长上限（分钟）
/// - 每日观看视频数上限
/// - 收藏夹豁免（在指定收藏夹中观看不计入）
import 'package:pilistudy/utils/storage_pref.dart';
import 'package:pilistudy/utils/watch_time_tracker.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class UsageLimitService {
  static final UsageLimitService _instance = UsageLimitService._internal();
  factory UsageLimitService() => _instance;
  UsageLimitService._internal();

  /// 当前豁免的收藏夹 ID 列表
  List<int> get exemptFavIds => Pref.exemptFavFoldersForLimit;

  /// 当前是否在豁免收藏夹中观看
  bool _isExempted = false;

  /// 标记当前播放会话在豁免收藏夹中
  void markExempted() => _isExempted = true;

  /// 重置豁免标记
  void resetExemption() => _isExempted = false;

  /// 检查是否超出每日时长限制
  /// 返回 true 表示已超限
  bool isTimeExceeded() {
    final limit = Pref.dailyTimeLimitMinutes;
    if (limit <= 0) return false;
    final todayMin = WatchTimeTracker.todaySeconds ~/ 60;
    return todayMin >= limit;
  }

  /// 检查是否超出每日视频数限制
  /// 返回 true 表示已超限
  bool isCountExceeded() {
    final limit = Pref.dailyVideoCountLimit;
    if (limit <= 0) return false;
    return WatchTimeTracker.todayVideoCount >= limit;
  }

  /// 综合检查是否超限
  bool isAnyLimitExceeded() => isTimeExceeded() || isCountExceeded();

  /// 在播放前调用，返回 false 表示被拦截
  bool canPlay() {
    WatchTimeTracker.checkReset();

    // 已在豁免收藏夹中，放行
    if (_isExempted) return true;

    if (isTimeExceeded()) {
      SmartDialog.showToast(
        '今日观看时长已达上限（${Pref.dailyTimeLimitMinutes}分钟）',
      );
      return false;
    }
    if (isCountExceeded()) {
      SmartDialog.showToast(
        '今日观看视频数已达上限（${Pref.dailyVideoCountLimit}个）',
      );
      return false;
    }
    return true;
  }

  /// 播放结束时记录观看数据
  void recordWatch(int secondsWatched) {
    if (_isExempted) return;
    WatchTimeTracker.addSeconds(secondsWatched);
    WatchTimeTracker.incrementVideoCount();
  }

  /// 剩余时长（分钟），-1 表示无限制
  int remainingTimeMinutes() {
    final limit = Pref.dailyTimeLimitMinutes;
    if (limit <= 0) return -1;
    final used = WatchTimeTracker.todaySeconds ~/ 60;
    final remaining = limit - used;
    return remaining < 0 ? 0 : remaining;
  }

  /// 剩余视频数，-1 表示无限制
  int remainingVideoCount() {
    final limit = Pref.dailyVideoCountLimit;
    if (limit <= 0) return -1;
    final remaining = limit - WatchTimeTracker.todayVideoCount;
    return remaining < 0 ? 0 : remaining;
  }

  /// 格式化的剩余时长字符串
  String remainingTimeFormatted() {
    final remaining = remainingTimeMinutes();
    if (remaining < 0) return '';
    if (remaining >= 60) {
      final h = remaining ~/ 60;
      final m = remaining % 60;
      return m > 0 ? '${h}h${m}min' : '${h}h';
    }
    return '${remaining}min';
  }

  /// 用于首页/播放器显示的汇总文本
  String get statusText {
    final parts = <String>[];
    final timeLimit = Pref.dailyTimeLimitMinutes;
    final countLimit = Pref.dailyVideoCountLimit;

    if (timeLimit > 0) {
      parts.add('${WatchTimeTracker.todayFormatted}/${timeLimit}min');
    }
    if (countLimit > 0) {
      parts.add('${WatchTimeTracker.todayVideoCount}/$countLimit个');
    }

    if (parts.isEmpty) {
      // 未设置任何限制时仅显示今日观看时间
      final s = WatchTimeTracker.todaySeconds;
      if (s > 0) {
        return '今日观看: ${WatchTimeTracker.todayFormatted}';
      }
    }

    return parts.join(' | ');
  }
}

final usageLimitService = UsageLimitService();

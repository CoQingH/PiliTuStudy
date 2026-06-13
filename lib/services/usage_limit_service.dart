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
  bool isTimeExceeded() =>
      (WatchTimeTracker.todaySeconds ~/ 60) >= Pref.dailyTimeLimitMinutes;

  /// 检查是否超出每日视频数限制
  bool isCountExceeded() =>
      WatchTimeTracker.todayVideoCount >= Pref.dailyVideoCountLimit;

  /// 综合检查是否超限
  bool isAnyLimitExceeded() => isTimeExceeded() || isCountExceeded();

  /// 在播放前调用，返回 false 表示被拦截
  bool canPlay() {
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

  /// 剩余时长（分钟）
  int remainingTimeMinutes() {
    final used = WatchTimeTracker.todaySeconds ~/ 60;
    final remaining = Pref.dailyTimeLimitMinutes - used;
    return remaining < 0 ? 0 : remaining;
  }

  /// 剩余视频数
  int remainingVideoCount() {
    final remaining = Pref.dailyVideoCountLimit - WatchTimeTracker.todayVideoCount;
    return remaining < 0 ? 0 : remaining;
  }

  /// 格式化的剩余时长字符串
  String remainingTimeFormatted() {
    final remaining = remainingTimeMinutes();
    if (remaining >= 60) {
      final h = remaining ~/ 60;
      final m = remaining % 60;
      return m > 0 ? '${h}h${m}min' : '${h}h';
    }
    return '${remaining}min';
  }

  /// 用于播放器顶部显示的汇总文本
  String get statusText {
    return '${WatchTimeTracker.todayFormatted}/${Pref.dailyTimeLimitMinutes}min  |  ${WatchTimeTracker.todayVideoCount}/${Pref.dailyVideoCountLimit}个';
  }
}

final usageLimitService = UsageLimitService();

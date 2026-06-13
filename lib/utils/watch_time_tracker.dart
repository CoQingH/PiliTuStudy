import 'package:pilistudy/utils/storage.dart';
import 'package:pilistudy/utils/storage_key.dart';

class WatchTimeTracker {
  static int get todaySeconds {
    checkReset();
    final data = _read();
    return data['seconds'] as int? ?? 0;
  }

  static int get todayVideoCount {
    checkReset();
    final data = _read();
    return data['videoCount'] as int? ?? 0;
  }

  static String get todayFormatted {
    final s = todaySeconds; // checkReset() called inside todaySeconds
    if (s < 60) return '${s}s';
    final m = s ~/ 60;
    if (m < 60) return '${m}min';
    final h = m ~/ 60;
    final rm = m % 60;
    return rm > 0 ? '${h}h${rm}min' : '${h}h';
  }

  /// 累加观看秒数（播放结束时调用）
  static void addSeconds(int seconds) {
    if (seconds <= 0) return;
    checkReset();
    final data = _read();
    final prev = data['seconds'] as int? ?? 0;
    GStorage.localCache.put(LocalCacheKey.dailyWatchTime, {
      'date': _today(),
      'seconds': prev + seconds,
      'videoCount': data['videoCount'] as int? ?? 0,
    });
  }

  /// 累加视频计数（播放结束时调用）
  static void incrementVideoCount() {
    checkReset();
    final data = _read();
    final prev = data['videoCount'] as int? ?? 0;
    GStorage.localCache.put(LocalCacheKey.dailyWatchTime, {
      'date': _today(),
      'seconds': data['seconds'] as int? ?? 0,
      'videoCount': prev + 1,
    });
  }

  /// 检查日期是否已变更，若变更则清零
  static void checkReset() {
    final data = _read();
    final date = data['date'] as String?;
    if (date != _today()) {
      GStorage.localCache.put(LocalCacheKey.dailyWatchTime, {
        'date': _today(),
        'seconds': 0,
        'videoCount': 0,
      });
    }
  }

  static Map<String, dynamic> _read() {
    final raw = GStorage.localCache.get(
      LocalCacheKey.dailyWatchTime,
      defaultValue: <String, dynamic>{},
    );
    return raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
  }

  static String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/utils/content_filter.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

class RecommendFilter {
  static int minDurationForRcmd = Pref.minDurationForRcmd;
  static int minPlayForRcmd = Pref.minPlayForRcmd;
  static int minLikeRatioForRecommend = Pref.minLikeRatioForRecommend;
  static bool exemptFilterForFollowed = Pref.exemptFilterForFollowed;
  static bool applyFilterToRelatedVideos = Pref.applyFilterToRelatedVideos;
  static RegExp rcmdRegExp = RegExp(
    Pref.banWordForRecommend,
    caseSensitive: false,
  );
  static bool enableFilter = rcmdRegExp.pattern.isNotEmpty;

  /// 知识模式 — 分区白名单（默认：知识/科技/纪录/科学/人文/历史）
  static RegExp _zoneWhitelistRegExp = RegExp(
    Pref.knowledgeZoneWhitelist,
    caseSensitive: false,
  );

  /// 重新加载分区白名单正则
  static void reloadZoneWhitelist() {
    _zoneWhitelistRegExp = RegExp(
      Pref.knowledgeZoneWhitelist,
      caseSensitive: false,
    );
  }

  /// 检查视频分区是否在白名单中（知识模式开启时调用）
  static bool isZoneAllowed(String? zoneName) {
    if (!Pref.enableKnowledgeMode) return true;
    if (zoneName == null || zoneName.isEmpty) return false;
    return _zoneWhitelistRegExp.hasMatch(zoneName);
  }

  /// 检查是否在用户黑名单中
  static bool isBlacklisted(int? mid) {
    return mid != null && GlobalData().blackMids.contains(mid);
  }

  static bool filter(BaseVideoItemModel videoItem) {
    if (videoItem.isFollowed && exemptFilterForFollowed) {
      return false;
    }
    return filterAll(videoItem);
  }

  static bool filterLikeRatio(int? like, int? view) {
    if (view != null) {
      return (view > -1 && view < minPlayForRcmd) ||
          (like != null &&
              like > -1 &&
              like * 100 < minLikeRatioForRecommend * view);
    }
    return false;
  }

  static bool filterTitle(String title, {String? desc, String? tag}) {
    if (enableFilter && rcmdRegExp.hasMatch(title)) return true;
    return ContentFilter.shouldFilter(title: title, desc: desc, tag: tag);
  }

  static bool filterAll(BaseVideoItemModel videoItem) {
    if (isBlacklisted(videoItem.owner.mid)) return true;
    return (videoItem.duration > 0 &&
            videoItem.duration < minDurationForRcmd) ||
        filterLikeRatio(videoItem.stat.like, videoItem.stat.view) ||
        filterTitle(videoItem.title, desc: videoItem.desc);
  }
}

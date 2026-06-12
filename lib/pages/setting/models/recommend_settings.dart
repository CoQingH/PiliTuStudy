import 'package:pilistudy/http/fav.dart';
import 'package:pilistudy/http/video.dart';
import 'package:pilistudy/models/common/settings_type.dart';
import 'package:pilistudy/pages/rcmd/controller.dart';
import 'package:pilistudy/pages/setting/models/model.dart';
import 'package:pilistudy/utils/accounts.dart';
import 'package:pilistudy/utils/content_filter.dart';
import 'package:pilistudy/utils/recommend_filter.dart';
import 'package:pilistudy/utils/storage.dart';
import 'package:pilistudy/utils/storage_key.dart';
import 'package:pilistudy/utils/storage_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

List<SettingsModel> get recommendSettings => [
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '首页使用app端推荐',
    subtitle: '若web端推荐不太符合预期，可尝试切换至app端推荐',
    leading: Icon(Icons.model_training_outlined),
    setKey: SettingBoxKey.appRcmd,
    defaultVal: true,
    needReboot: true,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '保留首页推荐刷新',
    subtitle: '下拉刷新时保留上次内容',
    leading: const Icon(Icons.refresh),
    setKey: SettingBoxKey.enableSaveLastData,
    defaultVal: false,
    onChanged: (value) {
      try {
        Get.find<RcmdController>().enableSaveLastData = value;
      } catch (e) {
        if (kDebugMode) debugPrint('$e');
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '显示上次看到位置提示',
    subtitle: '保留上次推荐时，在上次刷新位置显示提示',
    leading: const Icon(Icons.tips_and_updates_outlined),
    setKey: SettingBoxKey.savedRcmdTip,
    defaultVal: true,
    onChanged: (value) {
      try {
        RcmdController ctr = Get.find<RcmdController>()..savedRcmdTip = value;
        if (!value) {
          ctr.lastRefreshAt = null;
        }
      } catch (e) {
        if (kDebugMode) debugPrint('$e');
      }
    },
  ),
  getVideoFilterSelectModel(
    context: Get.context!,
    title: '点赞率',
    suffix: '%',
    key: SettingBoxKey.minLikeRatioForRecommend,
    values: [0, 1, 2, 3, 4],
    onChanged: (value) => RecommendFilter.minLikeRatioForRecommend = value,
  ),
  getBanwordModel(
    context: Get.context!,
    title: '标题关键词过滤',
    key: SettingBoxKey.banWordForRecommend,
    onChanged: (value) {
      RecommendFilter.rcmdRegExp = value;
      RecommendFilter.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  getBanwordModel(
    context: Get.context!,
    title: 'App推荐/热门/排行榜: 视频分区关键词过滤',
    key: SettingBoxKey.banWordForZone,
    onChanged: (value) {
      VideoHttp.zoneRegExp = value;
      VideoHttp.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  getVideoFilterSelectModel(
    context: Get.context!,
    title: '视频时长',
    suffix: 's',
    key: SettingBoxKey.minDurationForRcmd,
    values: [0, 30, 60, 90, 120],
    onChanged: (value) => RecommendFilter.minDurationForRcmd = value,
  ),
  getVideoFilterSelectModel(
    context: Get.context!,
    title: '播放量',
    key: SettingBoxKey.minPlayForRcmd,
    values: [0, 50, 100, 500, 1000],
    onChanged: (value) => RecommendFilter.minPlayForRcmd = value,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '已关注UP豁免推荐过滤',
    subtitle: '推荐中已关注用户发布的内容不会被过滤',
    leading: const Icon(Icons.favorite_border_outlined),
    setKey: SettingBoxKey.exemptFilterForFollowed,
    defaultVal: true,
    onChanged: (value) {
      RecommendFilter.exemptFilterForFollowed = value;
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '过滤器也应用于相关视频',
    subtitle: '视频详情页的相关视频也进行过滤¹',
    leading: const Icon(Icons.explore_outlined),
    setKey: SettingBoxKey.applyFilterToRelatedVideos,
    defaultVal: true,
    onChanged: (value) {
      RecommendFilter.applyFilterToRelatedVideos = value;
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '过滤性别对立内容',
    subtitle: '过滤含有性别对立/打拳/性别歧视等关键词的视频',
    leading: const Icon(Icons.wc_outlined),
    setKey: SettingBoxKey.contentFilterGender,
    defaultVal: false,
    onChanged: (value) {
      ContentFilter.reload();
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '过滤低俗擦边内容',
    subtitle: '过滤含有擦边/福利姬/性暗示等关键词的视频',
    leading: const Icon(Icons.remove_moderator_outlined),
    setKey: SettingBoxKey.contentFilterNsfw,
    defaultVal: false,
    onChanged: (value) {
      ContentFilter.reload();
    },
  ),
  getBanwordModel(
    context: Get.context!,
    title: '性别对立 - 自定义关键词',
    key: SettingBoxKey.contentFilterGenderCustom,
    onChanged: (_) => ContentFilter.reload(),
  ),
  getBanwordModel(
    context: Get.context!,
    title: '低俗擦边 - 自定义关键词',
    key: SettingBoxKey.contentFilterNsfwCustom,
    onChanged: (_) => ContentFilter.reload(),
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '过滤政治敏感内容',
    subtitle: '过滤含有政治/时事/爱国等关键词的视频',
    leading: const Icon(Icons.gavel_outlined),
    setKey: SettingBoxKey.contentFilterPolitical,
    defaultVal: false,
    onChanged: (value) {
      ContentFilter.reload();
    },
  ),
  getBanwordModel(
    context: Get.context!,
    title: '政治敏感 - 自定义关键词',
    key: SettingBoxKey.contentFilterPoliticalCustom,
    onChanged: (_) => ContentFilter.reload(),
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '学习模式',
    subtitle: '一键开启：知识分区白名单+关闭推荐流+关弹幕+隐藏评论+隐藏相关视频',
    leading: const Icon(Icons.school_outlined),
    setKey: SettingBoxKey.enableStudyMode,
    defaultVal: false,
    onChanged: (value) {
      if (value) {
        // 联动开启：知识模式 + 关闭推荐流 + 纯净播放
        GStorage.setting
          ..put(SettingBoxKey.enableKnowledgeMode, true)
          ..put(SettingBoxKey.disableRcmdFeed, true)
          ..put(SettingBoxKey.enableShowDanmaku, false)
          ..put(SettingBoxKey.alwaysExapndIntroPanel, true)
          ..put(SettingBoxKey.showRelatedVideo, false)
          ..put(SettingBoxKey.defaultShowComment, false);
        RecommendFilter.reloadZoneWhitelist();
        SmartDialog.showToast('学习模式已开启\n推荐流已关闭，仅保留知识分区\n弹幕/评论/相关视频已隐藏');
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '知识模式',
    subtitle: '推荐/热门/排行榜仅保留知识类分区（知识/科技/数码/编程/数学/物理等）',
    leading: const Icon(Icons.filter_list_outlined),
    setKey: SettingBoxKey.enableKnowledgeMode,
    defaultVal: false,
    onChanged: (_) => RecommendFilter.reloadZoneWhitelist(),
  ),
  getBanwordModel(
    context: Get.context!,
    title: '知识模式 — 分区白名单',
    key: SettingBoxKey.knowledgeZoneWhitelist,
    onChanged: (_) => RecommendFilter.reloadZoneWhitelist(),
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '关闭全部推荐流',
    subtitle: '首页隐藏推荐/热门/排行榜，仅保留关注动态、直播、番剧',
    leading: const Icon(Icons.visibility_off_outlined),
    setKey: SettingBoxKey.disableRcmdFeed,
    defaultVal: false,
    needReboot: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '搜索词拦截',
    subtitle: '拦截命中屏蔽词的主动搜索（需开启对应屏蔽类别）',
    leading: const Icon(Icons.block),
    setKey: SettingBoxKey.enableSearchKeywordBlock,
    defaultVal: false,
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '每日观看时长上限',
    subtitle: '0=不限',
    leading: const Icon(Icons.timer_outlined),
    setKey: SettingBoxKey.dailyTimeLimitMinutes,
    getTrailing: () => Text(
      '${Pref.dailyTimeLimitMinutes}min',
      style: Get.theme.textTheme.titleSmall,
    ),
    onTap: (setState) async {
      final choices = [0, 15, 30, 45, 60];
      final current = Pref.dailyTimeLimitMinutes;
      final int? result = await showDialog<int>(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('每日观看时长上限'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: choices.map((c) {
                  return RadioListTile<int>(
                    title: Text(c == 0 ? '不限' : '${c}分钟'),
                    value: c,
                    groupValue: current,
                    onChanged: (v) {
                      if (v != null && v > current && current > 0) {
                        // 上调限制需检查冷却
                        final now = DateTime.now().millisecondsSinceEpoch;
                        final last = Pref.lastDailyLimitIncreaseMs;
                        const cooldown = 24 * 60 * 60 * 1000;
                        if (now - last < cooldown && last > 0) {
                          final remaining = cooldown - (now - last);
                          final h = remaining ~/ (60 * 60 * 1000);
                          final m = (remaining % (60 * 60 * 1000)) ~/ (60 * 1000);
                          SmartDialog.showToast('修改冷却中，${h}h${m}min后可上调');
                          return;
                        }
                        Pref.lastDailyLimitIncreaseMs = now;
                      }
                      GStorage.setting.put(SettingBoxKey.dailyTimeLimitMinutes, v);
                      Get.back();
                      setState();
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.dailyTimeLimitMinutes, result);
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '每日视频数上限',
    subtitle: '0=不限',
    leading: const Icon(Icons.videocam_outlined),
    setKey: SettingBoxKey.dailyVideoCountLimit,
    getTrailing: () => Text(
      '${Pref.dailyVideoCountLimit}个',
      style: Get.theme.textTheme.titleSmall,
    ),
    onTap: (setState) async {
      final choices = [0, 3, 5, 8, 10, 15];
      final current = Pref.dailyVideoCountLimit;
      final int? result = await showDialog<int>(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('每日视频数上限'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: choices.map((c) {
                  return RadioListTile<int>(
                    title: Text(c == 0 ? '不限' : '$c 个'),
                    value: c,
                    groupValue: current,
                    onChanged: (v) {
                      if (v != null && v > current && current > 0) {
                        // 上调限制需检查冷却
                        final now = DateTime.now().millisecondsSinceEpoch;
                        final last = Pref.lastDailyLimitIncreaseMs;
                        const cooldown = 24 * 60 * 60 * 1000;
                        if (now - last < cooldown && last > 0) {
                          final remaining = cooldown - (now - last);
                          final h = remaining ~/ (60 * 60 * 1000);
                          final m = (remaining % (60 * 60 * 1000)) ~/ (60 * 1000);
                          SmartDialog.showToast('修改冷却中，${h}h${m}min后可上调');
                          return;
                        }
                        Pref.lastDailyLimitIncreaseMs = now;
                      }
                      GStorage.setting.put(SettingBoxKey.dailyVideoCountLimit, v);
                      Get.back();
                      setState();
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.dailyVideoCountLimit, result);
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '限额豁免收藏夹',
    subtitle: '在这些收藏夹中观看不计入每日时长/次数',
    leading: const Icon(Icons.folder_off_outlined),
    onTap: (setState) async {
      if (!Accounts.main.isLogin) {
        SmartDialog.showToast('账号未登录');
        return;
      }
      final res = await FavHttp.allFavFolders(Accounts.main.mid);
      if (!res.isSuccess) {
        res.toast();
        return;
      }
      final list = res.data.list;
      if (list == null || list.isEmpty) return;
      final exemptIds = Pref.exemptFavFoldersForLimit;
      showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('选择豁免收藏夹'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: list.map((item) {
                  final isExempt = exemptIds.contains(item.id);
                  return CheckboxListTile(
                    title: Text(item.title),
                    value: isExempt,
                    onChanged: (checked) {
                      if (checked == true) {
                        exemptIds.add(item.id);
                      } else {
                        exemptIds.remove(item.id);
                      }
                      GStorage.setting.put(
                        SettingBoxKey.exemptFavFoldersForLimit,
                        exemptIds,
                      );
                      setState();
                      (context as Element).markNeedsBuild();
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '完成',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  ),
];

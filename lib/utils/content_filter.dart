import 'package:pilistudy/utils/storage_pref.dart';

class ContentFilter {
  static const List<String> _genderKeywords = [
    '男女对立',
    '性别对立',
    '打拳',
    '女拳',
    '男拳',
    '拳师',
    '打拳师',
    '厌女',
    '厌男',
    '性别战争',
    '两性对立',
    '极端女权',
    '极端男权',
    '挑拨性别',
    '制造性别',
    '性别歧视',
    '仇男',
    '仇女',
    '仙女',
    '普信男',
    '普信女',
    '小仙女',
    '下头男',
    '下头女',
    '婚恋',
    '彩礼',
    '恐婚',
    '不婚',
    '生育',
    '女性主义',
    '男权',
    '女权',
    '大男子主义',
    '物化女性',
    '物化男性',
    '荡妇羞辱',
    '凤凰男',
    '扶弟魔',
    '妈宝男',
    '直男癌',
    '田园女权',
  ];

  static const List<String> _nsfwKeywords = [
    // 直接的
    '擦边',
    'R18',
    'R-18',
    '18禁',
    '色情',
    '淫秽',
    '低俗',
    '成人',
    '限制级',
    '色欲',
    '情色',
    '黄色',
    'H漫',
    '本子',
    '里番',
    // 软色情/暗示
    '福利姬',
    '性暗示',
    '擦边球',
    '软色情',
    '打擦边',
    '情趣',
    '露点',
    '走光',
    '乳摇',
    '巨乳',
    '爆乳',
    '大胸',
    '美乳',
    '酥胸',
    '半球',
    '深沟',
    '事业线',
    '齐逼',
    '露底',
    '走guang',
    '春光',
    '真空',
    '激凸',
    '凸点',
    // ASMR
    'ASMR',
    '娇喘',
    '舔耳',
    '耳骚',
    '口腔音',
    '触发音',
    '助眠',
    '哄睡',
    '膝枕',
    // 穿搭/舞蹈相关
    '黑丝',
    '白丝',
    '渔网袜',
    '吊带袜',
    '绝对领域',
    '超短裙',
    'JK制服',
    '女仆装',
    '死库水',
    '比基尼',
    '泳装',
    '内衣',
    '透视装',
    '露背',
    '露脐',
    '露腰',
    '超短裤',
    '热裤',
    '丁字裤',
    // 动作/行为
    '热舞',
    '艳舞',
    '钢管舞',
    '电臀',
    '抖臀',
    '扭胯',
    '顶胯',
    '蹲下',
    '弯腰',
    '俯身',
    '乳沟',
    '深V',
    '低胸',
    '抹胸',
    // 直播相关
    '颜值区',
    '舞蹈区',
    '女主播',
    '直播间',
    '颜值主播',
    '舞蹈主播',
    // 福利/写真
    '写真',
    '福利',
    '套图',
    '私房',
    '私拍',
    '约拍',
    '人体艺术',
    '人体摄影',
    // COS
    'COS',
    'Cosplay',
    'coser',
    '色气',
    '绅士',
    '福利cos',
    // 其他平台引流
    'OnlyFans',
    'P站',
    'Pornhub',
    'X站',
    '绅士天堂',
    // 约会/社交
    '约炮',
    '一夜情',
    '同城约会',
    '交友软件',
    '探探',
    '陌陌',
    'Soul',
    '积目',
  ];

  static const List<String> _politicalKeywords = [
    // 国际政治人物
    '特朗普',
    '拜登',
    '奥巴马',
    '希拉里',
    '哈里斯',
    '马斯克',
    '普京',
    '泽连斯基',
    '金正恩',
    '尹锡悦',
    '安倍',
    '岸田',
    '石破茂',
    '内塔尼亚胡',
    // 国内政治
    '习近平',
    '包子',
    '维尼',
    '乳包',
    '刁大大',
    '庆丰',
    '小熊维尼',
    '天安门',
    '六四',
    '六四事件',
    '坦克人',
    '法轮功',
    '达赖',
    '藏独',
    '疆独',
    '台独',
    '港独',
    '反华',
    '辱华',
    '反共',
    '政治',
    '体制',
    '政权',
    '共产党',
    '国民党',
    '中共',
    '党中央',
    '政治局',
    '两会',
    '人大',
    '政协',
    '民主',
    '独裁',
    '专制',
    '极权',
    '言论自由',
    '新闻自由',
    '审查',
    'censorship',
    '防火墙',
    'GFW',
    '翻墙',
    'VPN',
    '敏感词',
    // 社会议题
    '社会信用',
    '监控',
    '维稳',
    '上访',
    '强拆',
    '城管',
    '钉子户',
    '农民工',
    '996',
    '内卷',
    '躺平',
    '润',
    '移民',
    '爱国',
    '战狼',
    '小粉红',
    '五毛',
    '美分',
    '带路党',
    '恨国党',
    '公知',
    '粉红',
    // 国际关系
    '中美',
    '中日',
    '中韩',
    '中印',
    '两岸',
    '台湾',
    '香港',
    '新疆',
    '西藏',
    '南海',
    '钓鱼岛',
    '贸易战',
    '芯片战',
    '制裁',
    '脱钩',
    // 时事热点
    '疫情',
    '清零',
    '封城',
    '核酸',
    '疫苗',
    '辉瑞',
    '科兴',
    '乌克兰',
    '俄罗斯',
    '哈马斯',
    '以色列',
    '巴以',
    '俄乌',
    '北约',
    '厉害了我的国',
    '辱华',
    '反华',
  ];

  static bool get enableGender => Pref.contentFilterGender;
  static bool get enableNsfw => Pref.contentFilterNsfw;
  static bool get enablePolitical => Pref.contentFilterPolitical;

  static RegExp _genderRegExp = _buildRegex(
    _genderKeywords,
    Pref.contentFilterGenderCustom,
  );
  static RegExp _nsfwRegExp = _buildRegex(
    _nsfwKeywords,
    Pref.contentFilterNsfwCustom,
  );
  static RegExp _politicalRegExp = _buildRegex(
    _politicalKeywords,
    Pref.contentFilterPoliticalCustom,
  );

  static RegExp _buildRegex(List<String> keywords, String customPattern) {
    final all = <String>[...keywords];
    if (customPattern.isNotEmpty) {
      all.add(customPattern);
    }
    return RegExp(all.join('|'), caseSensitive: false);
  }

  /// 重新加载正则（设置变更后调用）
  static void reload() {
    _genderRegExp = _buildRegex(_genderKeywords, Pref.contentFilterGenderCustom);
    _nsfwRegExp = _buildRegex(_nsfwKeywords, Pref.contentFilterNsfwCustom);
    _politicalRegExp = _buildRegex(
      _politicalKeywords,
      Pref.contentFilterPoliticalCustom,
    );
  }

  /// 检查标题/描述/标签是否命中过滤词
  static bool shouldFilter({
    required String title,
    String? desc,
    String? tag,
  }) {
    final text = <String>[
      title,
      if (desc != null && desc.isNotEmpty) desc,
      if (tag != null && tag.isNotEmpty) tag,
    ].join(' ');

    if (enableGender && _genderRegExp.hasMatch(text)) return true;
    if (enableNsfw && _nsfwRegExp.hasMatch(text)) return true;
    if (enablePolitical && _politicalRegExp.hasMatch(text)) return true;
    return false;
  }

  /// 检查搜索关键词本身是否命中屏蔽规则（用于拦截主动搜索）
  static bool isKeywordBlocked(String keyword) {
    if (keyword.isEmpty) return false;
    if (enableGender && _genderRegExp.hasMatch(keyword)) return true;
    if (enableNsfw && _nsfwRegExp.hasMatch(keyword)) return true;
    if (enablePolitical && _politicalRegExp.hasMatch(keyword)) return true;
    return false;
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pilistudy/app/theme.dart';
import 'package:pilistudy/http/init.dart';
import 'package:pilistudy/pages/home/youtube_home.dart';
import 'package:pilistudy/pages/search/youtube_search.dart';
import 'package:pilistudy/pages/library/view.dart';
import 'package:pilistudy/pages/setting/youtube_setting.dart';
import 'package:pilistudy/router/app_pages.dart';
import 'package:pilistudy/services/account_service.dart';
import 'package:pilistudy/utils/app_scheme.dart';
import 'package:pilistudy/utils/cache_manage.dart';
import 'package:pilistudy/utils/page_utils.dart';
import 'package:pilistudy/utils/request_utils.dart';
import 'package:pilistudy/utils/storage.dart';
import 'package:pilistudy/utils/utils.dart';
import 'package:pilistudy/utils/storage_key.dart';
import 'package:pilistudy/utils/storage_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await GStorage.init();
  Get.lazyPut(AccountService.new);
  HttpOverrides.global = _CustomHttpOverrides();

  await Future.wait([
    CacheManage.autoClearCache(),
    if (Utils.isMobile) SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      if (Pref.horizontalScreen) DeviceOrientation.landscapeLeft,
      if (Pref.horizontalScreen) DeviceOrientation.landscapeRight,
    ]),
  ]);

  Request();
  Request.setCookie();
  RequestUtils.syncHistoryStatus();
  if (Utils.isMobile) PiliScheme.init();

  SmartDialog.config.toast = SmartConfigToast(displayType: SmartToastType.onlyRefresh);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));

  runApp(const StudyTubeApp());
}

class _CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    if (Pref.badCertificateCallback) {
      return super.createHttpClient(context)..badCertificateCallback = (_, __, ___) => true;
    }
    return super.createHttpClient(context);
  }
}

typedef MyApp = StudyTubeApp;

class StudyTubeApp extends StatelessWidget {
  const StudyTubeApp({super.key});
  static ThemeData? darkThemeData;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PiliTuStudy',
      debugShowCheckedModeBanner: false,
      theme: YTTheme.darkTheme,
      darkTheme: YTTheme.darkTheme,
      themeMode: ThemeMode.dark,
      getPages: Routes.getPages,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  static const _pages = <Widget>[
    YoutubeHomePage(),
    YoutubeSearchPage(),
    LibraryPage(),
    YoutubeSettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: '搜索'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library_outlined), activeIcon: Icon(Icons.video_library), label: '媒体库'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: '设置'),
        ],
      ),
    );
  }
}

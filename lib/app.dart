
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:old_goods_trading/states/user_info_state.dart';
import 'package:old_goods_trading/utils/chat_uikit_manager.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'page/bottom_nav_bar/bottom_nav_bar.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {


  @override
  void initState() {
    ///初始化IM SDK
    ChatUikitManager.initTIMUIKitSDK();
    _checkIfConnected();
    super.initState();
  }

  Future<void> _checkIfConnected() async {
    V2TimValueCallback<int> getLoginStatusRes =
    await TencentImSDKPlugin.v2TIMManager.getLoginStatus();
    if (getLoginStatusRes.code == 0) {
      int? status = getLoginStatusRes.data; // getLoginStatusRes.data为用户登录状态值

      if (status == 1 || status == 2) {
        debugPrint('IM----------1 已登录  2 正在登录中${getLoginStatusRes.data}');
        return;
      } else {
        debugPrint('IM----------3 未登录${getLoginStatusRes.data}');
        await ChatUikitManager.loginIM();
        return;
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserInfoViewModel())],
      child: RefreshConfiguration(
        headerBuilder: () => const WaterDropHeader(),
        // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
        footerBuilder: () => const ClassicFooter(),
        // 配置默认底部指示器
        headerTriggerDistance: 80.0,
        // 头部触发刷新的越界距离
        springDescription:
            const SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
        // 自定义回弹动画,三个属性值意义请查询flutter api
        maxOverScrollExtent: 100,
        //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
        maxUnderScrollExtent: 0,
        // 底部最大可以拖动的范围
        enableScrollWhenRefreshCompleted: true,
        //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
        enableLoadingWhenFailed: true,
        //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
        hideFooterWhenNotFull: false,
        // Viewport不满一屏时,禁用上拉加载更多功能
        enableBallisticLoad: true,
        child: MaterialApp(
          localizationsDelegates: const [
            RefreshLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('zh'),
          ],
          localeResolutionCallback:
              (Locale? locale, Iterable<Locale> supportedLocales) {
            return locale;
          },
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black, size: 17),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 17,
                color: Color(0xFF2F3033),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          builder: BotToastInit(),
          navigatorKey: navigatorKey,
          navigatorObservers: [BotToastNavigatorObserver()],
          home: const BottomNavBar(),
        ),
      ),
    );
  }
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext? globalContext() => navigatorKey.currentState?.overlay?.context;
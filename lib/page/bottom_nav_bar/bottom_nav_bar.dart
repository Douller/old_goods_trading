import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import '../../constants/constants.dart';
import '../../states/user_info_state.dart';
import '../../utils/channel_push.dart';
import '../../utils/refresh_publish_event_bus.dart';
import '../../utils/toast.dart';
import '../add/add_page.dart';
import '../category/category_page.dart';
import '../home/home_page.dart';
import '../message/chat_page.dart';
import '../message/message_page.dart';
import '../mine/mine_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  DateTime? _lastPressTime;
  int _selectedPage = 0;
  late TabController _tabController;
  late PageController _pageController;
  final List<Widget> _pageList = [
    const HomePage(),
    const CategoryPage(),
    const AddPage(),
    const MessagePage(),
    const MinePage(),
  ];

  StreamSubscription? subscription;

  final TIMUIKitChatController _timuiKitChatController =
      TIMUIKitChatController();

  initOfflinePush() async {
    await ChannelPush.init(handleClickNotification);
    uploadOfflinePushInfoToken();
  }

  uploadOfflinePushInfoToken() async {
    ChannelPush.requestPermission();
    Future.delayed(const Duration(seconds: 3), () async {
      final bool isUploadSuccess =
          await ChannelPush.uploadToken(Constants.appInfo);
      debugPrint("Push token upload result: $isUploadSuccess");
    });
  }

  void handleClickNotification(Map<String, dynamic> msg) async {
    String ext = msg['ext'] ?? "";
    Map<String, dynamic> extMsp = jsonDecode(ext);
    String convId = extMsp["conversationID"] ?? "";
    //若当前的会话与要跳转至的会话一致，则不跳转。
    final currentConvID = _timuiKitChatController.getCurrentConversation();
    if (currentConvID == convId.split("_")[1]) {
      return;
    }
    final targetConversationRes = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .getConversation(conversationID: convId);
    V2TimConversation? targetConversation = targetConversationRes.data;
    if (targetConversation != null) {
      ChannelPush.clearAllNotification();
      if(!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            selectedConversation: targetConversation,
          ),
        ),
      );
    }

    // String ext = msg['ext'] ?? "";
    // Map<String, dynamic> extMsp = jsonDecode(ext);
    // V2TimConversation targetConversation = V2TimConversation.fromJson(extMsp['selectedConversation']);
    // ChannelPush.clearAllNotification();
    //
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => ChatPage(
    //         selectedConversation: targetConversation,
    //       ),
    //     ),
    //   );
    // });
  }

  @override
  void initState() {
    _tabController = TabController(length: _pageList.length, vsync: this);
    _pageController = PageController(initialPage: _selectedPage);

    subscription = eventBus.on<BackHomePage>().listen((event) {
      if (event.backHomePage == true) {
        if (_tabController.index != 0) {
          setState(() {
            _selectedPage = 0;
            _tabController.index = 0;
            _pageController.jumpToPage(_selectedPage);
          });
        }
      }
    });
    initOfflinePush();
    super.initState();
  }

  List<BottomNavigationBarItem> _getTabBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Image.asset(
          '${Constants.tabImagePath}tab_home_nor.png',
          width: 24,
          height: 24,
        ),
        activeIcon: Image.asset(
          '${Constants.tabImagePath}tab_home_sel.png',
          width: 24,
          height: 24,
        ),
        label: "首页",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          '${Constants.tabImagePath}tab_category_nor.png',
          width: 24,
          height: 24,
        ),
        activeIcon: Image.asset(
          '${Constants.tabImagePath}tab_category_sel.png',
          width: 24,
          height: 24,
        ),
        label: "目录",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          '${Constants.tabImagePath}tab_add.png',
          width: 32,
          height: 32,
        ),
        label: "发布",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          '${Constants.tabImagePath}tab_message_nor.png',
          width: 24,
          height: 24,
        ),
        activeIcon: Image.asset(
          '${Constants.tabImagePath}tab_message_sel.png',
          width: 24,
          height: 24,
        ),
        label: "消息",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          '${Constants.tabImagePath}tab_mine_nor.png',
          width: 24,
          height: 24,
        ),
        activeIcon: Image.asset(
          '${Constants.tabImagePath}tab_mine_sel.png',
          width: 24,
          height: 24,
        ),
        label: "我的",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          if (_lastPressTime == null ||
              DateTime.now().difference(_lastPressTime!) >
                  const Duration(seconds: 1)) {
            if (_tabController.index != 0) {
              setState(() {
                _selectedPage = 0;
                _tabController.index = 0;
                _pageController.jumpToPage(_selectedPage);
              });
            } else {
              _lastPressTime = DateTime.now();
              ToastUtils.showText(text: '再按一次退出程序');
            }

            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pageList,
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: const Color.fromRGBO(0, 0, 0, 0),
            highlightColor: const Color.fromRGBO(0, 0, 0, 0),
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xffF4F3F3),
            items: _getTabBarItems(),
            currentIndex: _selectedPage,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            selectedItemColor: const Color(0xffE7DD45),
            unselectedItemColor: const Color(0xff484C52),
            onTap: (int i) async {
              if ((i == 2 || i == 3) && !Constants.isLogin()) {
                setState(() {
                  _selectedPage = 0;
                  _tabController.index = 0;
                  _pageController.jumpToPage(_selectedPage);
                });
                bool login =
                    await Provider.of<UserInfoViewModel>(context, listen: false)
                        .login();
                if (login == false || i == 3) {
                  setState(() {
                    _selectedPage = 0;
                    _tabController.index = 0;
                    _pageController.jumpToPage(_selectedPage);
                  });
                }
              } else {
                if (i == 2) {
                  AppRouter.push(context, const AddPage()).then((value) {
                    setState(() {
                      _selectedPage = 0;
                      _tabController.index = 0;
                      _pageController.jumpToPage(_selectedPage);
                    });
                  });
                } else {
                  setState(() {
                    _selectedPage = i;
                    _pageController.jumpToPage(_selectedPage);
                  });
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';
import '../../model/my_coupon_model.dart';
import '../../net/service_repository.dart';
import '../../states/my_coupon_state.dart';

class MyCouponPage extends StatefulWidget {
  const MyCouponPage({Key? key}) : super(key: key);

  @override
  State<MyCouponPage> createState() => _MyCouponPageState();
}

class _MyCouponPageState extends State<MyCouponPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabBarList = [
    '未使用',
    '已使用',
    '已过期',
  ];

  TabController? _tabController;
  final MyCouponViewModel _myCouponViewModel = MyCouponViewModel();
  final TextEditingController _addCouponTF = TextEditingController();

  //统一定义一个圆角样式
  var customBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
      borderSide: BorderSide(color: const Color(0xffE4D719).withOpacity(0.8)));

  @override
  void initState() {
    _tabController = TabController(length: _tabBarList.length, vsync: this);
    _myCouponViewModel.getMyCouponListData();
    super.initState();
  }

  Future<void> _addCouponSn() async {
    if (_addCouponTF.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入优惠卷码');
      return;
    }

    ToastUtils.showLoading();
    bool res = await ServiceRepository.couponAdd(couponSn: _addCouponTF.text);
    if (res) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _myCouponViewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(title: const Text('优惠券')),
        body: ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),

          children: [
            _topTabBarView(),
            Consumer<MyCouponViewModel>(
              builder: (BuildContext context, value, Widget? child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 26),
                  itemCount: value.modelList.length,
                  itemBuilder: (context, index) {
                    return _itemCellView(value.modelList[index]);
                  },
                );
              },
            ),
            _tabController?.index == 0 ? _addCouponView() : Container(),
          ],
        ),
      ),
    );
  }

  Widget _topTabBarView() {
    return SizedBox(
      height: 40,
      child: Theme(
        data: ThemeData(
          splashColor: const Color.fromRGBO(0, 0, 0, 0),
          highlightColor: const Color.fromRGBO(0, 0, 0, 0),
        ),
        child: TabBar(
          controller: _tabController,
          labelColor: const Color(0xff484C52),
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          unselectedLabelColor: const Color(0xff484C52).withOpacity(0.4),
          unselectedLabelStyle: const TextStyle(fontSize: 16),
          indicatorColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: List.generate(_tabBarList.length, (index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: (index == _tabController?.index)
                    ? const Color(0xffE4D719)
                    : Colors.transparent,
              ),
              child: Text(_tabBarList[index]),
            );
          }),
          // 设置标题
          onTap: (int i) {
            setState(() {});
            _myCouponViewModel.changeTabStatus(i);
          },
        ),
      ),
    );
  }

  Widget _itemCellView(MyCouponModel model) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            '${Constants.iconsPath}coupon_tag.png',
            width: 24,
            height: 24,
            color: _tabController?.index == 0
                ? const Color(0xffE4D719).withOpacity(0.8)
                : const Color(0xffE4D719).withOpacity(0.4),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ThemeText(
                  text: model.name ?? '',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _tabController?.index == 0
                      ? const Color(0xff484C52).withOpacity(0.8)
                      : const Color(0xff484C52).withOpacity(0.4),
                ),
                const SizedBox(height: 8),
                ThemeText(
                  text: model.descpotion ?? '',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff9098B1),
                  height: 1.5,
                ),
                const SizedBox(height: 8),
                ThemeText(
                  text: model.isSupplier ?? '',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffEA4545).withOpacity(0.8),
                ),
                const SizedBox(height: 8),
                ThemeText(
                  text: '到期时间：${model.useEndTime}',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _tabController?.index == 0
                      ? const Color(0xffEA4545).withOpacity(0.8)
                      : const Color(0xffEA4545).withOpacity(0.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addCouponView() {
    return Container(
        height: 56,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addCouponTF,
                style: const TextStyle(
                  color: Color(0xff484C52),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  filled: true,
                  border: customBorder,
                  enabledBorder: customBorder,
                  focusedBorder: customBorder,
                  focusedErrorBorder: customBorder,
                  errorBorder: customBorder,
                  disabledBorder: customBorder,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  fillColor: Colors.white,
                  hintText: '输入优惠卷码',
                  hintStyle: const TextStyle(
                    color: Color(0xff484C52),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _addCouponSn(),
              child: Container(
                width: 63,
                alignment: Alignment.center,
                color: const Color(0xffE4D719).withOpacity(0.8),
                child: const ThemeText(
                  text: '添加',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ));
  }
}

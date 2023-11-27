import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import '../../model/nearby_address_model.dart';
import '../../widgets/home_widgets/search_text_field.dart';

typedef ChooseLocationCallBack = void Function(
  String latitude,
  String longitude,
  String address,
  String cityName,
  String provinceName,
  String addressId,
  String addressInfo,
  String zipcode,
  String addressAll,
);

class ChooseLocationPage extends StatefulWidget {
  final String latitude;
  final String longitude;
  final String keywords;
  final String? countryId;
  final String? title;
  final ChooseLocationCallBack locationCallBack;

  const ChooseLocationPage(
      {Key? key,
      required this.latitude,
      required this.longitude,
      required this.keywords,
      required this.locationCallBack,
      this.countryId,
      this.title})
      : super(key: key);

  @override
  State<ChooseLocationPage> createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  List<Data> _addressList = [];
  List<Data> _searchList = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _getArea();
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _searchList.clear();
        });
      }
    });
    super.initState();
  }

  Future<void> _searchAddress(String text) async {
    ToastUtils.showLoading();
    NearbyAddressModel? model =
        await ServiceRepository.getAreaGetListByLonlat(keywords: text);

    if (model != null && (model.data ?? []).isNotEmpty) {
      setState(() {
        _searchList = model.data ?? [];
      });
    }
  }

  Future<void> _getArea() async {
    ToastUtils.showLoading();
    NearbyAddressModel? model = await ServiceRepository.getAreaGetListByLonlat(
        keywords: widget.keywords,
        latitude: widget.latitude,
        longitude: widget.longitude);

    if (model != null && (model.data ?? []).isNotEmpty) {
      setState(() {
        _addressList = model.data ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.title ?? '宝贝所在地'),
        ),
        body: Column(
          children: [
            _topView(),
            _searchList.isEmpty
                ? Expanded(
                    child: ListView(
                      children: [
                        // _addressView('常用地址'),
                        // Container(height: 10, color: const Color(0xFFF2F3F5)),
                        _addressList.isEmpty
                            ? Container()
                            : _addressView('附近地址'),
                        Container(height: 10, color: const Color(0xFFF2F3F5)),
                        // _cityView(),
                      ],
                    ),
                  )
                : _searchListView()
          ],
        ),
      ),
    );
  }

  Widget _topView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: SearchTextField(
                  controller: _controller,
                  fillColor: const Color(0xffF6F6F6),
                  hintText: '搜索地址',
                  onSubmitted: (String text) async {
                    await _searchAddress(text);
                  },
                ),
              ),
              _searchList.isEmpty
                  ? Container()
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          _searchList.clear();
                          _controller.clear();
                        });
                      },
                      child: const ThemeText(
                        text: '取消',
                      ))
            ],
          ),
        ),
        Container(
          height: 36,
          alignment: Alignment.center,
          color: const Color(0xFFF2F3F5),
          child: const ThemeText(
            text: '选择精准的地址，帮你推给更多同城买家，卖更快',
            color: Color(0xFFCECECE),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _addressView(String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThemeText(
            text: subtitle,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _addressList.length,
              itemBuilder: (context, index) {
                return _listCell(_addressList[index]);
              }),
        ],
      ),
    );
  }

  // Widget _cityView() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 21),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const ThemeText(
  //           text: '城市区域',
  //           fontSize: 14,
  //           fontWeight: FontWeight.w500,
  //           color: Color(0xFF666666),
  //         ),
  //         const SizedBox(height: 24),
  //         ThemeText(
  //           text: widget.keywords,
  //           fontSize: 14,
  //           fontWeight: FontWeight.w500,
  //         ),
  //         const SizedBox(height: 24),
  //         GestureDetector(
  //           onTap: () {
  //             AppRouter.replace(
  //               context,
  //               newPage: MoreAddressPage(
  //                 userAddress: widget.keywords,
  //               ),
  //             );
  //           },
  //           child: Row(
  //             children: [
  //               const ThemeText(
  //                 text: '更多其他区域',
  //                 fontWeight: FontWeight.w700,
  //                 fontSize: 16,
  //                 color: Color(0xFF2AA4E5),
  //               ),
  //               const SizedBox(width: 8),
  //               Image.asset(
  //                 '${Constants.iconsPath}right_arrow.png',
  //                 width: 10,
  //                 height: 10,
  //                 color: const Color(0xFF2AA4E5),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _listCell(Data model) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.locationCallBack(
          model.latitude ?? '',
          model.longitude ?? '',
          model.name ?? '',
          model.city ?? '',
          model.province ?? '',
          model.addressId ?? '',
          model.addressInfo ?? '',
          model.zipcode ?? '',
          model.addres ?? '',
        );
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          ThemeText(
            text: model.name ?? '',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 4),
          ThemeText(
            text: model.addres ?? '',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF999999),
          ),
        ],
      ),
    );
  }

  Widget _searchListView() {
    return Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          itemCount: _searchList.length,
          itemBuilder: (context, index) {
            return _listCell(_searchList[index]);
          }),
    );
  }
}

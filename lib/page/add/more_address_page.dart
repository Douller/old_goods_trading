import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';

import '../../model/all_area_model.dart';
import '../../utils/refresh_publish_event_bus.dart';

class MoreAddressPage extends StatefulWidget {
  final String userAddress;

  const MoreAddressPage({
    Key? key,
    required this.userAddress,
  }) : super(key: key);

  @override
  State<MoreAddressPage> createState() => _MoreAddressPageState();
}

class _MoreAddressPageState extends State<MoreAddressPage> {
  List<Area> _countryList = [];
  List<Area> _parentList = [];
  List<Area> _cityList = [];

  String? _currentCountryId;
  String? _currentCityId;
  String? _currentParentId;
  int _currIndex = 0;

  //获取国家数组
  Future<void> _getAreaCountry() async {
    ToastUtils.showLoading();
    List<Area> dataList = await ServiceRepository.getAreaCountry();
    setState(() {
      _countryList = dataList;
    });
  }

  //获取省份和城市 level: '1' country_id =选择的 && parent_id
  Future<void> _getAreaProvince(String countryId) async {
    _currentCountryId = countryId;
    ToastUtils.showLoading();
    AllAreaModel? model =
        await ServiceRepository.getAreaList(level: '1', countryId: countryId);
    setState(() {
      _currIndex = 1;
      _parentList = model?.data ?? [];
    });
  }

  Future<void> _getAreaCity(String parentId) async {
    if ((_currentCountryId ?? '').isEmpty) return;
    _currentParentId = parentId;
    ToastUtils.showLoading();
    AllAreaModel? model = await ServiceRepository.getAreaList(
        level: '2', countryId: _currentCountryId!, parentId: parentId);
    setState(() {
      _currIndex = 2;
      _cityList = model?.data ?? [];
    });
  }

  @override
  void initState() {
    _getAreaCountry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('所在地'),
      ),
      body: Column(
        children: [
          _subtitleView('您的位置'),
          _userCityView(widget.userAddress),
          _subtitleView('切换城市'),
          _countryList.isEmpty
              ? Container()
              : Expanded(
                  child: ListView.builder(
                    itemCount: _currIndex == 0
                        ? _countryList.length
                        : _currIndex == 1
                            ? _parentList.length
                            : _cityList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          if (_currIndex == 0) {
                            await _getAreaProvince(
                                _countryList[index].id ?? '');
                          } else if (_currIndex == 1) {
                            await _getAreaCity(_parentList[index].id ?? '');
                          } else if (_currIndex == 2) {
                            eventBus.fire(ChooseLocation(
                              ' ${_cityList[index].name ?? ''}',
                              _cityList[index].latitude ?? '',
                              _cityList[index].longitude ?? '',
                            ));
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          height: 44,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ThemeText(
                                    text: _currIndex == 0
                                        ? _countryList[index].name ?? ''
                                        : _currIndex == 1
                                            ? _parentList[index].name ?? ''
                                            : _cityList[index].name ?? '',
                                    fontSize: 16,
                                  ),
                                  Image.asset(
                                    '${Constants.iconsPath}right_arrow.png',
                                    width: 11,
                                    height: 11,
                                  )
                                ],
                              ),
                              Expanded(child: Container()),
                              Container(
                                  height: 1, color: const Color(0xFFF2F3F5)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _subtitleView(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      height: 36,
      color: const Color(0xFFF2F3F5),
      alignment: Alignment.centerLeft,
      child: ThemeText(
        text: title,
        color: const Color(0xFFCECECE),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _userCityView(String cityName) {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      height: 42,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: ThemeText(
        text: cityName,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

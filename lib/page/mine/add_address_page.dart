import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import '../../dialog/dialog.dart';
import '../../model/all_area_model.dart';
import '../../model/order_buy_confirm_model.dart';
import '../../router/app_router.dart';
import '../../utils/custom_popup_menu.dart';
import '../../utils/location_utils.dart';
import '../../widgets/theme_button.dart';
import '../add/choose_location_page.dart';

class AddAddressPage extends StatefulWidget {
  final bool isEdit;
  final AddressModelInfo? addressModel;

  const AddAddressPage({
    Key? key,
    this.isEdit = false,
    this.addressModel,
  }) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _surnameTEC = TextEditingController();
  final TextEditingController _nameTEC = TextEditingController();
  final TextEditingController _address1TEC = TextEditingController();
  final TextEditingController _address2TEC = TextEditingController();
  final TextEditingController _zipCodeTEC = TextEditingController();
  final TextEditingController _phoneNumTEC = TextEditingController();

  // final TextEditingController _provinceTEC = TextEditingController();
  // final TextEditingController _cityTEC = TextEditingController();

  List<Area> _countryList = [];

  // List<Area> _parentList = [];
  // List<Area> _cityList = [];
  Area? _currentCountry;

  // Area? _currentCity;
  // Area? _currentParent;

  String _latitude = '';
  String _longitude = '';
  String _provinceId = '1';
  String _cityId = '1';
  String _province = '';
  String _city = '';
  String _addressId = '';
  String _addressInfo = '';
  String _isDefault = '0';

  //获取国家数组
  Future<void> _getAreaCountry() async {
    ToastUtils.showLoading();
    List<Area> dataList = await ServiceRepository.getAreaCountry();
    setState(() {
      _countryList = dataList;
    });
  }

  //获取省份和城市 level: '1' country_id =选择的 && parent_id
  // Future<void> _getAreaProvince() async {
  //   if (_currentCountry == null) return;
  //   ToastUtils.showLoading();
  //   AllAreaModel? model = await ServiceRepository.getAreaList(
  //       level: '1', countryId: _currentCountry!.id!);
  //
  //   setState(() {
  //     _parentList = model?.data ?? [];
  //   });
  // }

  // Future<void> _getAreaCity() async {
  //   if (_currentCountry == null) return;
  //   if (_currentParent == null) return;
  //   ToastUtils.showLoading();
  //   AllAreaModel? model = await ServiceRepository.getAreaList(
  //       level: '2',
  //       countryId: _currentCountry!.id!,
  //       parentId: _currentParent?.id);
  //
  //   setState(() {
  //     _cityList = model?.data ?? [];
  //   });
  // }

  Future<void> _saveAddress() async {
    if (_currentCountry == null) {
      ToastUtils.showText(text: '请选择国家');
      return;
    }
    if (_province.isEmpty && _provinceId.isEmpty) {
      ToastUtils.showText(text: '请选择省份/州');
      return;
    }
    if (_city.isEmpty && _cityId.isEmpty) {
      ToastUtils.showText(text: '请选择城市');
      return;
    }
    if (_surnameTEC.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入姓氏');
      return;
    }
    if (_nameTEC.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入名字');
      return;
    }
    if (_address1TEC.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入地址');
      return;
    }
    if (_zipCodeTEC.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入邮政编码');
      return;
    }
    if (_phoneNumTEC.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入电话号码');
      return;
    }

    ToastUtils.showLoading();
    String addressId = await ServiceRepository.addAddress(
      id: widget.addressModel?.id,
      xing: _surnameTEC.text.trim(),
      consignee: _nameTEC.text.trim(),
      telephone: _phoneNumTEC.text.trim(),
      address1: _address1TEC.text.trim(),
      address2: _address2TEC.text.trim(),
      countryId: _currentCountry?.id,
      cityId: _cityId,
      provinceId: _provinceId,
      zipcode: _zipCodeTEC.text.trim(),
      city: _city,
      province: _province,
      latitude: _latitude,
      longitude: _longitude,
      addressId: _addressId,
      addressInfo: _addressInfo,
      isDefault: _isDefault,
    );
    if (addressId.isNotEmpty) {
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  ///获取经纬度
  Future<void> _requestLocationPermission() async {
    bool res = await LocationUtils().requestLocationPermission();
    if (!res && mounted) {
      bool? dialogRes = await DialogUtils.openSetting(context);
      if ((dialogRes ?? false) == false) {
        ToastUtils.showText(text: '未获取到您的位置');
        return;
      }
    } else {
      LocationData locationData = await LocationUtils().getLocationData();

      _latitude = locationData.latitude.toString();
      _longitude = locationData.longitude.toString();
    }
  }

  Future<void> _chooseCity() async {
    if ((_currentCountry?.id ?? '').isEmpty) {
      ToastUtils.showText(text: '请先选择国家');
      return;
    }

    if (_latitude.isEmpty || _longitude.isEmpty) {
      ToastUtils.showText(text: '未获取到您的位置');
      return;
    }

    AppRouter.push(
        context,
        ChooseLocationPage(
          latitude: _latitude,
          longitude: _longitude,
          countryId: _currentCountry?.id,
          keywords: '',
          title: '选择地址',
          locationCallBack: (
            String latitude,
            String longitude,
            String address,
            String cityName,
            String provinceName,
            String addressId,
            String addressInfo,
            String zipcode,
            String addressAll,
          ) {
            setState(() {
              _province = provinceName;
              _city = cityName;
              _latitude = latitude;
              _longitude = longitude;
              _addressId = addressId;
              _addressInfo = addressInfo;
              _address1TEC.text = addressAll;
              _zipCodeTEC.text = zipcode;
            });
          },
        ));
  }

  @override
  void initState() {
    _requestLocationPermission();
    _getAreaCountry();
    if (widget.addressModel != null) {
      setState(() {
        _isDefault = widget.addressModel?.isDefault ?? '0';
        _surnameTEC.text = widget.addressModel?.xing ?? '';
        _nameTEC.text = widget.addressModel?.consignee ?? '';
        _address1TEC.text = widget.addressModel?.address ?? '';
        _address2TEC.text = widget.addressModel?.address2 ?? '';
        _zipCodeTEC.text = widget.addressModel?.zipcode ?? '';
        _phoneNumTEC.text = widget.addressModel?.telephone ?? '';

        _province = widget.addressModel?.provinceName ?? '';
        _city = widget.addressModel?.cityName ?? '';

        _provinceId = widget.addressModel?.provinceId ?? '';
        _cityId = widget.addressModel?.cityId ?? '';
        _currentCountry = Area(
          id: widget.addressModel?.countryId,
          name: widget.addressModel?.countryName,
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: const Color(0xffFAFAFA),
        appBar: AppBar(
          title: Text(widget.isEdit ? '修改地址' : '添加地址'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              _menuView('所在国家', _countryList),
              _itemView(title: '名', controller: _nameTEC, hintText: '请填写您的名字'),
              _itemView(
                  title: '姓氏', controller: _surnameTEC, hintText: '请填写您的姓氏'),
              GestureDetector(
                onTap: () => _chooseCity(),
                child: _itemView(
                  title: '地址',
                  controller: _address1TEC,
                  enabled: false,
                  hintText: '请选择地址',
                ),
              ),
              _itemView(title: '门牌 (可选填)', controller: _address2TEC),
              _itemView(
                title: '邮政编码',
                controller: _zipCodeTEC,
                hintText: '请填写邮政编码',
              ),
              _itemView(
                title: '电话号码',
                controller: _phoneNumTEC,
                hintText: '请填写手机号码',
              ),
              const SizedBox(height: 50),
              ThemeButton(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                text: '保存地址',
                height: 47,
                onPressed: () => _saveAddress(),
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  ///下拉按钮
  Widget _menuView(String title, List<Area> dataList) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleView(title),
          const SizedBox(height: 8),
          CustomPopupMenuButton(
            offset: const Offset(0, 56),
            onSelected: (Area model) async {
              setState(() {
                if (title == '所在国家') {
                  _currentCountry = model;
                }
                // else if (title == '省份/州') {
                //   _currentParent = model;
                // } else {
                //   _currentCity = model;
                // }
              });
              // if (title == '所在国家') {
              //   await _getAreaProvince();
              // }
              // else if (title == '省份/州') {
              //   await _getAreaCity();
              // }
            },
            itemBuilder: (context) {
              return List.generate(dataList.length, (index) {
                return CustomPopupMenuItem<Area>(
                  value: dataList[index],
                  child: ThemeText(
                    text: dataList[index].name ?? '',
                    color: const Color(0xff9098B1),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                );
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 1,
                color: const Color(0xffE4D719).withOpacity(0.8),
                style: BorderStyle.solid,
              ),
            ),
            child: Container(
              height: 48,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border:
                    Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
              ),
              child: ThemeText(
                text: _currentCountry?.name ?? '请选择国家',
                fontWeight: FontWeight.w400,
                fontSize: (_currentCountry?.name ?? '').isEmpty ? 14 : 16,
                color: (_currentCountry?.name ?? '').isEmpty
                    ? Colors.black26
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemView({
    required String title,
    String? hintText,
    int? maxLines,
    TextInputType? keyboardType,
    TextEditingController? controller,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleView(title),
          const SizedBox(height: 8),
          _buildWordInputWidget(
            maxLines: maxLines,
            keyboardType: keyboardType,
            controller: controller,
            hintText: hintText,
            enabled: enabled,
          ),
        ],
      ),
    );
  }

  Widget _titleView(String text) {
    return ThemeText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color(0xff223263),
    );
  }

  /// 单词输入框
  Widget _buildWordInputWidget({
    String? hintText,
    int? maxLines,
    TextInputType? keyboardType,
    TextEditingController? controller,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        focusedBorder: _inputBorder,
        disabledBorder: _inputBorder,
        enabledBorder: _inputBorder,
        border: _inputBorder,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
        hintStyle: const TextStyle(
          color: Color(0xffCECECE),
          fontSize: 14,
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}

InputBorder get _inputBorder {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide:
        BorderSide(width: 1, color: const Color(0xffE4D719).withOpacity(0.8)),
  );
}

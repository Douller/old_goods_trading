import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/states/my_address_state.dart';
import 'package:provider/provider.dart';
import '../../model/order_buy_confirm_model.dart';
import '../../widgets/no_data_view.dart';
import '../../widgets/theme_button.dart';
import '../../widgets/theme_text.dart';
import 'add_address_page.dart';

class MyAddressPage extends StatefulWidget {
  final bool isSelect;
  final AddressModelInfo? selectModel;

  const MyAddressPage({
    Key? key,
    this.isSelect = false,
    this.selectModel,
  }) : super(key: key);

  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  final MyAddressViewModel _myAddressViewModel = MyAddressViewModel();
  AddressModelInfo? selectModel;

  @override
  void initState() {
    _myAddressViewModel.getMyAddressList();
    selectModel = widget.selectModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _myAddressViewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(title: const Text('我的地址')),
        body: Consumer<MyAddressViewModel>(
          builder: (BuildContext context, value, Widget? child) {
            return value.addressList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: value.addressList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: Constants.screenWidth - 24,
                        padding: const EdgeInsets.only(bottom: 28),
                        child: Row(
                          children: [
                            if (selectModel != null &&
                                widget.isSelect == true &&
                                selectModel?.id == value.addressList[index].id)
                              Container(
                                margin: const EdgeInsets.only(right: 18),
                                child: Icon(
                                  Icons.check_circle,
                                  color:
                                      const Color(0xffE4D719).withOpacity(0.8),
                                  size: 20,
                                ),
                              )
                            else
                              Container(),
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  if (widget.isSelect == true) {
                                    Navigator.pop(
                                        context, value.addressList[index]);
                                  }
                                },
                                child: _addressCellView(
                                    name:
                                        '${value.addressList[index].consignee ?? ''} ${value.addressList[index].xing ?? ''}',
                                    address:
                                        value.addressList[index].addressAll ??
                                            '',
                                    phoneNum:
                                        value.addressList[index].telephone ??
                                            '',
                                    isDefault:
                                        value.addressList[index].isDefault ??
                                            '',
                                    editOnTap: () {
                                      AppRouter.push(
                                              context,
                                              AddAddressPage(
                                                  isEdit: true,
                                                  addressModel:
                                                      value.addressList[index]))
                                          .then((value) {
                                        if (value != null && value == true) {
                                          _myAddressViewModel
                                              .getMyAddressList();
                                        }
                                      });
                                    },
                                    deleteOnTap: () {
                                      value.deleteAddress(
                                          value.addressList[index].id ?? '');
                                    },
                                    setDefaultAddress: () {
                                      if ((value.addressList[index].isDefault ??
                                              '') ==
                                          '1') {
                                        return;
                                      }
                                      value.setDefaultAddress(
                                          value.addressList[index]);
                                    }),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const NoDataView(
                    pictureName: '${Constants.placeholderPath}address_no.png',
                    tips: '您尚未添加收货地址',
                  );
          },
        ),
        bottomNavigationBar: _bottomView(),
      ),
    );
  }

  Widget _bottomView() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, top: 16),
      alignment: Alignment.center,
      height: 50,
      child: ThemeButton(
        margin: const EdgeInsets.symmetric(horizontal: 60),
        text: '添加新地址',
        onPressed: () {
          AppRouter.push(context, const AddAddressPage()).then((value) {
            if (value != null && value == true) {
              _myAddressViewModel.getMyAddressList();
            }
          });
        },
      ),
    );
  }

  Widget _addressCellView({
    String? name,
    String? address,
    String? phoneNum,
    String? isDefault,
    GestureTapCallback? editOnTap,
    GestureTapCallback? deleteOnTap,
    GestureTapCallback? setDefaultAddress,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            width: 1, color: const Color(0xffE4D719).withOpacity(0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThemeText(
            text: name!,
            color: const Color(0xff223263),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          const SizedBox(height: 16),
          ThemeText(
            text: address!,
            color: const Color(0xff9098B1),
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          const SizedBox(height: 16),
          ThemeText(
            text: phoneNum!,
            color: const Color(0xff9098B1),
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: setDefaultAddress,
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xffE4D719).withOpacity(0.8),
                    ),
                    child: isDefault == '1'
                        ? const Icon(
                            Icons.check,
                            size: 10,
                          )
                        : Container(),
                  ),
                  const SizedBox(width: 16),
                  ThemeText(
                    text: isDefault == '1' ? '此地址为默认地址' : '设为默认地址',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: editOnTap,
                child: Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(2),
                  child: Image.asset(
                    '${Constants.iconsPath}address_edit.png',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: deleteOnTap,
                child: Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(2),
                  child: Image.asset(
                    '${Constants.iconsPath}address_delecte.png',
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/utils/regex.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../model/version_model.dart';

class AppVersionUpgradeDialog extends StatelessWidget {
  final VersionModel versionModel;

  const AppVersionUpgradeDialog({Key? key, required this.versionModel})
      : super(key: key);

  Future<void> _launchUrl() async {
    String? url;
    if (Platform.isAndroid) {
      url = versionModel.appDownloadAndroid;
    } else {
      url = versionModel.appDownloadIos;
    }

    if (url != null && RegexUtils.isURL(url) && await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      ToastUtils.showText(text: '下载地址出错，请联系客服');
    }
  }

  Widget get htmlView {
    return Html(data: versionModel.appVersionDesc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 55),
                padding: const EdgeInsets.symmetric(horizontal: 23),
                height: 383,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          '${Constants.placeholderPath}version_bg.png'),
                      fit: BoxFit.fill),
                  color: Colors.transparent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 58),
                    const Text(
                      '发现新版本',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      versionModel.appVersionName ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(child: Container()),
                    SizedBox(
                      height: 126,
                      child:
                          SingleChildScrollView(reverse: true, child: htmlView
                              // Text(
                              //   versionModel.appVersionDesc??'',
                              //   style:const TextStyle(
                              //     color: Color(0xFF2F3033),
                              //     fontWeight: FontWeight.w500,
                              //     fontSize: 14,
                              //   ),
                              // ),
                              ),
                    ),
                    GestureDetector(
                      onTap: _launchUrl,
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(vertical: 26),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF0BC196)),
                        child: const Text(
                          '立即升级',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  '${Constants.iconsPath}update_close.png',
                  width: 34,
                  height: 34,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

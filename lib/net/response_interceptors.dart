import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/model/user_info_model.dart';
import 'package:old_goods_trading/page/login/login_page.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:provider/provider.dart';

import '../app.dart';
import '../states/user_info_state.dart';
import '../utils/sp_manager.dart';

class ResponseInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? uid = SharedPreferencesUtils.getLoginUid();
    Map<String, dynamic> paramMap = {
      'uid': uid,
      'appkey': 'douller2022',
      'version': Constants.version
    };

    if(options.path.contains('douller')){
      options.queryParameters.addAll(paramMap);
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is String) {
      response.data = json.decode(response.data);
      if (response.data is Map && response.data['return_code'] == 999) {
        Future.delayed(Duration.zero).then((onValue) {
          if (globalContext() != null) {
            UserInfoModel? userMode =
                globalContext()!.read<UserInfoViewModel>().userInfoModel;
            if (userMode != null) {
              globalContext()!.read<UserInfoViewModel>().loginOut();
            }
          }
        });
      }
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    _formatError(err);
    super.onError(err, handler);
  }

  ///  error统一处理
  void _formatError(DioError err) {
    if (err.type == DioErrorType.connectTimeout) {
      debugPrint("${err.hashCode}连接超时");
    } else if (err.type == DioErrorType.sendTimeout) {
      debugPrint("${err.hashCode}请求超时");
    } else if (err.type == DioErrorType.receiveTimeout) {
      debugPrint("${err.hashCode}响应超时");
    } else if (err.type == DioErrorType.response) {
      debugPrint("${err.hashCode}出现异常404 503");
    } else if (err.type == DioErrorType.cancel) {
      debugPrint("${err.hashCode}请求取消");
    } else {
      debugPrint("message =${err.message}");
    }
  }
}

class ResultData {
  dynamic data;
  bool isSuccess;
  int? code;
  String? message;

  ResultData(
    this.data,
    this.isSuccess,
    this.code,
    this.message,
  );
}

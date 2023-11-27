import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:old_goods_trading/config/Config.dart';
import 'package:dio/adapter.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';

import 'response_interceptors.dart';

enum Methods { get, post }

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) => compute(_parseAndDecode, text);

class HttpManager extends DioForNative {
  static final HttpManager _httpManager = HttpManager._internal();

  factory HttpManager() => _httpManager;

  HttpManager._internal() {
    (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      final String httpHost = Config.httpProxyClientHost;
      // 配置代理
      if (httpHost.isNotEmpty) {
        client.findProxy = (uri) {
          return 'PROXY $httpHost';
        };
        // 代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      }
      return client;
    };
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

    options = BaseOptions(
      baseUrl: Config.hostUrl,
      connectTimeout: 15000,
      receiveTimeout: 30000,
      sendTimeout: 30000,
    );
    interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        queryParameters: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        showProcessingTime: true,
        showCUrl: true,
        canShowLog: !kReleaseMode,
      ),
      ResponseInterceptors(),
    ]);
  }
}

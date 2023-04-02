
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../consts.dart';
import 'proxies.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class Net {
  final AppState appState;
  final _cookieJar = CookieJar();
  late final _dio = Dio()..interceptors.add(CookieManager(_cookieJar));

  Net(this.appState);

  Future<bool> get authorized async
  => (await _dio.get('$baseUrl/authorizedU')).statusCode == 200;

  // Image loadImage(String image, {required double width, required double height}) => Image.network(
  //   imageUrl + image + jpgExtension,
  //   width: width,
  //   height: height,
  // );

  Future<Image> fetchImage(String which) async => _dio.get(
    imageUrl + which + jpgExtension,
    options: Options(responseType: ResponseType.bytes)
  ).then((response) => Image.memory(response.data as Uint8List));
}
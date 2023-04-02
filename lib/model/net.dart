
import 'dart:convert';
import 'dart:typed_data';
import '../util.dart';
import 'component.dart';
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
  static final _jsonOptions = Options(responseType: ResponseType.json);

  Net(this.appState);

  Future<bool> get authorized async
  => (await _dio.get('$baseUrl/authorizedU')).statusCode == 200;

  Future<Image?> fetchImage(String which) async => _dio.get(
    imageUrl + which + jpgExtension,
    options: Options(responseType: ResponseType.bytes)
  ).then((response) => response.successful ? Image.memory(response.data as Uint8List) : null);

  Future<List<Component>> fetchComponents(ComponentType type) => _dio.get(
    '$baseUrl/component/type/${type.id}',
    options: _jsonOptions
  ).then((response) => response.successful ? [
    for (final dynamic i in response.data)
      Component.fromJson(i)
  ] : []);
}

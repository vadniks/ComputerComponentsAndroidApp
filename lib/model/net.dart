
import 'dart:typed_data';
import '../util.dart';
import 'component.dart';
import 'package:flutter/material.dart';
import '../consts.dart';
import 'proxies.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'user.dart';

class Net {
  final AppState appState;
  late final _dio = Dio()..interceptors.add(CookieManager(CookieJar())); // TODO: persist cookie
  static final _jsonOptions = Options(responseType: ResponseType.json);
  static final _urlencodedOptions = Options(contentType: 'application/x-www-form-urlencoded');

  Net(this.appState);

  Future<bool> get authorized async { try {
    return (await _dio.get('$baseUrl/authorizedU')).successful;
  } on DioError catch (_) { return false; } }

  Future<Image?> fetchImage(String which, [bool defaultSize = true]) async { try {
    return await _dio.get(
      imageUrl + which + jpgExtension,
      options: Options(responseType: ResponseType.bytes)
    ).then((response) => response.successful ? Image.memory(
      response.data as Uint8List,
      width: defaultSize ? 50 : null,
      height: defaultSize ? 50 : null,
    ) : null);
  } on DioError catch (_) { return null; } }

  Future<List<Component>> fetchComponents(ComponentType type) async { try {
    return await _dio.get(
      '$baseUrl/component/type/${type.id}',
      options: _jsonOptions
    ).then((response) => response.successful ? [
      for (final dynamic i in response.data)
        Component.fromJson(i)
    ] : []);
  } on DioError catch (_) { return <Component>[]; } }

  Future<bool> login(String login, String password) async { try {
    return await _dio.post(
      '$baseUrl/login',
      data: {
        User.nameC : login,
        User.passwordC : password
      },
      options: _urlencodedOptions
    ).then((response) => response.successful);
  } on DioError catch (_) { return false; } }

  Future<String?> fetchName() async { try {
    return await _dio.get('$baseUrl/name')
      .then((response) => response.successful ? response.data : null);
  } on DioError catch (_) { return null; } }

  Future<bool> logout() async { try {
    return await _dio.post('$baseUrl/logout')
      .then((response) => response.successful && response.data == true);
  } on DioError catch (_) { return false; } }
}

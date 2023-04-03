
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
  late final _dio = Dio()..interceptors.add(CookieManager(CookieJar())); // TODO: persist cookie
  static final _jsonResponseOptions = Options(responseType: ResponseType.json);
  static final _urlencodedContentOptions = Options(contentType: Headers.formUrlEncodedContentType);
  static final _jsonContentOptions = Options(contentType: Headers.jsonContentType);

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
      options: _jsonResponseOptions
    ).then((response) => response.successful ? [
      for (final Map<String, dynamic> i in response.data)
        Component.fromJson(i)
    ] : []);
  } on DioError catch (_) { return <Component>[]; } }

  Future<bool> login(String login, String password) async { try {
    return await _dio.post(
      '$baseUrl/login',
      data: {
        'name': login,
        'password': password
      },
      options: _urlencodedContentOptions
    ).then((response) => response.successful);
  } on DioError catch (_) { return false; } }

  Future<String?> fetchName() async { try {
    return await _dio.get('$baseUrl/name')
      .then((response) => response.successful ? response.data : null);
  } on DioError catch (_) { return null; } }

  Future<bool> logout() async { try {
    return await _dio.post('$baseUrl/logout')
      .then((response) => response.successful);
  } on DioError catch (_) { return false; } }

  Future<bool> submit(List<String> texts) async {
    assert(texts.length == 4);
    try {
      return await _dio.post(
        '$baseUrl/order',
        data: {
          'firstName': texts[0],
          'lastName': texts[1],
          'phone': int.tryParse(texts[2])!,
          'address': texts[3]
        },
        options: _jsonContentOptions
      ).then((response) => response.successful);
    } on DioError catch (_) { return false; }
  }

  Future<List<Component>> fetchHistory() async { try {
    final response = await _dio.get(
      '$baseUrl/history',
      options: _jsonResponseOptions
    );

    return !response.successful ? [] :
      [for (final Map<String, dynamic> i in response.data) Component.fromJson(i)];
  } on DioError catch (_) { return []; } }

  Future<bool> clearHistory() async { try {
    return (await _dio.delete('$baseUrl/history')).successful;
  } on DioError catch (_) { return false; } }

  Future<Component?> fetchComponent(int id) async { try {
    return await _dio.get(
      '$baseUrl/component/$id',
      options: _jsonResponseOptions
    ).then((response) =>
      response.successful && response.data != null
        ? Component.fromJson(response.data)
        : null
    );
  } on DioError catch (_) { return null; } }

  Future<List<Component?>> fetchSelected() async { try {
    final response = await _dio.get('$baseUrl/selected');

    return !response.successful || response.data == null ? [] : [
      for (final String i in (response.data as String).split(','))
        i == nullString ? null : (await fetchComponent(int.tryParse(i)!))!
    ];
  } on DioError catch (_) { return []; } } // TODO: extract template

  Future<bool> clearSelected() async { try {
    return (await _dio.post('$baseUrl/clearSelected')).successful;
  } on DioError catch (_) { return false; } }

  Future<bool> select(int id) async { try {
    return (await _dio.post('$baseUrl/select/$id')).successful;
  } on DioError catch (_) { return false; } }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mvvm_expample/repository/base/api_exception.dart';

import '../parking_repository.dart';

class Repository<T> {
  Future<Response> _getApi(String url) async {
    final response = await http.get(Uri.parse(url)).catchError((dynamic error) {
      throw ApiException(0, '網路異常');
    });
    _catchError(response.statusCode);
    return response;
  }

  Future<T> getListApi(String url, dynamic type) {
    return _getApi(url).then((dynamic response) {
      return _parseListType(const Utf8Codec().decode(response.bodyBytes), type)
          as T;
    });
  }

  Future<T> getClassApi(String url, dynamic type) {
    return _getApi(url).then((dynamic response) {
      return _parseClassType(response.body, type) as T;
    });
  }

  dynamic _parseClassType(String responseBody, dynamic type) {
    final parsed = jsonDecode(utf8.decode(responseBody.runes.toList()));
    switch (type) {
      case TaoyuanCityParking:
        return TaoyuanCityParking.fromJson(parsed);
    }
    return type;
  }

  List<dynamic> _parseListType(String responseBody, dynamic types) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    switch (types) {
      case HsinchuCityParking:
        return parsed
            .map<HsinchuCityParking>(
                (json) => HsinchuCityParking.fromJson(json))
            .toList();
      case TaichungCityParking:
        return parsed
            .map<TaichungCityParking>(
                (json) => TaichungCityParking.fromJson(json))
            .toList();
    }
    return types;
  }

  void _catchError(int statusCode) {
    switch (statusCode) {
      case 400:
        throw ApiException(statusCode, '伺服器因為收到無效語法，而無法理解請求');
      case 404:
        throw ApiException(statusCode, '伺服器找不到請求的資源');
      case 401:
        throw ApiException(statusCode, '需要授權以回應請求');
      case 500:
        throw ApiException(statusCode, '伺服器端發生未知或無法處理的錯誤');
    }
  }
}

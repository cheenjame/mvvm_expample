import 'dart:convert';

import 'package:mvvm_expample/repository/parking_repository.dart';

List<HsinchuCityParking> parseHisnchuParking(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<HsinchuCityParking>((json) => HsinchuCityParking.fromJson(json))
      .toList();
}
dynamic parseClassType(String responseBody, dynamic type) {
  final parsed = jsonDecode(utf8.decode(responseBody.runes.toList()));
  switch (type) {
    case TaoyuanCityParking:
      return TaoyuanCityParking.fromJson(parsed);
  }
  return type;
}

List<dynamic> parseListType(String responseBody, dynamic types) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  switch (types) {
    case HsinchuCityParking:
      return parsed
          .map<HsinchuCityParking>((json) => HsinchuCityParking.fromJson(json))
          .toList();
    case TaichungCityParking:
      return parsed
          .map<TaichungCityParking>(
              (json) => TaichungCityParking.fromJson(json))
          .toList();
  }
  return types;
}



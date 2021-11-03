import 'dart:convert';

import 'package:mvvm_expample/repository/repository.dart';

List<HsinchuCityParking> parseHisnchuParking(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<HsinchuCityParking>((json) => HsinchuCityParking.fromJson(json))
      .toList();
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

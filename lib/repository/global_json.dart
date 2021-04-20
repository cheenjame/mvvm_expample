import 'dart:convert';

import 'package:mvvm_expample/repository/repository.dart';

List<HsinchuCityParking> parseParking(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<HsinchuCityParking>((json) => HsinchuCityParking.fromJson(json))
      .toList();
}

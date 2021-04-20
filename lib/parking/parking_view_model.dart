import 'package:flutter/material.dart';
import 'package:mvvm_expample/repository/repository.dart';

class ParkingViewModel {
  ParkingViewModel({Repository? repository})
      : _repository = repository ?? Repository();
  final Repository _repository;
  bool isLoaded = false;
  final items = ValueNotifier<List<HsinchuCityParking>>([]);
  Future<List<HsinchuCityParking>> getHsinchuParking() async {
    isLoaded = true;
    return _repository.getHsinchuParking().then((value) => items.value = value);
  }

/// 總車位是否為0
  bool isTotal(String total) {
    final number = int.parse(total);
    return number == 0;
  }
}

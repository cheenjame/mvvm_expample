import 'dart:async';

import 'package:mvvm_expample/repository/repository.dart';

class MapViewModel {
  MapViewModel({Repository? repository})
      : _repository = repository ?? Repository();

  final Repository _repository;

  /// 取得停車場資訊
  Future<List<TaiwanParking>> getParkingMap() async {
    final List<TaiwanParking> allParkingList = [];
    await _repository.getHsinchuParking().then((parking) {
      for (final HsinchuCityParking hsinchu in parking) {
        final allParking = TaiwanParking();
        final car = int.parse(hsinchu.carSurplus ?? '');
        if (car > 0) {
          allParking.name = hsinchu.name ?? '';
          allParking.time = hsinchu.time ?? '';
          allParking.billing = hsinchu.holiday ?? '';
          allParking.surplus = hsinchu.carSurplus ?? '';
          allParking.latitude = double.parse(hsinchu.latitude ?? '');
          allParking.longitude = double.parse(hsinchu.longitude ?? '');
          allParkingList.add(allParking);
        }
      }
    });
    await _repository.getTaichungParking().then((parking) {
      for (final TaichungCityParking taichung in parking) {
        for (final TaichungAreaParking area in taichung.parkingLots) {
          final allParking = TaiwanParking();
          if (area.surplus > 0) {
            allParking.name = area.name;
            allParking.billing = area.billing;
            allParking.surplus = area.surplus.toString();
            allParking.latitude = area.latitude;
            allParking.longitude = area.longitude;
            allParkingList.add(allParking);
          }
        }
      }
    });

    await _repository.getTaoyuanParking().then((parking) {
      for (final TaoyuanAreaParking area in parking.parkingList) {
        final allParking = TaiwanParking();
        if (int.parse(area.surplus) > 0) {
          allParking.name = area.name;
          allParking.billing = area.billing;
          allParking.surplus = area.surplus;
          allParking.latitude = area.latitude;
          allParking.longitude = area.longitude;
          allParkingList.add(allParking);
        }
      }
    });
    return allParkingList;
  }
}

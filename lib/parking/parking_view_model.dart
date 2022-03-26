import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvvm_expample/repository/parking_repository.dart';
import 'package:mvvm_expample/utils/location.dart';

class ParkingViewModel with ChangeNotifier, LocationSetting {
  ParkingViewModel({ParkingRepository? repository})
      : _repository = repository ?? ParkingRepository();
  final ParkingRepository _repository;
  bool isLoaded = false;

  /// 是否輸入中
  bool _isEditing = false;

  /// 輸入框是否在編輯中
  bool get isEditing => _isEditing;
  set isEditing(bool isEditing) {
    _isEditing = isEditing;
    notifyListeners();
  }

  final items = ValueNotifier<List<TaiwanParking>>([]);
  Future<List<TaiwanParking>> getParking() async {
    isLoaded = true;
    return _getAllParking().then((value) => items.value = value);
  }

  /// 車位是否為0
  bool isTotal(String car) {
    final number = int.parse(car);
    return number == 0;
  }

  Future<List<TaiwanParking>> getSearchParking(String text) async {
    return _getAllParking()
        .then((value) => value.where((element) => element.name.contains(text)))
        .then((value) => items.value = value.toList());
  }

  /// 輸入文本列出最新消息列表
  void inputText(String text) {
    if (text.length >= 2) {
      getSearchParking(text);
    }
  }

  /// 判斷輸入框是否在編輯中
  void editing(bool hasFocus) {
    if (hasFocus) {
      isEditing = true;
    } else {
      isEditing = false;
    }
  }

  double myLat = 24.143587246187604;
  double myLong = 120.68893067904283;

  /// 取得定位
  Future<LatLng> getMyLocation() async {
    final currentPosition = await myPosition();
    final _cameraPosition = LatLng(
        currentPosition?.latitude ?? 24.143587246187604,
        currentPosition?.longitude ?? 120.68893067904283);
    myLat = _cameraPosition.latitude;
    myLong = _cameraPosition.longitude;
    notifyListeners();
    return _cameraPosition;
  }

  double _rad(double d) => d * pi / 180;

  /// 取得停車場距離
  double getDistance(double parkingLat, double parkingLong) {
    const radius = 6378137.0;
    final radLat1 = _rad(myLat);
    final radLat2 = _rad(parkingLat);
    final a = radLat1 - radLat2;
    final b = _rad(myLong) - _rad(parkingLong);
    final s = 2 *
        asin(sqrt(pow(sin(a / 2), 2) +
            cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    return (s * radius).roundToDouble() / 1000;
  }

  /// 取得所有停車場資訊
  Future<List<TaiwanParking>> _getAllParking() async {
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
          allParking.distance =
              getDistance(allParking.latitude, allParking.longitude);
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
            allParking.distance =
                getDistance(allParking.latitude, allParking.longitude);

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
          allParking.distance =
              getDistance(allParking.latitude, allParking.longitude);

          allParkingList.add(allParking);
        }
      }
    });
    await _repository.getTainanCityParking().then((parking) {
      for (final TainanCityParking tainan in parking) {
        final allParking = TaiwanParking();
        if (tainan.surplus > 0) {
          allParking.name = tainan.name;
          allParking.billing = tainan.billing;
          allParking.surplus = tainan.surplus.toString();
          String lat = tainan.lngAndLat.trim();
          lat = lat.replaceAll(RegExp(','), '');
          allParking.latitude = double.parse(lat.trim().substring(0, 9));
          allParking.longitude = double.parse(lat.trim().substring(9));
          allParking.distance =
              getDistance(allParking.latitude, allParking.longitude);

          allParkingList.add(allParking);
        }
      }
    });
    allParkingList.sort((a, b) => a.distance.compareTo(b.distance));
    return allParkingList;
  }
}

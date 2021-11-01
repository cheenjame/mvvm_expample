import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mvvm_expample/repository/repository.dart';
import "dart:math";

class ParkingViewModel extends ChangeNotifier {
  ParkingViewModel({Repository? repository})
      : _repository = repository ?? Repository();
  final Repository _repository;
  bool isLoaded = false;

  /// 是否輸入中
  bool _isEditing = false;

  /// 輸入框是否在編輯中
  bool get isEditing => _isEditing;
  set isEditing(bool isEditing) {
    _isEditing = isEditing;
    notifyListeners();
  }

  final items = ValueNotifier<List<HsinchuCityParking>>([]);
  Future<List<HsinchuCityParking>> getHsinchuParking() async {
    isLoaded = true;
    return _repository.getHsinchuParking().then((value) => items.value = value);
  }

  /// 車位是否為0
  bool isTotal(String car) {
    final number = int.parse(car);
    return number == 0;
  }

  Future<List<HsinchuCityParking>> getSearchHsinchuParking(String text) async {
    return _repository
        .getHsinchuParking()
        .then((value) => value.where((element) => element.name!.contains(text)))
        .then((value) => items.value = value.toList());
  }

  /// 輸入文本列出最新消息列表
  void inputText(String text) {
    if (text.length >= 2) {
      getSearchHsinchuParking(text);
    }
  }

  /// 判斷輸入框是否在編輯中
  void editing(bool hasFoucs) {
    if (hasFoucs) {
      isEditing = true;
    } else {
      isEditing = false;
    }
  }

  double myLat = 24.143587246187604;
  double myLong = 120.68893067904283;

  /// 取得定位
  Future<LatLng> getMyLocation() async {
    final location = Location();
    final currentPosition = await location.getLocation();
    final _cameraposition = LatLng(
        currentPosition.latitude ?? 24.143587246187604,
        currentPosition.longitude ?? 120.68893067904283);
    myLat = _cameraposition.latitude;
    myLong = _cameraposition.longitude;
    notifyListeners();
    return _cameraposition;
  }

  double _rad(double d) => d * pi / 180;

  /// 取得停車場距離
  String getDistance(double parkingLat, double parkingLong) {
    const radius = 6378137.0;
    final radLat1 = _rad(myLat);
    final radLat2 = _rad(parkingLat);
    final a = radLat1 - radLat2;
    final b = _rad(myLong) - _rad(parkingLong);
    final s = 2 *
        asin(sqrt(pow(sin(a / 2), 2) +
            cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    return ((s * radius).roundToDouble() / 1000).toStringAsFixed(1);
  }
}

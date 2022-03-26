import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

mixin LocationSetting {



  // 取得使用者定位
  Future<Position?> myPosition() async {
    bool serviceEnable;
    LocationPermission permission;
    serviceEnable = await Geolocator.isLocationServiceEnabled();
    // 位置服務未啟用
    if (!serviceEnable) {
      Geolocator.openLocationSettings();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      // 權限被拒絕
      if (permission == LocationPermission.denied) {
        Geolocator.openLocationSettings();
      }
    }
    // 權限永遠被拒絕
    if (permission == LocationPermission.deniedForever) {
      Geolocator.openLocationSettings();
    }

    return Geolocator.getCurrentPosition();
  }
}

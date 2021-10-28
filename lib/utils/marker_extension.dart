import 'package:mvvm_expample/repository/repository.dart';

extension HsinchuCityParkingExt on HsinchuCityParking {
  /// 確認座標是否正確
  bool isLocationVaild() {
    final lat = double.parse(latitude ?? '');
    final log = double.parse(longitude ?? '');
    return (lat >= -90 && lat <= 90) && (log >= -180 && log <= 180);
  }
}

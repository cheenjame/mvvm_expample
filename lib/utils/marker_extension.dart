import 'package:mvvm_expample/repository/repository.dart';

extension TaiwanParkingExt on TaiwanParking {
  /// 確認座標是否正確
  bool isLocationVaild() {
    return (latitude >= -90 && latitude <= 90) &&
        (longitude >= -180 && longitude <= 180);
  }
}

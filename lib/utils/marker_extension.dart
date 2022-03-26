import 'package:mvvm_expample/repository/parking_repository.dart';

extension TaiwanParkingExt on TaiwanParking {
  /// 確認座標是否正確
  bool isLocationValid() {
    return (latitude >= -90 && latitude <= 90) &&
        (longitude >= -180 && longitude <= 180);
  }
}

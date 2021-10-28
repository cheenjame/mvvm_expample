import 'package:mvvm_expample/repository/repository.dart';

extension HsinchuCityParkingExt on HsinchuCityParking {
  bool isLocationVaild() {
    final lat = double.parse(latitude ?? '');
    final log = double.parse(longitude ?? '');
    print('XX02 = $lat');
    print('XXX03 = $log');
    return (lat >= -90 && lat <= 90) && (log >= -180 && log <= 180);
  }
}

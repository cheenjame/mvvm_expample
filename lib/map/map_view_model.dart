import 'package:mvvm_expample/repository/repository.dart';

class MapViewModel {
  MapViewModel({Repository? repository})
      : _repository = repository ?? Repository();

  final Repository _repository;

  /// 取得停車場資訊
  Future<List<AllParking>> getParkingMap() async {
    final List<AllParking> allParkingList = [];
    await _repository.getHsinchuParking().then((parking) {
      for (final HsinchuCityParking hsinchu in parking) {
        final allParking = AllParking();
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
          final allParking = AllParking();
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
    return allParkingList;
  }
}

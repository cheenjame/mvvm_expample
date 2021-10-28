import 'package:mvvm_expample/repository/repository.dart';

class MapViewModel {
  MapViewModel({Repository? repository})
      : _repository = repository ?? Repository();

  final Repository _repository;

  Future<List<HsinchuCityParking>> getParkingMap() {
    return _repository.getHsinchuParking();
  }
}

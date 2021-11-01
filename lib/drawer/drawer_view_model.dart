import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DrawerViewModel {
  late LocationData _currentPosition;
  Location location = Location();
  LatLng _cameraposition =
      const LatLng(24.143587246187604, 120.68893067904283);
  Future<LatLng> getMyLocation() async {
    _currentPosition = await location.getLocation();
    _cameraposition = LatLng(
        _currentPosition.latitude ?? 0.0, _currentPosition.longitude ?? 0.0);
    return _cameraposition;
  }
}

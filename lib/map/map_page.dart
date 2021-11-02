import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mvvm_expample/drawer/drawer.dart';
import 'package:mvvm_expample/generated/l10n.dart';
import 'package:mvvm_expample/map/map_view_model.dart';

/// 停車場資訊地圖頁
class MapPage extends StatefulWidget {
  MapPage({MapViewModel? viewModel}) : _viewModel = viewModel ?? MapViewModel();
  final MapViewModel _viewModel;
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapPage> {
  late MapViewModel _viewModel;
  final Map<String, Marker> _marker = {};
  late LocationData _currentPosition;

  /// 地圖控制項
  GoogleMapController? _mapController;
  Location location = Location();
  LatLng _initialcameraposition =
      const LatLng(24.143587246187604, 120.68893067904283);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await _viewModel.getParkingMap();
    _mapController = controller;
    setState(() {
      _marker.clear();
      for (final office in googleOffices) {
        final car = int.parse(office.carSurplus ?? '');
        if (car != 0) {
          final marker = Marker(
              markerId: MarkerId(office.name ?? ''),
              position: LatLng(double.parse(office.latitude ?? ''),
                  double.parse(office.longitude ?? '')),
              infoWindow: InfoWindow(
                  title: office.name,
                  snippet:
                      '${MvvmApp.of(context).carRemaining} : ${office.carSurplus}'));
          _marker[office.name ?? ''] = marker;
        }
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => getLoc()); 
    super.initState();
    _viewModel = widget._viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MvvmApp.of(context).parkingMap),
      ),
      drawer: MvvmDrawer(),
      body: GoogleMap(
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition:
            CameraPosition(target: _initialcameraposition, zoom: 17.0),
        markers: _marker.values.toSet(),
      ),
    );
  }

  /// 取得地圖權限
  Future<void> getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _currentPosition = await location.getLocation();
    _initialcameraposition = LatLng(
        _currentPosition.latitude ?? 0.0, _currentPosition.longitude ?? 0.0);

    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition = LatLng(_currentPosition.latitude ?? 0.0,
            _currentPosition.longitude ?? 0.0);
      });
    });
    await _moveCamera(_initialcameraposition, 17);
  }

  /// 移動地圖中心
  Future<void> _moveCamera(LatLng target, double zoom) async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: zoom,
        ),
      ),
    );
  }
}

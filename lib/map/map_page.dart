import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mvvm_expample/drawer.dart';
import 'package:mvvm_expample/generated/l10n.dart';
import 'package:mvvm_expample/map/map_view_model.dart';

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
  Location location = Location();
  LatLng _initialcameraposition =
      const LatLng(24.143587246187604, 120.68893067904283);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await _viewModel.getParkingMap();
    setState(() {
      _marker.clear();
      for (final office in googleOffices) {
        final marker = Marker(
            markerId: MarkerId(office.name ?? ''),
            position: LatLng(double.parse(office.latitude ?? ''),
                double.parse(office.longitude ?? '')),
            infoWindow:
                InfoWindow(title: office.name, snippet: office.address));
        _marker[office.name ?? ''] = marker;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _viewModel = widget._viewModel;
    getLoc();
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
            CameraPosition(target: _initialcameraposition, zoom: 12.0),
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
  }
}

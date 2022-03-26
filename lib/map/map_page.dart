import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvvm_expample/drawer/drawer.dart';
import 'package:mvvm_expample/generated/l10n.dart';
import 'package:mvvm_expample/map/map_car_parking_Card.dart';
import 'package:mvvm_expample/map/map_view_model.dart';
import 'package:mvvm_expample/repository/parking_repository.dart';
import 'package:mvvm_expample/utils/location.dart';

/// 停車場資訊地圖頁
class MapPage extends StatefulWidget {
  MapPage({MapViewModel? viewModel}) : _viewModel = viewModel ?? MapViewModel();
  final MapViewModel _viewModel;
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapPage> with LocationSetting {
  late MapViewModel _viewModel;
  final Map<String, Marker> _marker = {};

  /// 當前地圖中間點
  CameraPosition? _currentMapPosition;

  /// 卡片bottom隱藏
  double cardPosition = -100;

  /// 地圖控制項
  GoogleMapController? _mapController;
  final _initialCameraPosition =
      const LatLng(24.143587246187604, 120.68893067904283);
  TaiwanParking parking = TaiwanParking();
  late Timer timer;

  void refreshParking() {
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      getMarker();
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => getLoc());
    _viewModel = widget._viewModel;
    refreshParking();
    super.initState();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MvvmApp.of(context).parkingMap),
      ),
      drawer: MvvmDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition:
                CameraPosition(target: _initialCameraPosition, zoom: 17.0),
            markers: _marker.values.toSet(),
            onTap: (LatLng latLng) {
              setState(() {
                cardPosition = -1000;
              });
            },
            onCameraMove: (position) => _currentMapPosition = position,
            onCameraIdle: _onMapCameraIdle,
          ),
          MapCardParkingCard(
            cardPosition: cardPosition,
            parking: parking,
          )
        ],
      ),
    );
  }

  /// 取得地圖權限
  Future<void> getLoc() async {
    final _currentPosition = await myPosition();
    final latLng = LatLng(
        _currentPosition?.latitude ?? 0.0, _currentPosition?.longitude ?? 0.0);
    await _moveCamera(latLng, 17);
  }

  /// 移動地圖中心點
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

  /// 移動座標
  void _onMapCameraIdle() {
    final currentMapPosition = _currentMapPosition;
    if (currentMapPosition == null) {
      return;
    }
    getMarker();
  }

  /// 取得地圖座標
  Future<void> getMarker() async {
    final googleOffices = await _viewModel.getParkingMap();
    setState(() {
      _marker.clear();
      for (final office in googleOffices) {
        final marker = Marker(
            markerId: MarkerId(office.name),
            position: LatLng(office.latitude, office.longitude),
            onTap: () {
              setState(() {
                cardPosition = 0;
                parking = office;
              });
            });
        _marker[office.name] = marker;
      }
    });
  }
}

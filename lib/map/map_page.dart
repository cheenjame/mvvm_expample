import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  double initlat = 0.0;
  double initLog = 0.0;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text(MvvmApp.of(context).parkingMap),
        ),
        drawer: MvvmDrawer(),
        body: GoogleMap(
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
              target: LatLng(24.800005, 120.968525), zoom: 12.0),
          markers: _marker.values.toSet(),
        ),
      );
  }
}

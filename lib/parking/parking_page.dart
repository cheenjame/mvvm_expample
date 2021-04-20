import 'package:flutter/material.dart';
import 'package:mvvm_expample/generated/l10n.dart';
import 'package:mvvm_expample/parking/parking_view_model.dart';
import 'package:mvvm_expample/repository/repository.dart';
import 'package:mvvm_expample/drawer.dart';
import 'package:provider/provider.dart';

class ParkingPage extends StatelessWidget {
  ParkingPage({ParkingViewModel? viewModel})
      : _viewModel = viewModel ?? ParkingViewModel();
  final ParkingViewModel _viewModel;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    if (!_viewModel.isLoaded) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _refreshKey.currentState?.show();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(MvvmApp.of(context).parkingLotInformation),
      ),
      drawer: MvvmDrawer(),
      body: ChangeNotifierProvider.value(
        value: _viewModel.items,
        child: Column(children: [
          Expanded(
            child: RefreshIndicator(
              key: _refreshKey,
              child: Consumer<ValueNotifier<List<HsinchuCityParking>>>(
                builder: (context, items, child) => ListView.separated(
                    itemBuilder: (BuildContext context, int index) =>
                        _buildParkingItem(context, items.value[index]),
                    separatorBuilder: (context, int index) => const Divider(),
                    itemCount: items.value.length),
              ),
              onRefresh: _viewModel.getHsinchuParking,
            ),
          )
        ]),
      ),
    );
  }

  /// 停車場資訊內容
  Widget _buildParkingItem(BuildContext context, HsinchuCityParking parking) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          parking.name ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(children: [
          Text(MvvmApp.of(context).operatingHours),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              parking.time ?? '',
              style: const TextStyle(fontSize: 12),
            ),
          )
        ]),
        Text(MvvmApp.of(context).weekdays),
        Text(
          parking.weekdays ?? '',
          style: const TextStyle(fontSize: 11, color: Colors.red),
        ),
        Text(MvvmApp.of(context).holiday),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            parking.holiday ?? '',
            style: const TextStyle(fontSize: 11, color: Colors.red),
          ),
        ),
        _buildLocomotive(
            MvvmApp.of(context).totalCar,
            MvvmApp.of(context).carRemaining,
            parking.carTotal ?? '',
            parking.carSurplus ?? ''),
        _buildLocomotive(
            MvvmApp.of(context).totalLocomotive,
            MvvmApp.of(context).locomotiveRemaining,
            parking.locomotiveTotal ?? '',
            parking.locomotiveSurplus ?? '')
      ]),
    );
  }

  Widget _buildLocomotive(String totalTitle, String numberTitle, String total,
      String locomotiveSurplus) {
    if (_viewModel.isTotal(total)) 
    return Container();
    return Row(
      children: [
        Expanded(
            child: Row(
          children: [Text(totalTitle), Text(total)],
        )),
        Expanded(
          child: Row(
            children: [Text(numberTitle), Text(locomotiveSurplus)],
          ),
        )
      ],
    );
  }
}

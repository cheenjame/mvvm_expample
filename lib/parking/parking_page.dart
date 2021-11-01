import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mvvm_expample/colors.dart';
import 'package:mvvm_expample/drawer/drawer.dart';
import 'package:mvvm_expample/generated/l10n.dart';
import 'package:mvvm_expample/parking/parking_view_model.dart';
import 'package:mvvm_expample/repository/repository.dart';
import 'package:mvvm_expample/utils/marker_extension.dart';
import 'package:mvvm_expample/widget/loadging_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// 停車場資訊列表頁
class ParkingPage extends StatefulWidget {
  ParkingPage({ParkingViewModel? viewModel})
      : _viewModel = viewModel ?? ParkingViewModel();
  final ParkingViewModel _viewModel;

  @override
  _ParkingState createState() => _ParkingState();
}

class _ParkingState extends State<ParkingPage> {
  late ParkingViewModel _viewModel;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _viewModel = widget._viewModel;
    _focus.addListener(() => _viewModel.editing(_focus.hasFocus));
    _viewModel.getMyLocation();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
        actions: [
          InkWell(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                child: Text(MvvmApp.of(context).position),
              ),
              onTap: () {
                final LoadingDialog loadDialog = showMvvmLoadingDialog(context);
                _viewModel
                    .getMyLocation()
                    .whenComplete(() => loadDialog.close(context));
              })
        ],
      ),
      drawer: MvvmDrawer(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _viewModel.items),
            ChangeNotifierProvider.value(value: _viewModel)
          ],
          child: Column(children: [
            _buildSearchTextField(),
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
            )),
          ]),
        ),
      ),
    );
  }

  /// 搜尋輸入框
  Widget _buildSearchTextField() {
    return Container(
        margin: const EdgeInsets.fromLTRB(8, 12, 19, 12),
        height: 36,
        decoration: BoxDecoration(
            border: Border.all(
              color: mainColor,
            ),
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(7.0))),
        child: ChangeNotifierProvider.value(
          value: _viewModel,
          child: Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Selector<ParkingViewModel, bool>(
              selector: (_, model) => model.isEditing,
              builder: (context, isEditing, child) => TextField(
                focusNode: _focus,
                controller: _controller,
                decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: mainColor,
                    ),
                    suffixIcon: isEditing
                        ? InkWell(
                            onTap: _clearTextField,
                            child: const Icon(
                              Icons.cancel_rounded,
                              color: Colors.black,
                            ),
                          )
                        : null),
                onChanged: (text) => _viewModel.inputText(text),
              ),
            ),
          ),
        ));
  }

  /// 清除輸入框內容
  void _clearTextField() {
    _controller.clear();
    _viewModel.inputText('');
    _viewModel.getHsinchuParking();
  }

  /// 停車場資訊內容
  Widget _buildParkingItem(BuildContext context, HsinchuCityParking parking) {
    return InkWell(
      child: Container(
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
          _buildParkingSpace(
              MvvmApp.of(context).carRemaining,
              parking.carTotal ?? '',
              parking.carSurplus ?? ''),
          _buildParkingSpace(
              MvvmApp.of(context).locomotiveRemaining,
              parking.locomotiveTotal ?? '',
              parking.locomotiveSurplus ?? ''),
          Consumer<ParkingViewModel>(
              builder: (context, model, _) => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(MvvmApp.of(context).distance),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(model.getDistance(
                            double.parse(parking.latitude ?? ''),
                            double.parse(parking.longitude ?? ''))),
                      ),
                      const Text('km')
                    ],
                  ))
        ]),
      ),
      onTap: () => _openGoogleMap(parking),
    );
  }

  /// 車位資訊
  Widget _buildParkingSpace( String numberTitle, String total,
      String locomotiveSurplus) {
    if (_viewModel.isTotal(total)) {
      return Container();
    }
    return Row(
      children: [Text(numberTitle), Text(locomotiveSurplus)],
    );
  }

  /// 開啟google 導航
  Future<void> _openGoogleMap(HsinchuCityParking parking) async {
    if (!parking.isLocationVaild()) {
      return;
    }
    final lat = double.parse(parking.latitude ?? '');
    final lng = double.parse(parking.longitude ?? '');
    final google = 'comgooglemaps://?daddr=$lat,$lng&directionsmode=d';
    final google1 = Uri.parse('google.navigation:q=$lat,$lng&mode=d');
    final google2 = Uri.parse('geo:0,0?q=$lat,$lng(${parking.name})');
    final google3 =
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving&dir_action=navigate';
    final apple = 'https://maps.apple.com/?daddr=$lat,$lng&dirflg=d';
    if (Platform.isIOS && await canLaunch(google)) {
      await launch(google);
    } else if (Platform.isIOS && await canLaunch(apple)) {
      await launch(apple);
    } else if (await canLaunch(google1.toString())) {
      await launch(google1.toString());
    } else if (await canLaunch(google2.toString())) {
      await launch(google2.toString());
    } else if (await canLaunch(google3)) {
      await launch(google3);
    }
  }
}

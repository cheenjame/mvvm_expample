import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mvvm_expample/generated/l10n.dart';
import 'package:mvvm_expample/repository/parking_repository.dart';
import 'package:mvvm_expample/utils/marker_extension.dart';
import 'package:url_launcher/url_launcher.dart';

/// 地圖停車場卡片資訊
class MapCardParkingCard extends StatefulWidget {
  const MapCardParkingCard({this.cardPosition, this.parking});

  /// 卡片bottom是否隱藏
  final double? cardPosition;
  final TaiwanParking? parking;
  @override
  _MapCardParkingCardState createState() => _MapCardParkingCardState();
}

class _MapCardParkingCardState extends State<MapCardParkingCard> {
  @override
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        bottom: widget.cardPosition,
        right: 0,
        left: 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(left: 10),
                  child: const ClipOval(
                    child: Icon(Icons.local_parking),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.parking!.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        RichText(
                            text: TextSpan(
                                text: MvvmApp.of(context).carRemaining,
                                style: const TextStyle(color: Colors.black),
                                children: [
                              TextSpan(
                                  text: widget.parking!.surplus,
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold))
                            ])),
                        RichText(
                            text: TextSpan(
                                text: MvvmApp.of(context).fee,
                                style: const TextStyle(color: Colors.black),
                                children: [
                              TextSpan(
                                  text: widget.parking!.billing,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold))
                            ]))
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.navigation,
                    color: Colors.blue,
                  ),
                  onPressed: () => _openGoogleMap(widget.parking!),
                )
              ],
            ),
          ),
        ),
        duration: const Duration(microseconds: 200));
  }

  /// 開啟google 導航
  Future<void> _openGoogleMap(TaiwanParking parking) async {
    if (!parking.isLocationValid()) {
      return;
    }
    final lat = parking.latitude;
    final lng = parking.longitude;
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

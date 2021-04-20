import 'package:flutter/material.dart';
import 'package:mvvm_expample/parking/parking_page.dart';
import 'package:mvvm_expample/second/second_page.dart';
import 'package:mvvm_expample/splash_page.dart';

enum TransitionType { normal, slideTop, slideLeft }

const String kRouteSplash = '/';
const String kRouteSecond = '/second/second';
const String kRouteParking = '/parking';

Map<String, WidgetBuilder> getRoute() {
  return {
    kRouteSplash: (context) => SplashPage(),
    kRouteSecond: (context) => SecondPage(),
    kRouteParking: (context) => ParkingPage()
  };
}

Route<dynamic> onRoute(RouteSettings settings) {
  final route = getRoute();
  return MaterialPageRoute(builder: route[settings.name]!, settings: settings);
}

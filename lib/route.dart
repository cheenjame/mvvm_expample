import 'package:flutter/material.dart';
import 'package:mvvm_expample/map/map_page.dart';
import 'package:mvvm_expample/parking/parking_page.dart';
import 'splash/splash_page.dart';

enum TransitionType { normal, slideTop, slideLeft }

const String kRouteSplash = '/';
const String kRouteParking = '/parking';
const String kRouteMap = '/map';

Map<String, WidgetBuilder> getRoute() {
  return {
    kRouteSplash: (context) => SplashPage(),
    kRouteParking: (context) => ParkingPage(),
    kRouteMap: (context) => MapPage()
  };
}

Route<dynamic> onRoute(RouteSettings settings) {
  final route = getRoute();
  return MaterialPageRoute(builder: route[settings.name]!, settings: settings);
}

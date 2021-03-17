
import 'package:flutter/material.dart';
import 'package:mvvm_expample/second_page.dart';
import 'package:mvvm_expample/splash_page.dart';

enum TransitionType { normal, slideTop, slideLeft }

const String kRouteSplash = '/';
const String kRouteFirst = '/second';

Map<String, WidgetBuilder> getRoute() {
  return {
    kRouteSplash: (context) => SplashPage(),
    kRouteFirst: (context) => SecondPage()
  };
}

Route<dynamic> onRoute(RouteSettings settings) {
  final  route = getRoute();
  return MaterialPageRoute(builder: route[settings.name]!, settings: settings);
}

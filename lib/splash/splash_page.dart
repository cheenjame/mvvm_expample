import 'package:flutter/material.dart';
import 'package:mvvm_expample/route.dart';

import 'splash_view_model.dart';

class SplashPage extends StatelessWidget {
  SplashPage({SplashViewModel? viewModel})
      : _viewModel = viewModel ?? SplashViewModel();
  final SplashViewModel _viewModel;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _viewModel.getTime(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Navigator.popAndPushNamed(context, kRouteParking);
            });
          }
          return Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: const Icon(Icons.car_repair),
          );
        });
  }
}

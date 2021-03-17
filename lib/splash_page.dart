import 'package:flutter/material.dart';
import 'package:mvvm_expample/generated/l10n.dart';
import 'package:mvvm_expample/route.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(MvvmApp.of(context).startpage),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              child: const Text('點擊'),
              onPressed: () => Navigator.pushNamed(context, kRouteFirst))
        ],
      )),
    );
  }
}

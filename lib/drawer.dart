import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mvvm_expample/colors.dart';
import 'package:mvvm_expample/generated/l10n.dart';
import 'package:mvvm_expample/route.dart';

/// 側邊欄
class MvvmDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Text(
            MvvmApp.of(context).trafficInformation,
            style: const TextStyle(fontSize: 20),
          ),
          decoration: const BoxDecoration(color: mainColor),
        ),
        ListTile(title: Text(MvvmApp.of(context).drawerMap)),
        ListTile(
          title: Text(MvvmApp.of(context).drawerList),
          onTap: () => Navigator.pushNamed(context, kRouteParking),
        ),
        ListTile(
          title: const Text('練習'),
          onTap: () => Navigator.pushNamed(context, kRouteSecond),
        )
      ],
    ));
  }
}

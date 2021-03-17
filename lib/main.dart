import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mvvm_expample/generated/l10n.dart';
import 'package:mvvm_expample/route.dart';

void main() {
  runApp(MvvmExampleApp());
}

class MvvmExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        MvvmApp.delegate
      ],
      supportedLocales: [
        Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
        Locale.fromSubtags(languageCode: 'en'),
      ],
      onGenerateRoute: onRoute,
      initialRoute: kRouteSplash,
    );
  }
}

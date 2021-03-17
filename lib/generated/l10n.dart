// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class MvvmApp {
  MvvmApp();

  static MvvmApp? _current;

  static MvvmApp get current {
    assert(_current != null, 'No instance of MvvmApp was loaded. Try to initialize the MvvmApp delegate before accessing MvvmApp.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<MvvmApp> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = MvvmApp();
      MvvmApp._current = instance;
 
      return instance;
    });
  } 

  static MvvmApp of(BuildContext context) {
    final instance = MvvmApp.maybeOf(context);
    assert(instance != null, 'No instance of MvvmApp present in the widget tree. Did you add MvvmApp.delegate in localizationsDelegates?');
    return instance!;
  }

  static MvvmApp? maybeOf(BuildContext context) {
    return Localizations.of<MvvmApp>(context, MvvmApp);
  }

  /// `第一頁`
  String get startpage {
    return Intl.message(
      '第一頁',
      name: 'startpage',
      desc: '第一頁/標題',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<MvvmApp> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<MvvmApp> load(Locale locale) => MvvmApp.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
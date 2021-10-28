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
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class MvvmApp {
  MvvmApp();

  static MvvmApp? _current;

  static MvvmApp get current {
    assert(_current != null,
        'No instance of MvvmApp was loaded. Try to initialize the MvvmApp delegate before accessing MvvmApp.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<MvvmApp> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
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
    assert(instance != null,
        'No instance of MvvmApp present in the widget tree. Did you add MvvmApp.delegate in localizationsDelegates?');
    return instance!;
  }

  static MvvmApp? maybeOf(BuildContext context) {
    return Localizations.of<MvvmApp>(context, MvvmApp);
  }

  /// `營運時間:`
  String get operatingHours {
    return Intl.message(
      '營運時間:',
      name: 'operatingHours',
      desc: '停車場資訊/營運時間:',
      args: [],
    );
  }

  /// `停車場資訊`
  String get parkingLotInformation {
    return Intl.message(
      '停車場資訊',
      name: 'parkingLotInformation',
      desc: '停車場資訊/停車場資訊',
      args: [],
    );
  }

  /// `平日收費方式`
  String get weekdays {
    return Intl.message(
      '平日收費方式',
      name: 'weekdays',
      desc: '停車場資訊/平日收費方式',
      args: [],
    );
  }

  /// `假日收費方式`
  String get holiday {
    return Intl.message(
      '假日收費方式',
      name: 'holiday',
      desc: '停車場資訊/假日收費方式',
      args: [],
    );
  }

  /// `汽車總車位:`
  String get totalCar {
    return Intl.message(
      '汽車總車位:',
      name: 'totalCar',
      desc: '停車場資訊/汽車總車位:',
      args: [],
    );
  }

  /// `汽車剩餘車位:`
  String get carRemaining {
    return Intl.message(
      '汽車剩餘車位:',
      name: 'carRemaining',
      desc: '停車場資訊/汽車剩餘車位:',
      args: [],
    );
  }

  /// `機車總車位:`
  String get totalLocomotive {
    return Intl.message(
      '機車總車位:',
      name: 'totalLocomotive',
      desc: '停車場資訊/機車總車位:',
      args: [],
    );
  }

  /// `機車剩餘車位:`
  String get locomotiveRemaining {
    return Intl.message(
      '機車剩餘車位:',
      name: 'locomotiveRemaining',
      desc: '停車場資訊/機車剩餘車位:',
      args: [],
    );
  }

  /// `交通資訊`
  String get trafficInformation {
    return Intl.message(
      '交通資訊',
      name: 'trafficInformation',
      desc: '側邊欄/交通資訊',
      args: [],
    );
  }

  /// `地圖`
  String get drawerMap {
    return Intl.message(
      '地圖',
      name: 'drawerMap',
      desc: '側邊欄/地圖',
      args: [],
    );
  }

  /// `列表`
  String get drawerList {
    return Intl.message(
      '列表',
      name: 'drawerList',
      desc: '側邊欄/列表',
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

import 'dart:async';
import 'package:mvvm_expample/repository/base/repository.dart';

enum CityType {
  /// 台北
  Taipei,

  /// 新竹
  Hsinchu,

  /// 台中
  Taichung,

  /// 台南
  Tainan,

  /// 宜蘭
  Yilan
}

class ParkingRepository {
  /// 取得新竹停車場資訊
  Future<List<HsinchuCityParking>> getHsinchuParking() {
    final service = Repository<List<HsinchuCityParking>>();
    return service.getListApi(
        'https://odws.hccg.gov.tw/001/Upload/25/OpenData/9059/452/7f02e869-396b-480c-b93f-f62cf67b0f7c.json',
        HsinchuCityParking);
  }

  /// 取得台中停車場資訊
  Future<List<TaichungCityParking>> getTaichungParking() async {
    final service = Repository<List<TaichungCityParking>>();
    return service.getListApi(
        'https://datacenter.taichung.gov.tw/swagger/OpenData/56a846ca-bc23-4754-b14a-0170f0541e09',
        TaichungCityParking);
  }

  /// 取得桃園停車場資訊
  Future<TaoyuanCityParking> getTaoyuanParking() {
    final service = Repository<TaoyuanCityParking>();
    return service.getClassApi(
        'https://data.tycg.gov.tw/opendata/datalist/datasetMeta/download?id=f4cc0b12-86ac-40f9-8745-885bddc18f79&rid=0daad6e6-0632-44f5-bd25-5e1de1e9146f',
        TaoyuanCityParking);
  }

  /// 取得停車場資訊
  Future<List<TaiwanParking>> getParkingMap() async {
    final List<TaiwanParking> allParkingList = [];
    await getHsinchuParking().then((parking) {
      for (final HsinchuCityParking hsinchu in parking) {
        final allParking = TaiwanParking();
        final car = int.parse(hsinchu.carSurplus ?? '');
        if (car > 0) {
          allParking.name = hsinchu.name ?? '';
          allParking.time = hsinchu.time ?? '';
          allParking.billing = hsinchu.holiday ?? '';
          allParking.surplus = hsinchu.carSurplus ?? '';
          allParking.latitude = double.parse(hsinchu.latitude ?? '');
          allParking.longitude = double.parse(hsinchu.longitude ?? '');
          allParkingList.add(allParking);
        }
      }
    });
    await getTaichungParking().then((parking) {
      for (final TaichungCityParking taichung in parking) {
        for (final TaichungAreaParking area in taichung.parkingLots) {
          final allParking = TaiwanParking();
          if (area.surplus > 0) {
            allParking.name = area.name;
            allParking.billing = area.billing;
            allParking.surplus = area.surplus.toString();
            allParking.latitude = area.latitude;
            allParking.longitude = area.longitude;
            allParkingList.add(allParking);
          }
        }
      }
    });

    await getTaoyuanParking().then((parking) {
      for (final TaoyuanAreaParking area in parking.parkingList) {
        final allParking = TaiwanParking();
        if (int.parse(area.surplus) > 0) {
          allParking.name = area.name;
          allParking.billing = area.billing;
          allParking.surplus = area.surplus;
          allParking.latitude = area.latitude;
          allParking.longitude = area.longitude;
          allParkingList.add(allParking);
        }
      }
    });
    return allParkingList;
  }
}

/// 台中市停車場
class TaichungCityParking {
  TaichungCityParking.fromJson(dynamic json)
      : parkingLots = json['ParkingLots']
            .map((dynamic v) => TaichungAreaParking.fromJson(v))
            .toList()
            .cast<TaichungAreaParking>();
  final List<TaichungAreaParking> parkingLots;
}

class TaichungAreaParking {
  TaichungAreaParking.fromJson(dynamic json)
      : name = json['Position'] ?? '',
        billing = json['Notes'] ?? '',
        surplus = json['AvailableCar'] ?? '',
        longitude = json['X'] ?? 0,
        latitude = json['Y'] ?? 0;

  /// 停車場名稱
  final String name;

  /// 計費方式
  final String billing;

  /// 剩餘車位
  final int surplus;

  /// 經度
  final double longitude;

  /// 緯度
  final double latitude;
  @override
  String toString() {
    return 'TaichungAreaParking (name = $name , billing = $billing , surplus = $surplus , longitude = $longitude , latitude = $latitude )';
  }
}

// 停車場名稱: "永兆(勞山)停車場",
// 地址: "新竹市南大路140巷內",
// 營運時間: "每日00:00~24:00(24H)",
// 平日收費方式: "機車：20元/次",
// 假日收費方式: "機車：20元/次",
// 汽車總車位: "0",
// 汽車剩餘車位: "0",
// 機車總車位: "500",
// 機車剩餘車位: "139",
// X座標: "24.80726", 緯度
// Y座標: "120.969783" 經度

/// 新竹市停車場
class HsinchuCityParking {
  HsinchuCityParking.fromJson(dynamic json)
      : name = json['停車場名稱'] ?? '',
        address = json['地址'] ?? '',
        time = json['營運時間'] ?? '',
        weekdays = json['平日收費方式'] ?? '',
        holiday = json['假日收費方式'] ?? '',
        carTotal = json['汽車總車位'] ?? '',
        carSurplus = json['汽車剩餘車位'] ?? '',
        locomotiveTotal = json['機車總車位'] ?? '',
        locomotiveSurplus = json['機車剩餘車位'] ?? '',
        latitude = json['X座標'] ?? '',
        longitude = json['Y座標'];
  final String? name;
  final String? address;
  final String? time;
  final String? weekdays;
  final String? holiday;
  final String? carTotal;
  final String? carSurplus;
  final String? locomotiveTotal;
  final String? locomotiveSurplus;

  /// 緯度
  final String? latitude;

  /// 經度
  final String? longitude;

  @override
  String toString() {
    return 'HsinchuCityParking(name = $name , address = $address , time = $time , weekdays = $weekdays , holiday = $holiday , carTotal = $carTotal , carSurplus = $carSurplus , locomotiveTotal = $locomotiveTotal , locomotiveSurplus = $locomotiveSurplus, longitude = $longitude, latitude = $latitude )';
  }
}

/// 桃園停車場資訊
class TaoyuanCityParking {
  TaoyuanCityParking.fromJson(dynamic json)
      : parkingList = json['parkingLots']
            .map((dynamic v) => TaoyuanAreaParking.fromJson(v))
            .toList()
            .cast<TaoyuanAreaParking>();
  final List<TaoyuanAreaParking> parkingList;
}

class TaoyuanAreaParking {
  TaoyuanAreaParking.fromJson(dynamic json)
      : name = json['parkName'],
        billing = json['payGuide'],
        surplus = json['surplusSpace'],
        longitude = json['wgsX'],
        latitude = json['wgsY'];

  /// 停車場名稱
  final String name;

  /// 計費方式
  final String billing;

  /// 剩餘車位
  final String surplus;

  /// 經度
  final double longitude;

  /// 緯度
  final double latitude;

  @override
  @override
  String toString() {
    return 'TaoyuanParking(name = $name , billing = $billing , surplus = $surplus , longitude = $longitude , latitude = $latitude)';
  }
}

/// 全台停車場
class TaiwanParking {
  /// 停車場名稱
  String name = '';

  /// 營業時間
  String time = '';

  /// 計費方式
  String billing = '';

  /// 剩餘車位
  String surplus = '';

  /// 經度
  double longitude = 0;

  /// 緯度
  double latitude = 0;

  /// 距離
  double distance = 0;
}

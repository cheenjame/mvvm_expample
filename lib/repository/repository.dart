import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mvvm_expample/repository/global_json.dart';

class Repository {
  /// 取得專輯
  Future<Album> fetchAlbum() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      return Album.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  /// 取得新竹停車場資訊
  Future<List<HsinchuCityParking>> getHsinchuParking() async {
    final repsonse = await http.get(Uri.parse(
        'https://odws.hccg.gov.tw/001/Upload/25/OpenData/9059/452/7f02e869-396b-480c-b93f-f62cf67b0f7c.json'));
    if (repsonse.statusCode == 200) {
      return parseParking(const Utf8Codec().decode(repsonse.bodyBytes));
    } else {
      throw Exception('網路異常');
    }
  }
}

/// 專輯json資料
class Album {
  Album.fromJson(dynamic json)
      : userId = json['userId'] ?? 0,
        id = json['id'] ?? 0,
        title = json['title'] ?? '';

  /// 使用者id
  final int? userId;

  /// 專輯id
  final int? id;

  /// 專輯標題
  final String? title;
  @override
  String toString() {
    return 'Album(userId : $userId , id : $id , title: $title)';
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

import 'dart:convert';
import 'package:http/http.dart' as http;

class  AlbumRepository {
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

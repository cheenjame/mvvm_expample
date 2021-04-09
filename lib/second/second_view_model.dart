import 'package:flutter/foundation.dart';
import 'package:mvvm_expample/repository/repository.dart';

class SecondViewModel extends ChangeNotifier {
  SecondViewModel({Repository? repository})
      : _repository = repository ?? Repository();
  final Repository _repository;

  /// 取得專輯
  Future fetchAlbum() async {
    return _repository.fetchAlbum().then((value) => title = value.title ?? '');
  }

  String _title = '';

  /// 取得標題
  String get title => _title;
  set title(String title) {
    _title = title;
    notifyListeners();
  }
}

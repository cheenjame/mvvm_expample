import 'package:flutter/material.dart';
import 'package:mvvm_expample/repository/repository.dart';

class ParkingViewModel extends ChangeNotifier {
  ParkingViewModel({Repository? repository})
      : _repository = repository ?? Repository();
  final Repository _repository;
  bool isLoaded = false;

  /// 是否輸入中
  bool _isEditing = false;

  /// 輸入框是否在編輯中
  bool get isEditing => _isEditing;
  set isEditing(bool isEditing) {
    _isEditing = isEditing;
    notifyListeners();
  }

  final items = ValueNotifier<List<HsinchuCityParking>>([]);
  Future<List<HsinchuCityParking>> getHsinchuParking() async {
    isLoaded = true;
    return _repository.getHsinchuParking().then((value) => items.value = value);
  }

  /// 總車位是否為0
  bool isTotal(String total) {
    final number = int.parse(total);
    return number == 0;
  }

  Future<List<HsinchuCityParking>> getSearchHsinchuParking(String text) async {
    return _repository
        .getHsinchuParking()
        .then((value) => value.where((element) => element.name!.contains(text)))
        .then((value) => items.value = value.toList());
  }

  /// 輸入文本列出最新消息列表
  void inputText( String text) {
    if (text.length >= 2) {
      getSearchHsinchuParking(text);
    }
  }

  /// 判斷輸入框是否在編輯中
  void editing(bool hasFoucs) {
    if (hasFoucs) {
      isEditing = true;
    } else {
      isEditing = false;
    }
  }
}




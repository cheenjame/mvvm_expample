import 'package:flutter/material.dart';
import 'package:mvvm_expample/second/second_view_model.dart';
import 'package:provider/provider.dart';

class SecondPage extends StatelessWidget {
  SecondPage({SecondViewModel? viewModel})
      : _viewModel = viewModel ?? SecondViewModel();
  final SecondViewModel _viewModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('第二頁')),
      body: Center(
        child: Column(children: [
          ElevatedButton(
            child: const Text('點擊'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: const Text('讀取資料'),
            onPressed: () {
              _viewModel.fetchAlbum().then((value) => print('${value.title}'));
            },
          ),
          ChangeNotifierProvider.value(
              value: _viewModel,
              child: Consumer<SecondViewModel>(
                builder: (context, value, child) => Text(_viewModel.title),
              ))
        ]),
      ),
    );
  }
}

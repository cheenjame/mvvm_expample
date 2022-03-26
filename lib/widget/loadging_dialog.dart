import 'package:flutter/material.dart';
import 'package:mvvm_expample/colors.dart';

/// 顯示轉圈圈提示框
LoadingDialog showMvvmLoadingDialog(BuildContext context) {
  const dialog = LoadingDialog();
  showNonDismissDialog(context, dialog);
  return dialog;
}

/// 自訂轉圈圈提示框
class LoadingDialog extends AlertDialog {
  const LoadingDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const CircularProgressIndicator circularProgress =
        CircularProgressIndicator(
      strokeWidth: 3.0,
      valueColor: AlwaysStoppedAnimation<Color>(mainColor),
    );

    return const Center(
      child: circularProgress,
    );
  }

  ///關閉轉圈圈提示框
  void close(BuildContext context) {
    Navigator.of(context).pop();
  }
}

/// 顯示點擊外部及返回鍵不關閉
void showNonDismissDialog(BuildContext context, Widget widget) {
  showDialog<dynamic>(
    context: context,
    barrierDismissible: false,
    builder: (_) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: widget,
    ),
  );
}

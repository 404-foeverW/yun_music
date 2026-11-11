import 'package:flutter/material.dart';

class ShowDialog {
  static Future<void> showLoadingDialog(
    BuildContext context, {
    String title = '',
    String content = '',
    String cancelText = '取消',
    String confirmText = '确定',
    bool barrierDismissible = true,
    Function? onCancel,
    Function? onConfirm,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content.isEmpty ? null : Text(content),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
              if (onCancel != null) {
                onCancel();
              }
            }, child: Text(cancelText)),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null) {
                  onConfirm();
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
              ),
              child: Text(confirmText, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

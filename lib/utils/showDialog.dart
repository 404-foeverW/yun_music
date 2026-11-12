import 'package:flutter/material.dart';
import 'package:yun_music/components/pressmask.dart';

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
          // contentPadding: EdgeInsets.all(10),
          titlePadding: EdgeInsets.all(0),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Flex(
              spacing: 10,
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: PressMask(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onCancel != null) {
                          onCancel();
                        }
                      },
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        side: WidgetStateProperty.all(
                          BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      child: Text(
                        cancelText,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PressMask(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onConfirm != null) {
                          onConfirm();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                      ),
                      child: Text(
                        confirmText,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

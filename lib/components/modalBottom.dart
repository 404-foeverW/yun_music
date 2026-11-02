import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SheetListItem {
  bool isIcon; //是否显示图标
  bool isIconCustom; //是否自定义图标
  Widget icon; //图标
  String iconPath; //图标路径
  String text; //文字
  bool isOperator; //是否显示操作按钮
  Widget operatorWidget; //操作按钮
  bool isItemCustom; //是否自定义列表项
  Widget itemWidget; //自定义列表项

  SheetListItem({
    this.isIcon = true,
    this.isIconCustom = false,
    this.icon = const Icon(Icons.more_horiz),
    this.iconPath = '',
    this.text = '',
    this.isOperator = false,
    this.operatorWidget = const Icon(Icons.more_horiz),
    this.isItemCustom = false,
    this.itemWidget = const Text(''),
  });
}

class SheetConfig {
  String? title;
  bool isTitleCustom; //是否自定义标题
  Widget? titleWidget; //自定义标题
  bool isDividingLine; //是否显示分割线
  bool isShowFooter; //是否显示底部按钮
  bool isCancel; //是否显示取消按钮
  String cancelText; //取消按钮文字
  bool isConfirm; //是否显示确认按钮
  String confirmText; //确认按钮文字
  Function? confirmCallback; //确认按钮回调
  Function? cancelCallback; //取消按钮回调
  List<SheetListItem>? items; //列表项
  bool isListItemCustom; //是否自定义全部列表项
  List<Widget>? customItems; //列表项

  SheetConfig({
    this.title,
    this.isTitleCustom = false,
    this.titleWidget,
    this.isDividingLine = true,
    this.isCancel = true,
    this.cancelText = '取消',
    this.isConfirm = true,
    this.confirmText = '确认',
    this.confirmCallback,
    this.cancelCallback,
    this.items,
    this.isListItemCustom = false,
    this.customItems,
    this.isShowFooter = false,
  });
}

Future<void> showBottomSheetPop(
  BuildContext context,
  SheetConfig config,
) async {
  return showModalBottomSheet<void>(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        children: [
          _buildSheetTitle(context, config),
          if (config.isDividingLine) const Divider(height: 1),
          _buildSheetContent(context, config),
          if (config.isShowFooter) _buildSheetFooter(context, config),
        ],
      ),
    ),
  );
}

Widget _buildSheetTitle(BuildContext context, SheetConfig config) {
  return config.isTitleCustom
      ? config.titleWidget!
      : Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          child: Text(config.title!, style: TextStyle(fontSize: 13, color: Colors.black.withValues(alpha: 0.6))),
        );
}

Widget _buildSheetContent(BuildContext context, SheetConfig config) {
  return config.isListItemCustom
      ? Column(children: config.customItems!)
      : ListView.builder(
          shrinkWrap: true,
          itemCount: config.items!.length,
          itemBuilder: (context, index) {
            return _buildSheetListItem(context, config.items![index]);
          },
        );
}

Widget _buildSheetListItem(BuildContext context, SheetListItem item) {
  return item.isItemCustom
      ? item.itemWidget
      : ListTile(
          leading: item.isIcon
              ? item.isIconCustom
                    ? item.icon
                    : SvgPicture.asset(item.iconPath, width: 16, height: 16)
              : null,
          title: Text(item.text, style: TextStyle(fontSize: 15)),
          trailing: item.isOperator ? item.operatorWidget : SizedBox(width: 16,height: 16),
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        );
}

Widget _buildSheetFooter(BuildContext context, SheetConfig config) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (config.isCancel)
          TextButton(
            onPressed: () {
              if (config.cancelCallback != null) {
                config.cancelCallback!();
              }
              Navigator.pop(context);
            },
            child: Text(config.cancelText),
          ),
        if (config.isConfirm)
          TextButton(
            onPressed: () {
              if (config.confirmCallback != null) {
                config.confirmCallback!();
              }
              Navigator.pop(context);
            },
            child: Text(config.confirmText),
          ),
      ],
    ),
  );
}

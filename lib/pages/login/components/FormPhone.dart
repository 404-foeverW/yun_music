// 手机号码输入
import 'package:flutter/material.dart';

class FormPhone extends StatefulWidget {
  final Function setVisible;
  final TextEditingController controller;

  const FormPhone({super.key, required this.setVisible, required this.controller});

  @override
  State<FormPhone> createState() => _FormPhoneState();
}

class _FormPhoneState extends State<FormPhone> {
  // TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 216, 204, 204),
      ),
      child: IntrinsicHeight(
        child: Row(
          // spacing: 5,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                '+86',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 148, 146, 146),
                ),
              ),
            ),
            VerticalDivider(
              color: Color.fromARGB(255, 148, 146, 146),
              thickness: 1,
              width: 10,
              indent: 16, // 顶部缩进
              endIndent: 16, // 底部缩进
            ),
            Expanded(
              child: Focus(
                onFocusChange: (value) {
                  if (value) {
                    widget.setVisible(true);
                    print('phone 获得焦点，键盘即将弹出');
                  } else {
                    widget.setVisible(false);
                    print('phone 失去焦点，键盘即将收起');
                  }
                },
                child: TextFormField(
                  controller: widget.controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '手机号不能为空';
                    }
                    RegExp regx = RegExp(r"^1[3-9]\d{9}$");
                    if (!regx.hasMatch(value)) {
                      return '请输入正确的手机号';
                    }
                    return null;
                  },
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: '请输入手机号',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 57, 56, 56),
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:flutter_tour_bus_new/pages/member/resetPassword/reset_password_phone_verification_code.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ResetPasswordFinish extends StatefulWidget {

  final String phone;

  const ResetPasswordFinish({Key? key, required this.phone}) : super(key: key);

  @override
  _ResetPasswordFinishState createState() => _ResetPasswordFinishState();
}

class _ResetPasswordFinishState extends State<ResetPasswordFinish> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _httpGetResetPassword(widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('重設密碼'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Text("臨時密碼已經傳送至您的手機簡訊，\n請使用臨時密碼登入。"),
            SizedBox(height: 20),
            CustomElevatedButton(
              title: '未收到簡訊，重新傳送',
              color: AppColor.yellow,
              onPressed: (){
                _httpGetResetPassword(widget.phone);
              },
            ),
            CustomElevatedButton(
              title: '返回登入頁',
              color: AppColor.yellow,
              onPressed: (){
                Navigator.popUntil(context, ModalRoute.withName('/login_register'));
              },
            ),
          ],
        ));
  }

  Future _httpGetResetPassword(String phone) async {
    String path = Service.PATH_RESET_PASSWORD_SMS_PASSWORD;

    try {

      final queryParameters = {
        'phone': phone,
      };

      final response = await http.get(
        Service.standard(path: path, queryParameters: queryParameters),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(response.body);

      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      if(map['message'] != "ok"){
        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('可能網路不佳，未成功重設密碼！')));
      }

    } catch (e) {
      print(e);
      return "error";
    }
  }

}

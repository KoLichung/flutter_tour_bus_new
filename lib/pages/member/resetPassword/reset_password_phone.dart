import 'dart:convert';

import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:flutter_tour_bus_new/pages/member/resetPassword/reset_password_phone_verification_code.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ResetPasswordPhone extends StatefulWidget {
  const ResetPasswordPhone({Key? key}) : super(key: key);

  @override
  _ResetPasswordPhoneState createState() => _ResetPasswordPhoneState();
}

class _ResetPasswordPhoneState extends State<ResetPasswordPhone> {

  TextEditingController phoneNumberController = TextEditingController();
  // TextEditingController pwdTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('重設密碼'),
        ),
        body: Column(
          children: [
            SizedBox(height: 60,),
            CustomTextField(
              icon: Icons.phone_android_outlined,
              hintText: '電話號碼',
              controller: phoneNumberController,
              isNumblerOnly: true,
            ),

            CustomElevatedButton(
              title: '取得驗證碼',
              color: AppColor.yellow,
              onPressed: (){
                _getVerifyCode(phoneNumberController.text);
              },
            ),
          ],
        ));
  }


  Future _getVerifyCode(String phone) async {
    String path = Service.PATH_RESET_PASSWORD_SMS_VERIFY;

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
      if(map['code'] != null){
        String code = map['code'].toString();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResetPasswordPhoneVerificationCode(phone: phone,code: code) ),
        );
        // setState(() {});
      }else{
        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('找不到此電話的使用者！')));
      }

    } catch (e) {
      print(e);
      return "error";
    }
  }


}

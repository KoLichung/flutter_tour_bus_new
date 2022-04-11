import 'dart:convert';

import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import 'package:http/http.dart' as http;

import '../../../notifier_model/user_model.dart';

class RegisterIdentitySocial extends StatefulWidget {
  final String displayName;
  final String lineId;

  const RegisterIdentitySocial({Key? key, required this.displayName, required this.lineId}) : super(key: key);

  @override
  _RegisterIdentitySocialState createState() => _RegisterIdentitySocialState();
}

enum UserIdentity { passenger, driver }

class _RegisterIdentitySocialState extends State<RegisterIdentitySocial> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController pwdTextController = TextEditingController();
  TextEditingController userPhoneTextController = TextEditingController();

  UserIdentity? _userIdentity = UserIdentity.passenger;

  bool driverFormIsVisible = false;

  @override
  void initState() {
    super.initState();
    userNameController.text = widget.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('註冊選擇身份'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40,),
              chooseIdentity(),
              CustomTextField(
                icon: Icons.person,
                hintText: '使用者名稱',
                controller: userNameController,
              ),
              CustomTextField(
                icon: Icons.phone_android_outlined,
                hintText: '電話',
                controller: userPhoneTextController,
                isNumblerOnly: true,
              ),
              const Text('( 電話號碼請填對，避免聯絡不到！)'),
              driverForm(),
              CustomElevatedButton(
                title: '註冊',
                color: AppColor.yellow,
                onPressed: (){
                  // Navigator.popUntil(context, ModalRoute.withName('/login_register'));

                  if(_userIdentity == UserIdentity.passenger){
                    User user = User(name: userNameController.text, phone: userPhoneTextController.text);
                    _postCreateUser(user, pwdTextController.text, widget.lineId);
                  }
                },
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ));
  }

  chooseIdentity(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Row(
        children: [
          Radio<UserIdentity>(
            value: UserIdentity.passenger,
            groupValue: _userIdentity,
            onChanged: (UserIdentity? value){
              setState(() {
                _userIdentity = value;
                driverFormIsVisible = false;
              });
            },
            activeColor: Colors.black54,
          ),
          const Text('一般消費者'),
          Radio<UserIdentity>(
            value: UserIdentity.driver,
            groupValue: _userIdentity,
            onChanged: (UserIdentity? value){
              setState(() {
                _userIdentity = value;
                driverFormIsVisible = true;
              });
            },
            activeColor: Colors.black54,
          ),
          const Text('遊覽車業者')
        ],
      ),
    );
  }

  driverForm(){
    return Visibility(
        visible: driverFormIsVisible,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0,20,0,10),
                child: Align(
                    alignment:Alignment.centerLeft,
                    child: Text('* 業主資訊')),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          primary: AppColor.yellow,
                          elevation: 0
                      ),
                      child: const SizedBox(
                        height: 40,
                        width: 80,
                        child: Align(
                          child: Text(
                            '業主規範',
                            style: TextStyle(fontSize: 16),),
                          alignment: Alignment.center,
                        ),
                      )

                  ),
                  const Text('  (請點入並同意規範)'),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(children: [
                  const Text('行號：'),
                  Expanded(child: driverFormTextField())]),
              ),
              Row(children: [
                const Text('地址：'),
                Expanded(child: driverFormTextField())]),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Align(alignment:Alignment.centerLeft,child: Text('擇一輛車填寫以下資料：'))),
              Row(children: [
                const Text('牌照：'),
                Expanded(child: driverFormTextField())]),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(children: [
                  const Text('車主：'),
                  Expanded(child: driverFormTextField())]),
              ),
              Row(children: [
                const Text('引擎號碼：'),
                Expanded(child: driverFormTextField())]),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(children: [
                  const Text('車身號碼：'),
                  Expanded(child: driverFormTextField())]),
              ),
              Row(children: [
                const Text('上傳行照：'),
                const SizedBox(width: 20,),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColor.grey,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed: null,
                    child: Icon(Icons.photo_camera_outlined)),
              ]),
            ],
          ),
        ));
  }

  driverFormTextField(){
    return Container(
      margin: const  EdgeInsets.symmetric(horizontal: 10),
      height: 46,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColor.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),),
      child: const TextField(
        style: TextStyle(fontSize: 18),
        // controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),

      ),
    );
  }

  Future _postCreateUser(User user, String password, String lineId) async {
    String path = Service.PATH_CREATE_USER;

    try {
      Map queryParameters = {
        'phone': user.phone,
        'name': user.name,
        'password': '00000',
        'line_id': lineId,
      };

      final response = await http.post(
          Service.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(queryParameters)
      );

      // print(response.body);

      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      User theUser = User.fromJson(map);

      String? token = await _getUserTokenFromLine(lineId);

      var userModel = context.read<UserModel>();
      userModel.setUser(theUser);
      userModel.token = token;
      userModel.isLineLogin = true;

      Navigator.popUntil(context, ModalRoute.withName('/login_register'));
    } catch (e) {
      print(e);
      return "error";
    }
  }

  Future<String?> _getUserTokenFromLine(String lineId) async {
    String path = Service.PATH_USER_TOKEN;
    try {
      Map queryParameters = {
        'phone': '00000',
        'password': '00000',
        'line_id': lineId,
      };

      final response = await http.post(
          Service.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(queryParameters)
      );

      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      if(map['token']!=null){
        String token = map['token'];
        return token;
      }else{
        print(response.body);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }


}

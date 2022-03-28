import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/pages/booking/rental_agreement.dart';
import 'package:flutter_tour_bus_new/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'register_social.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';
import 'package:flutter_tour_bus_new/models/user.dart';
import 'package:provider/provider.dart';


class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pwdTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('登入'),
        ),
        body: Column(
          children: [
            Container(
              //images
              margin: const EdgeInsets.symmetric(vertical: 60),
              color: AppColor.lightGrey,
              width: 100,
              height: 100,
            ),
            CustomTextField(
              icon: Icons.phone_android_outlined,
              hintText: '電話號碼',
              controller: phoneNumberController,
            ),
            CustomTextField(
              icon: Icons.lock_outline,
              hintText: '密碼',
              controller: pwdTextController,
              isObscureText: true,
            ),
            CustomElevatedButton(
              title: '登入',
              color: AppColor.yellow,
              onPressed: (){
                _phoneLogIn(context, phoneNumberController.text, pwdTextController.text);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => const RentalAgreement()));
              },
            ),
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                alignment: Alignment.centerRight,
                child: Text(
                  '註冊',
                  style: TextStyle(color: Colors.yellow.shade700,decoration: TextDecoration.underline,),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/register_phone');
              },
            ),
            const Divider(
              height: 30,
              color: Colors.black87,
              indent: 30,
              endIndent: 30,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF00B900),
                      elevation: 0
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterSocial()),
                    );
                  },
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex:1, child:Container(
                          margin: const EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          width: 40,
                          child: const Icon(FontAwesomeIcons.line),
                        )),
                        Expanded(flex:3, child:Container(child: const Text('使用LINE繼續',textAlign: TextAlign.center,),)),
                        Expanded(flex:1, child:Container()),

                      ],
                    ),
                  )),
            ),
          ],
        ));
  }

  Future<void> _phoneLogIn(BuildContext context, String phone, String password) async {
    String path = Service.PATH_USER_TOKEN;
    try {
      Map queryParameters = {
        'phone': phone,
        'password': password,
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

        User? user = await _getUserData(token);
        user!.token = token;
        user.loginMethod = LoginMethod.phone;

        // notifi user_model
        var userModel = context.read<UserModel>();
        userModel.setUser(user);

        Navigator.pop(context, 'ok');

      }else{
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("電話號碼 或 密碼錯誤！"),
            )
        );
      }

    }catch(e){
      print(e);
    }
  }

  // Future<void> _lineSignIn(BuildContext context) async {
  //   try {
  //     final result = await LineSDK.instance.login();
  //
  //     String lineId = result.userProfile.userId;
  //     String displayName = result.userProfile.displayName;
  //     String email = '${lineId}@line.com';
  //     String token = await _getUserToken(email, lineId, LoginMethod.line_id);
  //
  //     if(token != null){
  //       User user = await _getUserData(token);
  //       user.token = token;
  //       user.loginMethod = LoginMethod.line_id;
  //       user.socialId =lineId;
  //
  //       // save to sharePreference
  //       // UserUtil.saveLoginInfo(user);
  //
  //       // notifi user_model
  //       var userModel = context.read<UserModel>();
  //       userModel.setUser(user);
  //
  //       Navigator.pop(context);
  //     }else{
  //       User user = User(email: email, name: displayName, loginMethod: LoginMethod.line_id, socialId: lineId);
  //
  //       final result = await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => RegisterSocial(user: user),
  //           )
  //       );
  //
  //       if(result!=null && result=='ok'){
  //         Navigator.pop(context, 'ok');
  //       }else{
  //         ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text('未成功建立使用者！')));
  //       }
  //     }
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future<String?> _getUserToken(String phone, String socialId, var loginMethod) async {
  //   String path = Service.PATH_USER_TOKEN;
  //   try {
  //     Map queryParameters = {
  //       'phone': phone,
  //       'password': '000000',
  //     };
  //
  //     switch(loginMethod){
  //
  //       case LoginMethod.lineID:
  //         queryParameters['line_id'] = socialId;
  //         break;
  //     }
  //
  //     final response = await http.post(
  //         Service.standard(path: path),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode(queryParameters)
  //     );
  //
  //     Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
  //     if(map['token']!=null){
  //       String token = map['token'];
  //       return token;
  //     }else{
  //       print(response.body);
  //       return null;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  Future<User?> _getUserData(String token) async {
    String path = Service.PATH_USER_DATA;
    try {
      final response = await http.get(
        Service.standard(path: path),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
      );
      print('here');
      print(token);

      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      String phone = map['phone'];
      String name = map['name'];
      bool isOwner = map['isOwner'];
      bool isGottenLineId = map['is_gotten_line_id'];

      return User(phone: phone, name: name, isGottenLineId: isGottenLineId,isOwner: isOwner, token: token);

    } catch (e) {
      print(e);

      // return null;
      // return User(phone: '0000000000', name: 'test test', isGottenLineId: false, token: '4b36f687579602c485093c868b6f2d8f24be74e2',isOwner: false);

    }
  }


}

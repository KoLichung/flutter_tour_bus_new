import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/pages/member/register/register_identity_social.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';
import 'package:flutter_tour_bus_new/models/user.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pwdTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var userModel = context.read<UserModel>();
    if(userModel.deviceId==null){
      _getDeviceInfo();
    }
  }

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
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image:AssetImage('images/appIcon_tour_bus_round.png'),
                  )
              ),
            ),
            CustomTextField(
              icon: Icons.phone_android_outlined,
              hintText: '電話號碼',
              controller: phoneNumberController,
              isNumblerOnly: true,
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
                Navigator.pushNamed(context, '/register_phone').then((value){
                  var userModel = context.read<UserModel>();
                  if(userModel.user != null){
                    Navigator.pop(context,"ok");
                  }
                });
              },
            ),

            Consumer<UserModel>(builder: (context, userModel, child) =>
                (userModel.platformType=="android")?
                Container():
                Column(
                  children: [
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
                            print("line button pressed");
                            _lineSignIn(context);
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
                          )
                      ),
                    )
                  ],
                )
            ),
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 30),
            //   child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //           primary: const Color(0xFF00B900),
            //           elevation: 0
            //       ),
            //       onPressed: (){
            //         print("line button pressed");
            //         _lineSignIn(context);
            //       },
            //       child: Container(
            //         height: 46,
            //         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Expanded(flex:1, child:Container(
            //               margin: const EdgeInsets.only(left: 10),
            //               alignment: Alignment.centerLeft,
            //               width: 40,
            //               child: const Icon(FontAwesomeIcons.line),
            //             )),
            //             Expanded(flex:3, child:Container(child: const Text('使用LINE繼續',textAlign: TextAlign.center,),)),
            //             Expanded(flex:1, child:Container()),
            //           ],
            //         ),
            //       )
            //   ),
            // ),
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
        print('server token $token');

        User? user = await _getUserData(token);

        // notifi user_model
        var userModel = context.read<UserModel>();
        userModel.setUser(user!);
        userModel.token = token;

        _httpPostFCMDevice();

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

  Future<void> _lineSignIn(BuildContext context) async {
    try {
      print("trying to line login");
      final result = await LineSDK.instance.login();

      String lineId = result.userProfile!.userId;
      String displayName = result.userProfile!.displayName;

      print("lineId $lineId");

      String? token = await _getUserTokenFromLine(lineId);
      print("userToken $token");

      if(token != null){
        User? user = await _getUserData(token);

        // notifi user_model
        var userModel = context.read<UserModel>();
        userModel.setUser(user!);
        userModel.token = token;
        userModel.isLineLogin = true;

        _httpPostFCMDevice();

        Navigator.pop(context);
      }else{

        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterIdentitySocial(displayName: displayName, lineId: lineId),
            )
        );

        var userModel = context.read<UserModel>();
        if(userModel.user != null){
          Navigator.pop(context, 'ok');
        }else{
          ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('未成功建立使用者！')));
        }
      }
    } on PlatformException catch (e) {
      print(e.toString());
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

      print(response.body);

      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      User theUser = User.fromJson(map);

      return theUser;

    } catch (e) {
      print(e);

      // return null;
      // return User(phone: '0000000000', name: 'test test', isGottenLineId: false, token: '4b36f687579602c485093c868b6f2d8f24be74e2',isOwner: false);

    }
    return null;
  }

  Future _getDeviceInfo() async {
    var userModel = context.read<UserModel>();
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      String deviceID = iosDeviceInfo.identifierForVendor!;
      print(deviceID);
      userModel.deviceId = deviceID;
      userModel.platformType = 'ios';
      setState(() {});
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      String deviceID =  androidDeviceInfo.androidId!;
      print(deviceID);
      userModel.deviceId = deviceID;
      userModel.platformType = 'android';
      setState(() {});
    }
  }

  Future<void> _httpPostFCMDevice() async {
    print("postFCMDevice");
    String path = Service.PATH_REGISTER_DEVICE;
    var userModel = context.read<UserModel>();

    try {
      Map queryParameters = {
        'user_id': userModel.user!.id.toString(),
        'registration_id': userModel.fcmToken,
        'device_id': userModel.deviceId,
        'type': userModel.platformType!,
      };

      final response = await http.post(
          Service.standard(path: path),
          body: queryParameters,
      );

      print(response.body);

    }catch(e){
      print(e);
    }
  }

}

import 'dart:convert';
import 'dart:io';
import 'package:flutter_tour_bus_new/pages/member/register/register_identity_owner_dialog.dart';

import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import 'package:http/http.dart' as http;

import '../../../notifier_model/user_model.dart';

class RegisterIdentitySocial extends StatefulWidget {
  final String displayName;
  final String lineId;
  final String appleId;

  const RegisterIdentitySocial({Key? key, required this.displayName, required this.lineId, required this.appleId}) : super(key: key);

  @override
  _RegisterIdentitySocialState createState() => _RegisterIdentitySocialState();
}

enum UserIdentity { passenger, driver }

class _RegisterIdentitySocialState extends State<RegisterIdentitySocial> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController userPhoneTextController = TextEditingController();

  TextEditingController companyTextController = TextEditingController();
  TextEditingController companyAddressTextController = TextEditingController();
  TextEditingController vehicalLicenceTextController = TextEditingController();
  TextEditingController vehicalOwnerTextController = TextEditingController();
  // TextEditingController vehicalEngineNumberTextController = TextEditingController();
  // TextEditingController vehicalBodyNumberTextController = TextEditingController();

  UserIdentity? _userIdentity = UserIdentity.passenger;

  bool driverFormIsVisible = false;
  // bool isOwnerAgreementChecked = false;

  XFile? driverlicenseImage;
  XFile? licenseImage;
  bool isLoading = false;

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
        body: (isLoading)?
        const Center(
          child: CircularProgressIndicator(),
        ):
        SingleChildScrollView(
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
                onPressed: () async {
                    if(_userIdentity == UserIdentity.passenger){
                      if(userNameController.text ==''){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("名稱不可空白！"),));
                      }else{
                        User user = User(name: userNameController.text, phone: userPhoneTextController.text);
                        if(widget.lineId!=""){
                          _postCreateUser(user, widget.lineId, false);
                        }else if(widget.appleId!=""){
                          _postCreateAppleUser(user, widget.appleId, false);
                        }
                        isLoading = true;
                        setState(() {});
                      }
                    }else if(_userIdentity == UserIdentity.driver){
                      final result = await showDialog(context: context,builder: (_){return RegisterIdentityOwnerDialog();});
                      if(result.toString() == "confirmRegister"){
                        if(userNameController.text == '' || companyTextController.text == '' ||
                            companyAddressTextController.text == '' || vehicalLicenceTextController.text == '' || vehicalOwnerTextController.text == ''){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("業者各項資料不可空白！"),));
                        }else if(licenseImage == null){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("需上傳行照照片！"),));
                        }else if(driverlicenseImage == null){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("需上傳車主駕照照片！"),));
                        }else{
                          User user = User(
                            name: userNameController.text,
                            phone: userPhoneTextController.text,
                            company: companyTextController.text,
                            address: companyAddressTextController.text,
                            vehicalLicence: vehicalLicenceTextController.text,
                            vehicalOwner: vehicalOwnerTextController.text,
                            // vehicalEngineNumber: vehicalEngineNumberTextController.text,
                            // vehicalBodyNumber: vehicalBodyNumberTextController.text
                          );
                          if(widget.lineId!=""){
                            _postCreateUser(user, widget.lineId, false);
                          }else if(widget.appleId!=""){
                            _postCreateAppleUser(user, widget.appleId, false);
                          }
                          isLoading = true;
                          setState(() {});
                        }
                    }
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
                    child: Text('* 業者資訊')),
              ),
              // Row(children: [
              //   Checkbox(
              //       visualDensity: const VisualDensity(
              //         horizontal: VisualDensity.minimumDensity,
              //       ),
              //       value: isOwnerAgreementChecked,
              //       onChanged: (bool? value){
              //         setState(() {
              //           isOwnerAgreementChecked = value!;
              //         });
              //       }),
              //   const Text('我同意下列遊覽車業者規範：')
              // ],),
              // const Text('在此上架之遊覽車業者應符合國家遊覽車業者規定，且無不法情事，如有違反經查證屬實將強制下架該遊覽車業者。使用平台服務費為出車一天\$1000元。'),
              // const SizedBox(height: 10,),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(children: [
                  const Text('行號：'),
                  Expanded(child: driverFormTextField(companyTextController))]),
              ),
              Row(children: [
                const Text('地址：'),
                Expanded(child: driverFormTextField(companyAddressTextController))]),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Align(alignment:Alignment.centerLeft,child: Text('擇一輛車填寫以下資料：'))),
              Row(children: [
                const Text('牌照：'),
                Expanded(child: driverFormTextField(vehicalLicenceTextController))]),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(children: [
                  const Text('車主：'),
                  Expanded(child: driverFormTextField(vehicalOwnerTextController))]),
              ),
              // Row(children: [
              //   const Text('引擎號碼：'),
              //   Expanded(child: driverFormTextField(vehicalEngineNumberTextController))]),
              // Container(
              //   margin: const EdgeInsets.symmetric(vertical: 10),
              //   child: Row(children: [
              //     const Text('車身號碼：'),
              //     Expanded(child: driverFormTextField(vehicalBodyNumberTextController))]),
              // ),
              Row(children: [
                const Text('上傳駕照：'),
                const SizedBox(width: 20,),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColor.grey,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 640, maxHeight: 480);

                      if(pickedFile == null) return;

                      driverlicenseImage = pickedFile;
                      setState(() {});
                    },
                    child: const Icon(Icons.photo_camera_outlined)
                ),
                (driverlicenseImage==null)?
                SizedBox():
                Container(
                  margin: const EdgeInsets.fromLTRB(10,10,0,8),
                  height: 60, width: 60,
                  child: Image.file(File(driverlicenseImage!.path),fit: BoxFit.cover,),
                ),
              ]),
              Row(children: [
                const Text('上傳行照：'),
                const SizedBox(width: 20,),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColor.grey,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 640);

                      if(pickedFile == null) return;

                      licenseImage = pickedFile;
                      setState(() {});
                    },
                    child: const Icon(Icons.photo_camera_outlined)
                ),
                (licenseImage==null)?
                SizedBox():
                Container(
                  margin: const EdgeInsets.fromLTRB(10,10,0,8),
                  height: 60, width: 60,
                  child: Image.file(File(licenseImage!.path),fit: BoxFit.cover,),
                ),
              ]),
            ],
          ),
        ));
  }

  driverFormTextField(TextEditingController controller){
    return Container(
      margin: const  EdgeInsets.symmetric(horizontal: 10),
      height: 46,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColor.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),),
      child: TextField(
        style: const TextStyle(fontSize: 18),
        controller: controller,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),

      ),
    );
  }

  Future _postCreateUser(User user, String lineId, bool isOwner) async {
    String path = Service.PATH_CREATE_USER;

    try {
      Map queryParameters = {};
      if(!isOwner) {
        queryParameters = {
          'phone': user.phone,
          'name': user.name,
          'password': '00000',
          'line_id': lineId,
        };
      }else{
        queryParameters['phone'] = user.phone;
        queryParameters['name'] = user.name;
        queryParameters['isOwner'] = 'true';
        queryParameters['company'] = user.company;
        queryParameters['address'] = user.address;
        queryParameters['vehicalLicence'] = user.vehicalLicence;
        queryParameters['vehicalOwner'] = user.vehicalOwner;
        // queryParameters['vehicalEngineNumber'] = user.vehicalEngineNumber;
        // queryParameters['vehicalBodyNumber'] = user.vehicalBodyNumber;
        queryParameters['line_id'] = lineId;
        queryParameters['password'] = '00000';
      }

      final response = await http.post(
          Service.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(queryParameters)
      );

      if(response.statusCode == 201){
        Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
        User theUser = User.fromJson(map);

        String? token = await _getUserTokenFromLine(lineId);

        var userModel = context.read<UserModel>();
        userModel.setUser(theUser);
        userModel.token = token;
        userModel.isLineLogin = true;

        if(isOwner && licenseImage != null){
          _uploadLicenceImage(licenseImage, driverlicenseImage, token!);
        }else{
          Navigator.popUntil(context, ModalRoute.withName('/login_register'));
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("此電話號碼可能已註冊，更改電話試試！"),));
        isLoading = false;
        setState(() {});
      }

      // print(response.body);

    } catch (e) {
      print(e);
      return "error";
    }
  }

  Future _postCreateAppleUser(User user, String appleId, bool isOwner) async {
    String path = Service.PATH_CREATE_USER;

    try {
      Map queryParameters = {};
      if(!isOwner) {
        queryParameters = {
          'phone': user.phone,
          'name': user.name,
          'password': '00000',
          'apple_id': appleId,
        };
      }else{
        queryParameters['phone'] = user.phone;
        queryParameters['name'] = user.name;
        queryParameters['isOwner'] = 'true';
        queryParameters['company'] = user.company;
        queryParameters['address'] = user.address;
        queryParameters['vehicalLicence'] = user.vehicalLicence;
        queryParameters['vehicalOwner'] = user.vehicalOwner;
        // queryParameters['vehicalEngineNumber'] = user.vehicalEngineNumber;
        // queryParameters['vehicalBodyNumber'] = user.vehicalBodyNumber;
        queryParameters['apple_id'] = appleId;
        queryParameters['password'] = '00000';
      }

      final response = await http.post(
          Service.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(queryParameters)
      );

      if(response.statusCode == 201){
        Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
        User theUser = User.fromJson(map);

        String? token = await _getUserTokenFromApple(appleId);

        var userModel = context.read<UserModel>();
        userModel.setUser(theUser);
        userModel.token = token;
        userModel.isLineLogin = true;

        if(isOwner && licenseImage != null){
          _uploadLicenceImage(licenseImage, driverlicenseImage, token!);
        }else{
          Navigator.popUntil(context, ModalRoute.withName('/login_register'));
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("此電話號碼可能已註冊，更改電話試試！"),));
        isLoading = false;
        setState(() {});
      }

      // print(response.body);

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

  Future<String?> _getUserTokenFromApple(String appleId) async {
    String path = Service.PATH_USER_TOKEN;
    try {
      Map queryParameters = {
        'phone': '00000',
        'password': '00000',
        'apple_id': appleId,
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

  Future _uploadLicenceImage(XFile? image, XFile? driverImage,String token)async{
    print("here to upload image");
    String path = Service.PATH_USER_DATA;
    var request = http.MultipartRequest('PUT', Service.standard(path: path));

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    request.headers.addAll(headers);

    final file = await http.MultipartFile.fromPath('vehicalLicenceImage', image!.path);
    request.files.add(file);

    final driverFile = await http.MultipartFile.fromPath('driverLicenceImage', driverImage!.path);
    request.files.add(driverFile);

    request.fields['isOwner'] = 'true';

    // print(request.files.first.);

    var response = await request.send();
    // print(response.headers);
    print(response.statusCode);


    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      // Widget okButton = TextButton(
      //   child: Text("OK"),
      //   onPressed: () { },
      // );
      //
      // // set up the AlertDialog
      // AlertDialog alert = AlertDialog(
      //   title: Text("My title"),
      //   content: Text(value),
      //   actions: [
      //     okButton,
      //   ],
      // );
      //
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return alert;
      //   },
      // );


      Map<String, dynamic> map = json.decode(utf8.decode(value.runes.toList()));
      if(map['name']!=null){
        User theUser = User.fromJson(map);

        var userModel = context.read<UserModel>();
        userModel.setUser(theUser);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("成功註冊！"),));
        Navigator.popUntil(context, ModalRoute.withName('/login_register'));
      }else{
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("無法更新資料 請檢察網路！"),));
      }

    });
  }

}

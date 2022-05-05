import 'dart:convert';
import 'dart:io';

import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/pages/member/register/register_identity_owner_dialog.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import 'package:http/http.dart' as http;

import '../../../notifier_model/user_model.dart';

class RegisterIdentity extends StatefulWidget {
  final String phone;

  const RegisterIdentity({Key? key, required this.phone}) : super(key: key);

  @override
  _RegisterIdentityState createState() => _RegisterIdentityState();
}

enum UserIdentity { passenger, driver }

class _RegisterIdentityState extends State<RegisterIdentity> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController pwdTextController = TextEditingController();

  TextEditingController companyTextController = TextEditingController();
  TextEditingController companyAddressTextController = TextEditingController();
  TextEditingController vehicalLicenceTextController = TextEditingController();
  TextEditingController vehicalOwnerTextController = TextEditingController();
  // TextEditingController vehicalEngineNumberTextController = TextEditingController();
  // TextEditingController vehicalBodyNumberTextController = TextEditingController();

  UserIdentity? _userIdentity = UserIdentity.passenger;

  bool driverFormIsVisible = false;
  bool isOwnerAgreementChecked = false;

  XFile? driverlicenseImage;
  XFile? licenseImage;
  bool isLoading = false;

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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: ListTile(
                  leading: const Icon(
                    Icons.phone_android_outlined,
                    size: 26.0,
                    color: AppColor.grey,
                  ),
                  title: Text(
                    widget.phone,
                  ),
                ),
              ),
              chooseIdentity(),
              CustomTextField(
                icon: Icons.person,
                hintText: '使用者名稱',
                controller: userNameController,
              ),
              CustomTextField(
                icon: Icons.lock_outline,
                hintText: '密碼',
                controller: pwdTextController,
                isObscureText: true,
              ),
              driverForm(),
              CustomElevatedButton(
                title: '註冊',
                color: AppColor.yellow,
                onPressed: (){
                  // Navigator.popUntil(context, ModalRoute.withName('/login_register'));

                  showDialog(
                      context: context,
                      builder: (_){
                        return RegisterIdentityOwnerDialog();});


                    // if(_userIdentity == UserIdentity.passenger){
                    //   if(userNameController.text ==''){
                    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("名稱不可空白！"),));
                    //   }else{
                    //     User user = User(name: userNameController.text, phone: widget.phone);
                    //     _postCreateUser(user, pwdTextController.text, false);
                    //     isLoading = true;
                    //     setState(() {});
                    //   }
                    // }else if(_userIdentity == UserIdentity.driver){
                    //   if(isOwnerAgreementChecked ){
                    //     if(userNameController.text == '' || companyTextController.text == '' ||
                    //         companyAddressTextController.text == '' || vehicalLicenceTextController.text == '' || vehicalOwnerTextController.text == ''){
                    //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("業者各項資料不可空白！"),));
                    //     }else if(licenseImage == null){
                    //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("需上傳行照照片！"),));
                    //     }else if(driverlicenseImage == null){
                    //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("需上傳車主駕照照片！"),));
                    //     } else{
                    //       User user = User(
                    //           name: userNameController.text,
                    //           phone: widget.phone,
                    //           company: companyTextController.text,
                    //           address: companyAddressTextController.text,
                    //           vehicalLicence: vehicalLicenceTextController.text,
                    //           vehicalOwner: vehicalOwnerTextController.text,
                    //       );
                    //       // print(user.company);
                    //       _postCreateUser(user, pwdTextController.text, true);
                    //       // isLoading = true;
                    //       // setState(() {});
                    //     }
                    //   } else {
                    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("您尚未同意瀏覽車業者規範！"),));
                    //   }
                    // }
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
                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 640, maxHeight: 480);

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

  Future _postCreateUser(User user, String password, bool isOwner) async {
    String path = Service.PATH_CREATE_USER;

    try {
      Map queryParameters = {};
      if(!isOwner) {
        queryParameters['phone'] = user.phone;
        queryParameters['name'] = user.name;
        queryParameters['password'] = password;
        queryParameters['isOwner'] = 'false';
      }else{
        queryParameters['phone'] = user.phone;
        queryParameters['name'] = user.name;
        queryParameters['password'] = password;
        queryParameters['isOwner'] = 'true';
        queryParameters['company'] = user.company;
        queryParameters['address'] = user.address;
        queryParameters['vehicalLicence'] = user.vehicalLicence;
        queryParameters['vehicalOwner'] = user.vehicalOwner;
      }

      print(queryParameters);

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

      var userModel = context.read<UserModel>();
      userModel.setUser(theUser);

      if(isOwner && licenseImage != null){
        //get user token
        path = Service.PATH_USER_TOKEN;

        Map queryParameters = {
          'phone': user.phone,
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
        if(map['token']!=null) {
          String token = map['token'];
          userModel.token = token;
          //upload image
          _uploadLicenceImage(licenseImage, driverlicenseImage,token);
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("成功 create User, 要上傳 image"),));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("無法取得Token！"),));
        }
      }else{
        Navigator.popUntil(context, ModalRoute.withName('/login_register'));
      }

    } catch (e) {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () { },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("My title"),
        content: Text(e.toString()),
        actions: [
          okButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );

      print(e);
      return "error";
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

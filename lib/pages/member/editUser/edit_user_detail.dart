import 'dart:convert';
import 'dart:io';

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
import '../../../widgets/image_upload_button.dart';

class EditUserDetail extends StatefulWidget {

  const EditUserDetail({Key? key}) : super(key: key);

  @override
  _EditUserDetailState createState() => _EditUserDetailState();
}

enum UserIdentity { passenger, driver }

class _EditUserDetailState extends State<EditUserDetail> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController userPhoneTextController = TextEditingController();

  TextEditingController companyTextController = TextEditingController();
  TextEditingController companyAddressTextController = TextEditingController();
  TextEditingController vehicalLicenceTextController = TextEditingController();
  TextEditingController vehicalOwnerTextController = TextEditingController();
  // TextEditingController vehicalEngineNumberTextController = TextEditingController();
  // TextEditingController vehicalBodyNumberTextController = TextEditingController();

  XFile? driverlicenseImage;
  XFile? licenseImage;
  String? currentImageUrl;
  String? currentDriverImageUrl;

  UserIdentity? _userIdentity = UserIdentity.passenger;

  bool driverFormIsVisible = false;

  User? theUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    var userModel = context.read<UserModel>();
    theUser = userModel.user;

    userNameController.text = theUser!.name!;
    userPhoneTextController.text = theUser!.phone!;

    if(theUser!.isOwner!){
      _userIdentity = UserIdentity.driver;
      driverFormIsVisible = true;

      try{
        companyTextController.text = theUser!.company!;
        companyAddressTextController.text = theUser!.address!;
        vehicalLicenceTextController.text = theUser!.vehicalLicence!;
        vehicalOwnerTextController.text = theUser!.vehicalOwner!;
        // vehicalEngineNumberTextController.text = theUser!.vehicalEngineNumber!;
        // vehicalBodyNumberTextController.text = theUser!.vehicalBodyNumber!;

        currentImageUrl = theUser!.vehicalLicenceImage;
        currentDriverImageUrl = theUser!.driverLicenceImage;
      }catch(e){
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.read<UserModel>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('修改資料'),
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
                title: '修改',
                color: AppColor.yellow,
                onPressed: (){
                  // Navigator.popUntil(context, ModalRoute.withName('/login_register'));
                  if(_userIdentity == UserIdentity.passenger){
                    if(userNameController.text =='' || userPhoneTextController.text == ''){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("名稱或電話不可空白！"),));
                    }else{
                      User user = User(name: userNameController.text, phone: userPhoneTextController.text);
                      _putUpdateUser(user, userModel.token!, false);
                      isLoading = true;
                      setState(() {});
                    }
                  }else if(_userIdentity == UserIdentity.driver){
                    if(userNameController.text == '' || userPhoneTextController.text == '' || companyTextController.text == '' ||
                        companyAddressTextController.text == '' || vehicalLicenceTextController.text == '' || vehicalOwnerTextController.text == ''){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("業者各項資料不可空白！"),));
                    }else if(licenseImage == null && currentImageUrl == null){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("需上傳行照照片！"),));
                    }else if(licenseImage == null && currentImageUrl == null){
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
                      _putUpdateUser(user, userModel.token!, true);
                      isLoading = true;
                      setState(() {});
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
              Row(
                children: const [
                  Text('我已同意下列遊覽車業者規範：'),
                ],
              ),
              const Text('在此上架之遊覽車業者應符合國家遊覽車業者規定，且無不法情事，如有違反經查證屬實將強制下架該遊覽車業者。使用平台服務費為出車一天\$1000元。'),
              const SizedBox(height: 10,),
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
                      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 640);

                      if(pickedFile == null) return;

                      driverlicenseImage = pickedFile;
                      currentDriverImageUrl = null;
                      setState(() {});
                    },
                    child: Icon(Icons.photo_camera_outlined)),
                (driverlicenseImage == null && currentDriverImageUrl == null)? SizedBox() :
                (currentDriverImageUrl == null)?
                Container(
                  margin: const EdgeInsets.fromLTRB(10,10,0,8),
                  height: 60, width: 60,
                  child: Image.file(File(driverlicenseImage!.path),fit: BoxFit.cover,),
                ):
                Container(
                  margin: const EdgeInsets.fromLTRB(10,10,0,8),
                  height: 60, width: 60,
                  child: Image.network(currentDriverImageUrl!,fit: BoxFit.cover,),
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
                      currentImageUrl = null;
                      setState(() {});
                    },
                    child: Icon(Icons.photo_camera_outlined)),
                (licenseImage == null && currentImageUrl == null)? SizedBox() :
                (currentImageUrl == null)?
                Container(
                  margin: const EdgeInsets.fromLTRB(10,10,0,8),
                  height: 60, width: 60,
                  child: Image.file(File(licenseImage!.path),fit: BoxFit.cover,),
                ):
                Container(
                  margin: const EdgeInsets.fromLTRB(10,10,0,8),
                  height: 60, width: 60,
                  child: Image.network(currentImageUrl!,fit: BoxFit.cover,),
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

  Future _uploadLicenceImage(XFile? image, XFile? driverImage, String token)async{
    print("here to upload image");
    String path = Service.PATH_USER_DATA;
    var request = http.MultipartRequest('PUT', Service.standard(path: path));

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    request.headers.addAll(headers);

    if(image!=null) {
      final file = await http.MultipartFile.fromPath('vehicalLicenceImage', image.path);
      request.files.add(file);
    }

    if(driverImage!=null) {
      final driverFile = await http.MultipartFile.fromPath('driverLicenceImage', driverImage.path);
      request.files.add(driverFile);
    }

    request.fields['isOwner'] = 'true';

    // print(request.files.first.);

    var response = await request.send();
    // print(response.headers);
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      Map<String, dynamic> map = json.decode(utf8.decode(value.runes.toList()));
      if(map['name']!=null){
        User theUser = User.fromJson(map);

        var userModel = context.read<UserModel>();
        userModel.setUser(theUser);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("成功更新！"),));
        Navigator.pop(context);
      }else{
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("無法更新資料 請檢察網路！"),));
      }
    });
  }

  Future _putUpdateUser(User user, String token, bool isOwner) async {
    String path = Service.PATH_USER_DATA;

    // try {
      Map queryParameters = {};
      if(!isOwner) {
        queryParameters['phone'] = user.phone;
        queryParameters['name'] = user.name;
        queryParameters['isOwner'] = 'false';
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
      }

      // print(queryParameters);

      final response = await http.put(
          Service.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token $token',
          },
          body: jsonEncode(queryParameters)
      );

      // print(response.body);

      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      if(map['name']!=null){
        // print(map['vehicalLicenceImage']);

        if(isOwner && (licenseImage != null || driverlicenseImage != null)){
          _uploadLicenceImage(licenseImage, driverlicenseImage, token);
        }else{
          User theUser = User.fromJson(map);

          var userModel = context.read<UserModel>();
          userModel.setUser(theUser);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("成功更新！"),));
          Navigator.pop(context);
        }

      }else{
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("無法更新資料 請檢察網路！"),));
      }

    // } catch (e) {
    //   print(e);
    //   return "error";
    // }
  }

}

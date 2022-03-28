import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class RegisterIdentity extends StatefulWidget {
  const RegisterIdentity({Key? key}) : super(key: key);

  @override
  _RegisterIdentityState createState() => _RegisterIdentityState();
}

enum UserIdentity { passenger, driver }

class _RegisterIdentityState extends State<RegisterIdentity> {

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController pwdTextController = TextEditingController();

  UserIdentity? _userIdentity = UserIdentity.passenger;

  bool driverFormIsVisible = false;

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
                controller: phoneNumberController,
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const RegisterPhoneVerificationCode()),
                  // );
                },
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ));
  }

  chooseIdentity(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
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




}

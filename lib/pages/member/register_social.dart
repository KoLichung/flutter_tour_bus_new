import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'register_phone_verification_code.dart';


class RegisterSocial extends StatefulWidget {
  const RegisterSocial({Key? key}) : super(key: key);

  @override
  _RegisterSocialState createState() => _RegisterSocialState();
}

class _RegisterSocialState extends State<RegisterSocial> {

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController userNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('註冊'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 60,),
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
            CustomElevatedButton(
              title: '註冊',
              color: AppColor.yellow,
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPhoneVerificationCode()),
                );
              },
            ),
          ],
        ));
  }


}

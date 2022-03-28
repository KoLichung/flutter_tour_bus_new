
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'register_phone_verification_code.dart';


class RegisterPhone extends StatefulWidget {
  const RegisterPhone({Key? key}) : super(key: key);

  @override
  _RegisterPhoneState createState() => _RegisterPhoneState();
}

class _RegisterPhoneState extends State<RegisterPhone> {

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pwdTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('註冊'),
        ),
        body: Column(
          children: [
            SizedBox(height: 60,),
            CustomTextField(
              icon: Icons.phone_android_outlined,
              hintText: '電話號碼',
              controller: phoneNumberController,
            ),

            CustomElevatedButton(
              title: '取得驗證碼',
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

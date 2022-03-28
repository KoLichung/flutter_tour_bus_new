import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/pages/member/register_identity.dart';

class RegisterPhoneVerificationCode extends StatefulWidget {
  const RegisterPhoneVerificationCode({Key? key}) : super(key: key);

  @override
  _RegisterPhoneVerificationCodeState createState() => _RegisterPhoneVerificationCodeState();
}

class _RegisterPhoneVerificationCodeState extends State<RegisterPhoneVerificationCode> {

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pwdTextController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('註冊'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 60,),
            const Text('請輸入您的手機驗證碼'),
            RichText(
              text: TextSpan(
                text: '59 ',
                style: TextStyle(fontSize: 24,color: Colors.black, height: 2),
                children: const <TextSpan>[
                  TextSpan(text: '秒',style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              verificationCodeTextField(),
              verificationCodeTextField(),
              verificationCodeTextField(),
              verificationCodeTextField(),
            ],),
            const SizedBox(height: 30,),
            CustomElevatedButton(
              title: '輸入驗證碼',
              color: AppColor.yellow,
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterIdentity()),
                );
              },
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                alignment: Alignment.center,
                child: Text(
                  '未取得驗證碼，請再次發送',
                  style: TextStyle(color: Colors.yellow.shade700,decoration: TextDecoration.underline,),
                ),
              ),
            ),
          ],
        ));
  }

  verificationCodeTextField(){
    return Container(
      margin: const  EdgeInsets.symmetric(horizontal: 10),
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColor.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),),
      child: const TextField(
        style: TextStyle(fontSize: 30),
        // controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),

      ),
    );
  }


}

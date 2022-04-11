import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/pages/member/register/register_identity.dart';

class RegisterPhoneVerificationCode extends StatefulWidget {

  final String phone;
  final String code;

  const RegisterPhoneVerificationCode({Key? key, required this.phone, required this.code}) : super(key: key);

  @override
  _RegisterPhoneVerificationCodeState createState() => _RegisterPhoneVerificationCodeState();
}

class _RegisterPhoneVerificationCodeState extends State<RegisterPhoneVerificationCode> {

  TextEditingController pwdTextControllerOne = TextEditingController();
  TextEditingController pwdTextControllerTwo = TextEditingController();
  TextEditingController pwdTextControllerThree = TextEditingController();
  TextEditingController pwdTextControllerFour = TextEditingController();

  FocusNode textFocusNodeOne = FocusNode();
  FocusNode textFocusNodeTwo = FocusNode();
  FocusNode textFocusNodeThree = FocusNode();
  FocusNode textFocusNodeFour = FocusNode();

  int runDownSecond = 60;

  String theCode = '';

  @override
  void initState() {
    super.initState();
    theCode = widget.code;
  }

  @override
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
                text: runDownSecond.toString(),
                style: const TextStyle(fontSize: 24,color: Colors.black, height: 2),
                children: const <TextSpan>[
                  TextSpan(text: ' 秒',style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              verificationCodeTextField(pwdTextControllerOne, 1, textFocusNodeOne),
              verificationCodeTextField(pwdTextControllerTwo, 2, textFocusNodeTwo),
              verificationCodeTextField(pwdTextControllerThree, 3, textFocusNodeThree),
              verificationCodeTextField(pwdTextControllerFour, 4, textFocusNodeFour),
            ],),
            const SizedBox(height: 30,),
            CustomElevatedButton(
              title: '驗證',
              color: AppColor.yellow,
              onPressed: (){
                // print(pwdTextControllerOne.text + pwdTextControllerTwo.text + pwdTextControllerThree.text + pwdTextControllerFour.text);

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => RegisterIdentity(phone: widget.phone)),
                // );


                String verifyCode = pwdTextControllerOne.text + pwdTextControllerTwo.text + pwdTextControllerThree.text + pwdTextControllerFour.text;
                if(verifyCode == theCode){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterIdentity(phone: widget.phone)),
                  );
                }else{
                  ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('驗證碼錯誤！')));
                }

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

  verificationCodeTextField(TextEditingController controller, int index, FocusNode focusNode){
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
      child:  TextField(
        style: const TextStyle(fontSize: 30),
        controller: controller,
        keyboardType: TextInputType.number,
        focusNode: focusNode,
        onChanged: (text){
          if(text!=''){
            if(index == 1){
              FocusScope.of(context).requestFocus(textFocusNodeTwo);
            }else if(index == 2){
              FocusScope.of(context).requestFocus(textFocusNodeThree);
            }else if(index == 3){
              FocusScope.of(context).requestFocus(textFocusNodeFour);
            }
          }else{
            if(index == 2){
              FocusScope.of(context).requestFocus(textFocusNodeOne);
            }else if(index == 3){
              FocusScope.of(context).requestFocus(textFocusNodeTwo);
            }else if(index == 4){
              FocusScope.of(context).requestFocus(textFocusNodeThree);
            }
          }
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),

      ),
    );
  }


}
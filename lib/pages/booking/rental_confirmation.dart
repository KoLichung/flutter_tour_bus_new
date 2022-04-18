import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/pages/member/login_register.dart';
import 'home_page.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/main.dart';

class RentalConfirmation extends StatefulWidget {
  const RentalConfirmation({Key? key}) : super(key: key);

  @override
  _RentalConfirmationState createState() => _RentalConfirmationState();
}

class _RentalConfirmationState extends State<RentalConfirmation> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('包遊覽車'),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:AssetImage('images/order_complete.png',),
                      fit:BoxFit.fill),),
                height: 420,
              ),
              const Text(
                  '恭喜您，下訂完成！'
                  '\n請等待業主決定是否接單，\n我們會用簡訊通知您。'
              '\n您也可以隨時回來查看訂單狀況'
              '\n( 會員中心 / 我的訂單 )'
              '\n感謝您~', textAlign: TextAlign.center,),
              const SizedBox(height: 40,),
              CustomElevatedButton(
                color: AppColor.yellow,
                title: '回到首頁',
                onPressed: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyHomePage()), (Route<dynamic> route) => false, );
                },)

            ],
          ),
        )
    );
  }
}

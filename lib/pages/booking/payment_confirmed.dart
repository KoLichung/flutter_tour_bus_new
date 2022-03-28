import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';

class PaymentConfirmed extends StatefulWidget {
  const PaymentConfirmed({Key? key}) : super(key: key);

  @override
  _PaymentConfirmedState createState() => _PaymentConfirmedState();
}

class _PaymentConfirmedState extends State<PaymentConfirmed> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('付款完成'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:AssetImage('images/payment_complete.png',),
                      fit:BoxFit.fill),),
                height: 420,
              ),
              Text('付款完成！',style: Theme.of(context).textTheme.subtitle2,),
              const Text(
                    '\n業主是：\n長興旅行社'
                    '\n0912345678'
                    '\n台中市南區xxxxxxxxxx'
                    '\n業主會儘速聯絡您喔~ '
                    '\n感謝您~', textAlign: TextAlign.center,),
              const SizedBox(height: 40,),
              CustomElevatedButton(
                color: AppColor.yellow,
                title: '回到我的訂單',
                onPressed: (){
                  Navigator.pushNamed(context, '/order_list');

                },)

            ],
          ),
        )
    );
  }
}

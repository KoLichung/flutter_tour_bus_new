import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/pages/member/login_register.dart';
import 'search_list.dart';

import '../../widgets/custom_elevated_button.dart';

class RentalAgreement extends StatefulWidget {
  const RentalAgreement({Key? key}) : super(key: key);

  @override
  _RentalAgreementState createState() => _RentalAgreementState();
}

class _RentalAgreementState extends State<RentalAgreement> {

  List<FakeTourBus> fakeResult = [
    FakeTourBus(title: '10人坐遊覽車', agentName: '長興旅行社',location: '台北',busYear: '2018',seat: '10'),
    FakeTourBus(title: '20人坐遊覽車', agentName: '長興旅行社',location: '台中',busYear: '2018',seat: '20'),
    FakeTourBus(title: '30人坐遊覽車', agentName: '長興旅行社',location: '台南',busYear: '2018',seat: '30'),
  ];

  bool agreementIsChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('包遊覽車'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(40,40,40,10),
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                height: 500,
                width: 360,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.grey
                  ),
                ),
                child: Text('合約書'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Row(children: [
                  Checkbox(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                      ),
                      value: agreementIsChecked,
                      onChanged: (bool? value){
                        setState(() {
                          agreementIsChecked = value!;
                        });
                      }),
                  const Text('同意此租賃合約書')
                ],),
              ),
              const Divider(
                color: AppColor.superLightGrey,
                thickness: 8,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                child: Column(
                  children: [
                    Align(alignment: Alignment.centerLeft,child: Text('租車內容：',style: Theme.of(context).textTheme.bodyText1,)),
                    Row(children: [
                      Align(alignment: Alignment.centerLeft,child: Text(fakeResult[1].title,style: Theme.of(context).textTheme.bodyText1,)),
                      Align(alignment: Alignment.centerLeft,child: Text('  ${fakeResult[1].agentName}',style: const TextStyle(color: Colors.grey),)),
                    ],),
                    Row(children: [
                      Text('年份：${fakeResult[1].busYear}'),
                      const SizedBox(width: 20,),
                      Text('座位：${fakeResult[1].seat} 人'),
                    ],),
                    Align(alignment: Alignment.centerLeft,child: Text('租期：3月1日(週二) - 3月2日(週三)')),
                    Row(children: [
                      const Align(alignment: Alignment.centerLeft,child: Text('App優惠價 '),),
                      Align(alignment: Alignment.centerLeft,child: Text(' \$7654',style: Theme.of(context).textTheme.subtitle2,),),
                    ],),

                  ],
                ),
              ),
              const Divider(
                color: AppColor.superLightGrey,
                thickness: 8,
              ),
              CustomElevatedButton(
                color: AppColor.yellow,
                title: '確認，下訂單',
                onPressed: (){
                  Navigator.pushNamed(context, '/rental_confirmation');
                },),
              const SizedBox(height: 20,)
            ],
          ),
        )
    );
  }
}

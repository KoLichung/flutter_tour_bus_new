import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:provider/provider.dart';
import '../../models/bus.dart';

import '../../models/order.dart';
import '../../notifier_model/user_model.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;

class RentalAgreement extends StatefulWidget {

  final Bus theBus;
  final String fromCity;
  final String toCity;
  final DateTime startDate;
  final DateTime endDate;

  const RentalAgreement({Key? key, required this.theBus, required this.fromCity, required this.toCity, required this.startDate, required this.endDate}) : super(key: key);

  @override
  _RentalAgreementState createState() => _RentalAgreementState();
}

class _RentalAgreementState extends State<RentalAgreement> {

  // List<FakeTourBus> fakeResult = [
  //   FakeTourBus(title: '10人坐遊覽車', agentName: '長興旅行社',location: '台北',busYear: '2018',seat: '10'),
  //   FakeTourBus(title: '20人坐遊覽車', agentName: '長興旅行社',location: '台中',busYear: '2018',seat: '20'),
  //   FakeTourBus(title: '30人坐遊覽車', agentName: '長興旅行社',location: '台南',busYear: '2018',seat: '30'),
  // ];

  bool isAgreementChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('包遊覽車'),
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
                      value: isAgreementChecked,
                      onChanged: (bool? value){
                        setState(() {
                          isAgreementChecked = value!;
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
                      Align(alignment: Alignment.centerLeft,child: Text(widget.theBus.title!,style: Theme.of(context).textTheme.bodyText1,)),
                      // Align(alignment: Alignment.centerLeft,child: Text('  ${fakeResult[1].agentName}',style: const TextStyle(color: Colors.grey),)),
                    ],),
                    Row(children: [
                      Text('年份：${widget.theBus.vehicalYearOfManufacture!}'),
                      const SizedBox(width: 20,),
                      Text('座位：${widget.theBus.vehicalSeats} 人'),
                    ],),
                    Align(alignment: Alignment.centerLeft,child: Text('${DateFormat('MM / dd EEE').format(widget.startDate)} - ${DateFormat('MM / dd EEE').format(widget.endDate)}')),
                    Row(children: [
                      const Align(alignment: Alignment.centerLeft,child: Text('App優惠價 '),),
                      Align(alignment: Alignment.centerLeft,child: Text('\$${_getDaysInterval()*11000}',style: Theme.of(context).textTheme.subtitle2,),),
                      Align(alignment: Alignment.centerLeft,child: Text(' (訂金 ${_getDaysInterval()*2500})'),),
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
                  if(isAgreementChecked) {
                    var userModel = context.read<UserModel>();

                    Order theOrder = Order();
                    theOrder.tourBus = widget.theBus.id;
                    theOrder.startDate = DateFormat('yyyy-MM-dd').format(widget.startDate);
                    theOrder.endDate = DateFormat('yyyy-MM-dd').format(widget.endDate);
                    theOrder.depatureCity = widget.fromCity;
                    theOrder.destinationCity = widget.toCity;
                    theOrder.orderMoney = _getDaysInterval()*11000;
                    theOrder.depositMoney = _getDaysInterval()*2500;
                    _httpPostCreateOrder(theOrder, userModel.token!);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請先勾選同意租賃合約書！"),));
                  }
                },),
              const SizedBox(height: 20,)
            ],
          ),
        )
    );
  }

  int _getDaysInterval(){
    return -widget.startDate.difference(widget.endDate).inDays;
  }

  Future _httpPostCreateOrder(Order theOrder, String token) async {

    String path = Service.ORDERS;

    try {
      Map queryParameters = {
        'tourBus': theOrder.tourBus,
        'startDate': theOrder.startDate!+"T00:00:00Z",
        'endDate': theOrder.endDate!+"T00:00:00Z",
        'depatureCity': theOrder.depatureCity!,
        'destinationCity': theOrder.destinationCity!,
        'orderMoney': theOrder.orderMoney,
        'depositMoney': theOrder.depositMoney,
      };

      print(queryParameters);

      final response = await http.post(Service.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'token $token'
          },
          body: jsonEncode(queryParameters)
      );
      print(response.body);
      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      if(map['id']!=null){
        Navigator.pushNamed(context, '/rental_confirmation');
      }
    } catch(e){
      print(e);
    }
  }

}

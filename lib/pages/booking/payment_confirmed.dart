import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentConfirmed extends StatefulWidget {
  final int orderId;

  const PaymentConfirmed({Key? key, required this.orderId}) : super(key: key);

  @override
  _PaymentConfirmedState createState() => _PaymentConfirmedState();
}

class _PaymentConfirmedState extends State<PaymentConfirmed> {

  OwnerInfo? _ownerInfo;

  @override
  void initState() {
    super.initState();
    print("orderId: ${widget.orderId}");
    _ownerInfo = OwnerInfo(user: 0,phone: "", company: "", address: "", name: "");
    _getOrderUserInfo(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('付款完成'),
          automaticallyImplyLeading: false,
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
              Text(
                    '\n業者是：\n${_ownerInfo!.company!}'
                    '\n${_ownerInfo!.address!}\n聯絡人：${_ownerInfo!.name!} \n電話：${_ownerInfo!.phone!}'
                    '\n業者會儘速聯絡喔~ '
                    '\n感謝您~', textAlign: TextAlign.center,),
              const SizedBox(height: 40,),
              CustomElevatedButton(
                color: AppColor.yellow,
                title: '回到我的訂單',
                onPressed: (){
                  Navigator.pop(context, "ok");
                })
            ],
          ),
        )
    );
  }

  Future _getOrderUserInfo(int orderId) async {
    String path = Service.GET_ORDER_USER_INFO;
    try {
      final queryParams = {
        "order_id": orderId.toString(),
      };

      final response = await http.get(
        Service.standard(path: path, queryParameters: queryParams),
      );

      print(response.body);

      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      _ownerInfo = OwnerInfo.fromJson(map);
      setState(() {});
    } catch (e) {
      print(e);

      // return null;
      // return User(phone: '0000000000', name: 'test test', isGottenLineId: false, token: '4b36f687579602c485093c868b6f2d8f24be74e2',isOwner: false);

    }
    return null;
  }
}


class OwnerInfo {
  int? user;
  String? phone;
  String? company;
  String? address;
  String? name;

  OwnerInfo({this.user, this.phone, this.company, this.address, this.name});

  OwnerInfo.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    phone = json['phone'];
    name = json['name'];
    if(json['company']==null){
      company = '';
    }else{
      company = json['company'];
    }

    if(json['address']==null){
      address = '';
    }else{
      address = json['address'];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['phone'] = this.phone;
    data['company'] = this.company;
    data['address'] = this.address;
    data['name'] = this.name;
    return data;
  }
}
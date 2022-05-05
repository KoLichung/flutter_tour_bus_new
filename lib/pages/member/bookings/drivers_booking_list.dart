import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/pages/member/bookings/drivers_booking_detail.dart';
import 'package:flutter_tour_bus_new/widgets/custom_outlined_text.dart';
import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../notifier_model/user_model.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


class DriversBookingList extends StatefulWidget {
  const DriversBookingList({Key? key}) : super(key: key);

  @override
  State<DriversBookingList> createState() => _DriversBookingListState();
}

class _DriversBookingListState extends State<DriversBookingList> {

  List<Order> ownerOrderList = [];

  @override
  void initState() {
    super.initState();
    _httpGetOwnerOrderList();
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.read<UserModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('業者訂單列表'),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: GestureDetector(
        //       onTap: () {},
        //       child:
        //       const Text('狀態說明', style: TextStyle(fontSize: 15),),),)],
      ),
      body: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: ownerOrderList.length,
              itemBuilder:(BuildContext context,int i){
                return  Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                      trailing: _getOrderStatusButton(userModel.token!, ownerOrderList[i], context),
                      // title: Text(ownerOrderList[i].d),
                      title:
                      Text('${ownerOrderList[i].name} ${ownerOrderList[i].phone} \n名稱：${ownerOrderList[i].busTitle} \n'
                          '租車日期： ${DateFormat("yyyy-MM-dd").format(DateTime.parse(ownerOrderList[i].startDate!))}~${DateFormat("yyyy-MM-dd").format(DateTime.parse(ownerOrderList[i].endDate!))} \n'
                          '出發地：${ownerOrderList[i].depatureCity} 目的地：${ownerOrderList[i].destinationCity}'
                        ,style: Theme.of(context).textTheme.bodyText2,),
                    onTap: () async {
                      final result = await Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => DriversBookingDetail(theOrder: ownerOrderList[i]),
                        )
                      );
                      if(result=="ok"){
                        _httpGetOwnerOrderList();
                      }
                        // Navigator.pushNamed(context, '/drivers_booking_detail');
                    },
                    ),
                    const Divider(color: AppColor.lightGrey,)],);
              }),
      );
  }

  Widget _getOrderStatusButton(String userToken, Order order, BuildContext context){
    PassengerOrderStatus orderStatus = PassengerOrderStatus(userToken,order.id);
    if(order.state=="waitOwnerCheck"){
      return orderStatus.pending(context, (){
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              title: Container(
                  padding: const EdgeInsets.all(10),
                  color: AppColor.yellow,
                  child: const Text('是否接單?',style: TextStyle(color: Colors.white, fontSize: 18),)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      _httpPostUpdateOrderState(userToken, order.id!, "waitForDeposit");
                      Navigator.pop(context,"confirm");
                    },
                    child:const CustomOutlinedText(
                        title: '接單',
                        color: AppColor.grey),
                  ),
                  GestureDetector(
                    onTap: (){
                      _httpPostUpdateOrderState(userToken, order.id!, "ownerCanceled");
                      Navigator.pop(context,"confirm");
                    },
                    child: const CustomOutlinedText(
                        title: '不接單',
                        color: AppColor.grey),
                  )
                ],
              ),
            )
        );
      });
    }else if(order.state=="ownerCanceled"){
      return orderStatus.decline();
    }else if(order.state=="waitForDeposit"){
      return orderStatus.waitingForPayment(context);
    }else if(order.state=="ownerWillContact"){
      return orderStatus.confirmed(context, (){
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              title: Container(
                  padding: const EdgeInsets.all(10),
                  color: AppColor.yellow,
                  child: const Text('是否已完成?',style: TextStyle(color: Colors.white, fontSize: 18),)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      _httpPostUpdateOrderState(userToken, order.id!, "closed");
                      Navigator.pop(context,"confirm");
                    },
                    child:const CustomOutlinedText(
                        title: '完成出車',
                        color: AppColor.grey),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context,"confirm");
                    },
                    child: const CustomOutlinedText(
                        title: '尚未出車',
                        color: AppColor.grey),
                  )
                ],
              ),
            )
        );
      });
    }else if(order.state=="closed"){
      return orderStatus.complete();
    }

    return orderStatus.decline();
  }

  Future _httpGetOwnerOrderList() async {
    var userModel = context.read<UserModel>();
    String path = Service.OWNER_BUS_ORDERS;
    try {
      final response = await http.get(Service.standard(path: path),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'token ${userModel.token!}'},
      );

      if (response.statusCode == 200) {
        // print(response.body);
        List<dynamic> parsedListJson = json.decode(utf8.decode(response.body.runes.toList()));
        List<Order> data = List<Order>.from(parsedListJson.map((i) => Order.fromJson(i)));
        // print(data[0].title);
        // print(data[1].city);
        ownerOrderList = data;
        // print(orderList);

        setState(() {});

      }
    } catch (e) {
      print(e);
    }
  }

  Future _httpPostUpdateOrderState(String userToken, int orderId, String state) async {

    String path = Service.OWNER_UPDATE_STATE;
    try {
      final bodyParams = {
        "state": state,
        "order_id": orderId.toString(),
      };

      final response = await http.post(Service.standard(path: path),
        headers: <String, String>{
          'Authorization': 'token $userToken'
        },
        body: bodyParams,
      );

      if (response.statusCode == 200) {
        print("success update order state");
        _httpGetOwnerOrderList();
      }
    } catch (e) {
      print(e);
    }
  }

}


class PassengerOrderStatus {

  String? userToken;
  int? orderId;

  PassengerOrderStatus(this.userToken,this.orderId);

  pending(context, onTap){
    return GestureDetector(
      onTap: onTap,
      child: const CustomOutlinedText(
        color: AppColor.pending,
        title: '是否接訂',
      ),
    );
  }

  decline(){
    return const CustomOutlinedText(
        title: '不接訂',
        color: AppColor.decline);
  }

  waitingForPayment(context){
    return const CustomOutlinedText(
        title: '接訂\n等待付款',
        color: AppColor.waiting);
  }

  confirmed(context, onTap){
    return GestureDetector(
      onTap: onTap,
      child: const CustomOutlinedText(
        color: AppColor.waiting,
        title: '已付款請出車\n按我結單',
      ),
    );
  }

  // onGoing(){
  //   return const CustomOutlinedText(
  //       title: '租借中',
  //       color: AppColor.onGoing);
  // }

  complete(){
    return const CustomOutlinedText(
        title: '已結單',
        color: AppColor.yellow);
  }

}

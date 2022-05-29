import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/pages/booking/payment_confirmed.dart';
import 'package:flutter_tour_bus_new/pages/member/atm_info_dialog.dart';
import 'package:flutter_tour_bus_new/widgets/custom_outlined_text.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tour_bus_new/models/order.dart';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PassengerOrderList extends StatefulWidget {
  const PassengerOrderList({Key? key}) : super(key: key);

  @override
  State<PassengerOrderList> createState() => _PassengerOrderListState();
}

class _PassengerOrderListState extends State<PassengerOrderList> {

  List<Order> orderList =[];
  // PassengerOrderStatus orderStatus = PassengerOrderStatus();

  static const EventChannel paymentCallBackChannel = EventChannel('samples.flutter.io/pay_ec_pay_call_back');

  @override
  void initState() {
    // TODO: implement initState
    _fetchOrderList();
    super.initState();
    paymentCallBackChannel.receiveBroadcastStream().listen(_onPaymentState, onError: _onPaymentError);
  }

  Future<void> _onPaymentState(Object? event) async {
    print(event.toString());

    if(event.toString().contains("{") && event.toString().contains("}")){
      Map<String, dynamic> map = json.decode(event.toString());
      // print(map["bankCode"]);
      // print(map["vAccount"]);
      // print(map["expireDate"]);
      // print(map["orderId"]);
      String dateString = "";
      if(map["expireDate"].toString().contains("Optional")){
        dateString = map["expireDate"].toString().replaceAll("Optional", "").replaceAll("(", "").replaceAll(")", "");
        map["date"] = DateTime.parse(dateString);
      }else{
        dateString = map["expireDate"];
        map["date"] = DateFormat('yyyy/MM/dd').parse(dateString);
      }
      // print(dateString);
      // print(DateTime.parse(dateString));

      print(map);
      var userModel = context.read<UserModel>();
      _httpPutUpdateOrderATMInfo(userModel.token!, map);
    }

    if(event.toString().contains("orderId=")){
      int orderId = int.parse(event.toString().replaceAll("orderId=", ""));
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  PaymentConfirmed(orderId: orderId),
          ));
      if(result == "ok"){
        _fetchOrderList();
      }
    }else if(event.toString() == 'fail'){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('交易失敗!')));
    }
  }

  void _onPaymentError(Object error) {
    print("payment state listen error");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的訂單'),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: GestureDetector(
        //       onTap: () {},
        //       child:
        //       const Text('狀態說明', style: TextStyle(fontSize: 15),),),)],
      ),
      body:
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: orderList.length,
              itemBuilder:(BuildContext context,int i){

                String startDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(orderList[i].startDate!));
                String endDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(orderList[i].endDate!));

                return  Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                      trailing: _getOrderStatusButton(orderList[i],context),
                      // trailing: Text(orderList[i].state), //要判斷state內容顯示不同的(外框文字)狀態
                      title: Text('名稱：${orderList[i].busTitle!}'),
                      subtitle: Text('訂金：${orderList[i].depositMoney!}  \n租車日期： $startDate~$endDate'),
                    ),
                    const Divider(color: AppColor.lightGrey,)],);
              },
      ),
    );
  }

  Widget _getOrderStatusButton(Order order, BuildContext context){
    PassengerOrderStatus orderStatus = PassengerOrderStatus(order);
    if(order.state=="waitOwnerCheck"){
      return orderStatus.pending();
    }else if(order.state=="ownerCanceled"){
      return orderStatus.decline();
    }else if(order.state=="waitForDeposit"){
      return orderStatus.waitingForPayment(context);
    }else if(order.state=="waitForAtmDeposit"){
      DateTime expireDate = DateTime.parse(order.aTMInfoExpireDate!);
      if (expireDate.isAfter(DateTime.now())){
        return orderStatus.waitingForATM(context);
      }else{
        return orderStatus.atmExpired(context);
      }
    }else if(order.state=="ownerWillContact"){
      return orderStatus.confirmed(context);
    }else if(order.state=="closed"){
      return orderStatus.complete();
    }

    return orderStatus.pending();
  }

  Future _fetchOrderList() async {
    var userModel = context.read<UserModel>();
    String path = Service.ORDERS;
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
        orderList = data;
        // print(orderList);

        setState(() {});

      }
    } catch (e) {
      print(e);
    }
  }

  Future _httpPutUpdateOrderATMInfo(String token, Map map) async {

    String path = Service.ORDERS + map["orderId"].toString() + "/";

    try {
      final bodyParams = {
        "isAtm": true,
        "ATMInfoBankCode": map["bankCode"],
        "ATMInfovAccount": map["vAccount"],
        "ATMInfoExpireDate": map["date"].toString(),
        "tourBus": map["tourBus"].toString(),
        "state": "waitForAtmDeposit",
      };

      final response = await http.put(Service.standard(path: path),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'token $token'
        },
        body: jsonEncode(bodyParams),
      );

      print(response.body);
      if (response.statusCode == 200) {
        print("success update order atm info");
        _fetchOrderList();
      }
    } catch (e) {
      print(e);
    }
  }

}

class PassengerOrderStatus {

  static const MethodChannel methodGetTestTokenChannel = MethodChannel('samples.flutter.io/get_test_token');
  static const MethodChannel methodPayChannel = MethodChannel('samples.flutter.io/pay_ec_pay');

  String token = "";
  Order? order;
  bool isLoadingToken = false;

  PassengerOrderStatus(this.order);

  Future<void> _getTestToken() async {
    String message;
    try {
      final result = await methodGetTestTokenChannel.invokeMethod('getTestToken',  <String, dynamic>{
      "name": "test user",
      "order_id": "0012345",
      });
      message = 'return message: $result';
      token = result;
    } on PlatformException {
      message = 'Failed to get test token.';
    }
    print(message);
    if(token != ""){
      // _payECPay(token);
    }
  }

  Future<void> _payECPay(String token, int orderId, int tourBus) async {
    String message;
    try {
      final result = await methodPayChannel.invokeMethod('payECPay',  <String, dynamic>{
        "token": token,
        "orderId": orderId.toString(),
        "tourBus": tourBus.toString(),
      });
      message = 'return message: $result';
    } on PlatformException {
      message = 'Failed to get test token.';
    }
    print(message);
  }

  pending(){
    return const CustomOutlinedText(
      color: AppColor.grey,
      title: '等待業者\n確認訂單');
  }

  decline(){
    return const CustomOutlinedText(
        color: AppColor.decline,
        title: '業者\n無法接單');
  }

  waitingForPayment(context){
    return GestureDetector(
      onTap: (){
        if(!isLoadingToken){
          isLoadingToken = true;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("取得付款資訊中~"),));
          _fetchPaymentToken(context, order!);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請等待付款資訊回應~"),));
        }


        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) =>  PaymentConfirmed(orderId: order!.id!),
        //     ));

      },
      child: const CustomOutlinedText(
        color: AppColor.pending,
        title: '點我付訂'),
    );
  }

  waitingForATM(context){
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AtmInfoDialog(theOrder: order!);
          });
      },
      child: const CustomOutlinedText(
          color: AppColor.pending,
          title: '等待\nATM轉帳'),
    );
  }

  atmExpired(context){
    return GestureDetector(
      onTap: (){

      },
      child: const CustomOutlinedText(
          color: AppColor.decline,
          title: 'ATM過期'),
    );
  }

  confirmed(context){
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  PaymentConfirmed(orderId: order!.id!),
            ));
      },
      child: const CustomOutlinedText(
          color: AppColor.waiting,
          title: '收訂，業者\n會接洽您'),
    );
  }

  onGoing(){
    return const CustomOutlinedText(
        color: AppColor.waiting,
        title: '出遊中');
  }

  complete(){
    return const CustomOutlinedText(
        color: AppColor.yellow,
        title: '已結案');
  }

  Future _fetchPaymentToken(BuildContext context,Order order) async {

    String path = Service.PATH_GET_PAYMENT_TOKEN;
    try {

      final queryParameters = {
        "order_id" : order.id.toString(),
      };

      final response = await http.get(Service.standard(path: path, queryParameters: queryParameters));
      isLoadingToken = false;

      if (response.statusCode == 200) {
        // print(response.body);
        Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
        // print(map);
        if(map['Token']!=null){
          print('token ${map['Token']}');
          _payECPay(map['Token'], order.id!, order.tourBus!);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('無法正確取得付款資訊!')));
        }
        // setState(() {});

      }
    } catch (e) {
      print(e);
    }
  }
}

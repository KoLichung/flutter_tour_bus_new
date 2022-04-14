import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tour_bus_new/color.dart';
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

  PassengerOrderStatus orderStatus = PassengerOrderStatus();

  static const EventChannel paymentCallBackChannel = EventChannel('samples.flutter.io/pay_ec_pay_call_back');

  @override
  void initState() {
    // TODO: implement initState
    _fetchOrderList();
    super.initState();
    paymentCallBackChannel.receiveBroadcastStream().listen(_onPaymentState, onError: _onPaymentError);
  }

  void _onPaymentState(Object? event) {
    print(event.toString());
    if(event.toString() == 'success'){
      Navigator.pushNamed(context, '/payment_confirmed');
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {},
              child:
              const Text('狀態說明', style: TextStyle(fontSize: 15),),),)],),
      body: Column(
        children: [
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: orderList.length,
              itemBuilder:(BuildContext context,int i){

                String startDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(orderList[i].startDate));
                String endDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(orderList[i].endDate));

                return  Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                      trailing: orderStatus.waitingForPayment(context),
                      // trailing: Text(orderList[i].state), //要判斷state內容顯示不同的(外框文字)狀態
                      title: Text('名稱：遊覽車名稱待改'),
                      subtitle: Text('旅行社名稱待改 價格待改  \n租車日期： $startDate~$endDate'),
                    ),
                    const Divider(color: AppColor.lightGrey,)],);
              }),],
      ),
    );
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
}

class FakeOrderHistory{
  String busType;
  String startDate;
  String endDate;
  String agentName;
  String price;

  FakeOrderHistory({
    required this.busType,
    required this.startDate,
    required this.endDate,
    required this.agentName,
    required this.price,
  });

}

class PassengerOrderStatus {

  static const MethodChannel methodGetTestTokenChannel = MethodChannel('samples.flutter.io/get_test_token');
  static const MethodChannel methodPayChannel = MethodChannel('samples.flutter.io/pay_ec_pay');

  String token = "";

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

  Future<void> _payECPay(String token) async {
    String message;
    try {
      final result = await methodPayChannel.invokeMethod('payECPay',  <String, dynamic>{
        "token": token,
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
      title: '等待業者確認訂單');
  }

  decline(){
    return const CustomOutlinedText(
        color: AppColor.decline,
        title: '業者無法接單');
  }

  waitingForPayment(context){
    return GestureDetector(
      onTap: (){
        _fetchPaymentToken(context,1);
        // _getTestToken();

        // _payECPay();
      },
      child: const CustomOutlinedText(
        color: AppColor.pending,
        title: '點我付訂'),
    );
  }

  confirmed(){
    return const CustomOutlinedText(
        color: AppColor.waiting,
        title: '收訂，業者會接洽您');

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

  Future _fetchPaymentToken(BuildContext context,int orderId) async {

    String path = Service.PATH_GET_PAYMENT_TOKEN;
    try {

      final queryParameters = {
        "order_id" : orderId.toString(),
      };

      final response = await http.get(Service.standard(path: path, queryParameters: queryParameters));

      if (response.statusCode == 200) {
        // print(response.body);
        Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
        // print(map);
        if(map['Token']!=null){
          print('token ${map['Token']}');
          _payECPay(map['Token']);
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

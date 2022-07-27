import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../color.dart';
import '../../models/order.dart';
import '../../notifier_model/user_model.dart';

class AtmInfoDialog extends StatefulWidget {

  final Order theOrder;
  const AtmInfoDialog({Key? key, required this.theOrder});

  @override
  _AtmInfoDialogState createState() => _AtmInfoDialogState();
}

class _AtmInfoDialogState extends State<AtmInfoDialog> {

  TextEditingController fiveDigitController = TextEditingController();
  DateTime? date;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = DateTime.parse(widget.theOrder.aTMInfoExpireDate!);
    _fetchOrder(widget.theOrder);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        width: 300,
        padding: const EdgeInsets.all(10),
        color: AppColor.yellow,
        child: const Text(
          'ATM 繳款訊息',
          style: TextStyle(color: Colors.white),
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('您的 ATM 繳款訊息如下：'),
            const SizedBox(height: 10),
            Text('繳款銀行代碼:\n${widget.theOrder.aTMInfoBankCode!}'),
            const SizedBox(height: 5),
            Text('繳款帳號:\n${widget.theOrder.aTMInfovAccount!}'),
            const SizedBox(height: 5),
            Text('截止日期:\n${DateFormat('yyyy/MM/dd h:mm a').format(date!)}'),
            const SizedBox(height: 10),
            const Text('回填後 5 碼:'),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 30, 10),
              height: 55,
              child: TextField(
                controller: fiveDigitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.yellow, width: 0.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:  BorderSide(color: AppColor.yellow, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:  BorderSide(color: AppColor.yellow, width: 1.5),
                  ),
                ),
              ),
            ),
            const Text('p.s 繳款完，請回填後5碼，才能為您對帳喔！'),
          ],
        ),
      ),
      backgroundColor: AppColor.yellow,
      actions: <Widget>[
        OutlinedButton(
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            child: const Text('返回', style: TextStyle(color: Colors.white))
        ),
        OutlinedButton(
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
            onPressed: () {
              setState(() {
                if(fiveDigitController.text.length==5){
                  //update to server
                  var userModel = context.read<UserModel>();
                  _httpPutUpdateOrderATMFiveDigit(userModel.token!,widget.theOrder, fiveDigitController.text);
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("後五碼長度不符合~"),));
                }
              });
            },
            child: const Text('確認儲存', style: TextStyle(color: Colors.white))
        ),
      ],
    );
  }

  Future _fetchOrder(Order order) async {
    var userModel = context.read<UserModel>();
    String path = Service.ORDERS+order.id.toString();
    try {
      final response = await http.get(Service.standard(path: path),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'token ${userModel.token!}'},
      );

      if (response.statusCode == 200) {
        // print(response.body);
        Map<String, dynamic> parsedListJson = json.decode(utf8.decode(response.body.runes.toList()));
        Order order = Order.fromJson(parsedListJson);
        // print(orderList);

        setState(() {
          fiveDigitController.text = order.aTMFiveDigit!;
        });

      }
    } catch (e) {
      print(e);
    }
  }

  Future _httpPutUpdateOrderATMFiveDigit(String token, Order order, String fiveDigit) async {

    String path = Service.ORDERS + order.id.toString() + "/";

    try {
      final bodyParams = {
        "tourBus": order.tourBus.toString(),
        "ATMFiveDigit": fiveDigit,
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
        Navigator.pop(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("無法儲存後五碼~"),));
      }
    } catch (e) {
      print(e);
    }
  }

}
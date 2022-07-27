import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../../color.dart';
import '../../../notifier_model/user_model.dart';

class ConfirmDeleteDialog extends StatefulWidget {

  const ConfirmDeleteDialog({Key? key});

  @override
  _ConfirmDeleteDialogState createState() => _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<ConfirmDeleteDialog> {

  TextEditingController fiveDigitController = TextEditingController();
  DateTime? date;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          '刪除用戶資料',
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
            const Text('注意：刪除用戶資料後，不可恢復！'),
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
            child: const Text('取消', style: TextStyle(color: Colors.white))
        ),
        OutlinedButton(
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
            onPressed: () {
              var userModel = context.read<UserModel>();
              _httpGetDelete(userModel.token!, userModel.user!.id!);
            },
            child: const Text('確認刪除', style: TextStyle(color: Colors.white))
        ),
      ],
    );
  }

  Future _httpGetDelete(String token, int userId) async {

    String path = Service.PATH_USER_DELETE + userId.toString();

    try {
      // final params = {
      //   "tourBus": order.tourBus.toString(),
      //   "ATMFiveDigit": fiveDigit,
      // };

      final response = await http.get(Service.standard(path: path),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'token $token'
        },
      );

      if (response.statusCode == 204) {
        print("success delete user");
        var userModel = context.read<UserModel>();
        userModel.removeUser(context);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("刪除失敗，請聯繫管理員~"),));
      }
    } catch (e) {
      print(e);
    }
  }

}
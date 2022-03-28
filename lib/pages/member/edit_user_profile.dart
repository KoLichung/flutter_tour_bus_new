import 'package:flutter/material.dart';
import '../../widgets/custom_big_outlined_button.dart';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tour_bus_new/constant.dart';


class EditUserProfile extends StatefulWidget {
  const EditUserProfile({Key? key}) : super(key: key);

  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {

  @override
  void initState() {
    // TODO: implement initState
    // _fetchUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.read<UserModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('會員資料'),),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('名稱：${userModel.user?.name}', style: const TextStyle(fontSize: 20),),
                Text('電話：${userModel.user?.phone}', style: const TextStyle(fontSize: 20),),
          ],),),

          CustomBigOutlinedButton(
            title: '修改資料',
            onPressed: (){},
          ),
          CustomBigOutlinedButton(
            title: '修改密碼',
            onPressed: (){},
          ),
        ],
      ),

    );
  }

  // Future _fetchUserProfile() async {
  //   var userModel = context.read<UserModel>();
  //   String path = Service.ORDERS;
  //   try {
  //     final response = await http.get(Service.standard(path: path),
  //       headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'token ${userModel.user?.token}'},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // print(response.body);
  //       List<dynamic> parsedListJson = json.decode(utf8.decode(response.body.runes.toList()));
  //       List<User> data = List<User>.from(parsedListJson.map((i) => User.fromJson(i)));
  //       // print(data[0].title);
  //       // print(data[1].city);
  //       orderList = data;
  //       // print(orderList);
  //
  //       setState(() {});
  //
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}



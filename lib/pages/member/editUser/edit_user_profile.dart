import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/pages/member/editUser/edit_user_detail.dart';
import 'package:flutter_tour_bus_new/pages/member/editUser/edit_user_password.dart';
import '../../../widgets/custom_big_outlined_button.dart';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';
import 'package:provider/provider.dart';



class EditUserProfile extends StatefulWidget {
  const EditUserProfile({Key? key}) : super(key: key);

  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('會員資料'),),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
            child: Consumer<UserModel>(builder: (context, userModel, child) =>
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('名稱：${userModel.user?.name}', style: const TextStyle(fontSize: 20),),
                        Text('電話：${userModel.user?.phone}', style: const TextStyle(fontSize: 20),),
                      ]
                    ),
            ),
          ),
          CustomBigOutlinedButton(
            title: '修改資料',
            onPressed: (){
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditUserDetail()));
            },
          ),
          Consumer<UserModel>(builder: (context, userModel, child) =>
              (!userModel.isLineLogin)?
              CustomBigOutlinedButton(
                title: '修改密碼',
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditUserPassword()));
                },
              ):
              Container(),
          )
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



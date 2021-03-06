import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import '../../models/announcement.dart';
import '../../widgets/custom_member_page_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';
import 'login_register.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class MemberPage extends StatefulWidget {
  const MemberPage({Key? key}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {

  int lengthOfAnnounce = 0;
  String adminPhone = "0912585506";

  @override
  void initState() {
    super.initState();
    print('at init');
    var userModel = context.read<UserModel>();
    if(userModel.isLogin() && userModel.user!.isOwner! && userModel.user!.phone! == adminPhone){
      _httpGetAnnouncements();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('會員資料'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<UserModel>(
              builder: (context, userModel, child) => (userModel.isLogin())
                  ? Container(
                padding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
                alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('狀態： 已登入', style: TextStyle(fontSize: 14)),
                        Text('名稱：${userModel.user?.name}', style: const TextStyle(fontSize: 20),),
                        Text('電話：${userModel.user?.phone}', style: const TextStyle(fontSize: 20),),
                      ],
                    ),
                  )
                  : Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                    child: const Text('狀態：未登入',
                      style: TextStyle(fontSize: 20),),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                         final result = await Navigator.pushNamed(context, '/login_register');
                         if(result=="ok"){
                           var userModel = context.read<UserModel>();
                           if(userModel.user!.phone == adminPhone){
                             _httpGetAnnouncements();
                           }
                         }
                      },
                      child: const Text('登入', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.yellow.shade700,
                          side: const BorderSide(color: Colors.white, width: 2))),
                ],
              ),
            ),
            const Divider(
              color: Color(0xffe5e5e5),
              thickness: 1,
            ),
            CustomMemberPageButton(
              title: '會員資料',
              onPressed: () {
                var userModel = context.read<UserModel>();
                if(userModel.isLogin()){
                  Navigator.pushNamed(context, '/edit_user_profile');
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginRegister(),
                      ));
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
              child: Row(
                  children:[
                    const Expanded(flex:3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text('我的訂單'),
                        )),
                    const Expanded(
                        flex: 3,
                        child: SizedBox()
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          var userModel = context.read<UserModel>();
                          if(userModel.isLogin()){
                            Navigator.pushNamed(context, '/order_list');
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginRegister(),
                                ));
                          }
                        },
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                      ),),]),
            ),
            const Divider(
              color: Color(0xffe5e5e5),
              thickness: 1,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
              child: Row(
                  children:[
                    const Expanded(flex:4,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text('管理員LINE客服'),
                        )),
                    const Expanded(
                        flex: 3,
                        child: SizedBox()
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        onPressed: () async {

                            const url = 'https://page.line.me/501weppt';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                        },
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                      ),),]),
            ),

            Consumer<UserModel>(builder: (context, userModel, child) => (userModel.isLogin() && userModel.user!.isOwner! && userModel.user!.isPassed!) ?
              Column(
                children: [
                  const Divider(
                    color: AppColor.superLightGrey,
                    thickness: 8,
                  ),
                  const Align(alignment:Alignment.centerLeft,child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 10),
                    child: Text('業者功能：\n在此上架之遊覽車業者應符合國家遊覽車業者規定，且無不法情事，如有違反經查證屬實將強制下架該遊覽車業者。使用平台服務費為出車一天 \$1000元。'),
                  )),
                  const Divider(
                    color: Color(0xffe5e5e5),
                    thickness: 1,
                  ),
                  CustomMemberPageButton(
                    title: '訂單列表',
                    onPressed: () {
                      Navigator.pushNamed(context, '/drivers_booking_list');
                    },
                  ),
                  CustomMemberPageButton(
                    title: '汽車列表',
                    onPressed: () {
                      Navigator.pushNamed(context, '/bus_list');
                    },
                  ),
                  (userModel.user!.phone == adminPhone)?
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                        child: Row(
                            children:[
                              const Expanded(flex:3,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                                    child: Text('租賃需求'),
                                  )),
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 3),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: AppColor.yellow,
                                        width: 1,

                                      ),
                                    ),

                                    child: Text('有 $lengthOfAnnounce 則新需求', style: TextStyle(color: AppColor.yellow),),
                                  )
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  // constraints: BoxConstraints(),
                                  // padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/inquiry_notice');
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios, color:Colors.grey),
                                ),
                              ),

                            ]

                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color(0xffe5e5e5),
                      ),
                    ],
                  )
                  :
                  SizedBox(),
                ],
              )
                :
              (userModel.isLogin() && userModel.user!.isOwner! && !userModel.user!.isPassed!)?
              Column(
                children: const [
                  Divider(
                    color: AppColor.superLightGrey,
                    thickness: 8,
                  ),
                  Align(alignment:Alignment.centerLeft,child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 10),
                    child: Text('業者功能：\n業者功能尚未開啟，請等待審核通過或聯繫管理員。'),
                  )),
                  Divider(
                    thickness: 1,
                    color: Color(0xffe5e5e5),
                  ),
                ],
              ):
              const Divider(
                color: Color(0xffe5e5e5),
                thickness: 1,
              ),
            ),
            Consumer<UserModel>(builder: (context, userModel, child) => (userModel.isLogin()) ?
            CustomElevatedButton(onPressed: (){
                // UserUtil.clearUserInfo();

                var userModel = context.read<UserModel>();
                // if (userModel.user!.loginMethod == LoginMethod.line_id) {
                //   _lineLogOut();
                // }
                userModel.removeUser(context);
              },
                title:'登出',
                color: AppColor.lightGrey
            )
                : const SizedBox()
            ),


          ],
        ),
      ),

    );
  }

  Future _httpGetAnnouncements() async {

    String path = Service.ANNOUNCEMENT;
    try {
      final response = await http.get(Service.standard(path: path));
      // print(response.body);

      if (response.statusCode == 200) {
        // print(response.body);
        List<dynamic> dataList = json.decode(utf8.decode(response.body.runes.toList()));
        List<Announcement> announcementList = dataList.map((value) => Announcement.fromJson(value)).toList();
        lengthOfAnnounce = announcementList.length;
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<Null> _lineLogOut() async {
  //   try {
  //     await LineSDK.instance.logout();
  //   } on PlatformException catch (e) {
  //     print(e.message);
  //   }
  // }

}



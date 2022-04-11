import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:flutter_tour_bus_new/models/order.dart';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tour_bus_new/models/bus.dart';

class DriversBusList extends StatefulWidget {
  const DriversBusList({Key? key}) : super(key: key);

  @override
  State<DriversBusList> createState() => _DriversBusListState();
}

class _DriversBusListState extends State<DriversBusList> {

  List<FakeOrderHistory> fakeOrderList = [
    FakeOrderHistory(busType:'20人座遊覽車', startDate:'2022-01-06', endDate:'2022-01-09', agentName: '長興旅行社', price: '8000'),
    FakeOrderHistory(busType:'30人座遊覽車', startDate:'2022-02-06', endDate:'2022-02-09', agentName: '長興旅行社', price: '5000'),
  ];

  List<Bus> driversBusList =[];

  @override
  void initState() {
    // TODO: implement initState
    _fetchDriversBusList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('車輛列表'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/add_new_bus');

              },
              child:
              const Text('新增車輛', style: TextStyle(fontSize: 15),),),)],),
      body: Column(
        children: [
          driversBusList.isEmpty
              ? Center(
                heightFactor: 10,
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
                  backgroundColor: Colors.yellow[100],
                ))
              : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: driversBusList.length,
                itemBuilder:(BuildContext context,int i){
                  return  Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                        leading: Container(
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                          image: DecorationImage(image:AssetImage('images/tour_bus.jpeg',),fit:BoxFit.fill),
                          ),),
                        title: Text(driversBusList[i].title!),
                        subtitle: Text('最近出租日： \n日期待改~日期待改'),
                        onTap: (){
                          Navigator.pushNamed(context, '/drivers_bus_detail');
                        },

                      ),
                      const Divider(color: AppColor.lightGrey,)],);
              }),
        ],
      ),
    );
  }

  Future _fetchDriversBusList() async {
    var userModel = context.read<UserModel>();
    String path = Service.BUSSES;
    try {
      final response = await http.get(Service.standard(path: path),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'token ${userModel.token}'},
      );

      if (response.statusCode == 200) {
        // print(response.body);
        List<dynamic> parsedListJson = json.decode(utf8.decode(response.body.runes.toList()));
        List<Bus> data = List<Bus>.from(parsedListJson.map((i) => Bus.fromJson(i)));

        driversBusList = data;
        // print(driversBusList);

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


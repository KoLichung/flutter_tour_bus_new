import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:flutter_tour_bus_new/pages/member/buses/drivers_bus_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:flutter_tour_bus_new/models/order.dart';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tour_bus_new/models/bus.dart';
import 'package:intl/intl.dart';

class DriversBusList extends StatefulWidget {
  const DriversBusList({Key? key}) : super(key: key);

  @override
  State<DriversBusList> createState() => _DriversBusListState();
}

class _DriversBusListState extends State<DriversBusList> {


  List<Bus> driversBusList =[];
  var formatter = DateFormat("yyyy/MM/dd EEE");

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
                const Text('新增車輛', style: TextStyle(fontSize: 15))
              )
            )
        ],),
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
                        leading:
                        (driversBusList[i].coverImage!=null)?
                        Container(
                          width: 100,
                          child: Image.network(driversBusList[i].coverImage!,fit: BoxFit.cover,),
                        ):
                        Container(
                          width: 100,
                        ),
                        title: Text(driversBusList[i].title!),
                        subtitle:
                        (driversBusList[i].recentStartDate != null)?
                        Text('最近出租日： \n${formatter.format(driversBusList[i].recentStartDate!)}~${formatter.format(driversBusList[i].recentEndDate!)}',)
                        :
                        const Text('尚無出租'),
                        onTap: (){
                          // Navigator.pushNamed(context, '/drivers_bus_detail');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  DriversBusDetail(busId: driversBusList[i].id!),
                              ));
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

        setState(() {});

      }
    } catch (e) {
      print(e);
    }
  }


}


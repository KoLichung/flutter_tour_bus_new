import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:flutter_tour_bus_new/pages/booking/rental_bus_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tour_bus_new/models/bus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/city.dart';
import '../../notifier_model/user_model.dart';
import '../member/login_register.dart';

class SearchList extends StatefulWidget {
  final String fromCity;
  final String toCity;
  final DateTime startDate;
  final DateTime endDate;
  final String numberOfPeople;

  const SearchList({Key? key, required this.fromCity, required this.toCity, required this.startDate, required this.endDate, required this.numberOfPeople}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {

  List<Bus> busResult =[];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchSearchResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.fromCity} ${DateFormat('MM/dd').format(widget.startDate)}~${DateFormat('MM/dd').format(widget.endDate)}'),),
      body: Column(
        children: [
          checkBusResult(),
          GestureDetector(
            child: const Text('沒有符合的需求，填寫需求單', style: TextStyle(color: AppColor.yellow, fontSize: 20, decoration: TextDecoration.underline,),),
            onTap: (){
              var userModel = context.read<UserModel>();
              if(userModel.isLogin()){
                Navigator.pushNamed(context, '/inquiry_form');
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginRegister(),
                    ));
              }
            }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: AppColor.yellow,
        child: const Icon(Icons.menu_outlined),
        onPressed: (){
          getPopUpMenu();
        },
      ),
    );

  }

  // ↓ create the RelativeRect from size of screen and where you tapped
  // RelativeRect get relRectSize => RelativeRect.fromSize(tapXY & const Size(40,40), overlay.size);

  checkBusResult(){
    if(isLoading){
      return Center(
        child: CircularProgressIndicator(
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
          backgroundColor: Colors.yellow[100],
        ),
      );
    } else{
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: busResult.length,
          itemBuilder:(BuildContext context,int i){
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading:
                    (busResult[i].coverImage!=null)?
                    Container(
                      width: 100,
                      child: Image.network(busResult[i].coverImage!,fit: BoxFit.cover,),
                    ):
                    Container(
                      width: 100,
                    ),
                    title:
                    (busResult[i].isTop!)?
                        Row(children: [
                          Text(busResult[i].title!, style: Theme.of(context).textTheme.subtitle2,),
                          const SizedBox(width: 10,),
                          const Chip(
                            visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                            backgroundColor: AppColor.pending,
                            label: Text('置頂推薦',style: TextStyle(fontSize: 13,color: Colors.white),),)
                        ],)
                    :
                    Text(busResult[i].title!, style: Theme.of(context).textTheme.subtitle2,),
                    // subtitle:RichText(
                    //     text: TextSpan(text: busResult[i].vehicalBodyNumber,
                    //             style:const TextStyle(color: AppColor.grey),
                    //             children: <TextSpan>[
                    //               TextSpan(text: '\n所在地：${busResult[i].city}\n年份：${busResult[i].vehicalYearOfManufacture!}  座位：${busResult[i].vehicalSeats}',
                    //                 style: Theme.of(context).textTheme.bodyText2,),
                    //             ],
                    //           ),
                    // ),
                    subtitle: Text('所在地：${busResult[i].city}\n年份：${busResult[i].vehicalYearOfManufacture!}  座位：${busResult[i].vehicalSeats}', style: Theme.of(context).textTheme.bodyText2),
                    onTap: (){
                      Bus theBus = busResult[i];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RentalBusDetail(
                              theBus: theBus,
                              fromCity: widget.fromCity,
                              toCity: widget.toCity,
                              startDate: widget.startDate,
                              endDate: widget.endDate,
                            ),
                          ));
                      // Navigator.pushNamed(context, '/bus_detail');
                    },
                  ),
                ),
                const Divider(color: Colors.grey,)
              ],
            );
          } );
    }
  }

  getPopUpMenu(){
    return showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 600, 20, 100),
      items: const [
        PopupMenuItem(
            value: 1,
            child: Text("距離排序")),
        PopupMenuItem(
            value: 2,
            child: Text("年份排序")),
        PopupMenuItem(
            value: 3,
            child: Text("座位數多到少")),
        PopupMenuItem(
            value: 4,
            child: Text("座位數少到多")),],
      elevation: 8.0,
    ).then((value){
      // NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null
      if(value!=null){
        print(value);
        if(value==1){
          City theCity = City.getCityFromName(widget.fromCity);
          busResult.sort( (a,b) => _calculateDistance(theCity.lat, theCity.lng, a.lat, a.lng).compareTo(_calculateDistance(theCity.lat, theCity.lng, b.lat, b.lng)) );
        }else if(value==2){
          busResult.sort((a, b) => - int.parse(a.vehicalYearOfManufacture!).compareTo(double.parse(b.vehicalYearOfManufacture!)));
        }else if(value==3){
          busResult.sort((a, b) => - (a.vehicalSeats!).compareTo(b.vehicalSeats!));
        }else if(value==4){
          busResult.sort((a, b) => (a.vehicalSeats!).compareTo(b.vehicalSeats!));
        }
        setState(() {});
      }
    });
  }

  Future _fetchSearchResult() async {
    String path = Service.SEARCH_BUS;
    try {
      final response = await http.get(Service.standard(path: path, queryParameters: {
        'departure_city_id':'1',
        'destination_city_id':'2',
        'startDate':'20220309',
        'endtDate':'20220310',
        'numberOfPeople':'25'
      }));
      // print(response.body);

      if (response.statusCode == 200) {
        // print(response.body);
        List<dynamic> parsedListJson = json.decode(utf8.decode(response.body.runes.toList()));
        List<Bus> data = List<Bus>.from(parsedListJson.map((i) => Bus.fromJson(i)));
        // print(data[0].title);
        // print(data[1].city);
        busResult = data;
        // print(busResult);


        setState(() {
          isLoading = false;
        });

        // if (response.statusCode == 200) {
        //   // print(response.body);
        //   Map<String, dynamic> map =
        //   json.decode(utf8.decode(response.body.runes.toList()));
        //   List body = map['results'];
        //   growthStatementSource = body.map((value) => GrowthStatement.fromJson(value)).toList();
        //   periodDataSource = growthStatementSource;
        //   setState(() {});
        // }

      }
    } catch (e) {
      print(e);
    }
  }

  double _calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

}

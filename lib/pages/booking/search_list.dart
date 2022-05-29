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

  // List<Bus> busResult =[];
  bool isLoading = false;
  List<Bus> topBusses = [];
  List<Bus> regularBuses = [];

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
      body: checkBusResult(),
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
          itemCount: topBusses.length+regularBuses.length+1,
          itemBuilder:(BuildContext context,int i){
            if(i == topBusses.length+regularBuses.length){
            return
              Center(
                child: GestureDetector(
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
                    }),
              );
            }else{
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading:getLeadingImage(i),
                      title:
                      (i<topBusses.length)?
                      Text(topBusses[i].title!, style: Theme.of(context).textTheme.subtitle2)
                          :
                      Text(regularBuses[i-topBusses.length].title!, style: Theme.of(context).textTheme.subtitle2),
                      // subtitle:RichText(
                      //     text: TextSpan(text: busResult[i].vehicalBodyNumber,
                      //             style:const TextStyle(color: AppColor.grey),
                      //             children: <TextSpan>[
                      //               TextSpan(text: '\n所在地：${busResult[i].city}\n年份：${busResult[i].vehicalYearOfManufacture!}  座位：${busResult[i].vehicalSeats}',
                      //                 style: Theme.of(context).textTheme.bodyText2,),
                      //             ],
                      //           ),
                      // ),
                      subtitle:
                      (i<topBusses.length)?
                      Text('所在地：${topBusses[i].city}\n年份：${topBusses[i].vehicalYearOfManufacture!}  座位：${topBusses[i].vehicalSeats}', style: Theme.of(context).textTheme.bodyText2)
                          :
                      Text('所在地：${regularBuses[i-topBusses.length].city}\n年份：${regularBuses[i-topBusses.length].vehicalYearOfManufacture!}  座位：${regularBuses[i-topBusses.length].vehicalSeats}', style: Theme.of(context).textTheme.bodyText2),
                      onTap: (){
                        Bus? theBus;
                        if(i<topBusses.length){
                          theBus = topBusses[i];
                        }else{
                          theBus = regularBuses[i-topBusses.length];
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RentalBusDetail(
                                theBus: theBus!,
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
            }
          }
          );
    }
  }

  Widget getLeadingImage(int i){
    if((i<topBusses.length && topBusses[i].coverImage == null) || (i>=topBusses.length && regularBuses[i-topBusses.length].coverImage == null )){
      return Container(
        width: 100,
      );
    }else if(i<topBusses.length){
      return Container(
        width: 100,
        child: Image.network(topBusses[i].coverImage!,fit: BoxFit.cover),
      );
    }else{
      return Container(
        width: 100,
        child: Image.network(regularBuses[i-topBusses.length].coverImage!,fit: BoxFit.cover),
      );
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
          regularBuses.sort( (a,b) => _calculateDistance(theCity.lat, theCity.lng, a.lat, a.lng).compareTo(_calculateDistance(theCity.lat, theCity.lng, b.lat, b.lng)) );
        }else if(value==2){
          regularBuses.sort((a, b) => - int.parse(a.vehicalYearOfManufacture!).compareTo(double.parse(b.vehicalYearOfManufacture!)));
        }else if(value==3){
          regularBuses.sort((a, b) => - (a.vehicalSeats!).compareTo(b.vehicalSeats!));
        }else if(value==4){
          regularBuses.sort((a, b) => (a.vehicalSeats!).compareTo(b.vehicalSeats!));
        }
        setState(() {});
      }
    });
  }

  Future _fetchSearchResult() async {
    String path = Service.SEARCH_BUS;
    try {
      final response = await http.get(Service.standard(path: path, queryParameters: {
        'departure_city_id': City.getCityFromName(widget.fromCity).id.toString(),
        'destination_city_id':City.getCityFromName(widget.toCity).id.toString(),
        'startDate': DateFormat('yyyyMMdd').format(widget.startDate),
        'endtDate':DateFormat('yyyyMMdd').format(widget.endDate),
        'numberOfPeople': widget.numberOfPeople,
      }));
      // print(response.body);

      if (response.statusCode == 200) {
        // print(response.body);
        List<dynamic> parsedListJson = json.decode(utf8.decode(response.body.runes.toList()));
        List<Bus> data = List<Bus>.from(parsedListJson.map((i) => Bus.fromJson(i)));
        // print(data[0].title);
        // print(data[1].city);
        for(Bus theBus in data){
          if(theBus.isTop!){
            topBusses.add(theBus);
          }else{
            regularBuses.add(theBus);
          }
        }
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:flutter_tour_bus_new/pages/booking/rental_bus_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tour_bus_new/models/bus.dart';

class SearchList extends StatefulWidget {
  const SearchList({Key? key}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {

  List<Bus> busResult =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchSearchResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('台北市 3/1~3/2'),),
      body: Column(
        children: [
          checkBusResult(),
          GestureDetector(
            child: const Text('沒有符合的需求，填寫需求單', style: TextStyle(color: AppColor.yellow, fontSize: 20, decoration: TextDecoration.underline,),),
            onTap: (){
              Navigator.pushNamed(context, '/inquiry_form');
            },),
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
    if(busResult.isEmpty){
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
                    leading: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('images/tour_bus.jpeg'),fit: BoxFit.fill)),
                    ),
                    title: Text(busResult[i].title, style: Theme.of(context).textTheme.subtitle2,),
                    subtitle:RichText(
                      text: TextSpan(text: busResult[i].vehicleBodyNumber,
                        style:const TextStyle(color: AppColor.grey),
                        children: <TextSpan>[
                          TextSpan(text: '\n所在地：${busResult[i].city}\n年份：2022  座位：${busResult[i].vehicleSeats}',
                            style: Theme.of(context).textTheme.bodyText2,),
                        ],
                      ),),
                    onTap: (){
                      Bus theBus = busResult[i];
                      Bus busDetail = Bus(
                          // id: theBus.id,
                          title: theBus.title,
                          lat: theBus.lat,
                          lng: theBus.lng,
                          city: theBus.city,
                          county: theBus.county,
                          vehicleSeats: theBus.vehicleSeats,
                          vehicleLicence: theBus.vehicleLicence,
                          vehicleOwner: theBus.vehicleOwner,
                          vehicleEngineNumber: theBus.vehicleEngineNumber,
                          vehicleBodyNumber: theBus.vehicleBodyNumber,
                          vehicleLicenceImage: theBus.vehicleLicenceImage,
                          isPublish: theBus.isPublish,
                          user: theBus.user);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RentalBusDetail(
                              theBusDetail: busDetail,
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
        // stock_codes=2330&stock_percent=100&start_date=2007-01-01&end_date=2020-03-01&is_compare_0050=true&is_reinvest_divident=true&month_cash_flow=1000&start_money=10000
        // 'stock_codes': widget.theTestingValues.stockCodes,
        // 'stock_percent': widget.theTestingValues.stockPercent,
        // 'start_date': widget.theTestingValues.startDate,
        // 'end_date': widget.theTestingValues.endDate,
        // 'is_compare_0050': widget.theTestingValues.isCompare0050,
        // 'is_reinvest_divident': widget.theTestingValues.isReinvestDivident,
        // 'month_cash_flow': widget.theTestingValues.monthCashFlow,
        // 'start_money': widget.theTestingValues.startMoney,
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


        setState(() {});

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

}

class FakeTourBus {
 String title;
 String agentName;
 String location;
 String busYear;
 String seat;

  FakeTourBus({ required this.title, required this.agentName, required this.location, required this.busYear, required this.seat});
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/models/tour_bus_image.dart';
import 'package:flutter_tour_bus_new/pages/member/buses/edit_bus_profile.dart';
import 'package:flutter_tour_bus_new/widgets/custom_big_outlined_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import '../../../models/bus.dart';
import '../../../models/bus_rent_day.dart';
import '../../../notifier_model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tour_bus_new/widgets/custom_outlined_text.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'drivers_bus_detail_delete_date_dialog.dart';

import 'package:intl/intl.dart';

class DriversBusDetail extends StatefulWidget {

  final Bus bus;

  const DriversBusDetail({Key? key, required this.bus}) : super(key: key);

  @override
  State<DriversBusDetail> createState() => _DriversBusDetailState();
}

class _DriversBusDetailState extends State<DriversBusDetail> {

  // List<String> fakeDate = ['2022-01-10~2022-01-16','2022-01-17~2022-01-31','2022-02-06~2022-02-19','2022-03-15~2022-03-26'];

  List<TourBusImage> listBusImages = [];

  String? _startDate;
  String? _endDate;
  final DateRangePickerController _controller = DateRangePickerController();

  // List<AvailableDate> availableDateList = [];

  List<BusRentDay> availableDays = [];
  List<BusRentDay> orderedDays = [];
  List<BusRentDay> pastDays = [];

  // int? theBusId;
  Bus? theBus;

  bool isBusListNeedRefresh = false;

  @override
  void initState() {
    super.initState();

    theBus = widget.bus;
    _fetchBusImages(theBus!.id!);
    _fetchBusRentDays(theBus!.id!);

    // print(userModel.currentBus!.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('車輛詳細'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
          if(isBusListNeedRefresh==true){
            Navigator.pop(context, 'refresh');
          }else{
            Navigator.pop(context);
          }
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              child: const Icon(Icons.edit),
              onTap: () async {
                // Navigator.pushNamed(context, '/edit_bus_profile');
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  EditBusProfile(theBus: theBus!, listBusImages: listBusImages)));

                if(result=='ok'){
                  var userModel = context.read<UserModel>();
                  _httpGetBus(userModel.token!, theBus!.id!);
                  _fetchBusImages(theBus!.id!);
                  isBusListNeedRefresh = true;
                }

              },
            ),)],),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 110,
                child:
                ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: listBusImages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(10,10,0,8),
                        height: 100, width: 100,
                        child: Image.network(listBusImages[index].image!,fit: BoxFit.cover,),
                      );
                    }
                )
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: (theBus!.isPublish!)?const Text('目前狀態：上架中'):const Text('目前狀態：下架中'),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '名稱： ${theBus!.title}\n車輛所在地：${theBus!.city}${theBus!.county}',style: const TextStyle(height: 2),),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text('設定可出租日期：'),
                  GestureDetector(
                    child: const CustomOutlinedText(title: '新增', color:  AppColor.yellow),
                    onTap: (){
                      showDialog<Widget>(
                          context: context,
                          builder: (BuildContext context) {
                            return getDatePicker();
                          });
                    }),
                ]),
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 6),
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: availableDays.length,
                itemBuilder: (context, index) {
                  // final date = availableDateList[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${availableDays[index].startDate!.substring(0,10)} ~ ${availableDays[index].endDate!.substring(0,10)}'),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.delete_forever,color: Colors.red,),
                          onPressed:() async {
                            var data = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DriversBusDetailDeleteDateDialog(availableDate: availableDays[index]);
                                });
                            if (data == 'confirmDelete'){
                              setState(() {
                                _destroyBusRentDay(availableDays[index]);
                                availableDays.removeAt(index);
                              });
                            }
                          })],
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                  alignment:Alignment.centerLeft,
                  child:Text('已下訂出租日：')),
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 6),
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: orderedDays.length,
                itemBuilder: (context, index) {
                  return Text('${orderedDays[index].startDate!.substring(0,10)} ~ ${orderedDays[index].endDate!.substring(0,10)}',style: const TextStyle(height: 2),);
                },
              ),
              // CustomBigOutlinedButton(
              //     onPressed: (){},
              //     title: '更多'),
              const SizedBox(
                height: 10,
              ),
              const Align(
                  alignment:Alignment.centerLeft,
                  child:Text('歷史出租紀錄：')),
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 6),
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: pastDays.length,
                itemBuilder: (context, index) {
                  return Text('${pastDays[index].startDate!.substring(0,10)}~${pastDays[index].endDate!.substring(0,10)}',style: const TextStyle(height: 2),);
                },
              ),
              // CustomBigOutlinedButton(
              //     onPressed: (){},
              //     title: '更多'),
            ],
          ),
        ),
      ),
    );
  }

  getDatePicker(){
    return Center(
      child: SizedBox(
        height: 460,
        width: 360,
        child: SfDateRangePickerTheme(
          data: SfDateRangePickerThemeData(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ),
          child: SfDateRangePicker(
            controller: _controller,
            view: DateRangePickerView.month,
            monthViewSettings: const DateRangePickerMonthViewSettings(
              firstDayOfWeek: 1,
            ),
            headerHeight: 60,
            headerStyle: const DateRangePickerHeaderStyle(
                backgroundColor: AppColor.yellow,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 22,
                  letterSpacing: 3,
                  color: Colors.white,
                )),
            selectionMode: DateRangePickerSelectionMode.range,
            minDate: DateTime.now(),
            onSelectionChanged: selectionChanged,
            showActionButtons: true,
            cancelText: '取消',
            confirmText: '確定',
            onSubmit: (Object? value, ) {
              BusRentDay availableDay = BusRentDay(tourBus: theBus!.id!, state: "available", startDate: _startDate, endDate: _endDate);
              // availableDays.add(availableDay);
              _postCreateBusRentDay(availableDay);
              // setState(() {});
              Navigator.pop(context);
            },
            onCancel: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    // on selectionChanged 這裏僅是先記錄選取的 date
    // 直到按下確定 submit 才需要存進資料裡
      if(args.value.startDate != null && args.value.endDate != null ){
        _startDate = DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
        _endDate = DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate).toString();
      }
  }

  Future _fetchBusImages(int busId) async {

    String path = Service.TOUR_BUS_IMAGES;
    try {

      final queryParameters = {
        "bus_id" : busId.toString(),
      };

      final response = await http.get(Service.standard(path: path, queryParameters: queryParameters));

      if (response.statusCode == 200) {
        // print(response.body);
        List body = json.decode(utf8.decode(response.body.runes.toList()));
        listBusImages = body.map((value) => TourBusImage.fromJson(value)).toList();

        setState(() {});

      }
    } catch (e) {
      print(e);
    }
  }

  Future _httpGetBus(String token, int busId) async {

    String path = Service.BUSSES + "$busId/";
    try {

      final response = await http.get(Service.standard(path: path),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        // print(response.body);
        Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
        theBus = Bus.fromJson(map);
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future _fetchBusRentDays(int busId) async {

    String path = Service.TOUR_BUS_RENT_DAYS;
    try {

      final queryParameters = {
        // "bus_id" : busId.toString(),
        "bus_id" : busId.toString(),
      };

      final response = await http.get(Service.standard(path: path, queryParameters: queryParameters));

      if (response.statusCode == 200) {
        // print(response.body);
        List body = json.decode(utf8.decode(response.body.runes.toList()));
        List<BusRentDay> theDays = body.map((value) => BusRentDay.fromJson(value)).toList();

        for(BusRentDay day in theDays){
          if(day.state == 'available'){
            availableDays.add(day);
          }else if(day.state == 'ordered'){
            orderedDays.add(day);
          }else if(day.state == 'pasted'){
            pastDays.add(day);
          }
        }

        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future _postCreateBusRentDay(BusRentDay theDay) async {

    String path = Service.TOUR_BUS_RENT_DAYS;
    try {

      final bodyParams = {
        "state": theDay.state!,
        "tourBus": theDay.tourBus!.toString(),
        "startDate":  theDay.startDate!+"T00:00:00Z",
        "endDate": theDay.endDate!+"T00:00:00Z",
      };

      final response = await http.post(Service.standard(path: path),
        body:bodyParams,
      );

      print(response.body);

      if (response.statusCode == 201) {
        Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
        BusRentDay theDay = BusRentDay.fromJson(map);
        availableDays.add(theDay);
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已建立新可出租日期')));
      }
    } catch (e) {
      print(e);
    }
  }

  Future _destroyBusRentDay(BusRentDay theDay) async {

    String path = Service.TOUR_BUS_RENT_DAYS+"${theDay.id!}/";
    try {

      final response = await http.delete(Service.standard(path: path));

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已刪除可出租日期')));
      }
    } catch (e) {
      print(e);
    }
  }

}

class AvailableDate{
  String? startDate;
  String? endDate;

  AvailableDate({
    required this.startDate,
    required this.endDate
  });
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


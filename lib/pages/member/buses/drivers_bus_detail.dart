import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/models/tour_bus_image.dart';
import 'package:flutter_tour_bus_new/widgets/custom_big_outlined_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import '../../../notifier_model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tour_bus_new/widgets/custom_outlined_text.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'drivers_bus_detail_delete_date_dialog.dart';

import 'package:intl/intl.dart';

class DriversBusDetail extends StatefulWidget {

  final int busId;

  const DriversBusDetail({Key? key, required this.busId}) : super(key: key);

  @override
  State<DriversBusDetail> createState() => _DriversBusDetailState();
}

class _DriversBusDetailState extends State<DriversBusDetail> {

  List<FakeOrderHistory> fakeOrderList = [
    FakeOrderHistory(busType:'20人座遊覽車', startDate:'2022-01-06', endDate:'2022-01-09', agentName: '長興旅行社', price: '8000'),
    FakeOrderHistory(busType:'30人座遊覽車', startDate:'2022-02-06', endDate:'2022-02-09', agentName: '長興旅行社', price: '5000'),
  ];

  List<String> fakeDate = ['2022-01-10~2022-01-16','2022-01-17~2022-01-31','2022-02-06~2022-02-19','2022-03-15~2022-03-26'];

  List<TourBusImage> listBusImages = [];

  String? _startDate;
  String? _endDate;
  final DateRangePickerController _controller = DateRangePickerController();

  List<AvailableDate> availableDateList = [];

  @override
  void initState() {
    var userModel = context.read<UserModel>();
    _fetchBusImages(userModel.token!, widget.busId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userModel = context.read<UserModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('車輛詳細'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              child: const Icon(Icons.edit),
              onTap: () {
                Navigator.pushNamed(context, '/edit_bus_profile');
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
                // ListView(
                //   shrinkWrap: true,
                //   scrollDirection: Axis.horizontal,
                //   children: [
                //     Container(
                //       margin: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                //       width: 100,
                //       height: 100,
                //       decoration: const BoxDecoration(
                //         image: DecorationImage(image:AssetImage('images/tour_bus.jpeg',),
                //             fit:BoxFit.fill),),
                //     ),
                //     Container(
                //       margin: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                //       width: 100,
                //       height: 100,
                //       decoration: const BoxDecoration(
                //         image: DecorationImage(image:AssetImage('images/tour_bus.jpeg',),
                //             fit:BoxFit.fill),),
                //     ),
                //     Container(
                //       margin: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                //       width: 100,
                //       height: 100,
                //       decoration: const BoxDecoration(
                //         image: DecorationImage(image:AssetImage('images/tour_bus.jpeg',),
                //             fit:BoxFit.fill),),
                //     ),
                //     Container(
                //       margin: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                //       width: 100,
                //       height: 100,
                //       decoration: const BoxDecoration(
                //         image: DecorationImage(image:AssetImage('images/tour_bus.jpeg',),
                //             fit:BoxFit.fill),),
                //     ),
                //     Container(
                //       margin: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                //       width: 100,
                //       height: 100,
                //       decoration: const BoxDecoration(
                //         image: DecorationImage(image:AssetImage('images/tour_bus.jpeg',),
                //             fit:BoxFit.fill),),
                //     ),
                //     Container(
                //       margin: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                //       width: 100,
                //       height: 100,
                //       decoration: const BoxDecoration(
                //         image: DecorationImage(image:AssetImage('images/tour_bus.jpeg',),
                //             fit:BoxFit.fill),),
                //     ),
                //     Container(
                //       margin: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                //       width: 100,
                //       height: 100,
                //       decoration: const BoxDecoration(
                //         image: DecorationImage(image:AssetImage('images/tour_bus.jpeg',),
                //             fit:BoxFit.fill),),
                //     ),
                //   ],
                // ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    '名稱： ${fakeOrderList[0].busType}\n車輛所在地：台中市南區',style: const TextStyle(height: 2),),
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
                itemCount: availableDateList.length,
                itemBuilder: (context, index) {
                  // final date = availableDateList[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(availableDateList[index].startDate! + '~' + availableDateList[index].endDate!),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.delete_forever,color: Colors.red,),
                          onPressed:() async {
                            var data = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DriversBusDetailDeleteDateDialog(availableDate: availableDateList[index],);
                                });
                            if (data == 'confirmDelete'){
                              setState(() {
                                availableDateList.removeAt(index);
                              });
                            }
                          })],
                  );
                  // return Dismissible(
                  //     key: Key(date),
                  //     onDismissed: (direction) {
                  //       // Remove the item from the data source.
                  //       setState(() {
                  //         availableDates.removeAt(index);
                  //       });
                  //       // Then show a snackbar.
                  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$date 已刪除')));
                  //     },
                  //     background: Container(color: Colors.red),
                  //     child: Row(
                  //       children: [
                  //         Text(availableDates[index],style: const TextStyle(height: 2),),
                  //         const SizedBox(width: 10,),
                  //         const Icon(Icons.remove_circle,color: Colors.red,)
                  //       ],
                  //     ));
                },
              ),
              const Align(
                  alignment:Alignment.centerLeft,
                  child:Text('已下訂出租日：')),
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 6),
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: fakeDate.length,
                itemBuilder: (context, index) {
                  return Text(fakeDate[index],style: const TextStyle(height: 2),);
                },
              ),
              CustomBigOutlinedButton(
                  onPressed: (){},
                  title: '更多'),
              const Align(
                  alignment:Alignment.centerLeft,
                  child:Text('歷史出租紀錄：')),
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 6),
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: fakeDate.length,
                itemBuilder: (context, index) {
                  return Text(fakeDate[index],style: const TextStyle(height: 2),);
                },
              ),
              CustomBigOutlinedButton(
                  onPressed: (){},
                  title: '更多'),
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
              setState(() {
                AvailableDate availableDate = AvailableDate(startDate: _startDate, endDate: _endDate);
                availableDateList.add(availableDate);
              });
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



  Future _fetchBusImages(String token, int busId) async {

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


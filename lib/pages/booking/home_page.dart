import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';
import '../../models/city.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:intl/intl.dart';
import 'search_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // List<String> cityList = ['基隆','台北','新北市','桃園','新竹','苗栗','台中','彰化','雲林','南投', '嘉義','台南','高雄','屏東','宜蘭','花蓮','台東'];

  List<String> cityList = City.getCityNames();

  String fromCity = '台北市';
  String toCity = '台中市';

  TextEditingController numberOfPeopleController = TextEditingController();

  final DateRangePickerController _dateRangePickerController = DateRangePickerController();

  // String _startDate = DateFormat('MM / dd EEE').format(DateTime.now().add(const Duration(days: 14)));
  // String _endDate = DateFormat('MM / dd EEE').format(DateTime.now().add(const Duration(days: 17)));

  DateTime startDate = DateTime.now().add(const Duration(days: 1));
  DateTime endDate = DateTime.now().add(const Duration(days: 2));

  @override
  initState(){
    super.initState();
    var userModel = context.read<UserModel>();
    numberOfPeopleController.text = userModel.numberOfPeople;
    // _getDeviceInfo();
    // _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {

    var userModel = context.read<UserModel>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar:AppBar(
          title: const Text('租遊覽車'),),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('預約租車', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.yellow,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('出發：'),
                              getFromCity(),
                              const VerticalDivider(
                                thickness: 2,
                                indent: 12,
                                endIndent: 12,
                                color: AppColor.yellow,
                              ),
                              const Text('目的：'),
                              getToCity(),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: AppColor.yellow,
                        thickness: 2,
                        height: 0,
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Text('日期：'),
                            GestureDetector(
                                onTap: (){
                                  showDialog<Widget>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return getDatePicker();
                                      });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text('${DateFormat('MM / dd EEE').format(userModel.startDate)} - ${DateFormat('MM / dd EEE').format(userModel.endDate)}'),
                                )
                            ),
                          ],),
                      ),
                      const Divider(
                        color: AppColor.yellow,
                        thickness: 2,
                        height: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(children: [
                          const Text('人數：   '),
                          SizedBox(
                            width: 30,
                            child: getNumberOfPeople(),
                          ),
                          const Text('人'),
                        ],),
                      ),
                    ],
                  ),
                ),
                CustomElevatedButton(
                  color: AppColor.yellow,
                  title: '開始搜尋',
                  onPressed: (){
                    if (numberOfPeopleController.text == '') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請輸入搭車人數！"),));
                    } else if(int.parse(numberOfPeopleController.text)>43){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("搜索人數必須小於 43 人！"),));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchList(startDate: userModel.startDate, endDate: userModel.endDate, fromCity: userModel.fromCity, toCity: userModel.toCity, numberOfPeople: userModel.numberOfPeople,),
                          ));
                    }
                  },),
              ]
          ),
        ),
      )
    );
  }

  DropdownButtonHideUnderline getFromCity(){
    var userModel = context.read<UserModel>();
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          itemHeight: 50,
          value: userModel.fromCity,
          onChanged:(String? newValue){
            setState(() {
              fromCity = newValue!;
              Provider.of<UserModel>(context, listen: false).changeBookingFromCity(fromCity);
            });
          },
          items: cityList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList())
        );
  }

  DropdownButtonHideUnderline getToCity(){
    var userModel = context.read<UserModel>();
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            itemHeight: 50,
            value: userModel.toCity,
            onChanged:(String? newValue){
              setState(() {
                toCity = newValue!;
                Provider.of<UserModel>(context, listen: false).changeBookingToCity(toCity);
              });
            },
            items: cityList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList())
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
            controller: _dateRangePickerController,
            view: DateRangePickerView.month,
            monthViewSettings: const DateRangePickerMonthViewSettings(
                firstDayOfWeek: 7,
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
              // print('chosen duration: $value');
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
    setState(() {
      // _startDate = DateFormat('MM / dd EEE').format(args.value.startDate).toString();
      // _endDate = DateFormat('MM / dd EEE').format(args.value.endDate ?? args.value.startDate).toString();

      startDate = args.value.startDate;
      endDate = args.value.endDate ?? args.value.startDate;

      Provider.of<UserModel>(context, listen: false).changeBookingStartDate(startDate);
      Provider.of<UserModel>(context, listen: false).changeBookingEndDate(endDate);
    });
  }


  getNumberOfPeople(){
    return TextFormField(
      controller: numberOfPeopleController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      onChanged: (String? value){
        setState(() {
          String numberOfPeople = value!;

          Provider.of<UserModel>(context, listen: false).changeBookingNumberOfPeople(numberOfPeople);
        });
      },
    );
  }

  // Future<Position> _getCurrentPosition() async {
  //   final hasPermission = await _handlePermission();
  //
  //   if (!hasPermission) {
  //     // return;
  //   }
  //
  //   final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  //   print(position);
  //   if(position != null){
  //
  //   }
  //
  //   List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude, localeIdentifier: 'zh-TW');
  //   if(placemarks.isNotEmpty){
  //     String output = placemarks[0].subAdministrativeArea.toString() + placemarks[0].locality.toString() + placemarks[0].street.toString();
  //     print(output);
  //   }else{
  //     print('empty place mark');
  //   }
  //
  //   return position;
  //
  // }
  //
  // Future<bool> _handlePermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return false;
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return false;
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return false;
  //   }
  //   return true;
  // }

}

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

  String _startDate = DateFormat('MM / dd EEE').format(DateTime.now().add(const Duration(days: 14)));
  String _endDate = DateFormat('MM / dd EEE').format(DateTime.now().add(const Duration(days: 17)));

  @override
  void initState() {

    var userModel = context.read<UserModel>();
    numberOfPeopleController.text = userModel.numberOfPeople;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var userModel = context.read<UserModel>();

    return Scaffold(
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
                            child: Text('${userModel.startDate}  -  ${userModel.endDate}')
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
                        const Text('人數：'),
                        SizedBox(
                          width: 40,
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
                    const snackBar =SnackBar(
                      content: Text('請輸入搭車人數！'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      _startDate =
          DateFormat('MM / dd EEE').format(args.value.startDate).toString();
      _endDate =
          DateFormat('MM / dd EEE').format(args.value.endDate ?? args.value.startDate).toString();
      Provider.of<UserModel>(context, listen: false).changeBookingStartDate(_startDate);
      Provider.of<UserModel>(context, listen: false).changeBookingEndDate(_endDate);
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



}

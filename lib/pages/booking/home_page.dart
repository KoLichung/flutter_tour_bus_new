import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import '../../models/city.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:intl/intl.dart';
import 'search_list.dart';

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

  String? startDate;
  String? endDate;

  TextEditingController numberOfPeople = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _getBatteryLevel();

    var now = DateTime.now();
    var formatter = DateFormat("MM/dd EEE");
    startDate = formatter.format(now.add(const Duration(days: 14)));
    endDate = formatter.format(now.add(const Duration(days: 17)));
  }

  @override
  Widget build(BuildContext context) {
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
                            child: Text('$startDate - $endDate')),

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchList(),
                      ));
                },)
            ]
        ),
      ),
    );
  }

  DropdownButtonHideUnderline getFromCity(){
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          itemHeight: 50,
          value: fromCity,
          onChanged:(String? newValue){
            setState(() {
              fromCity = newValue!;
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
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            itemHeight: 50,
            value: toCity,
            onChanged:(String? newValue){
              setState(() {
                toCity = newValue!;
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

    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      // TODO: implement your code here
    }

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
            monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
            selectionMode: DateRangePickerSelectionMode.range,
            showActionButtons: true,
            cancelText: '取消',
            confirmText: '確定',
            onSubmit: (Object? value) {
              print('value $value');
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

  getNumberOfPeople(){
    return TextFormField(
      controller: numberOfPeople,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: InputBorder.none,
        // isDense: true,
       hintText: '10',
      ),
    );
  }


}

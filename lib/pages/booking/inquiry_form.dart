import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/models/announcement.dart';
import 'package:provider/provider.dart';
import '../../models/city.dart';
import '../../notifier_model/user_model.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;

class InquiryForm extends StatefulWidget {
  const InquiryForm({Key? key}) : super(key: key);

  @override
  _InquiryFormState createState() => _InquiryFormState();
}

class _InquiryFormState extends State<InquiryForm> {

  List<String> cityList = City.getCityNames();

  String fromCity = '台北市';
  String toCity = '台中市';

  DateTime startDate = DateTime.now().add(const Duration(days: 1));
  DateTime endDate = DateTime.now().add(const Duration(days: 2));

  TextEditingController numberOfPeople = TextEditingController();
  TextEditingController memoTextController = TextEditingController();

  final DateRangePickerController _dateRangePickerController = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                                    child: Text('${DateFormat('MM / dd EEE').format(startDate)}  -  ${DateFormat('MM / dd EEE').format(endDate)}'),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('備註', style: TextStyle(fontSize: 18),),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),

                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: memoTextController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                          hintText: '範例：我們要到溪頭旅遊..',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10)
                      ),

                    ),
                  ),

                  CustomElevatedButton(
                    color: AppColor.yellow,
                    title: '送出需求單',
                    onPressed: (){
                        if(numberOfPeople.text!=''){
                          var userModel = context.read<UserModel>();

                          Announcement theAnnouncement = Announcement();
                          theAnnouncement.announceDateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
                          theAnnouncement.numbersOfPeople = int.parse(numberOfPeople.text);
                          theAnnouncement.startDateTime = DateFormat('yyyy-MM-dd').format(startDate);
                          theAnnouncement.endDateTime = DateFormat('yyyy-MM-dd').format(endDate);
                          theAnnouncement.depatureCity = fromCity;
                          theAnnouncement.destinationCity = toCity;
                          theAnnouncement.memo = memoTextController.text;

                          _httpPostCreateAnnouncement(theAnnouncement, userModel.token!);
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("人數不可空白！"),));
                        }
                    },),
                  const Center(child: Text('(如果有業者能承接，會主動聯絡您)',style: TextStyle(fontSize: 14),)),
                ]
            ),
          ),
        )
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
      startDate = args.value.startDate;
      endDate = args.value.endDate ?? args.value.startDate;
    });
  }

  getNumberOfPeople(){
    return TextFormField(
      controller: numberOfPeople,
      decoration: const InputDecoration(
        border: InputBorder.none,
        // isDense: true,
        hintText: '10',
      ),
    );
  }

  Future _httpPostCreateAnnouncement(Announcement announcement, String token) async {

    String path = Service.ANNOUNCEMENT;

    try {
      Map queryParameters = {
        'announceDateTime': announcement.announceDateTime!+"T08:00:00Z",
        'numbersOfPeople': announcement.numbersOfPeople.toString(),
        'startDateTime': announcement.startDateTime!+"T08:00:00Z",
        'endDateTime': announcement.endDateTime!+"T08:00:00Z",
        'depatureCity': announcement.depatureCity,
        'destinationCity': announcement.destinationCity,
        'memo': announcement.memo,
      };

      print(queryParameters);

      final response = await http.post(Service.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'token $token'
          },
          body: jsonEncode(queryParameters)
      );
      print(response.body);
      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      if(map['id']!=null){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("成功發出需求單！"),));
        Navigator.pop(context);
      }
    } catch(e){
      print(e);
    }
  }

}

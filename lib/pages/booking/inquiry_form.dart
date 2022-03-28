import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import  'package:intl/intl.dart';


class InquiryForm extends StatefulWidget {
  const InquiryForm({Key? key}) : super(key: key);

  @override
  _InquiryFormState createState() => _InquiryFormState();
}

class _InquiryFormState extends State<InquiryForm> {

  List<String> cityList = ['基隆','台北','新北市','桃園','新竹','苗栗','台中','彰化','雲林','南投', '嘉義','台南','高雄','屏東','宜蘭','花蓮','台東'];

  String fromCity = '台北';
  String toCity = '台中';

  String startDate = DateFormat("MM/dd EEE").format(DateTime.now().add(const Duration(days: 14)));
  String endDate = DateFormat("MM/dd EEE").format(DateTime.now().add(const Duration(days: 17)));

  TextEditingController numberOfPeople = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text('填寫需求單'),),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
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
                            const Text('出發地：'),
                            getFromCity(),
                            const VerticalDivider(
                              thickness: 2,
                              indent: 12,
                              endIndent: 12,
                              color: AppColor.yellow,
                            ),
                            const Text('目的地：'),
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

                child: const TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  decoration: InputDecoration(
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

                },),
              const Center(child: Text('(如果有業主能承接，會主動聯絡您)',style: TextStyle(fontSize: 14),)),
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
      decoration: const InputDecoration(
        border: InputBorder.none,
        // isDense: true,
        hintText: '10',
      ),
    );
  }


}

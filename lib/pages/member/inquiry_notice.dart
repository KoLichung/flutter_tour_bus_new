import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';



class InquiryNotice extends StatelessWidget {
  // const InquiryNotice({Key? key}) : super(key: key);


  List<FakeInquiryData> fakeDataList = [
    FakeInquiryData(
        issueDate: '2022-01-03',
        passengerName: '王小明',
        passengerPhoneNumber:'0912345678',
        busType:'20人座遊覽車',
        startDate:'2022-02-06',
        endDate:'2022-02-09',
        fromCity:'台中',
        toCity:'苗栗',
        note:'沒有',
        ),
    FakeInquiryData(
      issueDate: '2022-01-03',
      passengerName: '劉小美',
      passengerPhoneNumber:'0912345678',
      busType:'30人座遊覽車',
      startDate:'2022-02-06',
      endDate:'2022-02-09',
      fromCity:'桃園',
      toCity:'苗栗',
      note:'沒有',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('今日租賃需求公告'),),
      body: Column(
        children: [
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: fakeDataList.length,
              itemBuilder:(BuildContext context,int i){
                return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                        child: Text('${fakeDataList[i].issueDate}\n${fakeDataList[i].passengerName}  ${fakeDataList[i].passengerPhoneNumber}\n車型： ${fakeDataList[i].busType}\n租車時間： ${fakeDataList[i].startDate} - ${fakeDataList[i].endDate}\n出發地： ${fakeDataList[i].fromCity} 目的地： ${fakeDataList[i].toCity}\n消費者備註：\n${fakeDataList[i].note}'),
                      ),
                      const Divider(color: AppColor.lightGrey,)

                    ]
                  );

              } ),
        ],


      ),
    );
  }
}

class FakeInquiryData{
  String issueDate;
  String passengerName;
  String passengerPhoneNumber;
  String busType;
  String startDate;
  String endDate;
  String fromCity;
  String toCity;
  String note;

  FakeInquiryData({
    required this.issueDate,
    required this.passengerName,
    required this.passengerPhoneNumber,
    required this.busType,
    required this.startDate,
    required this.endDate,
    required this.fromCity,
    required this.toCity,
    required this.note
  });

}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/widgets/custom_big_outlined_button.dart';
import 'package:flutter_tour_bus_new/widgets/custom_outlined_text.dart';

class DriversBookingDetail extends StatefulWidget {
  const DriversBookingDetail({Key? key}) : super(key: key);

  @override
  State<DriversBookingDetail> createState() => _DriversBookingDetailState();
}

class _DriversBookingDetailState extends State<DriversBookingDetail> {

  List<FakeOrderHistory> fakeOrderList = [
    FakeOrderHistory(passengerName: '王小明',passengerPhoneNumber: '0912345678',issuedate: '2021-12-31', fromCity: '新竹', toCity: '台東',busType:'20人座遊覽車', startDate:'2022-01-06', endDate:'2022-01-09', agentName: '長興旅行社', price: '8000'),
    FakeOrderHistory(passengerName: '陳小明',passengerPhoneNumber: '0912345678',issuedate: '2021-12-31', fromCity: '台南', toCity: '高雄',busType:'30人座遊覽車', startDate:'2022-02-06', endDate:'2022-02-09', agentName: '長興旅行社', price: '5000'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('訂單詳細'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {},
              child:
              const Text('狀態說明', style: TextStyle(fontSize: 15),),),)],),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:AssetImage('images/tour_bus.jpeg',),
                            fit:BoxFit.fill),),
                      height: 75,
                      width: 75,
                    ),
                    GestureDetector(
                      child: CustomOutlinedText(title: '未處理', color: AppColor.pending),
                      onTap: (){},),
                    const Text('(點擊左方按鈕可以修改狀態)',style: TextStyle(color: AppColor.lightGrey,fontSize: 14),),
                  ],
                ),
                const Text('訂單成立時間：'),
                Text('租車日期：${fakeOrderList[0].startDate} ~ ${fakeOrderList[0].endDate}'),
                Text('車輛名稱：${fakeOrderList[0].busType}'),
                Text('出發地：${fakeOrderList[0].fromCity}    目的地：${fakeOrderList[0].toCity}'),
                Text('承租人：${fakeOrderList[0].passengerName}'),
                Text('車輛名稱：${fakeOrderList[0].passengerPhoneNumber}'),
                const Text('備註：'),
                Container(
                  margin: EdgeInsets.only(top: 10),
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
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10)

                    ),

                  ),
                ),
              ],
            ),
          ),
          CustomElevatedButton(
            color: AppColor.yellow,
            title:'確定修改',
            onPressed: (){},),




        ],
      ),
    );
  }
}

class FakeOrderHistory{
  String busType;
  String startDate;
  String endDate;
  String agentName;
  String price;
  String passengerName;
  String passengerPhoneNumber;
  String fromCity;
  String toCity;
  String issuedate;

  FakeOrderHistory({
    required this.busType,
    required this.startDate,
    required this.endDate,
    required this.agentName,
    required this.price,
    required this.passengerName,
    required this.toCity,
    required this.fromCity,
    required this.passengerPhoneNumber,
    required this.issuedate
  });

}



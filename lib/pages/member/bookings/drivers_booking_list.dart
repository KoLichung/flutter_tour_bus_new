import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_outlined_text.dart';



class DriversBookingList extends StatefulWidget {
  const DriversBookingList({Key? key}) : super(key: key);

  @override
  State<DriversBookingList> createState() => _DriversBookingListState();
}

class _DriversBookingListState extends State<DriversBookingList> {

  List<FakeOrderHistory> fakeOrderList = [
    FakeOrderHistory(passengerName: '王小明',passengerPhoneNumber: '0912345678',issuedate: '2021-12-31', fromCity: '新竹', toCity: '台東',busType:'20人座遊覽車', startDate:'2022-01-06', endDate:'2022-01-09', agentName: '長興旅行社', price: '8000'),
    FakeOrderHistory(passengerName: '陳小明',passengerPhoneNumber: '0912345678',issuedate: '2021-12-31', fromCity: '台南', toCity: '高雄',busType:'30人座遊覽車', startDate:'2022-02-06', endDate:'2022-02-09', agentName: '長興旅行社', price: '5000'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('業主訂單列表'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {},
              child:
              const Text('狀態說明', style: TextStyle(fontSize: 15),),),)],),
      body: Column(
        children: [
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: fakeOrderList.length,
              itemBuilder:(BuildContext context,int i){
                return  Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                      trailing: PassengerOrderStatus.pending(context),
                      title: Text(fakeOrderList[i].issuedate),
                      subtitle:
                      Text('${fakeOrderList[i].passengerName} ${fakeOrderList[i].passengerPhoneNumber} \n名稱：${fakeOrderList[i].busType} \n租車日期： ${fakeOrderList[i].startDate}~${fakeOrderList[i].endDate} \n出發地：${fakeOrderList[i].fromCity} 目的地：${fakeOrderList[i].toCity}',style: Theme.of(context).textTheme.bodyText2,),
                    onTap: (){
                        Navigator.pushNamed(context, '/drivers_booking_detail');

                    },
                    ),
                    const Divider(color: AppColor.lightGrey,)],);
              }),],
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

class PassengerOrderStatus {

  static pending(context){
    return GestureDetector(
      onTap: ()=>showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            title: Container(
                padding: const EdgeInsets.all(10),
                color: AppColor.yellow,
                child: const Text('是否接單?',style: TextStyle(color: Colors.white, fontSize: 18),)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CustomOutlinedText(
                    title: '接單',
                    color: AppColor.grey),
                CustomOutlinedText(
                    title: '不接單',
                    color: AppColor.grey),
              ],
            ),
          )),
      child: const CustomOutlinedText(
        color: AppColor.pending,
        title: '是否接訂',
      ),
    );
  }

  static decline(){
    return const CustomOutlinedText(
        title: '不接訂',
        color: AppColor.decline);
  }

  static waitingForPayment(context){
    return const CustomOutlinedText(
        title: '接訂，等待消費者付款',
        color: AppColor.waiting);
  }

  static confirmed(){
    return const CustomOutlinedText(
        title: '消費者已付款，儘速接洽',
        color: AppColor.waiting);
  }

  static onGoing(){
    return const CustomOutlinedText(
        title: '租借中',
        color: AppColor.onGoing);
  }

  static complete(){
    return const CustomOutlinedText(
        title: '已結單',
        color: AppColor.yellow);
  }

}

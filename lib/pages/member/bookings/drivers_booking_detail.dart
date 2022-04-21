import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../models/order.dart';
import 'package:intl/intl.dart';

import '../../../notifier_model/user_model.dart';

class DriversBookingDetail extends StatefulWidget {
  final Order theOrder;

  const DriversBookingDetail({Key? key, required this.theOrder}) : super(key: key);

  @override
  State<DriversBookingDetail> createState() => _DriversBookingDetailState();
}

class _DriversBookingDetailState extends State<DriversBookingDetail> {

  String imageUrl='';
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _httpGetBusImageLink(widget.theOrder.id!);
    memoController.text = widget.theOrder.memo!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('訂單詳細'),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: GestureDetector(
        //       onTap: () {},
        //       child:
        //       const Text('狀態說明', style: TextStyle(fontSize: 15),),),)],
    ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (imageUrl!="")?
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Image.network(imageUrl,fit: BoxFit.cover,),
                      height: 100,
                      width: 100,
                    ),
                    // GestureDetector(
                    //   child: CustomOutlinedText(title: '未處理', color: AppColor.pending),
                    //   onTap: (){},),
                    // const Text('(點擊左方按鈕可以修改狀態)',style: TextStyle(color: AppColor.lightGrey,fontSize: 14),),
                  ],
                ):
                Container(),
                const Text('訂單成立時間：'),
                Text('租車日期：${DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.theOrder.startDate!))}~${DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.theOrder.endDate!))}'),
                Text('車輛名稱：${widget.theOrder.busTitle}'),
                Text('出發地：${widget.theOrder.depatureCity}    目的地：${widget.theOrder.destinationCity}'),
                Text('承租人：${widget.theOrder.name}'),
                Text('承租人電話：${widget.theOrder.phone}'),
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

                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    controller: memoController,
                    decoration: const InputDecoration(
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
            title:'確定修改備註',
            onPressed: (){
              var userModel = context.read<UserModel>();
              _httpPostUpdateOrderMemo(userModel.token!, widget.theOrder.id!, memoController.text);
            }),

        ],
      ),
    );
  }

  Future _httpGetBusImageLink(int orderId) async {
    String path = Service.GET_ORDER_IMAGE;
    try {
      final queryParams = {
        "order_id":orderId.toString(),
      };

      final response = await http.get(Service.standard(path: path,queryParameters: queryParams));

      if (response.statusCode == 200) {
        // print(response.body);
        Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
        print(map['image']);

        imageUrl = Service.standard(path: map['image']).toString();
        setState(() {});

      }
    } catch (e) {
      print(e);
    }
  }

  Future _httpPostUpdateOrderMemo(String userToken, int orderId, String memo) async {

    String path = Service.OWNER_UPDATE_MEMO;
    try {
      final bodyParams = {
        "memo": memo,
        "order_id": orderId.toString(),
      };

      final response = await http.post(Service.standard(path: path),
        headers: <String, String>{
          'Authorization': 'token $userToken'
        },
        body: bodyParams,
      );

      print(response.body);
      if (response.statusCode == 200) {
        print("success update order memo");
        Navigator.pop(context,"ok");
      }
    } catch (e) {
      print(e);
    }
  }

}




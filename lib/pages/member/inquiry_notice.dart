import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/models/announcement.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;

class InquiryNotice extends StatefulWidget {

  const InquiryNotice({Key? key}) : super(key: key);

  @override
  _InquiryNoticeSate createState() => _InquiryNoticeSate();
}

class _InquiryNoticeSate extends  State<InquiryNotice> {

  List<Announcement> announcementList = [];

  @override
  void initState() {
    super.initState();
    _httpGetAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('租賃需求公告'),),
      body: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: announcementList.length,
              itemBuilder:(BuildContext context,int i){
                return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                        child: Text('${announcementList[i].announceDateTime!.substring(0,10)}\n'
                            '${announcementList[i].name} ${announcementList[i].phone}\n車型： ${announcementList[i].numbersOfPeople}\n'
                            '租車時間： ${announcementList[i].startDateTime!.substring(0,10)}~${announcementList[i].endDateTime!.substring(0,10)}\n'
                            '出發地： ${announcementList[i].depatureCity} 目的地： ${announcementList[i].destinationCity}\n'
                            '消費者備註：\n${announcementList[i].memo}'),
                      ),
                      const Divider(color: AppColor.lightGrey,)

                    ]
                  );

              } ),
      );
  }

  Future _httpGetAnnouncements() async {

    String path = Service.ANNOUNCEMENT;
    try {
      final response = await http.get(Service.standard(path: path));
      // print(response.body);

      if (response.statusCode == 200) {
        // print(response.body);
        List<dynamic> dataList = json.decode(utf8.decode(response.body.runes.toList()));
        announcementList = dataList.map((value) => Announcement.fromJson(value)).toList();
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }
}

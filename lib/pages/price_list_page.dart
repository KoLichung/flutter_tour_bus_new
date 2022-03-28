import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';

class PriceListPage extends StatefulWidget {
  const PriceListPage({Key? key}) : super(key: key);

  @override
  _PriceListPageState createState() => _PriceListPageState();
}

class _PriceListPageState extends State<PriceListPage> {

  String price =
  '''遊覽車價目表
  
車資
平日 \$11000/天
假日 \$12000/天

司機
\$2000/天
''';

  String priceNote =
      '''以上費用不含食宿、過路費、停車費，若有無法安排食宿的話需補貼：
平日\$1500/晚、假日\$2000/晚
誤餐費\$200/餐

如有需要導遊請提前詢問司機
用車時間 12小時/天，超過時間每小時加收 \$1000，未滿 1 小時以 1 小時算

里程數每天 300 公里，可合併天數計算。超過 20 公里加收 \$1000，未滿 20 公里以 20 公里計算。

確定訂車後需付訂金 \$2500/天 合約才會生效，行程結束時需付清尾款。''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('價位表'),),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.yellow, width: 2,),
            borderRadius: BorderRadius.circular(4),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(price, textAlign:TextAlign.center,style: Theme.of(context).textTheme.bodyText1,),
              Text(priceNote),

            ],),),
      ),
    );

  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:provider/provider.dart';
import '../../models/bus.dart';

import '../../models/order.dart';
import '../../notifier_model/user_model.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;

class RentalAgreement extends StatefulWidget {

  final Bus theBus;
  final String fromCity;
  final String toCity;
  final DateTime startDate;
  final DateTime endDate;

  const RentalAgreement({Key? key, required this.theBus, required this.fromCity, required this.toCity, required this.startDate, required this.endDate}) : super(key: key);

  @override
  _RentalAgreementState createState() => _RentalAgreementState();
}

class _RentalAgreementState extends State<RentalAgreement> {

  bool isAgreementChecked = false;

  @override
  Widget build(BuildContext context) {

    var userModel = context.read<UserModel>();

    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String startDate = formatter.format(widget.startDate);
    String endDate = formatter.format(widget.endDate);

    var rentalDays = (widget.endDate.difference(widget.startDate)).inDays+1;

    int finalPayment = _getDaysInterval()*11000 - _getDaysInterval()*1000;

    String agreementText = '''立契約書人
承租人（以下簡稱甲方）${userModel.user?.name}
出租人（以下簡稱乙方）${widget.theBus.company}，茲為遊覽車租賃事宜，雙方同意本契約條款如下：

第 一 條  
本契約租賃車輛（以下簡稱本車輛，不含隨車服務人員）租賃期間自 $startDate 起至 $endDate 止，共計 $rentalDays 天。

第 二 條  
租金計算（含營業稅）同價格表。

第 三 條  
租金給付時間：於簽約時預付定金（不得高於租金總額百分之二十），租金餘額於行程結束後給付。

第 四 條  
車輛基本資料：
一、車號：${widget.theBus.vehicalLicence}
二、座位數：${widget.theBus.vehicalSeats}（與行照記載相符）
三、出廠年份：${widget.theBus.vehicalYearOfManufacture!}

第 五 條  
車輛油費、車輛耗材費及車輛違反公路法、汽車運輸業管理規則及道路交通管理處罰條例等法規之罰鍰費用由乙方負擔。

第 六 條  
報到與出車之時間應由甲方告知，並由雙方協議合法停等地點；如未能準時報到及出車，致損害甲方權益，應由乙方依第九條所定方式負賠償責任，但可歸責於甲方之事由者，不在此限。

租賃期間行程安排之路線有行經公路主管機關公告之應特別注意路段時，遊覽車客運業者應告知承租人，並不得安排行駛公路主管機關公告之禁行路段。（相關禁行路段及應特別注意路段公告可至交通部公路總局網站監理服務項下業者資訊內之遊覽車項下查詢，網址：http://www.thb.gov.tw）

乙方應記載行程、路線及休息地點。

未經甲、乙雙方同意，不得變更行程、路線及休息地點，另雙方同意變更後之行程不得違反相關工作及駕駛時間法令規定。

第 七 條　　
乙方應於出車前，確使所有乘客知悉該款式車輛安全設施、逃生設備位置及使用方法、宣導遵守交通法規規定，並維護車輛整潔及雙方約定（如附服務項目表）應提供之服務。
　・乘客如有違反交通法規規定之要求，駕駛員應予拒絕。
　・乙方所屬駕駛員及隨車服務人員不得主動向乘客兜售或媒介商品或其他服務。
　・乘客非必要時不得任意取下或碰撞車內安全設備，並嚴禁攜帶違禁品、危險品上車。
乙方應依交通部公路總局訂定之「機關、團體租（使）用遊覽車出發前檢查及逃生演練紀錄表」填列相關資料後，交由甲方或其授權之人核對及收執。
租賃期間遇相關主管機關執行稽查時，駕駛員及乘客應配合辦理其作業。

第 八 條　　
乙方駕駛員應於行程前及行程中各休息站（點）、遊憩點行車前實施酒精檢測，並經甲方或其指定人確認駕駛員未有飲酒情事，方得行駛。駕駛員經檢測未能通過時，甲方得要求乙方於一小時內更換駕駛員，或暫緩旅遊行程進行，其所致延誤行程或不能完成預定行程，除當日不得收費外，應由乙方依所收費用總額每日平均之數額負賠償責任。
　・甲方如能證明損害超過前項數額者，乙方就超過部分仍應負損害賠償責任。

第 九 條　　
乙方應擔保駕駛員為合格駕駛員，簽約時應出示有效之遊覽車客運業駕駛人登記證與行車執照等證明文件供查驗，並檢附公立醫院或衛生機關或公路監理機關指定醫院出具之一年內有效之合格健康證明書（內含一般考照體檢、心血管疾病及血壓檢查）及駕駛員之交通違規紀錄（可逕上交通部公路總局之監理服務網項下之業者資訊查詢，網址：https://www.mvdis.gov.tw）。
　・倘乙方於行車前因故需更換駕駛員，亦應出示前項相關證明文件。

第十條　　
租賃期間乙方派任駕駛員駕駛車輛營業時，除應符合勞動基準法等相關法令關於工作時間之規定外，其調派單一駕駛員勤務並應符合下列規定：
（一）每日自工作開始至結束之時間不得超過十二小時；每日最多駕車時間不得超過十小時。
（二）連續駕車四小時，至少應有三十分鐘休息，休息時間如採分次實施者每次應不得少於十五分鐘。但因工作具連續性或交通壅塞者，得另行調配休息時間；其最多連續駕車時間不得超過六小時，且休息須一次休滿四十五分鐘。
（三）連續兩個工作日之間，應有連續十小時以上休息時間。但因排班需要，得調整為連續八小時以上，一週以二次為限，並不得連續為之。

第十一條　　
租賃期間車輛發生故障時應由乙方於一小時內接駁至下一地點，於二小時內提供同品質之車輛使用，並提供適當之飲料或餐點；其致延誤行程或不能完成預定行程者，應由乙方依第九條所定方式負賠償責任。

第十二條　　
車輛於租賃期間發生事故時，乙方應即派人協助處理乘客相關善後事宜。若乙方有歸責事由時，應負賠償責任。

第十三條　　
本契約簽訂後，如因可歸責於乙方之事由而解約者，乙方應加倍返還定金；如因可歸責於甲方之事由而解約者，甲方得依下列標準要求乙方返還已繳之定金：
一、預定用車日 30 日前通知解約，得請求返還已付定金百分之百，需扣除手續費。
二、預定用車日 15 日內通知解約，得請求返還已付定金百分之五十。
三、預定用車日 7 日內通知解約，不得要求返還已付定金。

第十四條　　
因臨時道路障礙、天災事變等不可抗力因素或其他不可歸責於雙方當事人之事由，致乙方無法出車，甲方得解除契約，並請求退還其預付定金。

第十五條　　
乙方出車後，因臨時道路障礙、其他天災事變等不可抗力因素，致未能完成預定行程者，雙方得就行程、路線、休息地點另行約定，乙方不負債務不履行責任。

第十六條　　
甲方欲續租本車輛時，應事先聯繫並取得乙方之同意，且不得非法使用。

第十七條　　
本車輛已投保強制汽車責任保險及乘客責任保險，不低於主管機關公告之金額。

第十八條　　
因本契約發生訴訟時，甲、乙雙方同意以ＯＯＯ地方法院為第一審管轄法院，但如為小額訴訟時，依民事訴訟法規定辦理，亦不得排除消費者保護法第四十七條規定之適用

第十九條　　
本契約如有未訂事宜，依相關法令、法理、習慣及誠信原則公平解決之。

第二十條　
甲、乙雙方如有必要可另訂協議規範之。

第二十一條　
本契約一式二份，由甲、乙雙方各執一份為憑。''';

    return Scaffold(
        appBar: AppBar(
          title: const Text('包遊覽車'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0,20,0,10),
                padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                height: 500,
                width: 370,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.grey
                  ),
                ),
                child:SingleChildScrollView(
                    child: Text(agreementText))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Row(children: [
                  Checkbox(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                      ),
                      value: isAgreementChecked,
                      onChanged: (bool? value){
                        setState(() {
                          isAgreementChecked = value!;
                        });
                      }),
                  const Text('同意此租賃合約書')
                ],),
              ),
              const Divider(
                color: AppColor.superLightGrey,
                thickness: 8,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                child: Column(
                  children: [
                    Align(alignment: Alignment.centerLeft,child: Text('租車內容：',style: Theme.of(context).textTheme.bodyText1,)),
                    Row(children: [
                      Align(alignment: Alignment.centerLeft,child: Text(widget.theBus.title!,style: Theme.of(context).textTheme.bodyText1,)),
                      // Align(alignment: Alignment.centerLeft,child: Text('  ${fakeResult[1].agentName}',style: const TextStyle(color: Colors.grey),)),
                    ],),
                    Row(children: [
                      Text('年份：${widget.theBus.vehicalYearOfManufacture!}'),
                      const SizedBox(width: 20,),
                      Text('座位：${widget.theBus.vehicalSeats} 人'),
                    ],),
                    Align(alignment: Alignment.centerLeft,child: Text('${DateFormat('MM / dd EEE').format(widget.startDate)} - ${DateFormat('MM / dd EEE').format(widget.endDate)}')),
                    Row(children: [
                      // const Align(alignment: Alignment.centerLeft,child: Text('App優惠價 '),),
                      // Align(alignment: Alignment.centerLeft,child: Text('\$${_getDaysInterval()*11000}',style: Theme.of(context).textTheme.subtitle2,),),
                      Align(alignment: Alignment.centerLeft,child: Text(' (訂金 ${_getDaysInterval()*1000})'),),
                    ],),

                  ],
                ),
              ),
              const Divider(
                color: AppColor.superLightGrey,
                thickness: 8,
              ),
              CustomElevatedButton(
                color: AppColor.yellow,
                title: '確認，下訂單',
                onPressed: (){
                  if(isAgreementChecked) {
                    var userModel = context.read<UserModel>();

                    Order theOrder = Order();
                    theOrder.tourBus = widget.theBus.id;
                    theOrder.startDate = DateFormat('yyyy-MM-dd').format(widget.startDate);
                    theOrder.endDate = DateFormat('yyyy-MM-dd').format(widget.endDate);
                    theOrder.depatureCity = widget.fromCity;
                    theOrder.destinationCity = widget.toCity;
                    theOrder.orderMoney = _getDaysInterval()*11000;
                    theOrder.depositMoney = _getDaysInterval()*1000;
                    // print(userModel.token!);
                    _httpPostCreateOrder(theOrder, userModel.token!);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請先勾選同意租賃合約書！"),));
                  }
                },),
              const SizedBox(height: 20,)
            ],
          ),
        )
    );
  }

  int _getDaysInterval(){
    return (-widget.startDate.difference(widget.endDate).inDays)+1;
  }

  Future _httpPostCreateOrder(Order theOrder, String token) async {

    String path = Service.ORDERS;

    try {
      Map queryParameters = {
        'tourBus': theOrder.tourBus,
        'startDate': theOrder.startDate!+"T00:00:00Z",
        'endDate': theOrder.endDate!+"T00:00:00Z",
        'depatureCity': theOrder.depatureCity!,
        'destinationCity': theOrder.destinationCity!,
        'orderMoney': theOrder.orderMoney,
        'depositMoney': theOrder.depositMoney,
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
        Navigator.pushNamed(context, '/rental_confirmation');
      }
    } catch(e){
      print(e);
    }
  }

}

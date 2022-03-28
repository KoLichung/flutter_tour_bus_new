import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class EditBusProfile extends StatefulWidget {
  const EditBusProfile({Key? key}) : super(key: key);

  @override
  _EditBusProfileState createState() => _EditBusProfileState();
}

enum BusListStatus { on, off }

class _EditBusProfileState extends State<EditBusProfile> {

  List<String> cityList = ['基隆','台北','新北市','桃園','新竹','苗栗','台中','彰化','雲林','南投', '嘉義','台南','高雄','屏東','宜蘭','花蓮','台東'];
  List<String> districtList = ['信義區','大安區','萬華區'];

  String locationCity = '台北';
  String locationDistrict = '信義區';

  BusListStatus? _busListStatus = BusListStatus.on;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('修改汽車'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              getBusListStatus(),
              driverInputRow('標題：'),
              driverInputRow('牌照：'),
              driverInputRow('車主：'),
              driverInputRow('引擎號碼：'),
              driverInputRow('車身號碼：'),
              driverInputRow('座位數：'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 6),
                child: Row(
                  children: [
                    const Text('所在位置：'),
                    getLocationCity(),
                    getLocationDistrict()
                  ],),
              ),
              imageUploadButton('上傳行照：'),
              imageUploadButton('外觀照片(1~5張)：'),
              imageUploadButton('內裝照片(1~5張)：'),
              imageUploadButton('行李箱(1張)：'),
              CustomElevatedButton(
                title: '確定新增',
                color: AppColor.yellow,
                onPressed: (){},
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ));
  }

  getBusListStatus(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 2),
      child: Row(
        children: [
          Radio<BusListStatus>(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
            ),
            value: BusListStatus.on,
            groupValue: _busListStatus,
            onChanged: (BusListStatus? value){
              setState(() {
                _busListStatus = value;
              });
            },
            activeColor: Colors.black54,
          ),
          const Text('上架'),
          const SizedBox(width: 20,),
          Radio<BusListStatus>(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
            ),
            value: BusListStatus.off,
            groupValue: _busListStatus,
            onChanged: (BusListStatus? value){
              setState(() {
                _busListStatus = value;
              });
            },
            activeColor: Colors.black54,
          ),
          const Text('下架')
        ],
      ),
    );
  }

  driverInputRow(String title){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 2),
      child: Row(
        children: [
          Text(title),
          Expanded(
            child: Container(
              margin: const  EdgeInsets.symmetric(horizontal: 10,vertical: 6),
              height: 46,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black54,
                  width: 1,),
                borderRadius: BorderRadius.circular(4),),
              child: const TextField(
                style: TextStyle(fontSize: 18),
                // controller: controller,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }

  imageUploadButton(String title){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 8),
      child: Column(
        children: [
          Align(
              alignment:Alignment.centerLeft
              ,child: Text(title)),
          const SizedBox(height: 8,),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              child: const Icon(Icons.photo_camera_outlined,color: AppColor.grey,),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                side: const BorderSide(
                  color: AppColor.grey,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              onPressed: (){},
            ),
          ),
        ],
      ),
    );
  }

  getLocationCity(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColor.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            isDense: true,
            itemHeight: 50,
            value: locationCity,
            onChanged:(String? newValue){
              setState(() {
                locationCity = newValue!;
              });
            },
            items: cityList.map<DropdownMenuItem<String>>((String value) {return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );}).toList()

        ),
      ),
    );


  }
  getLocationDistrict(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColor.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            isDense: true,
            itemHeight: 50,
            value: locationDistrict,
            onChanged:(String? newValue){
              setState(() {
                locationDistrict = newValue!;
              });
            },
            items: districtList.map<DropdownMenuItem<String>>((String value) {return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );}).toList()

        ),
      ),
    );
  }




}

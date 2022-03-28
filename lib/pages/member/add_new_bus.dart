import 'package:flutter/cupertino.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tour_bus_new/widgets/image_upload_button.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tour_bus_new/models/order.dart';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tour_bus_new/models/bus.dart';



class AddNewBus extends StatefulWidget {
  const AddNewBus({Key? key}) : super(key: key);

  @override
  _AddNewBusState createState() => _AddNewBusState();
}

class _AddNewBusState extends State<AddNewBus> {

  List<String> cityList = ['基隆','台北','新北市','桃園','新竹','苗栗','台中','彰化','雲林','南投', '嘉義','台南','高雄','屏東','宜蘭','花蓮','台東'];
  List<String> districtList = ['信義區','大安區','萬華區'];

  String locationCity = '台北';
  String locationDistrict = '信義區';

  TextEditingController carTitleController = TextEditingController();
  TextEditingController licenseController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController engineNumController = TextEditingController();
  TextEditingController bodyNumController = TextEditingController();
  TextEditingController seatNumController = TextEditingController();

  XFile? licenseImage;
  List<XFile>? outLookImageList = [];
  List<XFile>? interiorImageList = [];
  XFile? storageImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('新增汽車'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              driverInputRow('標題：',carTitleController),
              driverInputRow('牌照：',licenseController),
              driverInputRow('車主：',ownerController),
              driverInputRow('引擎號碼：',engineNumController),
              driverInputRow('車身號碼：',bodyNumController),
              driverInputRow('座位數：',seatNumController),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 6),
                child: Row(
                  children: [
                    const Text('所在位置：'),
                    getLocationCity(),
                    getLocationDistrict()
                ],),
              ),
              Row(
                children: [
                  ImageUploadButton(
                      title: '上傳行照：',
                      onPressed: ()async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

                        if(pickedFile == null) return;

                        licenseImage = pickedFile;

                        setState(() {});

                      }),
                  licenseImage == null ? SizedBox() : Container(
                    margin: const EdgeInsets.fromLTRB(0,30,0,8),
                    height: 60, width: 60,
                    child: Image.file(File(licenseImage!.path),fit: BoxFit.cover,),
                  ),],),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageUploadButton(
                      title: '外觀照片(1~5張)：',
                      onPressed: ()async {
                        final ImagePicker _picker = ImagePicker();
                        final List<XFile>? pickedFile = await _picker.pickMultiImage(
                          // source: ImageSource.gallery,
                          // maxWidth: maxWidth,
                          // maxHeight: maxHeight,
                        );

                        if(pickedFile == null) return;
                        if(pickedFile.isNotEmpty){
                          outLookImageList!.addAll(pickedFile);
                        }

                        pickedFile;
                        print('image list length' + outLookImageList!.length.toString());

                        setState(() {});

                      }),
                  outLookImageList!.isEmpty ? SizedBox() : Container(
                    margin: const EdgeInsets.fromLTRB(30,0,0,0),
                    height: 60,
                    // width: 200,
                    child:
                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: outLookImageList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Image.file(File(outLookImageList![index].path),
                                fit: BoxFit.cover,
                                width: 60,
                              ),
                            );
                          }),

                  ),
                ],
              ),
              ImageUploadButton(
                  title: '內裝照片(1~5張)：',
                  onPressed: ()async {
                    final ImagePicker _picker = ImagePicker();
                    final List<XFile>? pickedFiles = await _picker.pickMultiImage(
                      // source: ImageSource.gallery,
                      // maxWidth: maxWidth,
                      // maxHeight: maxHeight,
                    );

                    if(pickedFiles == null) return;
                    if(pickedFiles.isNotEmpty){
                      interiorImageList!.addAll(pickedFiles);
                    }

                    setState(() {});

                  }),
              // ImageUploadButton('外觀照片(1~5張)：'),
              // ImageUploadButton('內裝照片(1~5張)：'),
              // ImageUploadButton('行李箱(1張)：'),
              CustomElevatedButton(
                title: '確定新增',
                color: AppColor.yellow,
                onPressed: (){
                  // postCreateNewCar(licenseImage);
                  uploadImage(licenseImage);
                  // uploadImage();
                  // if (carTitleController.text != '' && licenseController.text != '' && engineNumController.text != ''
                  //     && bodyNumController.text!= '' && seatNumController.text!= '' && ownerController.text!= ''){
                  //   _postToCreateCar(carTitleController.text, licenseController.text, ownerController.text);
                  // }
                },
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ));
  }

  driverInputRow(String title, TextEditingController controller){
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
              child: TextField(
                style: const TextStyle(fontSize: 18),
                controller: controller,
                decoration: const InputDecoration(
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

  Future uploadImage(XFile? image)async{

    var userModel = context.read<UserModel>();
    String path = Service.BUSSES;
    var request = http.MultipartRequest('POST', Service.standard(path: path));
    print(request);


    request.fields['user']='1';
    request.fields['vehicalLicenceImage']='ttttttttest';

    // request.headers.addAll({'Content-Type': 'multipart/form-data; charset=UTF-8', 'Authorization': 'token ${userModel.user?.token}'});
    request.headers['Authorization']= 'token ${userModel.user?.token}';

    final file = await http.MultipartFile.fromPath('vehicalLicenceImage', image!.path, filename: 'test image');

    request.files.add(file);

    var response = await request.send();
    print(response.headers);
    print(response.statusCode);

  }


  Future postCreateNewCar(XFile? image) async {

    var userModel = context.read<UserModel>();
    String path = Service.BUSSES;

    var request = http.MultipartRequest('POST', Service.standard(path: path));
    print(request);


    request.fields['vehicalLicenceImage']='ttttttttest';

    // request.headers.addAll({'Content-Type': 'multipart/form-data; charset=UTF-8', 'Authorization': 'token ${userModel.user?.token}'});
    request.headers['Authorization']= 'token ${userModel.user?.token}';

    final file = await http.MultipartFile.fromPath('vehicalLicenceImage', image!.path, filename: 'test image');

    request.files.add(file);


    try {
      Map queryParameters = {
        'title': '測試',
        'lat': "25.011410",
        'lng': "121.461842",
        'city': '桃園市',
        'county': '桃園市',
        'vehicleSeats': '100',
        'vehicleLicence': 'test licence',
        'vehicleOwner': 'test owner',
        'vehicleEngineNumber': 'test number',
        'vehicleBodyNumber': 'test number',
        // 'vehicleLicenceImage':'',
        'isPublish': true,
        'user':1,
      };

      final response = await http.post(Service.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'token ${userModel.user?.token}'
          },
          body: jsonEncode(queryParameters)
      );
      print(response.body);
      print(response.statusCode);

    } catch(e){
      print(e);
    }





  }




}

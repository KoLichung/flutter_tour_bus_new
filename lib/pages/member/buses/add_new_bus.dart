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

import '../../../models/city.dart';
import '../../../models/county.dart';



class AddNewBus extends StatefulWidget {
  const AddNewBus({Key? key}) : super(key: key);

  @override
  _AddNewBusState createState() => _AddNewBusState();
}

class _AddNewBusState extends State<AddNewBus> {

  List<String> cityList = City.getCityNames();
  List<String> districtList = County.getCountyNames(1);

  String locationCity = '台北市';
  String locationDistrict = '中正區';

  TextEditingController carTitleController = TextEditingController();
  TextEditingController licenseController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController engineNumController = TextEditingController();
  TextEditingController bodyNumController = TextEditingController();
  TextEditingController seatNumController = TextEditingController();

  XFile? licenseImage;

  List<XFile> outLookImageList = [];
  List<XFile> interiorImageList = [];
  XFile? luggageImage;

  bool isLoading = false;

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
              driverInputRow('標題：',carTitleController, false),
              driverInputRow('牌照：',licenseController, false),
              driverInputRow('車主：',ownerController, false),
              driverInputRow('引擎號碼：',engineNumController, false),
              driverInputRow('車身號碼：',bodyNumController, false),
              driverInputRow('座位數：',seatNumController, true),
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
                          outLookImageList.addAll(pickedFile);
                        }

                        pickedFile;
                        print('image list length' + outLookImageList.length.toString());

                        setState(() {});

                      }),
                  outLookImageList.isEmpty ? SizedBox() : Container(
                    margin: const EdgeInsets.fromLTRB(30,0,0,0),
                    height: 60,
                    // width: 200,
                    child:
                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: outLookImageList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Image.file(File(outLookImageList[index].path),
                                fit: BoxFit.cover,
                                width: 60,
                              ),
                            );
                          }),

                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageUploadButton(
                      title: '內裝照片(1~5張)：',
                      onPressed: ()async {
                        final ImagePicker _picker = ImagePicker();
                        final List<XFile>? pickedFile = await _picker.pickMultiImage(
                          // source: ImageSource.gallery,
                          // maxWidth: maxWidth,
                          // maxHeight: maxHeight,
                        );

                        if(pickedFile == null) return;
                        if(pickedFile.isNotEmpty){
                          interiorImageList.addAll(pickedFile);
                        }

                        pickedFile;
                        print('image list length' + outLookImageList.length.toString());

                        setState(() {});

                      }),
                  interiorImageList.isEmpty ? SizedBox() : Container(
                    margin: const EdgeInsets.fromLTRB(30,0,0,0),
                    height: 60,
                    // width: 200,
                    child:
                    ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: interiorImageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Image.file(File(interiorImageList[index].path),
                              fit: BoxFit.cover,
                              width: 60,
                            ),
                          );
                        }),

                  ),
                ],
              ),
              Row(
                children: [
                  ImageUploadButton(
                      title: '行李箱(1張)：',
                      onPressed: ()async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

                        if(pickedFile == null) return;

                        luggageImage = pickedFile;

                        setState(() {});

                      }),
                  luggageImage == null ? SizedBox() : Container(
                    margin: const EdgeInsets.fromLTRB(0,30,0,8),
                    height: 60, width: 60,
                    child: Image.file(File(luggageImage!.path),fit: BoxFit.cover,),
                  ),],),
              CustomElevatedButton(
                title: '確定新增',
                color: AppColor.yellow,
                onPressed: (){
                  if (carTitleController.text != '' && licenseController.text != '' && engineNumController.text != ''
                      && bodyNumController.text!= '' && seatNumController.text!= '' && ownerController.text!= ''){
                    var userModel = context.read<UserModel>();

                    Bus theBus = Bus();
                    theBus.title = carTitleController.text;
                    theBus.city = locationCity;
                    theBus.county = locationDistrict;
                    theBus.vehicalSeats = int.parse(seatNumController.text);
                    theBus.vehicalLicence = licenseController.text;
                    theBus.vehicalOwner = ownerController.text;
                    theBus.vehicalEngineNumber = engineNumController.text;
                    theBus.vehicalBodyNumber = bodyNumController.text;

                    _postCreateNewCar(theBus, userModel.token!);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("各項資料不可空白！"),));
                  }

                  // _uploadImage(licenseImage);
                  // uploadImage();

                },
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ));
  }

  driverInputRow(String title, TextEditingController controller, bool isNumberOnly){
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
              child:
              (!isNumberOnly)?
              TextField(
                style: const TextStyle(fontSize: 18),
                controller: controller,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              )
              :
              TextField(
                style: const TextStyle(fontSize: 18),
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              )
              ,
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
              districtList = County.getCountyNames(City.getCityFromName(newValue).id!);
              locationDistrict = districtList.first;
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

  // List<XFile>? outLookImageList = [];
  // List<XFile>? interiorImageList = [];
  // XFile? luggageImage;

  Future _uploadImageList(int busId)async{
    String path = Service.TOUR_BUS_IMAGES;

    for (XFile image in outLookImageList){
      var request = http.MultipartRequest('POST', Service.standard(path: path));
      final file = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(file);
      request.fields['tourBus'] = busId.toString();
      request.fields['type'] = 'exterior';
      var response = await request.send();
      print(response.statusCode);
    }

    for (XFile image in interiorImageList){
      var request = http.MultipartRequest('POST', Service.standard(path: path));
      final file = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(file);
      request.fields['tourBus'] = busId.toString();
      request.fields['type'] = 'interior';
      var response = await request.send();
      print(response.statusCode);
    }

    var request = http.MultipartRequest('POST', Service.standard(path: path));
    final file = await http.MultipartFile.fromPath('image', luggageImage!.path);
    request.files.add(file);
    request.fields['tourBus'] = busId.toString();
    request.fields['type'] = 'luggage';
    var response = await request.send();
    print(response.statusCode);


  }

  Future _uploadLicenceImage(XFile? image, String token, int busId)async{
    print("here to upload image");
    String path = Service.BUSSES+'$busId/';
    var request = http.MultipartRequest('PUT', Service.standard(path: path));

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    request.headers.addAll(headers);

    final file = await http.MultipartFile.fromPath('vehicalLicenceImage', image!.path);

    request.files.add(file);
    request.fields['isPublish'] = 'true';

    var response = await request.send();
    // print(response.headers);
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      Map<String, dynamic> map = json.decode(value);
      if(map['title']!=null){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("成功更新！"),));
        // Navigator.pop(context);
        _uploadImageList(busId);
      }else{
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("無法更新資料 請檢察網路！"),));
      }
    });
  }

  Future _postCreateNewCar(Bus theBus, String token) async {

    String path = Service.BUSSES;

    County theCounty = County.getCountyFromName(theBus.county!);

    try {
      Map queryParameters = {
        'title': theBus.title,
        'lat': theCounty.lat,
        'lng': theCounty.lng,
        'city': theBus.city,
        'county': theBus.county,
        'vehicalSeats': theBus.vehicalSeats,
        'vehicalLicence': theBus.vehicalLicence,
        'vehicalOwner': theBus.vehicalOwner,
        'vehicalEngineNumber': theBus.vehicalEngineNumber,
        'vehicalBodyNumber': theBus.vehicalBodyNumber,
        'isPublish': true,
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
      if(map['title']!=null){
        _uploadLicenceImage(licenseImage, token, map['id']);
      }
      print(response.statusCode);

    } catch(e){
      print(e);
    }
  }

}
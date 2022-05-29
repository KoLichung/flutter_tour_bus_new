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
import 'add_new_bus_delete_photo_dialog.dart';
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
  // TextEditingController engineNumController = TextEditingController();
  // TextEditingController bodyNumController = TextEditingController();
  TextEditingController seatNumController = TextEditingController();
  TextEditingController yearManufactureController = TextEditingController();

  XFile? driverlicenseImage;
  XFile? licenseImage;

  List<XFile> outLookImageList = [];
  List<XFile> interiorImageList = [];

  XFile? luggageImage;

  bool isLoading = false;

  double maxWidth = 640;
  double maxHeight= 480;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('新增汽車'),
        ),
        body:  (isLoading)?
            Center(
              child:Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(height: 40),
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("資料上傳中，請稍候..."),
                ],
              ),
            )
        :
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              driverInputRow('標題：',carTitleController, false),
              Container(child: Text("(標題請勿輸入數字)"),width: double.infinity,margin: const EdgeInsets.symmetric(horizontal: 30) ),
              driverInputRow('牌照：',licenseController, false),
              driverInputRow('車主：',ownerController, false),
              // driverInputRow('引擎號碼：',engineNumController, false),
              // driverInputRow('車身號碼：',bodyNumController, false),
              driverInputRow('座位數：',seatNumController, true),
              driverInputRow('出廠年份：',yearManufactureController, true),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 6),
                child: Row(
                  children: [
                    const Text('所在位置：'),
                    getLocationCity(),
                    getLocationDistrict()
                ],),
              ),
              imageUploadButtonTitle('上傳駕照：'),
              Row(
                children: [
                  ImageUploadButton(
                      onPressed: ()async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: maxWidth, maxHeight: maxHeight);

                        if(pickedFile == null) return;

                        driverlicenseImage = pickedFile;

                        setState(() {});

                      }),
                  driverlicenseImage == null ? SizedBox() : Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(0,6,0,6),
                            height: 60, width: 60,
                            child: Image.file(File(driverlicenseImage!.path),fit: BoxFit.cover,)),
                        Positioned(
                          top: 8,
                          right: 2,
                          child: GestureDetector(
                            onTap: () async {
                              var data = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AddNewBusDeletePhotoDialog();
                                  });
                              if (data == 'confirmDelete'){
                                setState(() {
                                  driverlicenseImage = null;
                                });
                              }
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              child: const Icon(Icons.clear, size: 14,color: Colors.white,),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red),
                            ),
                          ),
                        )
                      ]
                  ),],),
              imageUploadButtonTitle('上傳行照：'),
              Row(
                children: [
                  ImageUploadButton(
                      onPressed: ()async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: maxWidth, maxHeight: maxHeight);

                        if(pickedFile == null) return;

                        licenseImage = pickedFile;

                        setState(() {});

                      }),
                  licenseImage == null ? SizedBox() : Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0,6,0,6),
                        height: 60, width: 60,
                        child: Image.file(File(licenseImage!.path),fit: BoxFit.cover,)),
                      Positioned(
                        top: 8,
                        right: 2,
                        child: GestureDetector(
                          onTap: () async {
                            var data = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddNewBusDeletePhotoDialog();
                                });
                            if (data == 'confirmDelete'){
                              setState(() {
                                licenseImage = null;
                              });
                            }
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            child: const Icon(Icons.clear, size: 14,color: Colors.white,),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red),
                          ),
                        ),
                      )
                    ]
                  ),],),
              imageUploadButtonTitle('外觀照片(1~2張)：'),
              Row(
                children: [
                  ImageUploadButton(

                      onPressed: ()async {
                        final ImagePicker _picker = ImagePicker();
                        final List<XFile>? pickedFile = await _picker.pickMultiImage(
                          // source: ImageSource.gallery,
                          maxWidth: maxWidth,
                          maxHeight: maxHeight,
                        );

                        if(pickedFile == null) return;
                        if(pickedFile.isNotEmpty){
                          for(XFile file in pickedFile){
                            if(outLookImageList.length < 2){
                              outLookImageList.add(file);
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("外觀照片需少於等於 2 張！"),));
                            }
                          }
                        }

                        pickedFile;
                        print('image list length' + outLookImageList.length.toString());

                        setState(() {});

                      }),
                  outLookImageList.isEmpty ? SizedBox() : Expanded(
                    child:
                        Container(
                          margin: const EdgeInsets.fromLTRB(0,6,0,6),
                          height: 60,
                          child:
                          ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: outLookImageList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Image.file(File(outLookImageList[index].path),
                                        fit: BoxFit.cover,
                                      ),),
                                    Positioned(
                                      top: 2,
                                      right: 12,
                                      child: GestureDetector(
                                        onTap: ()async{
                                          var data = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AddNewBusDeletePhotoDialog();
                                              });
                                          if (data == 'confirmDelete'){
                                            setState(() {
                                              outLookImageList.removeAt(index);
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          child: const Icon(Icons.clear, size: 14,color: Colors.white,),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),

                        ),
                  ),],
              ),
              imageUploadButtonTitle('內裝照片(1~3張)：'),
              Row(
                children: [
                  ImageUploadButton(

                      onPressed: ()async {
                        final ImagePicker _picker = ImagePicker();
                        final List<XFile>? pickedFile = await _picker.pickMultiImage(
                          // source: ImageSource.gallery,
                          maxWidth: maxWidth,
                          maxHeight: maxHeight,
                        );

                        if(pickedFile == null) return;
                        if(pickedFile.isNotEmpty){
                          for(XFile file in pickedFile){
                            if(interiorImageList.length < 3){
                              interiorImageList.add(file);
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("內裝照片需少於等於 3 張！"),));
                            }
                          }
                        }

                        pickedFile;
                        print('image list length' + interiorImageList.length.toString());

                        setState(() {});

                      }),
                  interiorImageList.isEmpty ? SizedBox() : Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0,6,0,6),
                      height: 60,
                      child:
                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: interiorImageList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children:[
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Image.file(File(interiorImageList[index].path),
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 12,
                                  child: GestureDetector(
                                    onTap: ()async{
                                      var data = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AddNewBusDeletePhotoDialog();
                                          });
                                      if (data == 'confirmDelete'){
                                        setState(() {
                                          interiorImageList.removeAt(index);
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      child: const Icon(Icons.clear, size: 14,color: Colors.white,),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red),
                                    ),
                                  ),
                                )
                              ]
                            );
                          }),

                    ),
                  ),
                ],
              ),
              imageUploadButtonTitle('行李箱(1張)：'),
              Row(
                children: [
                  ImageUploadButton(

                      onPressed: ()async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: maxWidth, maxHeight: maxHeight);

                        if(pickedFile == null) return;

                        luggageImage = pickedFile;

                        setState(() {});

                      }),
                  luggageImage == null ? SizedBox() : Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0,6,0,6),
                        height: 60, width: 60,
                        child: Image.file(File(luggageImage!.path),fit: BoxFit.cover,),
                      ),
                      Positioned(
                        top: 8,
                        right: 2,
                        child: GestureDetector(
                          onTap: () async {
                            var data = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddNewBusDeletePhotoDialog();
                                });
                            if (data == 'confirmDelete'){
                              setState(() {
                                luggageImage = null;
                              });
                            }

                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            child: const Icon(Icons.clear, size: 14,color: Colors.white,),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red),
                          ),
                        ),
                      )
                    ]
                  ),],),
              CustomElevatedButton(
                title: '確定新增',
                color: AppColor.yellow,
                onPressed: (){
                  if (carTitleController.text != '' && licenseController.text != ''&& seatNumController.text!= '' && ownerController.text!= '' && yearManufactureController.text!=''){

                    if(licenseImage == null){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("行照不可空白！"),));
                    }else if(driverlicenseImage == null){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("駕照不可空白！"),));
                    }else if(luggageImage == null){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("行李箱不可空白！"),));
                    }else if(outLookImageList.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("外觀照片不可空白！"),));
                    }else if(interiorImageList.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("內裝照片不可空白！"),));
                    }else{
                      var userModel = context.read<UserModel>();

                      Bus theBus = Bus();
                      theBus.title = carTitleController.text;
                      theBus.city = locationCity;
                      theBus.county = locationDistrict;
                      theBus.vehicalSeats = int.parse(seatNumController.text);
                      theBus.vehicalLicence = licenseController.text;
                      theBus.vehicalOwner = ownerController.text;
                      // theBus.vehicalEngineNumber = engineNumController.text;
                      // theBus.vehicalBodyNumber = bodyNumController.text;
                      theBus.vehicalYearOfManufacture = yearManufactureController.text;

                      _postCreateNewCar(theBus, userModel.token!);

                      isLoading = true;
                      setState(() {});
                    }

                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("各項資料不可空白！"),));
                  }

                },
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ));
  }

  imageUploadButtonTitle(String title){
    return Container(
      margin: const EdgeInsets.only(left: 30),
      alignment: Alignment.centerLeft,
      child: Text(title),);
  }

  imageDeleteButton(){
    return Positioned(
      top: 8,
      right: 2,
      child: GestureDetector(
        onTap: () async {
          var data = await showDialog<Widget>(
              context: context,
              builder: (BuildContext context) {
                return AddNewBusDeletePhotoDialog();
              });
          if (data == 'confirmDelete'){

          }

        },
        child: Container(
          width: 20,
          height: 20,
          child: const Icon(Icons.clear, size: 14,color: Colors.white,),
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red),
        ),
      ),
    );
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
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 6),
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
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 6),
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
      if(response.statusCode!= 201 && response.statusCode!= 200){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("此圖片上傳失敗，可能檔案太大！"),));
      }
    }

    for (XFile image in interiorImageList){
      var request = http.MultipartRequest('POST', Service.standard(path: path));
      final file = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(file);
      request.fields['tourBus'] = busId.toString();
      request.fields['type'] = 'interior';
      var response = await request.send();
      print(response.statusCode);
      if(response.statusCode!= 201 && response.statusCode!= 200){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("此圖片上傳失敗，可能檔案太大！"),));
      }
    }

    var request = http.MultipartRequest('POST', Service.standard(path: path));
    final file = await http.MultipartFile.fromPath('image', luggageImage!.path);
    request.files.add(file);
    request.fields['tourBus'] = busId.toString();
    request.fields['type'] = 'luggage';
    var response = await request.send();
    print(response.statusCode);
    if(response.statusCode!= 201 && response.statusCode!= 200){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("此圖片上傳失敗，可能檔案太大！"),));
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("成功更新！"),));
    Navigator.pop(context,"success");
  }

  Future _uploadLicenceImage(XFile? image, XFile? driverImage, String token, int busId)async{
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

    final driverFile = await http.MultipartFile.fromPath('driverLicenceImage', driverImage!.path);
    request.files.add(driverFile);

    request.fields['isPublish'] = 'true';

    var response = await request.send();
    // print(response.headers);
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      Map<String, dynamic> map = json.decode(value);
      if(map['title']!=null){
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("成功更新！"),));
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
        'vehicalYearOfManufacture': theBus.vehicalYearOfManufacture,
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
        _uploadLicenceImage(licenseImage, driverlicenseImage,token, map['id']);
      }
      print(response.statusCode);

    } catch(e){
      print(e);
    }
  }

}

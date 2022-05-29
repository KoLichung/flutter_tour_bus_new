import 'dart:io';

import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/models/tour_bus_image.dart';
import 'package:flutter_tour_bus_new/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../models/bus.dart';
import '../../../models/city.dart';
import '../../../models/county.dart';
import '../../../notifier_model/user_model.dart';

import 'package:flutter_tour_bus_new/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../widgets/image_upload_button.dart';
import 'add_new_bus_delete_photo_dialog.dart';

class EditBusProfile extends StatefulWidget {

  final Bus theBus;
  final List<TourBusImage> listBusImages;

  const EditBusProfile({Key? key, required this.theBus, required this.listBusImages}) : super(key: key);

  @override
  _EditBusProfileState createState() => _EditBusProfileState();
}

enum BusListStatus { on, off }

class _EditBusProfileState extends State<EditBusProfile> {

  List<String> cityList = City.getCityNames();
  List<String> districtList = [];

  String locationCity = '台北';
  String locationDistrict = '信義區';

  BusListStatus? _busListStatus = BusListStatus.on;

  TextEditingController carTitleController = TextEditingController();
  TextEditingController licenseController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  // TextEditingController engineNumController = TextEditingController();
  // TextEditingController bodyNumController = TextEditingController();
  TextEditingController seatNumController = TextEditingController();
  TextEditingController yearManufactureController = TextEditingController();

  XFile? newLicenseImage;
  XFile? newDriverlicenseImage;
  List<XFile> newOutLookImageList = [];
  List<XFile> newInteriorImageList = [];
  XFile? newLuggageImage;

  String? oldLicenseImage;
  String? oldDriverLicenseImage;
  List<TourBusImage> oldOutLookImageList = [];
  List<TourBusImage> oldInteriorImageList = [];
  TourBusImage? oldLuggageImage;

  List<TourBusImage> needDeleteImageList = [];

  bool isLoading = false;

  double maxWidth = 640;
  double maxHeight= 480;

  @override
  void initState() {
    super.initState();

    locationCity = widget.theBus.city!;
    locationDistrict = widget.theBus.county!;
    districtList = County.getCountyNames(City.getCityFromName(locationCity).id!);

    carTitleController.text = widget.theBus.title!;
    licenseController.text = widget.theBus.vehicalLicence!;
    ownerController.text = widget.theBus.vehicalOwner!;
    // engineNumController.text = widget.theBus.vehicalEngineNumber!;
    // bodyNumController.text = widget.theBus.vehicalBodyNumber!;
    seatNumController.text = widget.theBus.vehicalSeats!.toString();
    yearManufactureController.text = widget.theBus.vehicalYearOfManufacture!;

    if(widget.theBus.isPublish!){
      _busListStatus = BusListStatus.on;
    }else{
      _busListStatus = BusListStatus.off;
    }

    oldLicenseImage = widget.theBus.vehicalLicenceImage!;
    if(widget.theBus.driverLicenceImage!=null) {
      oldDriverLicenseImage = widget.theBus.driverLicenceImage!;
    }

    for(TourBusImage image in widget.listBusImages){
      if(image.type! == 'exterior'){
        oldOutLookImageList.add(image);
      }else if(image.type! == 'interior'){
        oldInteriorImageList.add(image);
      }else if(image.type! == 'luggage'){
        oldLuggageImage = image;
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('修改汽車'),
        ),
        body: (isLoading)?
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
              getBusListStatus(),
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

                        newDriverlicenseImage = pickedFile;

                        setState(() {});

                      }),
                  (newDriverlicenseImage == null && oldDriverLicenseImage == null)?  SizedBox():
                  Stack(
                      alignment: Alignment.topRight,
                      children: [
                        (newDriverlicenseImage != null)?
                        Container(
                            margin: const EdgeInsets.fromLTRB(0,6,0,6),
                            height: 60, width: 60,
                            child: Image.file(File(newDriverlicenseImage!.path),fit: BoxFit.cover,))
                            :
                        Container(
                            margin: const EdgeInsets.fromLTRB(0,6,0,6),
                            height: 60, width: 60,
                            child: Image.network(oldDriverLicenseImage!,fit: BoxFit.cover)),
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
                                  newDriverlicenseImage = null;
                                  oldDriverLicenseImage = null;
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
                  ),
                ],
              ),
              imageUploadButtonTitle('上傳行照：'),
              Row(
                children: [
                  ImageUploadButton(
                      onPressed: ()async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: maxWidth, maxHeight: maxHeight);

                        if(pickedFile == null) return;

                        newLicenseImage = pickedFile;

                        setState(() {});

                      }),
                  (newLicenseImage == null && oldLicenseImage == null)?  SizedBox():
                  Stack(
                      alignment: Alignment.topRight,
                      children: [
                        (newLicenseImage != null)?
                        Container(
                            margin: const EdgeInsets.fromLTRB(0,6,0,6),
                            height: 60, width: 60,
                            child: Image.file(File(newLicenseImage!.path),fit: BoxFit.cover,))
                        :
                        Container(
                            margin: const EdgeInsets.fromLTRB(0,6,0,6),
                            height: 60, width: 60,
                            child: Image.network(oldLicenseImage!,fit: BoxFit.cover)),
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
                                  newLicenseImage = null;
                                  oldLicenseImage = null;
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
                  ),
                ],
              ),
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
                            if(newOutLookImageList.length + oldOutLookImageList.length < 2){
                              newOutLookImageList.add(file);
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("外觀照片需少於等於 2 張！"),));
                            }
                          }
                        }

                        // pickedFile;
                        // print('image list length' + newOutLookImageList.length.toString());

                        setState(() {});

                      }),
                  (newOutLookImageList.isEmpty && oldOutLookImageList.isEmpty)? SizedBox() :
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0,6,0,6),
                      height: 60,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: (newOutLookImageList.length + oldOutLookImageList.length),
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                (index+1 <= newOutLookImageList.length)?
                                Container(
                                  height: 60,
                                  width: 60,
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Image.file(File(newOutLookImageList[index].path), fit: BoxFit.cover),
                                ):
                                Container(
                                  height: 60,
                                  width: 60,
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Image.network( oldOutLookImageList[index-newOutLookImageList.length].image! ,fit: BoxFit.cover),
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
                                          if( index+1 <= newOutLookImageList.length){
                                            newOutLookImageList.removeAt(index);
                                          }else{
                                            int theIndex = index-newOutLookImageList.length;
                                            needDeleteImageList.add(oldOutLookImageList[theIndex]);
                                            oldOutLookImageList.removeAt(theIndex);
                                          }
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
                  ),
                ],
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
                            if(newInteriorImageList.length + oldOutLookImageList.length < 3){
                              newInteriorImageList.add(file);
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("內裝照片需少於等於 3 張！"),));
                            }
                          }
                        }
                        setState(() {});

                      }),
                  (newInteriorImageList.isEmpty && oldInteriorImageList.isEmpty)? SizedBox() :
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0,6,0,6),
                      height: 60,
                      child:
                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: newInteriorImageList.length + oldInteriorImageList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                                alignment: Alignment.topRight,
                                children:[
                                  (index+1 <= newInteriorImageList.length)?
                                  Container(
                                    height: 60,
                                    width: 60,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Image.file(File(newInteriorImageList[index].path), fit: BoxFit.cover),
                                  ):
                                  Container(
                                    height: 60,
                                    width: 60,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Image.network( oldInteriorImageList[index-newInteriorImageList.length].image! ,fit: BoxFit.cover),
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
                                            if( index+1 <= newInteriorImageList.length){
                                              newInteriorImageList.removeAt(index);
                                            }else{
                                              int theIndex = index-newInteriorImageList.length;
                                              needDeleteImageList.add(oldInteriorImageList[theIndex]);
                                              oldInteriorImageList.removeAt(theIndex);
                                            }
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
                        newLuggageImage = pickedFile;

                        if(oldLuggageImage!=null){
                          oldLuggageImage == null;
                        }

                        setState(() {});

                      }),
                  (newLuggageImage == null && oldLuggageImage == null)? SizedBox() :
                  Stack(
                      alignment: Alignment.topRight,
                      children: [
                        (newLuggageImage != null)?
                        Container(
                          margin: const EdgeInsets.fromLTRB(0,6,0,6),
                          height: 60, width: 60,
                          child: Image.file(File(newLuggageImage!.path),fit: BoxFit.cover,),
                        ) :
                        Container(
                          margin: const EdgeInsets.fromLTRB(0,6,0,6),
                          height: 60, width: 60,
                          child: Image.network(oldLuggageImage!.image!,fit: BoxFit.cover,),
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
                                  newLuggageImage = null;
                                  oldLuggageImage = null;
                                  if(oldLuggageImage!=null){
                                    needDeleteImageList.add(oldLuggageImage!);
                                  }
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
                title: '確定修改',
                color: AppColor.yellow,
                onPressed: (){
                  if (carTitleController.text != '' && licenseController.text != '' && seatNumController.text!= '' && ownerController.text!= '' && yearManufactureController.text!=''){

                    if(newLicenseImage == null && oldLicenseImage == null){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("行照不可空白！"),));
                    }else if(newDriverlicenseImage == null && oldDriverLicenseImage == null){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("駕照不可空白！"),));
                    }else if(newLuggageImage == null && oldLuggageImage == null){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("行李箱不可空白！"),));
                    }else if(newOutLookImageList.isEmpty && oldOutLookImageList.isEmpty ){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("外觀照片不可空白！"),));
                    }else if(newInteriorImageList.isEmpty && oldInteriorImageList.isEmpty ){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("內裝照片不可空白！"),));
                    }else{
                      var userModel = context.read<UserModel>();

                      Bus theBus = Bus();
                      theBus.id = widget.theBus.id!;
                      theBus.title = carTitleController.text;
                      theBus.city = locationCity;
                      theBus.county = locationDistrict;
                      theBus.vehicalSeats = int.parse(seatNumController.text);
                      theBus.vehicalLicence = licenseController.text;
                      theBus.vehicalOwner = ownerController.text;
                      // theBus.vehicalEngineNumber = engineNumController.text;
                      // theBus.vehicalBodyNumber = bodyNumController.text;
                      theBus.vehicalYearOfManufacture = yearManufactureController.text;

                      if(_busListStatus == BusListStatus.on){
                        theBus.isPublish = true;
                      }else{
                        theBus.isPublish = false;
                      }

                      _putUpdateBus(theBus, userModel.token!);

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

  Future _putUpdateBus(Bus theBus, String token) async {

    String path = Service.BUSSES+'${theBus.id}/';

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
        // 'vehicalEngineNumber': theBus.vehicalEngineNumber,
        // 'vehicalBodyNumber': theBus.vehicalBodyNumber,
        'vehicalYearOfManufacture': theBus.vehicalYearOfManufacture,
        'isPublish': theBus.isPublish,
      };

      print(queryParameters);

      final response = await http.put(Service.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'token $token'
          },
          body: jsonEncode(queryParameters)
      );
      print(response.body);
      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      if(map['title']!=null){
        if(newLicenseImage!=null || newDriverlicenseImage!=null) {
          _uploadLicenceImage(newLicenseImage, newDriverlicenseImage,token, map['id']);
        }else{
          _uploadImageList(map['id']);
        }
      }
      print(response.statusCode);

    } catch(e){
      print(e);
    }
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

    if(image != null){
      final file = await http.MultipartFile.fromPath('vehicalLicenceImage', image.path);
      request.files.add(file);
    }

    if(driverImage != null){
      final driverFile = await http.MultipartFile.fromPath('driverLicenceImage', driverImage.path);
      request.files.add(driverFile);
    }

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

  Future _uploadImageList(int busId)async{


    //delete removed old images
    for (TourBusImage image in needDeleteImageList){
      String path = Service.TOUR_BUS_IMAGES+"${image.id!}/";
      try {

        final response = await http.delete(Service.standard(path: path));

        if (response.statusCode == 204) {
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已刪除可出租日期')));
        }
      } catch (e) {
        print(e);
      }
    }

    String path = Service.TOUR_BUS_IMAGES;
    //add new images
    for (XFile image in newOutLookImageList){
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

    for (XFile image in newInteriorImageList){
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

    if(newLuggageImage!=null){
      var request = http.MultipartRequest('POST', Service.standard(path: path));
      final file = await http.MultipartFile.fromPath('image', newLuggageImage!.path);
      request.files.add(file);
      request.fields['tourBus'] = busId.toString();
      request.fields['type'] = 'luggage';
      var response = await request.send();
      print(response.statusCode);
      if(response.statusCode!= 201 && response.statusCode!= 200){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("此圖片上傳失敗，可能檔案太大！"),));
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("成功更新！"),));
    Navigator.pop(context, 'ok');
  }



}

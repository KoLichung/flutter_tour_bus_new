import 'package:flutter_tour_bus_new/constant.dart';

class Bus {
  int? id;
  int? user;
  String? title;
  String? lat;
  String? lng;
  String? city;
  String? county;
  int? vehicalSeats;
  String? vehicalLicence;
  String? vehicalOwner;
  String? vehicalEngineNumber;
  String? vehicalBodyNumber;
  String? vehicalLicenceImage;
  bool? isPublish;
  String? coverImage;
  DateTime? recentStartDate;
  DateTime? recentEndDate;

  Bus(
      {this.id,
        this.user,
        this.title,
        this.lat,
        this.lng,
        this.city,
        this.county,
        this.vehicalSeats,
        this.vehicalLicence,
        this.vehicalOwner,
        this.vehicalEngineNumber,
        this.vehicalBodyNumber,
        this.vehicalLicenceImage,
        this.isPublish,
        this.coverImage,
        this.recentStartDate,
        this.recentEndDate});

  Bus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    title = json['title'];
    try{
      lat = json['lat'];
      lng = json['lng'];
    }catch(e){
      print(e);
    }
    city = json['city'];
    county = json['county'];
    vehicalSeats = json['vehicalSeats'];
    try {
      vehicalLicenceImage = json['vehicalLicenceImage'];
    }catch(e){
      print(e);
    }
    vehicalOwner = json['vehicalOwner'];
    vehicalEngineNumber = json['vehicalEngineNumber'];
    vehicalBodyNumber = json['vehicalBodyNumber'];
    vehicalLicenceImage = json['vehicalLicenceImage'];
    isPublish = json['isPublish'];
    try{
      String path = Service.PATH_MEDIA + json['coverImage'];
      coverImage = Service.standard(path: path).toString() ;
    }catch(e){
      print(e);
    }
    try {
      recentStartDate = DateTime.parse(json['recent_start_date']);
      recentEndDate = DateTime.parse(json['recent_end_date']);
    }catch(e){
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['title'] = this.title;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['city'] = this.city;
    data['county'] = this.county;
    data['vehicalSeats'] = this.vehicalSeats;
    data['vehicalLicence'] = this.vehicalLicence;
    data['vehicalOwner'] = this.vehicalOwner;
    data['vehicalEngineNumber'] = this.vehicalEngineNumber;
    data['vehicalBodyNumber'] = this.vehicalBodyNumber;
    data['vehicalLicenceImage'] = this.vehicalLicenceImage;
    data['recent_start_date'] = this.recentStartDate;
    data['recent_end_date'] = this.recentEndDate;
    return data;
  }
}
import 'package:flutter_tour_bus_new/constant.dart';

class TourBusImage {
  int? id;
  String? type;
  String? image;
  int? tourBus;

  TourBusImage({this.id, this.type, this.image, this.tourBus});

  TourBusImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    try{
      image =  json['image'];
    }catch(e){
      print(e);
    }
    tourBus = json['tourBus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['image'] = this.image;
    data['tourBus'] = this.tourBus;
    return data;
  }
}
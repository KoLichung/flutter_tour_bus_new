import 'package:flutter/foundation.dart';

class Order {
  int? id;
  String state;
  String startDate;
  String endDate;
  String? depatureCity;
  String? destinationCity;
  int? user;
  int? tourBus;

  Order(
      {this.id,
        required this.state,
        required this.startDate,
        required this.endDate,
        this.depatureCity,
        this.destinationCity,
        this.user,
        this.tourBus});

  factory Order.fromJson(Map<String, dynamic> json){
    return Order(
      id:json['id'],
      state:json['state'],
      startDate:json['startDate'],
      endDate:json['endDate'],
      depatureCity:json['depatureCity'],
      destinationCity:json['destinationCity'],
      user:json['user'],
      tourBus:json['tourBus'],
    );
  }

  // Order.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   state = json['state'];
  //   startDate = json['startDate'];
  //   endDate = json['endDate'];
  //   depatureCity = json['depatureCity'];
  //   destinationCity = json['destinationCity'];
  //   user = json['user'];
  //   tourBus = json['tourBus'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state'] = this.state;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['depatureCity'] = this.depatureCity;
    data['destinationCity'] = this.destinationCity;
    data['user'] = this.user;
    data['tourBus'] = this.tourBus;
    return data;
  }
}
class BusRentDay {
  int? id;
  String? state;
  String? startDate;
  String? endDate;
  int? tourBus;

  BusRentDay({this.id, this.state, this.startDate, this.endDate, this.tourBus});

  BusRentDay.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    tourBus = json['tourBus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state'] = this.state;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['tourBus'] = this.tourBus;
    return data;
  }
}
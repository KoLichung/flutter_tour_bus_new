class Order {
  int? id;
  int? user;
  int? tourBus;
  String? state;
  String? startDate;
  String? endDate;
  String? depatureCity;
  String? destinationCity;
  int? orderMoney;
  int? depositMoney;
  String? memo;
  String? busTitle;
  String? name;
  String? phone;

  Order(
      {this.id,
        this.user,
        this.tourBus,
        this.state,
        this.startDate,
        this.endDate,
        this.depatureCity,
        this.destinationCity,
        this.orderMoney,
        this.depositMoney,
        this.memo,
        this.busTitle,
        this.name,
        this.phone});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    tourBus = json['tourBus'];
    state = json['state'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    depatureCity = json['depatureCity'];
    destinationCity = json['destinationCity'];
    orderMoney = json['orderMoney'];
    depositMoney = json['depositMoney'];
    memo = json['memo'];
    busTitle = json['busTitle'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['tourBus'] = this.tourBus;
    data['state'] = this.state;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['depatureCity'] = this.depatureCity;
    data['destinationCity'] = this.destinationCity;
    data['orderMoney'] = this.orderMoney;
    data['depositMoney'] = this.depositMoney;
    data['memo'] = this.memo;
    data['busTitle'] = this.busTitle;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}
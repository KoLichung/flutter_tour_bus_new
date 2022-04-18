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
  String? busTitle;

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
        this.busTitle});

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
    busTitle = json['busTitle'];
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
    data['busTitle'] = this.busTitle;
    return data;
  }
}
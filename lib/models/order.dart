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
  bool? isAtm;
  String? aTMInfoBankCode;
  String? aTMInfovAccount;
  String? aTMInfoExpireDate;
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
        this.isAtm,
        this.aTMInfoBankCode,
        this.aTMInfovAccount,
        this.aTMInfoExpireDate,
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
    try {
      isAtm = json['isAtm'];
    }catch(e){
      isAtm = false;
    }
    try{
      aTMInfoBankCode = json['ATMInfoBankCode'];
      aTMInfovAccount = json['ATMInfovAccount'];
      aTMInfoExpireDate = json['ATMInfoExpireDate'];
    }catch(e){
      print(e);
    }
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
    data['isAtm'] = this.isAtm;
    data['ATMInfoBankCode'] = this.aTMInfoBankCode;
    data['ATMInfovAccount'] = this.aTMInfovAccount;
    data['ATMInfoExpireDate'] = this.aTMInfoExpireDate;
    data['busTitle'] = this.busTitle;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}
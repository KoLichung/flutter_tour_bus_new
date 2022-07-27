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
  String? aTMFiveDigit;
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
        this.aTMFiveDigit,
        this.busTitle,
        this.name,
        this.phone});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if(json['user']!=null) {
      user = json['user'];
    }else{
      user = null;
    }
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
    if(json['ATMFiveDigit']!=null){
      aTMFiveDigit = json['ATMFiveDigit'];
    }else{
      aTMFiveDigit = "";
    }
    busTitle = json['busTitle'];

    if (user != null){
      try{
        name = json['name'].toString().replaceAll(RegExp('[0-9]'), "");
      }catch(e){
        name = json['name'];
      }
      phone = json['phone'];
    }else{
      name = '用戶已刪除';
      phone = '用戶已刪除';
    }

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
class User {
  String phone;
  String name;
  String token;
  var loginMethod;
  String? socialId;
  bool isGottenLineId;
  bool isOwner;

  User({required this.phone, required this.name, required this.token, this.loginMethod = LoginMethod.phone, this.socialId, required this.isGottenLineId, required this.isOwner});


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phone: json['phone'],
      name: json['name'],
      token: json['token'],
      loginMethod: json['loginMethod'],
      socialId: json['socialId'],
      isGottenLineId: json['isGottenLineId'],
      isOwner: json['isOwner']
    );
  }

  // User.fromJson(Map<String, dynamic> json) {
  //   phone = json['phone'];
  //   name = json['name'];
  //   // token = json['token'];
  //   // loginMethod = json['loginMethod'];
  //   // socialID = json['socialID'];
  //   // isGottenLineID = json['isGottenLineID'];
  //
  //   if(json['is_gotten_line_id']!=null){
  //     isGottenLineID = json['is_gotten_line_id'];
  //   }else{
  //     isGottenLineID = false;
  //   }
  //
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['name'] = this.name;
    return data;
  }
}

enum LoginMethod{
  phone,
  lineID,
}
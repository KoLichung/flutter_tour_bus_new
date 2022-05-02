class User {
  int? id;
  String? phone;
  String? name;
  bool? isOwner;
  String? company;
  String? address;
  String? vehicalLicence;
  String? vehicalOwner;
  // String? vehicalEngineNumber;
  // String? vehicalBodyNumber;
  String? vehicalLicenceImage;
  String? driverLicenceImage;
  bool? isGottenLineId;

  User(
      {this.id,
        this.phone,
        this.name,
        this.isOwner,
        this.company,
        this.address,
        this.vehicalLicence,
        this.vehicalOwner,
        // this.vehicalEngineNumber,
        // this.vehicalBodyNumber,
        this.vehicalLicenceImage,
        this.driverLicenceImage,
        this.isGottenLineId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    name = json['name'];
    if(json['isOwner']!=null){
      isOwner = json['isOwner'];
    }else{
      isOwner = false;
    }
    if(json['company']!=null){
      company = json['company'];
    }else{
      company = "";
    }
    if(json['address']!=null){
      address = json['address'];
    }else{
      address = "";
    }
    if(json['vehicalLicence']!=null){
      vehicalLicence = json['vehicalLicence'];
    }else{
      vehicalLicence = "";
    }
    if(json['vehicalOwner']!=null){
      vehicalOwner = json['vehicalOwner'];
    }else{
      vehicalOwner = "";
    }
    // if(json['vehicalEngineNumber']!=null){
    //   vehicalEngineNumber = json['vehicalEngineNumber'];
    // }else{
    //   vehicalEngineNumber = "";
    // }
    // if(json['vehicalBodyNumber']!=null){
    //   vehicalBodyNumber = json['vehicalBodyNumber'];
    // }else{
    //   vehicalBodyNumber = "";
    // }
    if(json['vehicalLicenceImage']!=null){
      vehicalLicenceImage = json['vehicalLicenceImage'];
    }else{
      vehicalLicenceImage = "";
    }

    if(json['driverLicenceImage']!=null){
      driverLicenceImage = json['driverLicenceImage'];
    }else{
      driverLicenceImage = "";
    }

    isGottenLineId = json['is_gotten_line_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['isOwner'] = this.isOwner;
    data['company'] = this.company;
    data['address'] = this.address;
    data['vehicalLicence'] = this.vehicalLicence;
    data['vehicalOwner'] = this.vehicalOwner;
    // data['vehicalEngineNumber'] = this.vehicalEngineNumber;
    // data['vehicalBodyNumber'] = this.vehicalBodyNumber;
    data['vehicalLicenceImage'] = this.vehicalLicenceImage;
    data['driverLicenceImage'] = this.driverLicenceImage;
    data['is_gotten_line_id'] = this.isGottenLineId;
    return data;
  }
}
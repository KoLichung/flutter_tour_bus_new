class User {
  int? id;
  String? phone;
  String? name;
  bool? isOwner;
  String? company;
  String? address;
  String? vehicalLicence;
  String? vehicalOwner;
  String? vehicalEngineNumber;
  String? vehicalBodyNumber;
  String? vehicalLicenceImage;
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
        this.vehicalEngineNumber,
        this.vehicalBodyNumber,
        this.vehicalLicenceImage,
        this.isGottenLineId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    name = json['name'];
    isOwner = json['isOwner'];
    company = json['company'];
    address = json['address'];
    vehicalLicence = json['vehicalLicence'];
    vehicalOwner = json['vehicalOwner'];
    vehicalEngineNumber = json['vehicalEngineNumber'];
    vehicalBodyNumber = json['vehicalBodyNumber'];
    vehicalLicenceImage = json['vehicalLicenceImage'];
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
    data['vehicalEngineNumber'] = this.vehicalEngineNumber;
    data['vehicalBodyNumber'] = this.vehicalBodyNumber;
    data['vehicalLicenceImage'] = this.vehicalLicenceImage;
    data['is_gotten_line_id'] = this.isGottenLineId;
    return data;
  }
}
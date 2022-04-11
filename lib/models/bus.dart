class Bus {
  int? id;
  String? title;
  Null? lat;
  Null? lng;
  String? city;
  String? county;
  int? vehicalSeats;
  String? vehicalLicence;
  String? vehicalOwner;
  String? vehicalEngineNumber;
  String? vehicalBodyNumber;
  Null? vehicalLicenceImage;
  bool? isPublish;
  int? user;

  Bus(
      {this.id,
        this.title,
        this.lat,
        this.lng,
        this.city,
        this.county,
        this.vehicalSeats,
        this.vehicalLicence,
        this.vehicalOwner,
        this.vehicalEngineNumber,
        this.vehicalBodyNumber,
        this.vehicalLicenceImage,
        this.isPublish,
        this.user});

  Bus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    try{
      lat = json['lat'];
      lng = json['lng'];
    }catch(e){
      print(e);
    }
    city = json['city'];
    county = json['county'];
    vehicalSeats = json['vehicalSeats'];
    vehicalLicence = json['vehicalLicence'];
    vehicalOwner = json['vehicalOwner'];
    vehicalEngineNumber = json['vehicalEngineNumber'];
    vehicalBodyNumber = json['vehicalBodyNumber'];
    try {
      vehicalLicenceImage = json['vehicalLicenceImage'];
    }catch(e){
      print(e);
    }
    isPublish = json['isPublish'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['city'] = this.city;
    data['county'] = this.county;
    data['vehicalSeats'] = this.vehicalSeats;
    data['vehicalLicence'] = this.vehicalLicence;
    data['vehicalOwner'] = this.vehicalOwner;
    data['vehicalEngineNumber'] = this.vehicalEngineNumber;
    data['vehicalBodyNumber'] = this.vehicalBodyNumber;
    data['vehicalLicenceImage'] = this.vehicalLicenceImage;
    data['isPublish'] = this.isPublish;
    data['user'] = this.user;
    return data;
  }
}
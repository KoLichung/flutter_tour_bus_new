class Bus {
  // final int id;
  final String title;
  final String lat;
  final String lng;
  final String city;
  final String county;
  final int vehicleSeats;
  final String vehicleLicence;
  final String vehicleOwner;
  final String vehicleEngineNumber;
  final String vehicleBodyNumber;
  final String? vehicleLicenceImage;
  final bool isPublish;
  final int user;

  const Bus(
      {
        // required this.id,
        required this.title,
        required this.lat,
        required this.lng,
        required this.city,
        required this.county,
        required this.vehicleSeats,
        required this.vehicleLicence,
        required this.vehicleOwner,
        required this.vehicleEngineNumber,
        required this.vehicleBodyNumber,
        this.vehicleLicenceImage,
        required this.isPublish,
        required this.user});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
        // id: json['id'],
        title: json['title'],
        lat: json['lat'],
        lng: json['lng'],
        city: json['city'],
        county: json['county'],
        vehicleSeats: json['vehicalSeats'],
        vehicleLicence: json['vehicalLicence'],
        vehicleOwner: json['vehicalOwner'],
        vehicleEngineNumber: json['vehicalEngineNumber'],
        vehicleBodyNumber: json['vehicalBodyNumber'],
        vehicleLicenceImage: json['vehicalLicenceImage'],
        isPublish: json['isPublish'],
        user: json['user'],
    );

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = id;
    data['title'] = this.title;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['city'] = this.city;
    data['county'] = this.county;
    data['vehicalSeats'] = this.vehicleSeats;
    data['vehicalLicence'] = this.vehicleLicence;
    data['vehicalOwner'] = this.vehicleOwner;
    data['vehicalEngineNumber'] = this.vehicleEngineNumber;
    data['vehicalBodyNumber'] = this.vehicleBodyNumber;
    data['vehicalLicenceImage'] = this.vehicleLicenceImage;
    data['isPublish'] = this.isPublish;
    data['user'] = this.user;
    return data;
  }
}



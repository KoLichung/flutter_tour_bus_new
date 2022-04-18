class Announcement {
  int? id;
  String? phone;
  String? name;
  String? announceDateTime;
  int? numbersOfPeople;
  String? startDateTime;
  String? endDateTime;
  String? depatureCity;
  String? destinationCity;
  String? memo;
  int? user;

  Announcement(
      {this.id,
        this.phone,
        this.name,
        this.announceDateTime,
        this.numbersOfPeople,
        this.startDateTime,
        this.endDateTime,
        this.depatureCity,
        this.destinationCity,
        this.memo,
        this.user});

  Announcement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    name = json['name'];
    announceDateTime = json['announceDateTime'];
    numbersOfPeople = json['numbersOfPeople'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    depatureCity = json['depatureCity'];
    destinationCity = json['destinationCity'];
    memo = json['memo'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['announceDateTime'] = this.announceDateTime;
    data['numbersOfPeople'] = this.numbersOfPeople;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['depatureCity'] = this.depatureCity;
    data['destinationCity'] = this.destinationCity;
    data['memo'] = this.memo;
    data['user'] = this.user;
    return data;
  }
}
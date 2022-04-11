import 'dart:convert';

class City {
  int? id;
  String? name;
  String? lat;
  String? lng;

  City({this.id, this.name, this.lat, this.lng});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }

  static String jsonData = '[ { "id": 1, "name": "台北市", "lat": "25.042141", "lng": "121.519872" }, { "id": 2, "name": "基隆市", "lat": "25.118716", "lng": "121.745193" }, '
      '{ "id": 3, "name": "新北市", "lat": "25.167602", "lng": "121.639718" }, { "id": 4, "name": "宜蘭縣", "lat": "24.759115", "lng": "121.753740" }, '
      '{ "id": 5, "name": "新竹市", "lat": "24.792061", "lng": "120.993378" }, { "id": 6, "name": "新竹縣", "lat": "24.834687", "lng": "120.993368" }, '
      '{ "id": 7, "name": "桃園市", "lat": "24.972151", "lng": "121.205396" }, { "id": 8, "name": "苗栗縣", "lat": "24.700922", "lng": "120.878603" }, '
      '{ "id": 9, "name": "台中市", "lat": "24.140260", "lng": "120.681818" }, { "id": 10, "name": "彰化縣", "lat": "24.071658", "lng": "120.562447" }, '
      '{ "id": 11, "name": "南投縣", "lat": "23.917964", "lng": "120.677505" }, { "id": 12, "name": "嘉義市", "lat": "23.485335", "lng": "120.476085" }, '
      '{ "id": 13, "name": "雲林縣", "lat": "23.677137", "lng": "120.476081" }, { "id": 14, "name": "台南市", "lat": "22.994821", "lng": "120.196452" }, '
      '{ "id": 15, "name": "高雄市", "lat": "22.628389", "lng": "120.306071" }, { "id": 16, "name": "屏東縣", "lat": "22.655844", "lng": "120.470326" }, '
      '{ "id": 17, "name": "花蓮縣", "lat": "23.991073", "lng": "121.611195" }, { "id": 18, "name": "台東縣", "lat": "22.761321", "lng": "121.143815" }, '
      '{ "id": 19, "name": "澎湖縣", "lat": "23.570627", "lng": "119.577462" }, { "id": 20, "name": "金門縣", "lat": "24.481109", "lng": "118.427993" }, '
      '{ "id": 21, "name": "連江縣", "lat": "26.153436", "lng": "119.930686" } ]';

  static List<String> getCityNames(){
    List<String>? names = [];

    List bodyCategory = json.decode(City.jsonData);
    List<City> cities = bodyCategory.map((value) => City.fromJson(value)).toList();

    names = cities.map((e) => e.name!).toList();
    return names;
  }

  static String getCityNameFromId(int cityId){
    List bodyCategory = json.decode(City.jsonData);
    List<City> cities = bodyCategory.map((value) => City.fromJson(value)).toList();
    for (var city in cities){
      if (cityId == city.id){
        return city.name!;
      }
    }
    return 'not found';
  }

  static City getCityFromName(String name){
    List bodyCategory = json.decode(City.jsonData);
    List<City> cities = bodyCategory.map((value) => City.fromJson(value)).toList();
    for(var city in cities){
      if(city.name == name){
        return city;
      }
    }
    return City();
  }

}
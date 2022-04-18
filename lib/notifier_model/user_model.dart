import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tour_bus_new/models/user.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/bus.dart';

class UserModel extends ChangeNotifier {

  User? _user;
  User? get user => _user;
  // bool isNeedReloadIndexAndFilterCondition = false;
  String? token;

  bool isLineLogin = false;

  //booking bus
  String fromCity = '台北市';
  String toCity = '台中市';

  DateTime startDate = DateTime.now().add(const Duration(days: 1));
  DateTime endDate = DateTime.now().add(const Duration(days: 2));

  String numberOfPeople = '10';

  String? fcmToken;
  String? platformType;
  String? deviceId;

  void changeBookingFromCity(String newFromCity){
    fromCity = newFromCity;
  }

  void changeBookingToCity(String newToCity){
    toCity = newToCity;
  }

  void changeBookingStartDate(DateTime newStartDate){
    startDate = newStartDate;
  }

  void changeBookingEndDate(DateTime newEndDate){
    endDate = newEndDate;
  }

  void changeBookingNumberOfPeople(String newNumberOfPeople){
    numberOfPeople = newNumberOfPeople;
  }

  void setUser(User theUser){
    _user = theUser;
    // isNeedReloadIndexAndFilterCondition = true;
    notifyListeners();
  }

  void removeUser(BuildContext context){
    _user = null;
    isLineLogin = false;
    token = null;
    notifyListeners();
  }

  bool isLogin(){
    if(_user != null){
      return true;
    }else{
      return false;
    }
  }

  void updateLineStatus(){
    if(_user!=null){
      _user?.isGottenLineId = true;
      notifyListeners();
    }
  }

}
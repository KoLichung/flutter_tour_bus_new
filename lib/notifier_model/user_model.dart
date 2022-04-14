import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tour_bus_new/models/user.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserModel extends ChangeNotifier {

  User? _user;
  User? get user => _user;
  // bool isNeedReloadIndexAndFilterCondition = false;
  String? token;
  bool isLineLogin = false;


  //booking bus
  String fromCity = '台北市';
  String toCity = '台中市';
  String startDate =DateFormat('MM / dd EEE').format(DateTime.now().add(const Duration(days: 14)));
  String endDate =DateFormat('MM / dd EEE').format(DateTime.now().add(const Duration(days: 17)));
  String numberOfPeople = '10';

  void changeBookingFromCity(String newFromCity){
    fromCity = newFromCity;
    notifyListeners();
  }

  void changeBookingToCity(String newToCity){
    toCity = newToCity;
    notifyListeners();
  }

  void changeBookingStartDate(String newStartDate){
    startDate = newStartDate;
    notifyListeners();
  }

  void changeBookingEndDate(String newEndDate){
    endDate = newEndDate;
    notifyListeners();
  }

  void changeBookingNumberOfPeople(String newNumberOfPeople){
    numberOfPeople = newNumberOfPeople;
    notifyListeners();
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
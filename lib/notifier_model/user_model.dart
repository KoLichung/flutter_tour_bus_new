import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tour_bus_new/models/user.dart';
import 'package:provider/provider.dart';

class UserModel extends ChangeNotifier {

  User? _user;
  User? get user => _user;
  // bool isNeedReloadIndexAndFilterCondition = false;
  String? token;
  bool isLineLogin = false;


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
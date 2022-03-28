import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tour_bus_new/models/user.dart';
import 'package:provider/provider.dart';

class UserModel extends ChangeNotifier {

  User? _user;
  User? get user => _user;
  // bool isNeedReloadIndexAndFilterCondition = false;

  void setUser(User theUser){
    _user = theUser;
    // isNeedReloadIndexAndFilterCondition = true;
    notifyListeners();
  }

  void removeUser(BuildContext context){
    _user = null;
    // isNeedReloadIndexAndFilterCondition = true;

    // var likeStockModel = context.read<LikeStockModel>();
    // likeStockModel.stockLists.clear();
    // likeStockModel.allLikeStocks.clear();

    notifyListeners();
  }

  bool isLogin(){
    if(_user != null){
      return true;
    }else{
      return false;
    }
  }

  bool isSocialLogin(){
    if(_user?.loginMethod != LoginMethod.phone && _user?.loginMethod != null){
      return true;
    }else{
      return false;
    }
  }

  String loginMethod(){
    switch(_user?.loginMethod){
      case LoginMethod.phone:
        return 'Phone';
      case LoginMethod.lineID:
        return 'Line';
    }
    return '';
  }

  void updateLineStatus(){
    if(_user!=null){
      _user?.isGottenLineId = true;
      notifyListeners();
    }
  }

}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Service{
  static const _HOST ='45.77.25.172';

  static const SEARCH_BUS = '/api/search_bus/';

  static const ORDERS = '/api/orders/';

  static const BUSSES = '/api/busses/';
  static const TOUR_BUS_IMAGES = '/api/tour_bus_images/';

  static const PATH_CREATE_USER = '/api/user/create/';
  static const PATH_USER_TOKEN = '/api/user/token/';
  static const PATH_USER_DATA = '/api/user/me/';
  static const PATH_USER_UPDATE_PASSWORD = '/api/user/update_user_password';

  static const PATH_GET_SMS_VERIFY = '/api/sms_verify';


  static Uri standard({String? path, Map<String, String>? queryParameters}) {
    print(Uri.http(_HOST, '$path', queryParameters));
    return Uri.http(_HOST, '$path', queryParameters);
  }

}
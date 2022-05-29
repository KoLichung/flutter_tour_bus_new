import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Service{
  static const _HOST ='tourbustw.com';

  static const SEARCH_BUS = '/api/search_bus/';
  static const BUSSES = '/api/busses/';
  static const TOUR_BUS_IMAGES = '/api/tour_bus_images/';
  static const TOUR_BUS_RENT_DAYS = '/api/bus_rent_days/';

  static const PATH_CREATE_USER = '/api/user/create/';
  static const PATH_USER_TOKEN = '/api/user/token/';
  static const PATH_USER_DATA = '/api/user/me/';
  static const PATH_USER_UPDATE_PASSWORD = '/api/user/update_user_password';

  static const PATH_RESET_PASSWORD_SMS_VERIFY = "/api/reset_password_sms_verify";
  static const PATH_RESET_PASSWORD_SMS_PASSWORD = "/api/reset_password_sms_password";

  static const ORDERS = '/api/orders/';
  static const OWNER_BUS_ORDERS = '/api/owner_orders';
  static const OWNER_UPDATE_STATE = '/api/owner_update_state';
  static const OWNER_UPDATE_MEMO = '/api/owner_update_memo';
  static const GET_ORDER_IMAGE = '/api/get_order_image';
  static const GET_ORDER_USER_INFO = '/api/get_order_user_info';

  static const ANNOUNCEMENT = '/api/announcements/';

  static const PATH_GET_SMS_VERIFY = '/api/sms_verify';

  static const PATH_MEDIA = '/media/';

  static const PATH_GET_PAYMENT_TOKEN = '/api/ecpay/get_token';

  static const PATH_REGISTER_DEVICE = '/api/device_register';

  static Uri standard({String? path, Map<String, String>? queryParameters}) {
    print(Uri.https(_HOST, '$path', queryParameters));
    return Uri.https(_HOST, '$path', queryParameters);
  }

  static const BUS_COMPANY_NAME = 'XX有限公司';

}
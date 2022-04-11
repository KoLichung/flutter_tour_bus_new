import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tour_bus_new/pages/member/buses/drivers_bus_detail.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/pages/member/bookings/drivers_booking_detail.dart';
import 'package:flutter_tour_bus_new/pages/member/bookings/drivers_booking_list.dart';
import 'package:flutter_tour_bus_new/pages/member/buses/edit_bus_profile.dart';
import 'package:flutter_tour_bus_new/pages/member/editUser/edit_user_profile.dart';
import 'package:flutter_tour_bus_new/pages/booking/inquiry_form.dart';
import 'package:flutter_tour_bus_new/pages/member/inquiry_notice.dart';
import 'pages/member/login_register.dart';
import 'pages/booking/payment_confirmed.dart';
import 'package:flutter_tour_bus_new/pages/booking/rental_confirmation.dart';
import 'color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/booking/home_page.dart';
import 'pages/price_list_page.dart';
import 'pages/member/member_page.dart';
import 'pages/booking/search_list.dart';
import 'pages/booking/rental_bus_detail.dart';
import 'pages/member/register/register_phone.dart';
import 'pages/member/inquiry_notice.dart';
import 'pages/member/passenger_order_list.dart';
import 'pages/member/buses/drivers_bus_list.dart';
import 'pages/member/buses/add_new_bus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  LineSDK.instance.setup('1657037223').then((_) {
    print('LineSDK Prepared');
  });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
      create: (context) => UserModel(),
    ),
  ],child: const MyApp(),) );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh','TW'),
      ],
      locale: const Locale('zh','TW'),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColor.yellow,
        textTheme: const TextTheme(
          button: TextStyle(fontSize: 16),
          //headline6: AppBar title
          headline6: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
          //subtitle1: dropDownButton Text
          //subtitle2: body title
          subtitle2: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
          //bodyText2: default body text
          bodyText2: TextStyle(color: Colors.black, fontSize: 16,height: 1.5),
          //bodyText1: body text big and bold
          bodyText1: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(AppColor.yellow),
          checkColor: MaterialStateProperty.all(Colors.white),
        ),
        appBarTheme: const AppBarTheme(
            color: AppColor.yellow,
            elevation: 0
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      routes:  {
        '/main': (context) => const MyHomePage(),
        '/search_list': (context) => const SearchList(),
        '/inquiry_form': (context) => const InquiryForm(),
        // '/bus_detail': (context) => RentalBusDetail(),
        '/login_register': (context) => const LoginRegister(),
        '/register_phone': (context) => const RegisterPhone(),
        '/home_page': (context) => const HomePage(),
        '/rental_confirmation': (context) => const RentalConfirmation(),
        '/inquiry_notice': (context) => InquiryNotice(),
        '/edit_user_profile': (context) => const EditUserProfile(),
        '/order_list': (context) => const PassengerOrderList(),
        '/payment_confirmed': (context) => const PaymentConfirmed(),
        '/bus_list': (context) => const DriversBusList(),
        '/add_new_bus': (context) => const AddNewBus(),
        '/drivers_bus_detail': (context) => const DriversBusDetail(),
        '/edit_bus_profile': (context) => const EditBusProfile(),
        '/drivers_booking_list': (context) => const DriversBookingList(),
        '/drivers_booking_detail': (context) => const DriversBookingDetail(),

      },
      builder: (context, child){
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1), child: Container(child: child)
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;


  Future<void> getAPNSToken() async {
    FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    print('FlutterFire Messaging Example: Getting APNs token...');
    String? token = await FirebaseMessaging.instance.getAPNSToken();
    print('Got APNs token: $token');
    FirebaseMessaging.instance.getToken().then((token){
      print('the token: ' + token.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = "zh_TW";   //sets global,

    if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      getAPNSToken();
    }else{
      FirebaseMessaging.instance.getToken().then((token){
        print('the token: ' + token.toString());
      });
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: pageCaller(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColor.yellow, width: 1)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColor.yellow,
          unselectedItemColor: AppColor.lightGrey,
          currentIndex: _selectedIndex,
          // onTap: _onItemTapped,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.directions_bus_filled_outlined), label: '租遊覽車'),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: '價位表'),
            BottomNavigationBarItem(icon: Icon(Icons.face_outlined), label: '會員中心'),
          ],
        ),
      ),
    );
  }
  pageCaller(int index){
    switch (index){
      case 0 : { return const HomePage();}
      case 1 : { return const PriceListPage();}
      case 2 : { return const MemberPage();}
    }

  }
}

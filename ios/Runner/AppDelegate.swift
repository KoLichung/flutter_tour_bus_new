import UIKit
import Flutter
//import ECPayPaymentGatewayKit
//import PromiseKit
//import CryptoSwift
//import Alamofire

enum ChannelName {
  static let battery = "samples.flutter.io/battery"

  static let getTestToken = "samples.flutter.io/get_test_token"
  static let payECPay = "samples.flutter.io/pay_ec_pay"
    
  static let payECPayCallBack = "samples.flutter.io/pay_ec_pay_call_back"
}

enum BatteryState {
  static let charging = "charging"
  static let discharging = "discharging"
}

enum MyFlutterErrorCode {
  static let unavailable = "UNAVAILABLE"
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    private var mainCoordinator: AppCoordinator?
    private var tokenType:Int = 2
    private var tokenString = ""
    private var stateDescription = ""
    let merchantID = "3002607"
    let aesKey = "pwFHCqoQZGmho4w6"
    let aesIV = "EkRm7iFT261dpevs"
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        GeneratedPluginRegistrant.register(with: self)
//        ECPayPaymentGatewayManager.sharedInstance().initialize(env: .Stage)
//
//        guard let controller = window?.rootViewController as? FlutterViewController else {
//          fatalError("rootViewController is not type FlutterViewController")
//        }
//
//        let batteryChannel = FlutterMethodChannel(name: ChannelName.battery, binaryMessenger: controller.binaryMessenger)
//        batteryChannel.setMethodCallHandler({
//          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
//          guard call.method == "getBatteryLevel" else {
//            result(FlutterMethodNotImplemented)
//            return
//          }
//          self?.receiveBatteryLevel(result: result)
//        })
//
//
//        let getTestTokenChannel = FlutterMethodChannel(name: ChannelName.getTestToken, binaryMessenger: controller.binaryMessenger)
//        getTestTokenChannel.setMethodCallHandler({
//          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
//          guard call.method == "getTestToken" else {
//            result(FlutterMethodNotImplemented)
//            return
//          }
//            self?.receiveTestToken(call: call, result: result)
//        })
//
//        let getECPayChannel = FlutterMethodChannel(name: ChannelName.payECPay, binaryMessenger: controller.binaryMessenger)
//        getECPayChannel.setMethodCallHandler({
//          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
//          guard call.method == "payECPay" else {
//            result(FlutterMethodNotImplemented)
//            return
//          }
//          guard let args = call.arguments else {
//            return
//          }
//          let myArgs = args as? [String: Any]
//          let token = myArgs?["token"] as? String
//          let orderId = myArgs?["orderId"] as? String
//          let tourBus = myArgs?["tourBus"] as? String
//
//
//          self?.receivePayECPay(token: token!, orderId: orderId!, tourBus: tourBus!)
//        })
//
//        let navigationController = UINavigationController(rootViewController: controller)
//        navigationController.isNavigationBarHidden = true
//        window?.rootViewController = navigationController
//        mainCoordinator = AppCoordinator(navigationController: navigationController)
//        window?.makeKeyAndVisible()
//
//
//        let chargingChannel = FlutterEventChannel(name: ChannelName.payECPayCallBack,
//                                                  binaryMessenger: controller.binaryMessenger)
//        chargingChannel.setStreamHandler(self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
      self.eventSink = eventSink
      eventSink("on payment state listening")
        
//      UIDevice.current.isBatteryMonitoringEnabled = true
//      sendBatteryStateEvent()
//      NotificationCenter.default.addObserver(
//        self,
//        selector: #selector(AppDelegate.onBatteryStateDidChange),
//        name: UIDevice.batteryStateDidChangeNotification,
//        object: nil)
      return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
      NotificationCenter.default.removeObserver(self)
      eventSink = nil
      return nil
    }
    
    private func receiveBatteryLevel(result: FlutterResult) {
      let device = UIDevice.current
      device.isBatteryMonitoringEnabled = true
      guard device.batteryState != .unknown  else {
        result(FlutterError(code: MyFlutterErrorCode.unavailable,
                            message: "Battery info unavailable",
                            details: nil))
        return
      }
      result(Int(device.batteryLevel * 100))
    }

//    private func receivePayECPay(token: String, orderId: String, tourBus: String) {
//        print("here")
//  //      self.mainCoordinator?.start()
//
//        ECPayPaymentGatewayManager.sharedInstance().createPayment(token: token,
//                                                                  merchantID: "",
//                                                                  useResultPage: 1,
//                                                                  appStoreName: "???????????????(\(ECPayPaymentGatewayManager.sharedInstance().sdkEnvironmentString()))",
//                                                                  language: "zh-TW")
//        { (state) in
//
//
//  //                print(state)
//  //                print("")
//
//
////             if state.callbackStateStatus == .Success {
////                 // watch here!!!!
////                 self.eventSink!("success");
////             }else if(state.callbackStateStatus == .Fail){
////                 self.eventSink!("fail");
////             }else if(state.callbackStateStatus == .Cancel){
////                 self.eventSink!("cancel")
////             }else if(state.callbackStateStatus == .Exit){
////                 self.eventSink!("exit")
////             }
//
//
//            if let callbackState = state as? CreatePaymentCallbackState {
//
//                if let atm = callbackState.ATMInfo {
//                    print("\(atm)")
//                    print("\(atm.BankCode ?? "")")
//                    print("\(atm.vAccount ?? "")")
//                    print("\(atm.ExpireDate)")
////                    self.eventSink!("atm");
////                    self.eventSink!("atm:" + "\(atm.BankCode ?? "")");
////                    self.eventSink!("atm:" + "\(atm.vAccount ?? "")");
////                    self.eventSink!("atm:" + "\(atm.ExpireDate)");
//
//                    var atmJson = "{\"bankCode\":\"\(atm.BankCode ?? "")\",\"vAccount\":\"\(atm.vAccount ?? "")\",\"expireDate\":\"\(atm.ExpireDate)\",\"orderId\":\(orderId),\"tourBus\":\(tourBus)}"
//                    self.eventSink!(atmJson);
//
//                }
//
//                if(callbackState.RtnCode==1){
////                    self.eventSink!("success");
//                }
//
//                print("CreatePaymentCallbackState:")
//                print("RtnCode = \(callbackState.RtnCode)")
//                print("RtnMsg = \(callbackState.RtnMsg)")
//
//                if let order = callbackState.OrderInfo {
//                    print("\(order)")
//                    print("\(order.MerchantTradeNo ?? "")")
//                    print("\(order.TradeNo ?? "")")
//                    print("\(order.TradeDate)")
//                    print("\(order.TradeStatus ?? "")")
//                    print("\(order.PaymentDate)")
//                    print("\(order.TradeAmt ?? 0)")
//                    print("\(order.PaymentType ?? "")")
//                    print("\(order.ChargeFee ?? 0)")
//                    print("\(order.TradeStatus ?? "")")
//
//                }
//                if let card = callbackState.CardInfo {
//                    if(card.Card4No != "0"){
//                        self.eventSink!("orderId="+orderId);
//                    }
//                    print("\(card)")
//                    print("\(card.AuthCode ?? "")")
//                    print("\(card.Gwsr ?? "")")
//                    print("\(card.ProcessDate)")
//                    print("\(card.Stage ?? 0)")
//                    print("\(card.Stast ?? 0)")
//                    print("\(card.Staed ?? 0)")
//                    print("\(card.Amount ?? 0)")
//                    print("\(card.Eci ?? 0)")
//                    print("\(card.Card6No ?? "")")
//                    print("\(card.Card4No ?? "")")
//                    print("\(card.RedDan ?? 0)")
//                    print("\(card.RedDeAmt ?? 0)")
//                    print("\(card.RedOkAmt ?? 0)")
//                    print("\(card.RedYet ?? 0)")
//                    print("\(card.PeriodType ?? "")")
//                    print("\(card.Frequency ?? 0)")
//                    print("\(card.ExecTimes ?? 0)")
//                    print("\(card.PeriodAmount ?? 0)")
//                    print("\(card.TotalSuccessTimes ?? 0)")
//                    print("\(card.TotalSuccessAmount ?? 0)")
//                }
//                if let atm = callbackState.ATMInfo {
//                    print("\(atm)")
//                    print("\(atm.BankCode ?? "")")
//                    print("\(atm.vAccount ?? "")")
//                    print("\(atm.ExpireDate)")
//                }
//                if let cvs = callbackState.CVSInfo {
//                    print("\(cvs)")
//                    print("\(cvs.PaymentNo ?? "")")
//                    print("\(cvs.ExpireDate)")
//                    print("\(cvs.PaymentURL ?? "")")
//                }
//                if let barcode = callbackState.BarcodeInfo {
//                    print("\(barcode)")
//                    print("\(barcode.ExpireDate)")
//                    print("\(barcode.Barcode1 ?? "")")
//                    print("\(barcode.Barcode2 ?? "")")
//                    print("\(barcode.Barcode3 ?? "")")
//                }
//                if let unionpay = callbackState.UnionPayInfo {
//                    print("\(unionpay.UnionPayURL ?? "")")
//                }
//
//            }
//        }
//    }
//
//      private func receiveTestToken(call: FlutterMethodCall, result: FlutterResult) {
//  //      self.mainCoordinator?.start()
//          if let args = call.arguments as? Dictionary<String, Any>,
//              let name = args["name"] as? String,
//              let order_id = args["order_id"] as? String {
//
//              print(name)
//              print(order_id)
//          } else {
//              result(FlutterError.init(code: "bad args", message: nil, details: nil))
//          }
//
//
//          let params = tradeTokenRequestData(paymentUIType: tokenType, merchantID: merchantID)
//          ECPayPaymentGatewayManager.sharedInstance().testToGetTestingTradeToken(paymentUIType: tokenType,
//                                                                                 is3D: true,
//                                                                                 merchantID: merchantID,
//                                                                                 aesKey: aesKey,
//                                                                                 aesIV: aesIV,
//                                                                                 parameters: params){ (state) in
//
//
//  //            print("state.callbackStateStatus = \(state.callbackStateStatus.toString())")
//  //            print("state.callbackStateMessage = \(state.callbackStateMessage)")
//  //            print("")
//
//              if state.callbackStateStatus == .Success {
//
//                  let state_ = state as! TestingTokenCallbackState
//                  self.tokenString = state_.Token
//
//              } else {
//                  self.tokenString = state.callbackStateMessage
//              }
//          }
//          result(self.tokenString)
//    }
//
//    func tradeTokenRequestData(paymentUIType: Int = 0, merchantID: String) -> [String: Any] {
//        let periodType:String = "M"
//        let frequency:Int = 12 //????????????????????? 1????????????
//                             //??? PeriodType ?????? D ?????????????????? 365??????
//                             //??? PeriodType ?????? M ?????????????????? 12 ??????
//                             //??? PeriodType ?????? Y ?????????????????? 1 ??????
//
//        let execTimes:Int = 99 //??????????????? 1 ????????????
//                             //??? PeriodType ?????? D ?????????????????? 999??????
//                             //??? PeriodType ?????? M ?????????????????? 99 ??????
//                             //??? PeriodType ?????? Y ?????????????????? 9 ??????
//        let paymentListType = 0 //currentTestMode == TestMode.is3D ? "1" : "0"
//
//        let decryptedDictionary
//        =
//        [
//            "MerchantID": merchantID,
//            "RememberCard": 1,
//            "PaymentUIType": paymentUIType,
//            "ChoosePaymentList": paymentListType, //0:?????????1:???????????????????????????
//            "OrderInfo": [
//               //"MerchantTradeNo": "4200000515202003205168406290",
//                "MerchantTradeNo": Int(Date().timeIntervalSince1970 * 1000),
//               "MerchantTradeDate": getCurrentDateString(), //"2018/09/03 18:35:20",
//               "TotalAmount": 200,
//               "ReturnURL":"https://tw.yahoo.com/",
//               "TradeDesc":"????????????",
//               "ItemName":"????????????"
//            ],
//            "CardInfo": [
//                "Redeem":"0",
//                "PeriodAmount":paymentUIType == 0 ? 200 : 0, //???PaymentUIType???0????????????????????? (????????????TotalAmount)
//                "PeriodType":periodType,
//                "Frequency":frequency,
//                "ExecTimes":execTimes,
//                "OrderResultURL":"https://www.microsoft.com/",
//                "PeriodReturnURL":"https://www.ecpay.com.tw/",
//                "CreditInstallment":"3,12,24",
//                "TravelStartDate":getMMDDYYYY(),
//                "TravelEndDate":getMMDDYYYY(),
//                "TravelCounty":"001"
//            ],
//            "ATMInfo":[
//                "ExpireDate":5
//            ],
//            "CVSInfo":[
//                "StoreExpireDate":"10080",
//                "Desc_1":"?????????",
//                "Desc_2":"?????????",
//                "Desc_3":"?????????",
//                "Desc_4":"?????????"
//            ],
//            "BarcodeInfo":[
//                "StoreExpireDate":5
//            ],
//            "ConsumerInfo": [
//                "MerchantMemberID":"1234567",
//                "Email": "test@gmail.com",
//                "Phone": "0910000222",
//                "Name": "?????????",
//                "CountryCode":"002",
//                "Address": "???????????????????????????19-2??? 6????????????2, D"
//            ],
//            "CardList":[
//                ["PayToken":"123456789","Card6No":"123456","Card4No":"1234","IsValid":1,"BankName":"????????????","Code":"002"],
//                ["PayToken":"987456123","Card6No":"654123","Card4No":"1111","IsValid":1,"BankName":"????????????","Code":"003"]
//            ],
//            "UnionPayInfo":[
//                "OrderResultURL": "https://www.ecpay.com.tw/"
//            ]
//        ] as [String : Any]
//
//        return decryptedDictionary
//    }
//
//    func userTokenRequestData(_ merchantID: String) -> [String: Any] {
//        let decryptedDictionary: [String:Any]
//        =
//        [
//            "PlatformID": merchantID,
//            "MerchantID": merchantID,
//            "ConsumerInfo": [
//                "MerchantMemberID":"1234567",
//                "Email": "test@gmail.com",
//                "Phone": "0910000222",
//                "Name": "?????????",
//                "CountryCode":"002",
//                "Address": ""
//            ],
//        ] as [String:Any]
//
//        return decryptedDictionary
//    }
//
//    func getMMDDYYYY() -> String {
//      let date = Date()
//      let format = DateFormatter()
//      //format.dateFormat = "yyyy-MM-dd HH:mm:ss"
//      format.dateFormat = "MMddyyyy"
//      let formattedDate = format.string(from: date)
//      return formattedDate
//    }
//    func getCurrentDateString() -> String {
//      let date = Date()
//      let format = DateFormatter()
//      format.dateFormat = "yyyy/MM/dd HH:mm:ss"
//      //format.dateFormat = "MMddyyyy"
//      let formattedDate = format.string(from: date)
//      return formattedDate
//    }
}

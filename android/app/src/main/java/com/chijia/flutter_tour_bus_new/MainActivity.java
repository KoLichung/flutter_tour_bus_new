package com.chijia.flutter_tour_bus_new;

import io.flutter.embedding.android.FlutterActivity;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;

//import com.chijia.flutter_tour_bus_new.api.ATMInfo;
//import com.chijia.flutter_tour_bus_new.api.BarcodeInfo;
//import com.chijia.flutter_tour_bus_new.api.CVSInfo;
//import com.chijia.flutter_tour_bus_new.api.CardInfo;
//import com.chijia.flutter_tour_bus_new.api.ConsumerInfo;
//import com.chijia.flutter_tour_bus_new.api.DecData;
//import com.chijia.flutter_tour_bus_new.api.GetTokenByTradeData;
//import com.chijia.flutter_tour_bus_new.api.OrderInfo;
//import com.chijia.flutter_tour_bus_new.api.UnionPayInfo;
//import com.chijia.flutter_tour_bus_new.databinding.MainActivityBinding;
//import com.chijia.flutter_tour_bus_new.fragment.GatewaySDKFragment;
//import com.chijia.flutter_tour_bus_new.model.ExampleData;
//import com.chijia.flutter_tour_bus_new.util.UIUtil;
//import com.chijia.flutter_tour_bus_new.util.Utility;
import com.google.gson.Gson;

import org.json.JSONObject;

import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;
//import tw.com.ecpay.paymentgatewaykit.manager.CallbackFunction;
//import tw.com.ecpay.paymentgatewaykit.manager.CallbackStatus;
//import tw.com.ecpay.paymentgatewaykit.manager.CreatePaymentCallbackData;
//import tw.com.ecpay.paymentgatewaykit.manager.GetTokenByTradeInfo;
//import tw.com.ecpay.paymentgatewaykit.manager.GetTokenByTradeInfoCallbackData;
//import tw.com.ecpay.paymentgatewaykit.manager.LanguageCode;
//import tw.com.ecpay.paymentgatewaykit.manager.PaymentType;
//import tw.com.ecpay.paymentgatewaykit.manager.PaymentkitManager;
//import tw.com.ecpay.paymentgatewaykit.manager.ServerType;

//public class MainActivity extends FlutterActivity {
//}

public class MainActivity extends FlutterActivity {
    private static final String BATTERY_CHANNEL = "samples.flutter.io/battery";
    private static final String GET_TEST_TOKEN_CHANNEL = "samples.flutter.io/get_test_token";
    private static final String PAY_ECPAY_CHANNEL = "samples.flutter.io/pay_ec_pay";
    private static final String CHARGING_CHANNEL = "samples.flutter.io/charging";
    private static final String PAY_ECPAY_CALL_BACK_CHANNEL = "samples.flutter.io/pay_ec_pay_call_back";

    private ExecutorService service = Executors.newSingleThreadExecutor();
//    private ExampleData mExampleData;

    private Activity mActivity;
//    private ServerType serverType = ServerType.Stage;
    private String theToken = "";

    private String orderId = "";
    private String tourBus = "";

//    private MainActivityBinding binding;
//    @Override
//    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.main_activity);
//    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//        GeneratedPluginRegistrant.registerWith(flutterEngine);
        super.configureFlutterEngine(flutterEngine);
//        mExampleData = new ExampleData();
        mActivity = getActivity();

//        PaymentkitManager.initialize(mActivity, serverType);

//        new MethodChannel(flutterEngine.getDartExecutor(), BATTERY_CHANNEL).setMethodCallHandler(
//                new MethodCallHandler() {
//                    @Override
//                    public void onMethodCall(MethodCall call, Result result) {
//                        if (call.method.equals("getBatteryLevel")) {
//                            int batteryLevel = getBatteryLevel();
//
//                            if (batteryLevel != -1) {
//                                result.success(batteryLevel);
//                            } else {
//                                result.error("UNAVAILABLE", "Battery level not available.", null);
//                            }
//                        } else {
//                            result.notImplemented();
//                        }
//                    }
//                }
//        );

//        new MethodChannel(flutterEngine.getDartExecutor(), GET_TEST_TOKEN_CHANNEL).setMethodCallHandler(
//                new MethodCallHandler() {
//                    @Override
//                    public void onMethodCall(MethodCall call, Result result) {
//                        if (call.method.equals("getTestToken")) {
//                            getTestToken();
//
//                            if (theToken != "") {
//                                result.success("get test token");
//                            } else {
//                                result.error("UNAVAILABLE", "Fale to get token.", null);
//                            }
//                        } else {
//                            result.notImplemented();
//                        }
//                    }
//                }
//        );

//        new MethodChannel(flutterEngine.getDartExecutor(), PAY_ECPAY_CHANNEL).setMethodCallHandler(
//                new MethodCallHandler() {
//                    @Override
//                    public void onMethodCall(MethodCall call, Result result) {
//                        if (call.method.equals("payECPay")) {
//                            String token = call.argument("token");
//                            orderId = call.argument("orderId");
//                            tourBus = call.argument("tourBus");
//
//                            payECPay(token);
//
//                            if (true) {
//                                result.success("success pay!");
//                            } else {
//                                result.error("UNAVAILABLE", "Fail to pay!", null);
//                            }
//                        } else {
//                            result.notImplemented();
//                        }
//                    }
//                }
//        );

//        new EventChannel(flutterEngine.getDartExecutor(), CHARGING_CHANNEL).setStreamHandler(
//                new StreamHandler() {
//                    private BroadcastReceiver chargingStateChangeReceiver;
//
//                    @Override
//                    public void onListen(Object arguments, EventChannel.EventSink events) {
//                        chargingStateChangeReceiver = createChargingStateChangeReceiver(events);
//                        registerReceiver(chargingStateChangeReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
//                    }
//
//                    @Override
//                    public void onCancel(Object arguments) {
//                        unregisterReceiver(chargingStateChangeReceiver);
//                        chargingStateChangeReceiver = null;
//                    }
//                }
//        );
//
//        new EventChannel(flutterEngine.getDartExecutor(), PAY_ECPAY_CALL_BACK_CHANNEL).setStreamHandler(
//                new StreamHandler() {
//                    private BroadcastReceiver paymentStateChangeReceiver;
//
//                    @Override
//                    public void onListen(Object arguments, EventChannel.EventSink events) {
//                        paymentStateChangeReceiver = createPaymentStateChangeReceiver(events);
//                        registerReceiver(paymentStateChangeReceiver, new IntentFilter("com.chijia.payment") );
//                    }
//
//                    @Override
//                    public void onCancel(Object arguments) {
//                        unregisterReceiver(paymentStateChangeReceiver);
//                        paymentStateChangeReceiver = null;
//                    }
//                }
//        );

    }

    private BroadcastReceiver createPaymentStateChangeReceiver(final EventChannel.EventSink events) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String message = intent.getStringExtra("status");
                events.success(message);
            }
        };
    }

    private BroadcastReceiver createChargingStateChangeReceiver(final EventChannel.EventSink events) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);

                if (status == BatteryManager.BATTERY_STATUS_UNKNOWN) {
                    events.error("UNAVAILABLE", "Charging status unavailable", null);
                } else {
                    boolean isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                            status == BatteryManager.BATTERY_STATUS_FULL;
                    events.success(isCharging ? "charging" : "discharging");
                }
            }
        };
    }

    private int getBatteryLevel() {
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            return (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }
    }

//    private void getTestToken(){
////        binding = DataBindingUtil.setContentView(this,
////                R.layout.main_activity);
////
////        getSupportFragmentManager().beginTransaction()
////                .replace(R.id.frameLayout, GatewaySDKFragment.newInstance(),
////                        GatewaySDKFragment.FragmentTagName)
////                .commit();
//
//
//        service.submit(new Runnable() {
//            @Override
//            public void run() {
//                try {
//                    CallbackFunction<GetTokenByTradeInfoCallbackData> callback = new CallbackFunction<GetTokenByTradeInfoCallbackData>() {
//                        @Override
//                        public void callback(GetTokenByTradeInfoCallbackData callbackData) {
//                            try {
//                                if(callbackData.getCallbackStatus() == CallbackStatus.Success) {
//                                    if(callbackData.getRtnCode() == 1) {
//                                        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
//                                        cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(mExampleData.getAesKey().getBytes(),
//                                                "AES"), new IvParameterSpec(mExampleData.getAesIv().getBytes()));
//                                        byte[] decBytes = cipher.doFinal(Base64.decode(callbackData.getData(), Base64.NO_WRAP));
//                                        String resJson = URLDecoder.decode(new String(decBytes));
//                                        Utility.log("resJson " + resJson);
//                                        DecData decData = new Gson().fromJson(resJson, DecData.class);
//                                        theToken = decData.Token;
////                                        Log.i("data", decData.toString());
////                                        mActivity.runOnUiThread(new Runnable() {
////                                            @Override
////                                            public void run() {
////                                                payECPay();
////                                            }
////                                        });
//                                    } else {
//                                        Log.e("error", "error to get token");
//                                    }
//                                }
//                            } catch (Exception ex) {
//                                Utility.exceptionLog(ex);
//                            }
//                        }
//                    };
//                    callApiGetTokenByTrade(2, callback);
//                } catch (Exception ex) {
//                    Utility.exceptionLog(ex);
//                }
//            }
//        });
//    }

//    private void payECPay(String token){
//
//        LanguageCode languageCode = LanguageCode.zhTW;
//        boolean useResultPage = true;
//        String xmlMerchantID = null;
//
//        PaymentkitManager.createPayment(mActivity,
//                token, languageCode, useResultPage,
//                mExampleData.getAppStoreName(), PaymentkitManager.RequestCode_CreatePayment);
//
//    }

//    private void callApiGetTokenByTrade(int paymentUIType, CallbackFunction<GetTokenByTradeInfoCallbackData> callback) throws Exception {
//        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
//
//        // 交易金額
//        int totalAmount = 200;
//        // 信用卡紅利折抵
//        String redeem = "0";
//
//        OrderInfo orderInfo = new OrderInfo(
//                dateFormat.format(System.currentTimeMillis()),
//                String.valueOf(System.currentTimeMillis()),
//                totalAmount,
//                "http://45.77.25.172/api/ecpay/post_callback" ,
//                "交易測試",
//                "測試商品");
//
//        CardInfo cardInfo = null;
//        UnionPayInfo unionPayInfo = null;
//        if(paymentUIType == 0) {
//            // 信用卡定期定額
//            cardInfo = new CardInfo(
//                    "http://45.77.25.172/api/ecpay/post_callback",
//                    totalAmount,
//                    "M",
//                    3,
//                    5,
//                    "http://45.77.25.172/api/ecpay/post_callback");
//        } else if(paymentUIType == 1) {
//            // 國旅卡
//            cardInfo = new CardInfo(
//                    redeem,
//                    "http://45.77.25.172/api/ecpay/post_callback",
//                    "01012020",
//                    "01012029",
//                    "001");
//        } else if(paymentUIType == 2) {
//            // 付款選擇清單頁
//            cardInfo = new CardInfo(
//                    redeem,
//                    "http://45.77.25.172/api/ecpay/post_callback",
//                    "3,6");
//        }
//        unionPayInfo = new UnionPayInfo("http://45.77.25.172/api/ecpay/post_callback");
//
//        ATMInfo atmInfo = new ATMInfo(
//                5);
//
//        CVSInfo cvsInfo = new CVSInfo(
//                10080,
//                "條碼一",
//                "條碼二",
//                "條碼三",
//                "條碼四");
//
//        BarcodeInfo barcodeInfo = new BarcodeInfo(
//                5);
//
//        ConsumerInfo consumerInfo = new ConsumerInfo(
//                mExampleData.getMerchantMemberID(),
//                mExampleData.getEmail(),
//                mExampleData.getPhone(),
//                mExampleData.getName(),
//                mExampleData.getCountryCode(),
//                mExampleData.getAddress());
//
//        GetTokenByTradeData getTokenByTradeData = new GetTokenByTradeData(
//                null,
//                mExampleData.getMerchantID(),
//                1,
//                paymentUIType,
//                "1,3",
//                orderInfo,
//                cardInfo,
//                atmInfo,
//                cvsInfo,
//                barcodeInfo,
//                consumerInfo,
//                unionPayInfo);
//
//        String data = new Gson().toJson(getTokenByTradeData);
//
//        Utility.log(data);
//
//        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
//        cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(mExampleData.getAesKey().getBytes(),
//                "AES"), new IvParameterSpec(mExampleData.getAesIv().getBytes()));
//        byte[] encryptedBytes = cipher.doFinal(data.getBytes());
//        String base64Data = Base64.encodeToString(encryptedBytes, Base64.NO_WRAP);
//
//        GetTokenByTradeInfo getTokenByTradeInfo = new GetTokenByTradeInfo();
//        getTokenByTradeInfo.setRqID(String.valueOf(System.currentTimeMillis()));
//        getTokenByTradeInfo.setRevision(mExampleData.getRevision());
//        getTokenByTradeInfo.setMerchantID(mExampleData.getMerchantID());
//        getTokenByTradeInfo.setData(base64Data);
//
//        PaymentkitManager.testGetTokenByTrade(mActivity,
//                getTokenByTradeInfo, callback);
//    }

//    public void onActivityResult(int requestCode, int resultCode, Intent data) {
//        Utility.log("onActivityResult(), requestCode:" + requestCode + ", resultCode:" + resultCode);
//        if(requestCode == PaymentkitManager.RequestCode_CreatePayment) {
//            PaymentkitManager.createPaymentResult(mActivity, resultCode, data, new CallbackFunction<CreatePaymentCallbackData>() {
//                @Override
//                public void callback(CreatePaymentCallbackData callbackData) {
//                    //////////////watch here /////////////////////
//                    Intent intent=new Intent("com.chijia.payment");
//
//                    switch (callbackData.getCallbackStatus()) {
//                        case Success:
//                            if(callbackData.getRtnCode() == 1) {
//                                intent.putExtra("status", "success");
//                                sendBroadcast(intent);
//                                StringBuffer sb = new StringBuffer();
//                                sb.append("PaymentType:");
//                                sb.append("\r\n");
//                                sb.append(getPaymentTypeName(callbackData.getPaymentType()));
//                                sb.append("\r\n");
//                                sb.append("PlatformID:");
//                                sb.append("\r\n");
//                                sb.append(callbackData.getPlatformID());
//                                sb.append("\r\n");
//                                sb.append("MerchantID:");
//                                sb.append("\r\n");
//                                sb.append(callbackData.getMerchantID());
//                                sb.append("\r\n");
//                                sb.append("CustomField:");
//                                sb.append("\r\n");
//                                sb.append(callbackData.getCustomField());
//                                sb.append("\r\n");
//                                sb.append("\r\n");
//                                sb.append("OrderInfo.MerchantTradeNo");
//                                sb.append("\r\n");
//                                sb.append(callbackData.getOrderInfo().getMerchantTradeNo());
//                                sb.append("\r\n");
//                                sb.append("OrderInfo.TradeDate");
//                                sb.append("\r\n");
//                                sb.append(callbackData.getOrderInfo().getTradeDate());
//                                sb.append("\r\n");
//                                sb.append("OrderInfo.TradeNo");
//                                sb.append("\r\n");
//                                sb.append(callbackData.getOrderInfo().getTradeNo());
//                                sb.append("\r\n");
//                                sb.append("OrderInfo.TradeAmt");
//                                sb.append("\r\n");
//                                sb.append(callbackData.getOrderInfo().getTradeAmt());
//                                sb.append("\r\n");
//                                sb.append("OrderInfo.PaymentType");
//                                sb.append("\r\n");
//                                sb.append(callbackData.getOrderInfo().getPaymentType());
//                                sb.append("\r\n");
//                                sb.append("OrderInfo.ChargeFee");
//                                sb.append("\r\n");
//                                sb.append(callbackData.getOrderInfo().getChargeFee());
//                                sb.append("\r\n");
//                                sb.append("OrderInfo.TradeStatus");
//                                sb.append("\r\n");
//                                sb.append(callbackData.getOrderInfo().getTradeStatus());
//
//                                if(callbackData.getPaymentType() == PaymentType.CreditCard ||
//                                        callbackData.getPaymentType() == PaymentType.CreditInstallment ||
//                                        callbackData.getPaymentType() == PaymentType.PeriodicFixedAmount ||
//                                        callbackData.getPaymentType() == PaymentType.NationalTravelCard ||
//                                        callbackData.getPaymentType() == PaymentType.UnionPay) {
//                                    sb.append("\r\n");
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.AuthCode");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getAuthCode());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.Gwsr");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getGwsr());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.ProcessDate");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getProcessDate());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.Amount");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getAmount());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.Eci");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getEci());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.Card6No");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getCard6No());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.Card4No");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getCard4No());
//                                }
//                                if(callbackData.getPaymentType() == PaymentType.CreditCard) {
//                                    intent.putExtra("status", "orderId="+orderId);
//                                    sendBroadcast(intent);
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.RedDan");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getRedDan());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.RedDeAmt");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getRedDeAmt());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.RedOkAmt");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getRedOkAmt());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.RedYet");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getRedYet());
//                                }
//                                if(callbackData.getPaymentType() == PaymentType.CreditInstallment) {
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.Stage");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getStage());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.Stast");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getStast());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.Staed");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getStaed());
//                                }
//                                if(callbackData.getPaymentType() == PaymentType.PeriodicFixedAmount) {
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.PeriodType");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getPeriodType());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.Frequency");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getFrequency());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.ExecTimes");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getExecTimes());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.PeriodAmount");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getPeriodAmount());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.TotalSuccessTimes");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getTotalSuccessTimes());
//                                    sb.append("\r\n");
//                                    sb.append("CardInfo.TotalSuccessAmount");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCardInfo().getTotalSuccessAmount());
//                                }
//
//                                if(callbackData.getPaymentType() == PaymentType.ATM) {
//                                    HashMap<String, String> map = new HashMap<String, String>();
//                                    map.put("bankCode", callbackData.getAtmInfo().getBankCode());
//                                    map.put("vAccount", callbackData.getAtmInfo().getvAccount());
//                                    map.put("expireDate", callbackData.getAtmInfo().getExpireDate());
//                                    map.put("orderId", orderId);
//                                    map.put("tourBus", tourBus);
//                                    String jsonString = new JSONObject(map).toString();
//                                    intent.putExtra("status", jsonString);
//                                    sendBroadcast(intent);
//
//                                    sb.append("\r\n");
//                                    sb.append("\r\n");
//                                    sb.append("ATMInfo.BankCode");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getAtmInfo().getBankCode());
//                                    sb.append("\r\n");
//                                    sb.append("ATMInfo.vAccount");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getAtmInfo().getvAccount());
//                                    sb.append("\r\n");
//                                    sb.append("ATMInfo.ExpireDate");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getAtmInfo().getExpireDate());
//                                }
//                                if(callbackData.getPaymentType() == PaymentType.CVS) {
//                                    sb.append("\r\n");
//                                    sb.append("\r\n");
//                                    sb.append("CVSInfo.PaymentNo");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCvsInfo().getPaymentNo());
//                                    sb.append("\r\n");
//                                    sb.append("CVSInfo.ExpireDate");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCvsInfo().getExpireDate());
//                                    sb.append("\r\n");
//                                    sb.append("CVSInfo.PaymentURL");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getCvsInfo().getPaymentURL());
//                                }
//                                if(callbackData.getPaymentType() == PaymentType.Barcode) {
//                                    sb.append("\r\n");
//                                    sb.append("\r\n");
//                                    sb.append("BarcodeInfo.ExpireDate");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getBarcodeInfo().getExpireDate());
//                                    sb.append("\r\n");
//                                    sb.append("BarcodeInfo.Barcode1");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getBarcodeInfo().getBarcode1());
//                                    sb.append("\r\n");
//                                    sb.append("BarcodeInfo.Barcode2");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getBarcodeInfo().getBarcode2());
//                                    sb.append("\r\n");
//                                    sb.append("BarcodeInfo.Barcode3");
//                                    sb.append("\r\n");
//                                    sb.append(callbackData.getBarcodeInfo().getBarcode3());
//                                }
//
////                                UIUtil.showAlertDialog(mActivity, "提醒您", sb.toString(), new DialogInterface.OnClickListener() {
////                                    @Override
////                                    public void onClick(DialogInterface dialog, int which) {
////
////                                    }
////                                }, "確定");
//                            } else {
//                                intent.putExtra("status", "fail");
//                                sendBroadcast(intent);
//
//                                StringBuffer sb = new StringBuffer();
//                                sb.append(callbackData.getRtnCode());
//                                sb.append("\r\n");
//                                sb.append(callbackData.getRtnMsg());
//
//
////                                UIUtil.showAlertDialog(mActivity, "提醒您", sb.toString(), new DialogInterface.OnClickListener() {
////                                    @Override
////                                    public void onClick(DialogInterface dialog, int which) {
////
////                                    }
////                                }, "確定");
//                            }
//                            break;
//                        case Fail:
//                            intent.putExtra("status", "fail");
//                            sendBroadcast(intent);
////                            UIUtil.showAlertDialog(mActivity, "提醒您", "Fail Code=" + callbackData.getRtnCode() + ", Msg=" + callbackData.getRtnMsg(), new DialogInterface.OnClickListener() {
////                                @Override
////                                public void onClick(DialogInterface dialog, int which) {
////
////                                }
////                            }, "確定");
//                            break;
//                        case Cancel:
//                            intent.putExtra("status", "cancel");
//                            sendBroadcast(intent);
////                            UIUtil.showAlertDialog(mActivity, "提醒您", "交易取消", new DialogInterface.OnClickListener() {
////                                @Override
////                                public void onClick(DialogInterface dialog, int which) {
////
////                                }
////                            }, "確定");
//                            break;
//                        case Exit:
//                            intent.putExtra("status", "exit");
//                            sendBroadcast(intent);
////                            UIUtil.showAlertDialog(mActivity, "提醒您", "離開", new DialogInterface.OnClickListener() {
////                                @Override
////                                public void onClick(DialogInterface dialog, int which) {
////
////                                }
////                            }, "確定");
//                            break;
//                    }
//                }
//            });
//        } else if(requestCode == PaymentkitManager.RequestCode_GooglePay) {
//            PaymentkitManager.googlePayResult(mActivity, resultCode, data);
//        }
//    }

//    private String getPaymentTypeName(PaymentType paymentType) {
//        switch (paymentType) {
//            case CreditCard:
//                return "信用卡";
//            case CreditInstallment:
//                return "信用卡分期";
//            case ATM:
//                return "ATM虛擬帳號";
//            case CVS:
//                return "超商代碼";
//            case Barcode:
//                return "超商條碼";
//            case PeriodicFixedAmount:
//                return "信用卡定期定額";
//            case NationalTravelCard:
//                return "國旅卡";
//            case UnionPay:
//                return "銀聯卡";
//            default:
//                return "";
//        }
//    }
}

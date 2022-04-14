package com.chijia.flutter_tour_bus_new.model;

import  com.chijia.flutter_tour_bus_new.R;
import androidx.databinding.ObservableField;

public class GatewaySDKModel {

    public final ObservableField<String> description = new ObservableField<>();

    public final ObservableField<String> sdkVersion = new ObservableField<>();

    public final ObservableField<Integer> getTokenType = new ObservableField<>();

    public final ObservableField<String> token = new ObservableField<>();

    public final ObservableField<Integer> languageSelectedPosition = new ObservableField<>();

    public final ObservableField<Boolean> useResultPageSwitch = new ObservableField<>();

    public final ObservableField<String> xmlMerchantID = new ObservableField<>();

    public final ObservableField<Boolean> threeDSwitch = new ObservableField<>();

    public final ObservableField<Boolean> redeemSwitch = new ObservableField<>();

    public GatewaySDKModel() {
        getTokenType.set(R.id.getTokenType1);
    }

}

package com.chijia.flutter_tour_bus_new;

import android.content.Intent;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.Fragment;

import com.chijia.flutter_tour_bus_new.databinding.MainActivityBinding;
import com.chijia.flutter_tour_bus_new.fragment.GatewaySDKFragment;
import com.chijia.flutter_tour_bus_new.util.Utility;

public class MyFlutterActivity extends AppCompatActivity {

    private MainActivityBinding binding;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = DataBindingUtil.setContentView(this,
                R.layout.main_activity);

        getSupportFragmentManager().beginTransaction()
                .replace(R.id.frameLayout, GatewaySDKFragment.newInstance(),
                        GatewaySDKFragment.FragmentTagName)
                .commit();

    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        Utility.log("MainActivity(), requestCode:" + requestCode + ", resultCode:" + resultCode);
        super.onActivityResult(requestCode, resultCode, data);
        Fragment fragment = getSupportFragmentManager().findFragmentById(R.id.frameLayout);
        if(fragment!=null && requestCode == 13001) {
            (fragment).onActivityResult(requestCode, resultCode, data);
        }
    }

}
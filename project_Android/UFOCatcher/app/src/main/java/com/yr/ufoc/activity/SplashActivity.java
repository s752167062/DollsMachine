package com.yr.ufoc.activity;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

import com.yr.ufoc.R;

import com.base.application.BaseActivity;


/**
 * Created by Administrator on 2016/5/13.
 */
public class SplashActivity extends BaseActivity {
    private View rootView;
    private ImageView iv_splash;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        rootView = findViewById(R.id.rootView);
        iv_splash = ((ImageView) findViewById(R.id.iv_splash));
        rootView.postDelayed(new Runnable() {
            @Override
            public void run() {
                jump();
            }
        }, 500);
    }

    private void jump() {
    /*    boolean isNoFirst = SPControl.getFirst();//false
        if (isNoFirst) {//不是第一次
            String token = SPControl.getToken();
//            if(TextUtils.isEmpty(token)){
//                LoginActivity.start(this);
//            }else{
            //TMainActivity.start(this, 0);
//            }
        } else {//第一次
            //轮播启动页
            //GuidActivity.start(this);
        }*/
        MainActivity.start(this);
        finish();
    }


}
package com.yr.ufoc.application;

import android.app.Application;
import android.content.Context;
import android.util.DisplayMetrics;
import android.view.ViewGroup;

import com.yr.ufoc.R;

import com.base.application.ABApplicationImp;
import com.base.log.L;
import com.base.rxvolley.NetRequest;
import com.yr.ufoc.http.UrlConfig;
import com.yr.ufoc.http.Urls;

/**
 * Created by Anmi
 * on 2017/11/15.
 */

public class MyApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();

        ABApplicationImp.setApplication(this);
        ABApplicationImp.getInstance();
        NetRequest.setSafeRequest(false);
        L.init(true);
        //设置状态栏变色
        ABApplicationImp.getInstance().setStatusColor(getResources().getColor(R.color.themeColor), getResources().getColor(R.color.themeColor), true);
        initNetConfig();//初始化网络配置

    }

    /**
     * 初始化网络配置
     */
    private void initNetConfig() {

        UrlConfig config = Urls.newInstance().config();
    }


}

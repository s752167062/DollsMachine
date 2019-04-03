package com.yr.ufoc.activity;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewCompat;
import android.support.v4.view.ViewPager;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.View;
import android.widget.LinearLayout;

import com.yr.ufoc.R;

import java.util.ArrayList;
import java.util.List;
import java.lang.reflect.Field;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.Unbinder;

import com.base.application.BaseActivity;
import com.base.rxvolley.HttpResultListener;
import com.base.rxvolley.result.NetResult;
import com.yr.ufoc.adapter.IndexFragmentPageAdapter;

public class MainActivity extends BaseActivity implements HttpResultListener {

    @BindView(R.id.tabLayout)
    TabLayout tabLayout;
    @BindView(R.id.viewpager)
    ViewPager viewpager;
    private Unbinder bind;
    private IndexFragmentPageAdapter adapter;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        bind = ButterKnife.bind(this);
        initTab();
        initView();
    }

    private void initView() {
        List<String> list = new ArrayList<>();
        list.add("所有");
        list.add("第一页");
        list.add("第二页");
        list.add("第三页");
        list.add("空闲中");
        adapter = new IndexFragmentPageAdapter(getSupportFragmentManager(), list);
        viewpager.setAdapter(adapter);
        tabLayout.setTabMode(TabLayout.MODE_SCROLLABLE);
      //  new IndicatorUtil(this,);
    }
    private void initTab(){
        tabLayout.setTabMode(TabLayout.MODE_SCROLLABLE);
        tabLayout.setTabTextColors(ContextCompat.getColor(this, R.color.gray), ContextCompat.getColor(this, R.color.white));
        tabLayout.setSelectedTabIndicatorColor(ContextCompat.getColor(this, R.color.white));
        ViewCompat.setElevation(tabLayout, 10);
        tabLayout.setupWithViewPager(viewpager);
    }



    private void netRequestGoodsType() {
        //  NetRequest.request().setParams(Urls.getParams(new HttpParams(), true)).setFlag(NET_GOODS).post(Urls.goodsentityTypesUrl, this);
    }


    @Override
    protected void onStart() {
        super.onStart();
        //进行刷新动作
    }

    public static void start(Context context) {
        go2Act(context, MainActivity.class);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (bind != null)
            bind.unbind();
    }

    @Override
    public void onHttpResult(String data, int errorNo, String[] flag, String errorMsg, Integer requestId) {
        if (NetResult.isSuccess(this, data, errorNo, errorMsg, requestId)) {
           /*
            if(NET_GOODS.equals(flag[0])){

            }*/
        }

    }
}

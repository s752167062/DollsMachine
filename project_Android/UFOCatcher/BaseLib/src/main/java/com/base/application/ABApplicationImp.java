package com.base.application;

import android.app.Application;

import com.kymjs.rxvolley.RxVolley;
import com.kymjs.rxvolley.http.RequestQueue;
import com.umeng.analytics.MobclickAgent;

import java.io.File;

import com.base.exception.ABCrashHandler;
import com.base.log.SP;
import com.base.rxvolley.NetRequest;
import com.base.rxvolley.OkHttpStack;
import com.base.utils.ABPrefsUtil;
import okhttp3.OkHttpClient;

/**
 * 基础的application类
 */
public class ABApplicationImp {


    //状态栏颜色
    int statusColor;
    //底部导航栏颜色
    int navColor;
    //是否是黑色模式（小米和魅族有效）
    boolean darkmode;
    boolean requireStatusColor;
    private static ABApplicationImp instance;

    private static Application mApplication;

    public void setRequireStatusColor(boolean requireStatusColor) {
        this.requireStatusColor = requireStatusColor;
    }

    private ABApplicationImp() {
        // initCrashHandler(); // 初始化程序崩溃捕捉处理
        initPrefs(); // 初始化SharedPreference
        initOkHttp();
        //友盟统计日志加密
        MobclickAgent.enableEncrypt(false);
        MobclickAgent.setScenarioType(getApplication(), MobclickAgent.EScenarioType.E_UM_NORMAL);
    }

    public static ABApplicationImp getInstance() {
        if (instance == null)
            instance = new ABApplicationImp();
        return instance;
    }

    public Application getApplication() {
        return mApplication;
    }

    public static void setApplication(Application application) {
        mApplication = application;
    }


    private void initOkHttp() {
        final File cacheFolder = RxVolley.CACHE_FOLDER;
        if (cacheFolder != null) {
            try {
                final RequestQueue queue = RequestQueue.newRequestQueue(cacheFolder,
                        new OkHttpStack(new OkHttpClient()));
                if (queue != null)
                    NetRequest.setRequestQueue(queue);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void saveMd5Pwd(String md5Pwd) {
        ABPrefsUtil.getPrefsUtil("encrypt_prefs").putString("md5Pwd", md5Pwd).commit();
    }

    public String getMd5Pwd() {
        return ABPrefsUtil.getPrefsUtil("encrypt_prefs").getString("md5Pwd", "");
    }


    /**
     * 初始化程序崩溃捕捉处理
     */
    protected void initCrashHandler() {
        ABCrashHandler.init(getApplication());
    }

    /**
     * 初始化SharedPreference
     */
    protected void initPrefs() {
        SP.init(getApplication());
        ABPrefsUtil.init(getApplication(), "encrypt_prefs", getApplication().MODE_PRIVATE);
    }

    /**
     * 配置状态栏颜色
     *
     * @return
     */
    public int getStatusColor() {
        return statusColor;
    }

    public int getNavColor() {
        return navColor;
    }

    public boolean isDarkmode() {
        return darkmode;
    }

    /**
     * @param statusColor 状态栏颜色
     * @param navColor    底部栏颜色，暂时未使用
     * @param darkmode    是否要启用白色黑色模式（纯白色适用，小米和魅族适用）
     */
    public void setStatusColor(int statusColor, int navColor, boolean darkmode) {
        this.statusColor = statusColor;
        this.navColor = navColor;
        this.darkmode = darkmode;
        requireStatusColor = true;
    }

}

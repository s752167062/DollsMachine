package com.yr.ufoc.http;

import com.kymjs.rxvolley.client.HttpParams;

import java.util.HashMap;
import java.util.Map;

import com.base.control.LoginControl;
import com.base.utils.ABTextUtil;
import com.yr.ufoc.http.event.Server;

/**
 * Created by Nowy on 2016/4/6.
 * URL的基类，主要用于切换域名
 */
public class BaseUrls {
    public static final int NET_FAIL = 0;
    public static final int NET_SUCCESS = 1;
    public static final int TOKEN_INVALID = 40000;//Token无效
    public static final int SERVER_BUSY = -1;//服务繁忙


    private volatile static BaseUrls mBaseUrls ;
    private static Map<Integer,Map<String,Server>> mServerMaps; //保存所有的服务器信息


    public final static int TYPE_TEST_URL = 0;        //测试服务器
    public final static int TYPE_ONLINE_URL = 1;      //线上服务器
    public final static int TYPE_PREPARE_LINE_URL = 2;//测试线上服务器
    private static int mServerType = TYPE_PREPARE_LINE_URL; //默认线上
//    private static String mAppName = "";
    private static Map<Integer,String> mAppNameMaps;//appName集合
    public static BaseUrls newInstance(){
        mBaseUrls = new BaseUrls();
        mServerMaps = new HashMap<>();
        mAppNameMaps = new HashMap<>();
        return mBaseUrls;
    }


    /**
     * 设置服务器类型
     * @param serverType TYPE_TEST_URL，TYPE_ONLINE_URL，TYPE_PREPARE_LINE_URL
     */
    public static void setServerType(int serverType) {
        BaseUrls.mServerType = serverType;
    }

    public UrlConfig config(){
        return new UrlConfig(mServerMaps,mAppNameMaps);
    }

    private static String appendPort(int port){
        StringBuffer sb = new StringBuffer();
        return sb.append(":").append(port).append("/").toString();
    }


    //获取当前使用的主机和端口号
    public static String getHttpUrl(){
        Map<String,Server> serverMap = mServerMaps.get(mServerType);
        if(serverMap == null) throw new NullPointerException("Is not configured "+mServerType);
        Server server = serverMap.get(UrlConfig.URL_DATA);
        if(server == null ) throw  new NullPointerException("Is not configured UrlConfig by "+UrlConfig.URL_DATA);
        return new StringBuffer(server.getIp())
                                    .append(appendPort(server.getPort()))
                                            .append(mAppNameMaps.get(mServerType)).append("/").append("%s").toString();
    }

    public static String getImageUrl(String picName){
        if(picName == null) return null;
        if(picName.startsWith("http")) return picName;
        Map<String,Server> serverMap = mServerMaps.get(mServerType);
        if(serverMap == null) throw new NullPointerException("Is not configured "+mServerType);
        Server server = serverMap.get(UrlConfig.URL_IMAGE);
        if(server == null ) throw  new NullPointerException("Is not configured UrlConfig by "+UrlConfig.URL_IMAGE);
        return new StringBuffer(server.getIp()).append(appendPort(server.getPort())).append(picName).toString();
    }

    public static String getVideoUrl(String videoName){
        Map<String,Server> serverMap = mServerMaps.get(mServerType);
        if(serverMap == null) throw new NullPointerException("Is not configured "+mServerType);
        Server server = serverMap.get(UrlConfig.URL_VIDEO);
        if(server == null ) throw  new NullPointerException("Is not configured UrlConfig by "+UrlConfig.URL_VIDEO);
        return new StringBuffer(server.getIp()).append(appendPort(server.getPort()))
                .append(mAppNameMaps.get(mServerType)).append("/").append(videoName).toString();
    }


    /**
     * 根据severSpecies获取httpUrl,不带appName
     * @param severSpecies UrlConfig中的type
     * @return
     */
    public static String getHttpUrlNotWidthAppName(String severSpecies){
        Map<String,Server> serverMap = mServerMaps.get(mServerType);
        if(serverMap == null) throw new NullPointerException("Is not configured "+mServerType);
        Server server = serverMap.get(severSpecies);
        if(server == null ) throw  new NullPointerException("Is not configured UrlConfig by "+UrlConfig.URL_DATA);
        return new StringBuffer(server.getIp())
                .append(appendPort(server.getPort())).append("%s").toString();
    }

    /**
     * 根据传入的服务器种类获取服务器
     * @param severSpecies 服务器种类
     * @return
     */
    public static String getUrlBySeverSpecies(String severSpecies){
        Map<String,Server> serverMap = mServerMaps.get(mServerType);
        if(serverMap == null) throw new NullPointerException("Is not configured "+mServerType);
        Server server = serverMap.get(severSpecies);
        if(server == null ) throw  new NullPointerException("Is not configured UrlConfig by "+severSpecies);
        return new StringBuffer(server.getIp()).append(appendPort(server.getPort())).toString();
    }

    public static HttpParams getParams(boolean isPrivate) {
        HttpParams params = new HttpParams();
        if (isPrivate) {
            if (LoginControl.getUserId()!=0) {
                params.put("userId", "" + LoginControl.getUserId());
            }

            if(!ABTextUtil.isEmpty(LoginControl.getToken())){
                params.put("token", LoginControl.getToken());
            }

        }
//        params.putHeaders("APP_key", "59334e721bcd31");
//        params.putHeaders("APP_scode", MD5.md5("59334e721bcd31maicai"));
        return params;
    }

    public static String getDownloadUrl(String downloadUrl){
        Map<String,Server> serverMap = mServerMaps.get(mServerType);
        if(downloadUrl.startsWith("http")) return downloadUrl;
        if(serverMap == null) throw new NullPointerException("Is not configured "+mServerType);
        Server server = serverMap.get(UrlConfig.URL_DOWNLAND);
        if(server == null ) throw  new NullPointerException("Is not configured UrlConfig by "+UrlConfig.URL_DOWNLAND);
        return new StringBuffer(server.getIp()).append(appendPort(server.getPort()))
                .append(downloadUrl).toString();
    }


}

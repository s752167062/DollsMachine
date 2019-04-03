package com.yr.ufoc.http;



import java.util.HashMap;
import java.util.Map;

import com.yr.ufoc.http.event.Server;

public class UrlConfig {
    //服务器类型
    public static final String URL_DATA = "dataUrl";    //数据服务器
    public static final String URL_IMAGE = "imageUrl";  //图片服务器
    public static final String URL_VIDEO = "videoUrl";  //视频服务器
    public static final String URL_UPDATE = "updateUrl";//更新服务器
    public static final String URL_HTML  ="html";// html服务器
    public static final String URL_DOWNLAND = "downlandUrl";//下载服务器
    public static final String URL_OTHER = "otherUrl";      //其他服务器
    private Map<String,Server> mCacheServerMap ;//缓存单组服务器信息
    private Map<Integer,Map<String,Server>> mServerMaps;
    private Map<Integer,String> mAppNameMaps;
    private String mAppName; //项目名缓存
    public UrlConfig(Map<Integer,Map<String,Server>> serverMaps, Map<Integer,String> appNameMaps){
        this.mServerMaps = serverMaps;
        this.mAppNameMaps = appNameMaps;
    }

    public UrlConfig builder(String appName){
        mCacheServerMap = new HashMap<>();
        this.mAppName = appName;
        return this;
    }

    /**
     * 配置服务器域名
     * @param serverSpecies 服务器种类，常见有以下几种：
     *              URL_DATA，
     *              URL_IMAGE，
     *              URL_VIDEO，
     *              URL_UPDATE，
     *              URL_DOWNLAND，
     *              URL_OTHER
     *
     * @param ip   ip地址
     * @param port 端口号
     * @return
     */
    public UrlConfig setServer(String serverSpecies, String ip, int port){
        mCacheServerMap.put(serverSpecies,new Server(ip,port));
        return this;
    }


    public void setIn(int serverType){
        mServerMaps.put(serverType,mCacheServerMap);
        mAppNameMaps.put(serverType,mAppName);
    }
}
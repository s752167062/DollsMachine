package com.base.rxvolley.result;

import android.app.Activity;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import com.base.log.L;
import com.base.log.T;
import com.base.rxvolley.VolleyErrorMsg;

/**
 * Created by 红亮 on 2015/12/5.
 * 处理服务器返回数据，并将服务器json解析成javabean
 */
public class NetResultJson {
	public static final int NET_SUCCESS =1;
	public static final int NET_FAIL =0;
	public static final int TOKEN_INVALID =40000;
	public static final int SERVER_BUSY =-1;
	private static final String TAG =NetResultJson.class.getSimpleName() ;

	/**
	 * 将服务器json解析成javabean
	 * @param activity
	 * @param jsonClazz
	 * @param jsonStr
	 * @param <E>
	 * @return
	 */
	public static <E>E getJSON(Activity activity,Class<E> jsonClazz, String jsonStr, int errorNo,String errorMsg,Integer  requestId) {
		E jsonClassTemp=null;
		if (jsonStr != null) {
			JSONObject json = null;
			try {
				jsonClassTemp= JSON.parseObject(jsonStr, jsonClazz);
				json = JSONObject.parseObject(jsonStr);
			} catch (Exception e) {
				T.s(activity, "json解析异常");
				return null;
			}
			if (json == null) {
				T.s(activity, "网络请求失败");
			} else if (json.containsKey("code")) {
				if (json.getInteger("code") == NET_SUCCESS) {
					return jsonClassTemp;
				}else if (json.getInteger("code") == NET_FAIL) {
					T.s(activity, json.getString("msg"));
				}else if (json.getInteger("code") == TOKEN_INVALID) {
					T.s(activity, "登陆过期请重新登陆！");
					//LoginActivity.startForResult(activity,requestId);
				}  else if (json.getInteger("code") == SERVER_BUSY) {
					T.s(activity, "服务器忙");
				} else if (json.containsKey("msg")) {
					T.s(activity, json.getString("msg"));
				} else {
					T.s(activity, "网络请求失败");
				}
			} else {
				if (json.containsKey("msg")) {
					T.s(activity, json.getString("msg"));
				} else {
					T.s(activity, "网络请求失败");
				}
			}
			return null;
		} else {
			T.s(activity, VolleyErrorMsg.getMessage(errorNo, errorMsg));
			L.e(TAG, "netnet-error:" + "errorNo=" + errorNo + "  errorMsg=" + errorMsg);
		}
		return null;
	}

}

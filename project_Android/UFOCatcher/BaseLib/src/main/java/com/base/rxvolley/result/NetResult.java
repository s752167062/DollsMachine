package com.base.rxvolley.result;

import android.app.Activity;

import com.alibaba.fastjson.JSONObject;

import com.base.log.L;
import com.base.log.T;
import com.base.rxvolley.VolleyErrorMsg;

/**
 * 网络响应
 * 
 * @author ping 2014-4-16 上午10:36:09
 */
public class NetResult {
	public static final int NET_SUCCESS =1;
	public static final int NET_FAIL =0;
	public static final int TOKEN_INVALID =40000;
	public static final int SERVER_BUSY =-1;
	private final static String  TAG=NetResult.class.getSimpleName();

	public static boolean isSuccess(Activity activity, String object,int errorNo,String errorMsg,Integer requestId) {

		if (object != null) {
			JSONObject json = null;
			try {
				json = JSONObject.parseObject(object);
//				L.e("服务端json=" + json);
			} catch (Exception e) {
				T.s(activity, "Json解析异常");
			}
			if (json == null) {
				T.s(activity, "网络请求失败");
			} else if (json.containsKey("code")) {
				if (json.getInteger("code") == NET_SUCCESS) {
					return true;
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
		}else{
			T.s(activity, VolleyErrorMsg.getMessage(errorNo, errorMsg));
			L.e(TAG, "netnet-error:" + "errorNo=" + errorNo + "  errorMsg=" + errorMsg);
		}
		return false;
	}


	public static int getResponeCode(Activity activity, String object,int errorNo,String errorMsg,Integer requestId) {
		if (object != null) {
			JSONObject json = null;
			try {
				json = JSONObject.parseObject(object);
//				L.e("服务端json=" + json);
			} catch (Exception e) {
				T.s(activity, "Json解析异常");
			}
			if (json == null) {
				T.s(activity, "网络请求失败");
			} else if (json.containsKey("code")) {
				if (json.getInteger("code") == NET_SUCCESS) {
					return NET_SUCCESS;
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
				return json.getInteger("code");
			} else {
				if (json.containsKey("msg")) {
					T.s(activity, json.getString("msg"));
				} else {
					T.s(activity, "网络请求失败");
				}
			}
		}else{
			T.s(activity, VolleyErrorMsg.getMessage(errorNo, errorMsg));
			L.e(TAG, "netnet-error:" + "errorNo=" + errorNo + "  errorMsg=" + errorMsg);
		}
		return -1;
	}
}

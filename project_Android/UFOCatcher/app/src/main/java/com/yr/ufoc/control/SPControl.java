package com.yr.ufoc.control;

import com.base.control.LoginControl;
import com.base.log.SP;


/**
 * @作者: anmi
 * @创建时间：15-7-20 下午10:08
 * @类说明:登录控制类
 */
public class SPControl extends LoginControl {
    private static final java.lang.String PRFS_IS_USER = "user";
    protected static String PRFS_LOGIN_FIRST = "isNoFirst";

    protected static String PRFS_IS_THREELOGIN = "isThreeLogin";
    public static void saveIsThreeLogin(boolean isThreeLogin) {
        SP.putBoolean(PRFS_IS_THREELOGIN, isThreeLogin).commit();
    }

    public static boolean getIsThreeLogin() {
        return SP.getBoolean(PRFS_IS_THREELOGIN);
    }

    public static void saveIsUser(boolean isUser) {
        SP.putBoolean(PRFS_IS_USER, isUser).commit();
    }

    public static boolean getIsUser() {
        return SP.getBoolean(PRFS_IS_USER);
    }






    public static void saveFirst(boolean isFirst) {
        SP.putBoolean(PRFS_LOGIN_FIRST, isFirst).commit();
    }

    public static boolean getFirst() {
        return SP.getBoolean(PRFS_LOGIN_FIRST);
    }
}

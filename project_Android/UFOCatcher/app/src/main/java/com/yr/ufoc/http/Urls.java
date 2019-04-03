package com.yr.ufoc.http;

import android.widget.ImageView;

import com.base.utils.GlideDisplay;

/**
 * Created by Anmi
 * on 2017/11/16.
 * 联网连接类
 */

public class Urls extends BaseUrls  {

    public static void getDownloadImage(ImageView iv, String imageUrl) {
        GlideDisplay.display(iv, (imageUrl).trim());
    }
}

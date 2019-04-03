package com.yr.ufoc.widget;

import android.content.Context;
import android.view.Gravity;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.base.log.L;


/**
 * Created by Nowy on 2016/3/30.
 * 下标控件封装工具类
 */
public class IndicatorUtil {
    private int[] mResBgIndicator;
    private ImageView[] mImageViews;
    private int mCurrentPostion;
    public IndicatorUtil(Context context, LinearLayout llindicator, int count, int[] resBgIndicator){
        mResBgIndicator=resBgIndicator;
        mImageViews = initIndicator(context,llindicator,count);
    }
    /**
     * 初始化下标
     *
     * @param count 数量
     */
    private ImageView[] initIndicator(Context context, LinearLayout llindicator, int count) {
        LinearLayout.LayoutParams layoutParams =
                new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT, 1);
        layoutParams.leftMargin = dip2px(context, 4.0f);
        layoutParams.gravity = Gravity.CENTER;
        mImageViews = new ImageView[count];
        llindicator.removeAllViews();
        for (int i = 0; i < count; i++) {
            mImageViews[i] = new ImageView(context);
            mImageViews[i].setImageResource(mResBgIndicator[1]);
            llindicator.addView(mImageViews[i], layoutParams);
        }
        L.e("mImageViews=" + mImageViews.length);
        this.mCurrentPostion = 0;
        changeInditcator(mCurrentPostion);

        return mImageViews;
    }

    /**
     * 下标改变
     *
     * @param position 位置
     */
    public void changeInditcator(int position) {
        mCurrentPostion = position;
        if (mImageViews == null
                || mCurrentPostion > mImageViews.length
                || mCurrentPostion < 0) return;
        for (ImageView iv : mImageViews) {
            iv.setImageResource(mResBgIndicator[1]);
        }

//        L.e("size:"+mImageViews.length);
        mImageViews[mCurrentPostion].setImageResource(mResBgIndicator[0]);

    }

    public int getCurrentPostion() {
        return mCurrentPostion;
    }

    /**
     * 根据手机的分辨率从 dp 的单位 转成为 px(像素)
     */
    public static int dip2px(Context context, float dpValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }
}

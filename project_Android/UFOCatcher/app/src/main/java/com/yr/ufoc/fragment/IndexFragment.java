package com.yr.ufoc.fragment;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.CollapsingToolbarLayout;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.base.log.L;
import com.base.widget.StrokeTextView;
import com.base.widget.convenientbanner.ConvenientBanner;
import com.base.widget.convenientbanner.holder.CBViewHolderCreator;
import com.base.widget.convenientbanner.holder.Holder;
import com.base.widget.convenientbanner.listener.OnItemClickListener;
import com.yr.ufoc.R;
import com.yr.ufoc.adapter.IndexAdapter;
import com.yr.ufoc.http.Urls;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.Unbinder;

/**
 * Created by Anmi
 * on 2017/11/16.
 */

public class IndexFragment extends Fragment {


    @BindView(R.id.rv_index)
    RecyclerView rvIndex;
    @BindView(R.id.banner_Cb)
    ConvenientBanner mBanner;
    @BindView(R.id.re_banner_layout)
    RelativeLayout reBannerLayout;
    @BindView(R.id.toolbar)
    Toolbar toolbar;
    @BindView(R.id.tv_rooshow)
    ImageView tvRooshow;
    @BindView(R.id.iv_notice_toggle)
    ImageView mIVToggle;
    @BindView(R.id.re_notice_layout)
    RelativeLayout reNoticeLayout;
    @BindView(R.id.tv_notice)
    StrokeTextView tvNotice;

    private Unbinder bind;
    private IndexAdapter adapter;
    private View contentView;
    private Context mContext;
    private List<String> bannerViews;
    private int entityTypeId;
    private String[] notices={"有新的消息来了","只要动动手就能得","想要一只小娃娃不"};
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContext = getActivity();
        Bundle arguments = getArguments();
        if (arguments != null) {
            entityTypeId = arguments.getInt("entityTypeId", -1);
        }

    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        if (contentView != null) {
            ViewGroup parent = (ViewGroup) contentView.getParent();
            if (parent != null) {
                parent.removeView(contentView);
            }
            return contentView;
        }

        contentView = inflater.inflate(R.layout.fragment_index,
                container, false);

        bind = ButterKnife.bind(this, contentView);
        initData();
        if (entityTypeId == 0) {

            setBannerShow(true);

        } else if (entityTypeId > 0) {
            setBannerShow(false);
        }

        return contentView;


    }

    private void setBannerShow(boolean isShow) {
        if (isShow) {
            CollapsingToolbarLayout.LayoutParams params = new CollapsingToolbarLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, (int) (getResources().getDisplayMetrics().heightPixels / 2.5));
            reBannerLayout.setLayoutParams(params);
            bannerViews = new ArrayList<>();
            bannerViews.add("https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1527814347,4293881151&fm=27&gp=0.jpg");
            bannerViews.add("https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=492002676,2539510620&fm=11&gp=0.jpg");
            bannerViews.add("https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3616765171,3721318254&fm=27&gp=0.jpg");
            initBanner(bannerViews);


        } else {
            CollapsingToolbarLayout.LayoutParams params = new CollapsingToolbarLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, tvRooshow.getHeight());
            reBannerLayout.setLayoutParams(params);
            reBannerLayout.removeAllViews();
            toolbar.setBackgroundResource(R.mipmap.ic_roomtop);
            mBanner.setVisibility(View.GONE);
        }
    }

    private void initBanner(List<String> banners) {

        mBanner.setPages(mCBViewHolderCreator, banners)
                //.setPageIndicator(new int[]{R.drawable.dot_circle_gray, R.drawable.dot_circle_red})
                .setOnItemClickListener(mBannerClick);
        mBanner.startTurning(5000);
        if (banners.size() == 1) {
            mBanner.setPointViewVisible(false).setCanLoop(false);
        }

        mBanner.notifyDataSetChanged();
    }

    CBViewHolderCreator mCBViewHolderCreator = new CBViewHolderCreator<Holder<String>>() {
        @Override
        public Holder<String> createHolder() {
            return mBannerImgHolder;
        }
    };

    /**
     * banner item的holder
     */
    Holder mBannerImgHolder = new Holder<String>() {
        private ImageView dvImg;

        @Override
        public View createView(Context context) {
            View view = LayoutInflater.from(context).inflate(R.layout.adapter_banner_item_img, null);
            dvImg = (ImageView) view.findViewById(R.id.banner_item_DvImg);
            return dvImg;
        }

        @Override
        public void UpdateUI(Context context, int position, String entity) {
            tvNotice.setText(notices[position]);
            Urls.getDownloadImage(dvImg, entity);
        }
    };

    OnItemClickListener mBannerClick = new OnItemClickListener() {
        @Override
        public void onItemClick(int position) {
            if (bannerViews != null && bannerViews.size() > 0) {


            }
        }
    };

    private void initData() {
        List<String> list = new ArrayList<>();
        int indexnum = 0;
        if (entityTypeId == 0) {
            indexnum = 10;
        } else if (entityTypeId == 1) {
            indexnum = 5;
        } else if (entityTypeId == 2) {
            indexnum = 3;
        } else if (entityTypeId == 3) {
            indexnum = 2;
        } else {
            indexnum = 1;
        }
        for (int i = 0; i < indexnum; i++) {
            list.add(i + "");
        }
        adapter = new IndexAdapter(mContext, list);
        GridLayoutManager gridLayoutManager = new GridLayoutManager(mContext, 2);
        gridLayoutManager.setOrientation(GridLayoutManager.VERTICAL);
        rvIndex.setLayoutManager(gridLayoutManager);

        rvIndex.setAdapter(adapter);

    }

    /**
     * 获取屏幕高度
     *
     * @param aty
     * @return
     */
    public static int getScreenH(Context aty) {
        DisplayMetrics dm = aty.getResources().getDisplayMetrics();
        return dm.heightPixels;
    }

    @Override
    public void onStart() {
        super.onStart();
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        if (bind != null)
            bind.unbind();
    }


    public void onClick(View view) {
        Toast.makeText(mContext, "点击了", Toast.LENGTH_SHORT).show();
        L.e("点击了");
                   /* if(mCbToggle.isChecked()){
                        mBanner.setVisibility(View.VISIBLE);
                        mCbToggle.setChecked(false);
                    }else{

                        mCbToggle.setChecked(true);
                        setBannerShow(false);
                    }*/
    }
}

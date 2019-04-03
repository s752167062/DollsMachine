package com.yr.ufoc.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.base.widget.StrokeTextView;
import com.base.widget.imageview.roundedimageview.RoundedImageView;
import com.yr.ufoc.R;

import java.util.List;
import java.util.StringTokenizer;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Anmi
 * on 2017/11/16.
 */

public class IndexAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    public static final int TYPE_HEADER = 0;
    public static final int TYPE_NORMAL = 1;
    private View mHeaderView;
    private Context mContext;
    private List<String> mData;

    public IndexAdapter(Context mContext, List<String> mData) {
        this.mContext = mContext;
        this.mData = mData;
    }

    public void setHeaderView(View headerView) {
        mHeaderView = headerView;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if (mHeaderView != null && viewType == TYPE_HEADER)
            return new ViewHolder(mHeaderView);
        View itemtView = LayoutInflater.from(mContext).inflate(R.layout.adapter_index_item, parent, false);
        return new ViewHolder(itemtView);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        if(getItemViewType(position) == TYPE_HEADER)
            return;

        final int pos = getRealPosition(holder);
        final String data = mData.get(pos);
        if(holder instanceof ViewHolder) {
            //((ViewHolder) holder).mTvItem.setText(data);
        }

    }

    //返回正确的item个数
    @Override
    public int getItemCount() {
        return mHeaderView == null ? mData.size() : mData.size() + 1;
    }

    class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R.id.gz_iv)
        RoundedImageView gzIv;
        @BindView(R.id.gz_tv_title)
        StrokeTextView gzTvTitle;
        @BindView(R.id.gz_tv_num)
        StrokeTextView gzTvNum;

        public ViewHolder(View itemView) {
            super(itemView);
            if(itemView == mHeaderView)
                return;
            ButterKnife.bind(this, itemView);
        }
    }


    //根据pos返回不同的ItemViewType
    @Override
    public int getItemViewType(int position) {
        if (mHeaderView == null)
            return TYPE_NORMAL;
        if (position == 0)
            return TYPE_HEADER;
        return TYPE_NORMAL;
    }

    private int getRealPosition(RecyclerView.ViewHolder holder) {
        int position = holder.getLayoutPosition();
        return mHeaderView == null ? position : position - 1;
    }
}

package com.yr.ufoc.adapter;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import java.util.List;

import com.yr.ufoc.fragment.IndexFragment;

/**
 * Created by Anmi
 * on 2017/11/16.
 * 首页Fragment适配器
 */

public class IndexFragmentPageAdapter extends FragmentStatePagerAdapter {
    private List<String> tabNames;

    public IndexFragmentPageAdapter(FragmentManager fm, List<String> tabNames) {
        super(fm);
        this.tabNames = tabNames;
    }

    @Override
    public Fragment getItem(int position) {
        IndexFragment fragment = new IndexFragment();
        Bundle bundle = new Bundle();
        bundle.putInt("entityTypeId", position);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public int getCount() {
        return tabNames.size();
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return tabNames.get(position);
    }
}

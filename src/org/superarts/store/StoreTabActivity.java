package org.superarts.store;

import java.util.Iterator;
import java.util.List;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.simpledb.AmazonSimpleDBClient;
import com.amazonaws.services.simpledb.model.Attribute;
import com.amazonaws.services.simpledb.model.Item;
import com.amazonaws.services.simpledb.model.SelectRequest;
import com.fedorvlasov.lazylist.LazyAdapter;

import android.app.Activity;
import android.app.ListActivity;
import android.os.Bundle;
import android.widget.TabHost;
import au.mpiremedia.shared.LY;
import au.mpiremedia.ui.TabActivity;

public class StoreTabActivity extends TabActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.tab_main);

	    TabHost tabHost = getTabHost();
	    
        tabHost.addTab(createTab(StoreMainActivity.class, "main", getString(R.string.app_name), R.drawable.icon));

	    for (int i = 0; i < 1; i++)
	    {
		    tabHost.getTabWidget().getChildAt(i).getLayoutParams().width = 115; 
		    tabHost.getTabWidget().getChildAt(i).getLayoutParams().height = 100; 
	    }
	    tabHost.setCurrentTab(0);
    }
}
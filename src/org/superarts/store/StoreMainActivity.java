package org.superarts.store;

import java.util.Hashtable;
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
import com.google.ads.AdRequest;
import com.google.ads.AdSize;
import com.google.ads.AdView;

import android.app.Activity;
import android.app.ListActivity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Toast;
import au.mpiremedia.shared.LY;
import au.mpiremedia.ui.TabActivity;

public class StoreMainActivity extends ListActivity {
    private AmazonS3Client aws_s3 = null;
	private AmazonSimpleDBClient aws_sdb = null;
	private String[] urls;
	private String[] names;
	private String[] descs;
	private String[] types;
	private String[] packages;
	private AdView adView;	
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.store_main);
      
        adView = new AdView(this, AdSize.BANNER, "ab5b0737c2f146d5");
        LinearLayout layout = (LinearLayout)findViewById(R.id.linear_store_main);
        layout.addView(adView, 0);
        adView.loadAd(new AdRequest());
        
        String key = "AKIAIG737NOEC2VVPXQQ";
        String sec = "V+PxxcUpKNOCu+7ZPbTj1Y9gkNNA4Y9IBFmxj3Dy";
        AWSCredentials credentials = new BasicAWSCredentials(key, sec);
	    aws_s3 = new AmazonS3Client(credentials);
	    aws_sdb = new AmazonSimpleDBClient(credentials);
	    
		SelectRequest request = new SelectRequest("select * from `apps`" ).withConsistentRead( true );
	    List<?> list = aws_sdb.select(request).getItems();
	    LY.log("sdb", list.toString());
	    
		names = new String[list.size()];
		descs = new String[list.size()];
		types = new String[list.size()];
		urls = new String[list.size()];
		packages = new String[list.size()];
		
	    for (int i = 0; i < list.size(); i++)
	    {
	    		Item item = (Item)list.get(i);
	    		String name = item.getName();
	    		List<?> list_attr = item.getAttributes();
		    LY.log(name, "" + i);
		    packages[i] = name;
		    for (int ii = 0; ii < list_attr.size(); ii++)
		    {
		    		Attribute attr = (Attribute)list_attr.get(ii);
		    		String attr_name = attr.getName();
		    		String attr_value = attr.getValue();
			    LY.log(attr_name, attr_value);
			    if (attr_name.equals("title"))
				    names[i] = attr_value;
			    if (attr_name.equals("desc"))
				    descs[i] = attr_value;
			    if (attr_name.equals("url-image"))
				    urls[i] = attr_value;
			    if (attr_name.equals("type"))
				    types[i] = attr_value;
		    }
	    }
	    
        LazyAdapter adapter = new LazyAdapter(this, names, descs , urls);
		setListAdapter(adapter);
    }
  
    public void click_start(View v)
    {
	    	Toast.makeText(getApplicationContext(), "loading...", Toast.LENGTH_SHORT).show();
    }
   
	protected void onListItemClick(ListView l, View v, int index, long id) 
	{
	    	//Toast.makeText(getApplicationContext(), "Loading " + packages[index], Toast.LENGTH_SHORT).show();
		if (types[index].equals("play"))
		{
		    	Intent intent_play = new Intent(Intent.ACTION_VIEW).setData(Uri.parse("market://details?id=" + packages[index]));
		    startActivity(intent_play);
		}
	}
	
    @Override
    public void onDestroy() {
      if (adView != null) {
        adView.destroy();
      }
      super.onDestroy();
    }
}
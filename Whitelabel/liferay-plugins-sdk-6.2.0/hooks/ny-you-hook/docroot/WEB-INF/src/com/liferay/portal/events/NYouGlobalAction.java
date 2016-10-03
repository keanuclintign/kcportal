package com.liferay.portal.events;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.protocol.HTTP;

import com.liferay.portal.kernel.events.Action;
import com.liferay.portal.kernel.events.ActionException;
import com.liferay.util.portlet.PortletProps;

public class NYouGlobalAction {

	public static void setBadgeURLToContext(String badgeId, HttpServletRequest request, HttpServletResponse response) {
		String badgeURL = (String) request.getServletContext().getAttribute("basno_badge_best_lesson");
		if(badgeURL==null){
			try {
				badgeURL = getBadgeURL(badgeId);
				request.getServletContext().setAttribute("basno_badge_best_lesson", badgeURL);
			} catch (ClientProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	private static String getBadgeURL(String badgeId) throws ClientProtocolException, IOException {
		
    	StringBuffer sb=null;
    	String getClaimUrlEndpoint =  PortletProps.get("liferay.nyu.basno.app.url")
			+ PortletProps.get("liferay.nyu.basno.app.id")
			+ "/api/issue/url";
	    URL url1=new URL(getClaimUrlEndpoint);
	    HttpURLConnection urlConnection=(HttpURLConnection) url1.openConnection();
	    urlConnection.setRequestMethod("POST");
	    urlConnection.setDoOutput(true);
	    urlConnection.addRequestProperty(PortletProps.get("liferay.nyu.basno.app.secret.key"), PortletProps.get("liferay.nyu.basno.app.secret.key.value"));
	    urlConnection.addRequestProperty(HTTP.CONTENT_TYPE,"application/json");
	    String jsonString="{\"pid\":\""+badgeId+"\",\"tracking_id\":\"madhan.mohan@marlabs.com\"}";
	    urlConnection.getOutputStream().write(jsonString.getBytes());
	    urlConnection.connect();
	    InputStream is=urlConnection.getInputStream();
	    BufferedReader reader=new BufferedReader(new InputStreamReader(is));
	    String test="";
	    sb=new StringBuffer();
	    
	    while((test=reader.readLine())!=null){
		if(test!=null){
			test=test.replace("{", "").replace("}", "");
	    	String str[] = test.split(",");
	    	for(String s1 : str){
				if(s1.contains("preview_url")){
					test = s1.substring(s1.indexOf("https"), s1.lastIndexOf("\""));
				}
			}
	    	
	    	sb.append(test);
	    }
	  }   
	    
	return sb.toString();
    }
	
	
}
package com.nyu.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * 
 * @author Allwins Rajaiah
 *
 */
public class PropertyUtil {
	
	private final Properties configProp = new Properties();
	/**
	 * 
	 */
	public void loadProps() {
        try {
        	InputStream in = new FileInputStream ( NyuUtil.getPathFromUrl()+ "messages/nyu.properties" );
        	configProp.load(in);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
	/**
	 * 
	 * @param key
	 * @return
	 */
	public String getProperty( String key ){
		String value = configProp.getProperty( key );
		return value == null ? "[Property Not Found]" : value;
	}

}

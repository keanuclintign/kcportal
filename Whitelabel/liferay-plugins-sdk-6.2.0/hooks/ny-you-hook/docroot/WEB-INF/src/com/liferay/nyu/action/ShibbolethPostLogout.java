package com.liferay.nyu.action;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.liferay.nyyou.service.impl.ExtUserLocalServiceImpl;
import com.liferay.portal.kernel.events.Action;
import com.liferay.portal.kernel.events.ActionException;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.portlet.PortletProps;

public class ShibbolethPostLogout extends Action {
	
	private static Logger _log = Logger.getLogger(ShibbolethPostLogout.class);
	
    @Override
public void run(HttpServletRequest httpreq, HttpServletResponse httpres)
                  throws ActionException {
        try {
        	String portalURI = PortalUtil.getPortalURL(httpreq);
        	if(portalURI.contains(PortletProps.get("liferay.nyu.shibboleth.login"))) {
        		httpres.sendRedirect(PortletProps.get("liferay.nyu.logout.url")); //("https://aqa.home.nyu.edu/sso/UI/Logout");
        	}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}

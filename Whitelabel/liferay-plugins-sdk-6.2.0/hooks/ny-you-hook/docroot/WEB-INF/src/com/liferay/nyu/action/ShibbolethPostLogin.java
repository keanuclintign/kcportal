package com.liferay.nyu.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.liferay.portal.kernel.events.Action;
import com.liferay.portal.kernel.events.ActionException;
import com.liferay.portal.kernel.struts.LastPath;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.util.PortalUtil;

public class ShibbolethPostLogin extends Action{
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(ShibbolethPostLogin.class);
		  
	@Override
    public void run(HttpServletRequest request, HttpServletResponse response) throws ActionException {
		
		LOG.info("[ShibbolethPostLogin] [RUN] ");
		 
        HttpSession session = request.getSession();
        
        LastPath lastPath = null;
        
        String redirect = ParamUtil.getString(request, "redirectTo");
        
        if(null!=redirect && !"".equals(redirect)){
        	lastPath = new LastPath(StringPool.BLANK, redirect);
        	LOG.info("[ShibbolethPostLogin] [REDIRECT-TO]: "+lastPath);
        }else{ 
        	lastPath = new LastPath(StringPool.BLANK, PortalUtil.getCurrentURL(request));
        	LOG.info("[ShibbolethPostLogin] [REDIRECT]: "+lastPath);
        }
        
        session.setAttribute(WebKeys.LAST_PATH, lastPath);
        
     
        
    }
  
}

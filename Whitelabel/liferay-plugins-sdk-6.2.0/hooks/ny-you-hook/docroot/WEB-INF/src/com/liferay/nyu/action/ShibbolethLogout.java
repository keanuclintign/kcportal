package com.liferay.nyu.action;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.liferay.nyu.audit.AuditLogoutAction;
import com.liferay.portal.kernel.events.Action;
import com.liferay.portal.kernel.events.ActionException;

public class ShibbolethLogout extends Action{
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(ShibbolethLogout.class);
	
	 @Override
	 public void run(HttpServletRequest httpreq, HttpServletResponse httpres)   throws ActionException {
	              LOG.info("Hey Buddy U Pre Logout Now "+new Date());
	        }

}

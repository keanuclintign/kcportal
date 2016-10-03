package com.liferay.portal.tou;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.liferay.portal.kernel.struts.BaseStrutsAction;
import com.liferay.portal.kernel.struts.StrutsAction;
import com.liferay.portal.model.User;
import com.liferay.portal.util.PortalUtil;

public class CustomTermsOfUse extends BaseStrutsAction {
	public String execute(StrutsAction originalStrutsAction,HttpServletRequest request, HttpServletResponse response)throws Exception {
		User user = PortalUtil.getUser(request);
		user.getExpandoBridge().setAttribute("agree-date", new Date());
		return originalStrutsAction.execute(request,response); 
	}
}

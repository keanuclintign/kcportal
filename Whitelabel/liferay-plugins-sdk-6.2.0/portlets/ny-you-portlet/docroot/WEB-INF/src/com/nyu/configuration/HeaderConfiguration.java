package com.nyu.configuration;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletPreferences;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import com.liferay.portal.kernel.portlet.ConfigurationAction;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.nyu.util.Constant;

public class HeaderConfiguration implements ConfigurationAction{

	@Override
	public void processAction(PortletConfig config, ActionRequest request,
			ActionResponse response) throws Exception {
		String videoUrl = ParamUtil.getString(request, Constant.VIDEO_URL);
		PortletPreferences preferences=request.getPreferences();
		preferences.setValue(Constant.TAKE_VIDEO_URL,videoUrl);
		preferences.store();
	}

	@Override
	public String render(PortletConfig arg0, RenderRequest request,
			RenderResponse response) throws Exception {
		
		PortletPreferences preferences=request.getPreferences();
		request.setAttribute(Constant.TAKE_VIDEO_URL, preferences.getValue(Constant.TAKE_VIDEO_URL, StringPool.BLANK));
		return Constant.HEADER_CONFIGURATION_JSP;
	}

}

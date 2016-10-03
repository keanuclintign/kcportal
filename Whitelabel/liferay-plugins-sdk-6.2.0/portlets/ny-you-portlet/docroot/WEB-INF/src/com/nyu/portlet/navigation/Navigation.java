package com.nyu.portlet.navigation;

import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;

import com.liferay.portal.kernel.exception.SystemException;

@Controller
@RequestMapping(value = "VIEW")

public class Navigation {
 
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws SystemException 
	 */
	@RenderMapping
	public String view(RenderRequest request,RenderResponse response) {
		return "view";  
	}

}

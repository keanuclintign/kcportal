package com.nyu.portlet.activity;

import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;

import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portlet.social.model.SocialActivity;
import com.liferay.portlet.social.service.SocialActivityLocalServiceUtil;
import com.nyu.model.Lesson;


@Controller
@RequestMapping(value = "VIEW")
public class Activity {
	
	
	@RenderMapping
	public String view(RenderRequest request,RenderResponse response){
		return "view";
	}
	
}

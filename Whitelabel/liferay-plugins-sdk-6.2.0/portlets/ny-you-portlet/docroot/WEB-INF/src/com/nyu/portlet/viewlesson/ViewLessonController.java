package com.nyu.portlet.viewlesson;

import java.io.IOException;

import javax.portlet.PortletConfig;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.util.JavaConstants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.nyu.NoSuchLessonException;
import com.nyu.model.Lesson;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;


@Controller
@RequestMapping(value = "VIEW")
public class ViewLessonController  {
	private static Logger _log = Logger.getLogger(ViewLessonController.class);
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws SystemException 
	 * @throws PortalException 
	 */
	@RenderMapping
	public String view(RenderRequest request,RenderResponse response) throws SystemException, PortalException {

		try{
			ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
			Lesson lesson = LessonLocalServiceUtil.getLesson(ParamUtil.getLong(request,Constant.COMMON_STRING_CONSTANT_LESSON_ID));
			request.setAttribute(Constant.LESSON,lesson);
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_LESSON_ID,request.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID));
			request.setAttribute(Constant.DOCUMENT_ID,request.getParameter(Constant.DOCUMENT_ID));
			request.setAttribute(Constant.FROM_VIEW_LESSON,Constant.YES);
			if(!lesson.getStatus().equalsIgnoreCase(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH)){
				request.setAttribute(Constant.USER_PERMISSION_TO_ACCESS, false);
				String privacyCheckMessage = CommonUtil.JavaClassI18N(request, themeDisplay, "this-lesson-in-draft-mode");
				request.setAttribute(Constant.COMMON_STRING_CONSTANT_PRIVACY_CHECK_MESSAGE, privacyCheckMessage);
			}else{
				CommonUtil.getViewAdvanceLesson(request, response);
			}
		}catch(NoSuchLessonException nse ){
			request.setAttribute(Constant.LESSON, null);
		}catch(Exception e){
			_log.error(e);
		}
		
		return Constant.VIEWLESSON_VIEWLESSON;  			//added by asif, originally- return "viewLesson";
	}
	
	@ResourceMapping(value="lessonNote")
    public void getLessonNote(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException, PortalException, SystemException  {
	
		long lessonId = Long.parseLong(resourceRequest.getParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID));
		String notes=resourceRequest.getParameter(Constant.USER_NOTE);
		
		Lesson lesson=LessonLocalServiceUtil.getLesson(lessonId);
		lesson.setLessonNote(notes);
		LessonLocalServiceUtil.updateLesson(lesson);
		PortletConfig portletConfig = (PortletConfig)resourceRequest.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
		ThemeDisplay themeDisplay = (ThemeDisplay)resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
		
		/*
		 * added by asif
		 * originally it 
		 * resourceResponse.getWriter().write("Successfully saved");
		 */
		resourceResponse.getWriter().write(LanguageUtil.get(portletConfig, themeDisplay.getLocale(), "view-lesson-successfully-saved"));
	
	}
	
}
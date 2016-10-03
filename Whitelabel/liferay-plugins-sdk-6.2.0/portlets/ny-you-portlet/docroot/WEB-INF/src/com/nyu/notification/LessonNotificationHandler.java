package com.nyu.notification;

import java.util.Locale;

import javax.portlet.PortletConfig;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;

import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.notifications.BaseUserNotificationHandler;
import com.liferay.portal.kernel.portlet.LiferayPortletRequest;
import com.liferay.portal.kernel.util.JavaConstants;
import com.liferay.portal.kernel.util.StringBundler;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Layout;
import com.liferay.portal.model.UserNotificationEvent;
import com.liferay.portal.service.LayoutLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;

public class LessonNotificationHandler extends BaseUserNotificationHandler{

	public static final String PORTLET_ID = Constant.PORTLET_LESSON;

	public LessonNotificationHandler() {

		setPortletId(com.nyu.notification.LessonNotificationHandler.PORTLET_ID);

	}

	@Override
	protected String getBody(UserNotificationEvent userNotificationEvent,
			ServiceContext serviceContext) throws Exception {
		
		JSONObject jsonObject = JSONFactoryUtil
				.createJSONObject(userNotificationEvent.getPayload());
		long userId=jsonObject.getLong(Constant.COMMON_STRING_CONSTANT_USER_ID);
		long lessonId=jsonObject.getLong(Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		String lessonName = jsonObject.getString(Constant.COMMON_STRING_CONSTANT_LESSON_NAME);
		String type=jsonObject.getString(Constant.TYPE);
		String userName=jsonObject.getString(Constant.COMMON_STRING_CONSTANT_USER_NAME);
		
		String bodyText = null;
		
		LiferayPortletRequest liferayPortletRequest=serviceContext.getLiferayPortletRequest();
		ThemeDisplay themeDisplay=(ThemeDisplay)liferayPortletRequest.getAttribute(WebKeys.THEME_DISPLAY);
		Layout layout=themeDisplay.getLayout();
		
		PortletConfig portletConfig = (PortletConfig)liferayPortletRequest.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);	//added by asif
		Locale locale = themeDisplay.getLocale();																				//added by asif
		
		long targetPlId = LayoutLocalServiceUtil.getFriendlyURLLayout(themeDisplay.getScopeGroupId(), layout.isPrivateLayout(), Constant.PAGE_LESSON_BROWSE).getPlid();
		PortletURL lessonURL=PortletURLFactoryUtil.create(liferayPortletRequest, PORTLET_ID, targetPlId, PortletRequest.RENDER_PHASE);
		
		lessonURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);
		lessonURL.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID, String.valueOf(lessonId));
		
		
		if(type.equalsIgnoreCase(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH)){
			bodyText = LanguageUtil.get(portletConfig, locale, "lesson")+StringPool.SPACE+Constant.TAG_STRONG_OPEN+lessonName+Constant.TAG_STRONG_CLOSE+StringPool.SPACE+LanguageUtil.get(portletConfig, locale, "is-small-case")+StringPool.SPACE+ type +StringPool.PERIOD+StringPool.SPACE+LanguageUtil.get(portletConfig, locale, "to-view-lesson")+Constant.TAG_ANCHOR_REF+lessonURL+Constant.TAG_FONT_COLOR_BLUE+LanguageUtil.get(portletConfig, locale, "click-here")+Constant.TAG_FONT_CLOSE_ANCHOR;
		}
		
		if(type.equalsIgnoreCase(Constant.LIFERAY_VENDOR_LESSON_STATUS_DRAFT)){
			bodyText = CommonUtil.JavaClassI18N(liferayPortletRequest, themeDisplay, "lesson")+lessonName+Constant.TAG_STRONG_CLOSE+StringPool.SPACE+LanguageUtil.get(portletConfig, locale, "is-saved-as")+StringPool.SPACE+ type +StringPool.PERIOD+StringPool.SPACE+LanguageUtil.get(portletConfig, locale, "you-can-view-this-lesson-under-my-lessons-in-my-Stuff")+StringPool.PERIOD;
		}
		
		if(type.equalsIgnoreCase(Constant.IN_APPROPRIATE)){
			bodyText = LanguageUtil.get(portletConfig, locale, "lesson")+StringPool.SPACE+Constant.TAG_STRONG_OPEN+lessonName+Constant.TAG_STRONG_CLOSE+StringPool.SPACE+LanguageUtil.get(portletConfig, locale, "has-been-reported") +""+ type +StringPool.SPACE+LanguageUtil.get(portletConfig, locale, "by")+StringPool.SPACE+Constant.TAG_STRONG_OPEN+userName+StringPool.PERIOD+Constant.TAG_STRONG_CLOSE+StringPool.SPACE+LanguageUtil.get(portletConfig, locale, "to-view-lesson")+Constant.TAG_ANCHOR_REF+lessonURL+Constant.TAG_FONT_COLOR_BLUE+LanguageUtil.get(portletConfig, locale, "click-here")+Constant.TAG_FONT_CLOSE_ANCHOR;
		}
		
		if(type.equalsIgnoreCase(Constant.FAILED)){
			bodyText = LanguageUtil.get(portletConfig, locale, "lesson")+StringPool.SPACE+Constant.TAG_STRONG_OPEN+lessonName+Constant.TAG_STRONG_CLOSE+StringPool.SPACE+LanguageUtil.get(portletConfig, locale, "publish-failed-you-can-view-and-re-publish-this-lesson-under-my-lessons-in-my-stuff")+StringPool.PERIOD;
		}
		if(type.equalsIgnoreCase(Constant.MARKEDAS_RELEASE)){
			bodyText = LanguageUtil.get(portletConfig, locale, "lesson")+StringPool.SPACE+Constant.TAG_STRONG_OPEN+lessonName+Constant.TAG_STRONG_CLOSE+StringPool.SPACE+LanguageUtil.get(portletConfig, locale, "has-been-released-to-view-lesson")+Constant.TAG_ANCHOR_REF+lessonURL+Constant.TAG_FONT_COLOR_BLUE+LanguageUtil.get(portletConfig, locale, "click-here")+Constant.TAG_FONT_CLOSE_ANCHOR;
		}
		if(type.equalsIgnoreCase(Constant.MARKEDAS_QUARANTINE)){
			bodyText = LanguageUtil.get(portletConfig, locale, "lesson")+StringPool.SPACE+Constant.TAG_STRONG_OPEN+lessonName+Constant.TAG_STRONG_CLOSE+StringPool.SPACE+LanguageUtil.get(portletConfig, locale, "has-been-quarantined")+StringPool.PERIOD;
		}
		
		String body = StringUtil.replace(getBodyTemplate(), new String[] {
																		Constant.BODY_TEXT_DOLLAR },
																		new String[] {
																			 bodyText });
		
		return body;
	}

	@Override
	protected String getLink(UserNotificationEvent userNotificationEvent,
			ServiceContext serviceContext) throws Exception {
	
		return Constant.JAVASCRIPT_COLON_VOID_ZERO;
		
	}

	protected String getBodyTemplate() throws Exception {
		StringBundler sb = new StringBundler(4);
		//sb.append("<div class=\"title\">[$TITLE$]</div><div ");
		sb.append(Constant.TAG_DIV);
		sb.append(Constant.TAG_CLASS_BODY_BODY_TEXT);
		sb.append(Constant.TAG_DIV_CLOSE);
		return sb.toString();
	}
}

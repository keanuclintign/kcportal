package com.nyu.notification;

import javax.portlet.ActionRequest;
import javax.portlet.PortletURL;
import javax.portlet.ResourceURL;
import javax.portlet.WindowState;

import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.notifications.BaseUserNotificationHandler;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.util.StringBundler;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.model.UserNotificationEvent;
import com.liferay.portal.service.ServiceContext;
import com.nyu.util.Constant;

public class NyuLessonsNotificationHandler extends BaseUserNotificationHandler {
	public static final String PORTLET_ID = Constant.PORTLET_CREATE_LESSON;

	public NyuLessonsNotificationHandler() {

		setPortletId(com.nyu.notification.NyuLessonsNotificationHandler.PORTLET_ID);
 
	}

	@Override
	protected String getBody(UserNotificationEvent userNotificationEvent,
			ServiceContext serviceContext) throws Exception {

		JSONObject jsonObject = JSONFactoryUtil
				.createJSONObject(userNotificationEvent.getPayload());
		long userId=jsonObject.getLong(Constant.COMMON_STRING_CONSTANT_USER_ID);
		String userName =jsonObject.getString(Constant.COMMON_STRING_CONSTANT_USER_NAME);
		long lessonId = jsonObject.getLong(Constant.COMMON_STRING_CONSTANT_LESSON_ID);
		String lessonName = jsonObject.getString(Constant.COMMON_STRING_CONSTANT_LESSON_NAME);
		String message=jsonObject.getString(Constant.ADDITIONAL_DATA);
		String type=jsonObject.getString(Constant.TYPE);
		
		String title = Constant.TAG_STRONG_OPEN+userName+Constant.TAG_STRONG_CLOSE+StringPool.SPACE+message+
				StringPool.SPACE+Constant.TAG_STRONG_OPEN+lessonName+ Constant.TAG_STRONG_CLOSE;

		String bodyText = StringPool.BLANK;

		LiferayPortletResponse liferayPortletResponse = serviceContext
				.getLiferayPortletResponse();

		ResourceURL acceptURL = liferayPortletResponse
				.createResourceURL(com.nyu.notification.NyuLessonsNotificationHandler.PORTLET_ID);
		
		acceptURL.setResourceID(Constant.ACCEPT_LESSON_INVITATION);
		acceptURL.setParameter(Constant.REDIRECT, serviceContext.getLayoutFullURL());
		acceptURL.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID,
				String.valueOf(lessonId));
		acceptURL.setParameter(Constant.COMMON_STRING_CONSTANT_USER_ID,
				String.valueOf(userId));
		acceptURL.setParameter(Constant.USER_NOTIFICATION_EVENT_ID, String
				.valueOf(userNotificationEvent.getUserNotificationEventId()));
		
		ResourceURL declineURL = liferayPortletResponse
				.createResourceURL(com.nyu.notification.NyuLessonsNotificationHandler.PORTLET_ID);
		
		declineURL.setResourceID(Constant.DECLINE_LESSON_INVITATION);
		declineURL.setParameter(Constant.REDIRECT, serviceContext.getLayoutFullURL());
		declineURL.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID,
				String.valueOf(lessonId));
		declineURL.setParameter(Constant.COMMON_STRING_CONSTANT_USER_ID,
				String.valueOf(userId));
		declineURL.setParameter(Constant.USER_NOTIFICATION_EVENT_ID, String
				.valueOf(userNotificationEvent.getUserNotificationEventId()));
		
		String body = StringPool.BLANK;
		
		if(type.equalsIgnoreCase(Constant.ACCEPT_TO_MANAGE_LESSON) || type.equalsIgnoreCase(Constant.DECLINE_TO_MANAGE_LESSON)  ){
			body = StringUtil.replace(getAcceptedTemplate(), new String[] {
					Constant.DOLLAR_TITLE, Constant.BODY_TEXT_DOLLAR },
					new String[] {
					title, bodyText });
			}
		if(type.equalsIgnoreCase(Constant.INVITE_TO_JOIN_LESSON)){
			body = StringUtil.replace(getBodyTemplate(), new String[] {
				Constant.DOLLAR_CONFIRM, Constant.DOLLAR_CONFIRM_URL,Constant.DOLLAR_DECLINE, Constant.DOLLAR_DOLLAR_DECLINE_URL, Constant.DOLLAR_TITLE, Constant.BODY_TEXT_DOLLAR },
				new String[] {
				serviceContext.translate(Constant.ACCEPT), acceptURL.toString(),serviceContext.translate(Constant.DECLINE),
				declineURL.toString(),title, bodyText });
			}
		
		return body;
	}

	@Override
	protected String getLink(UserNotificationEvent userNotificationEvent,
			ServiceContext serviceContext) throws Exception {

		JSONObject jsonObject = JSONFactoryUtil
				.createJSONObject(userNotificationEvent.getPayload());

		long yourCustomEntityId = jsonObject.getLong(Constant.YOUR_CUSTOM_ENTITY_ID);
		LiferayPortletResponse liferayPortletResponse = serviceContext
				.getLiferayPortletResponse();

		PortletURL viewURL = liferayPortletResponse
				.createActionURL(com.nyu.notification.NyuLessonsNotificationHandler.PORTLET_ID);
		viewURL.setParameter(ActionRequest.ACTION_NAME, Constant.SHOW_DETAILS);
		viewURL.setParameter(Constant.REDIRECT, serviceContext.getLayoutFullURL());
		viewURL.setParameter(Constant.YOUR_CUSTOM_ENTITY_ID,
				String.valueOf(yourCustomEntityId));
		viewURL.setParameter(Constant.USER_NOTIFICATION_EVENT_ID, String
				.valueOf(userNotificationEvent.getUserNotificationEventId()));
		viewURL.setWindowState(WindowState.NORMAL);
		return Constant.JAVASCRIPT_COLON_VOID_ZERO;
	}

	protected String getBodyTemplate() throws Exception {
		StringBundler sb = new StringBundler(6);
		sb.append(Constant.TAG_DIV_CLASS_TITLE_DOLLAR_TITLE);
		sb.append(Constant.TAG_CLASS_BODY_DOLLAR_BODY_TEXT);
		sb.append(Constant.TAG_BTN_SUCCESS_BUTTON_CLICK_HREF_DOLLAR_CONFIRM_DETAIL);
		sb.append(Constant.TAG_ANCHOR_CLASS_BTN_ACTION);
		sb.append(Constant.TAG_BTN_PRIMARY_CLICK_DOLLAR_DECLINE_URL);
		sb.append(Constant.TAG_DIV_CLOSE);
		return sb.toString();
	}
	
	
	protected String getAcceptedTemplate() throws Exception {
		StringBundler sb = new StringBundler(4);
		sb.append(Constant.TAG_DIV_CLASS_TITLE_DOLLAR_TITLE);
		sb.append(Constant.TAG_CLASS_BODY_BODY_TEXT);
		sb.append(Constant.TAG_DIV_CLOSE);
		return sb.toString();
	}

}

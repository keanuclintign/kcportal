package com.nyu.poller;

import java.util.List;

import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.poller.BasePollerProcessor;
import com.liferay.portal.kernel.poller.PollerRequest;
import com.liferay.portal.kernel.poller.PollerResponse;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.model.UserNotificationEvent;
import com.liferay.portal.service.UserNotificationEventLocalServiceUtil;
import com.nyu.util.Constant;

public class NotifyMe extends BasePollerProcessor{

	@Override
	protected void doReceive(PollerRequest pollerRequest, PollerResponse pollerResponse)
			throws Exception {
		int newUserNotificationsCount =0;
		
		List<UserNotificationEvent> userNotificationList = UserNotificationEventLocalServiceUtil.getDeliveredUserNotificationEvents(pollerRequest.getUserId(), false);
		
		JSONArray newlyPublishedList = JSONFactoryUtil.createJSONArray();	
		for(UserNotificationEvent userNotification: userNotificationList){
			if(Validator.isNotNull(userNotification.getType()) && userNotification.getType().equalsIgnoreCase(Constant.PORTLET_LESSON)){
				JSONObject object = JSONFactoryUtil.createJSONObject(userNotification.getPayload());				
				if(object.getString(Constant.TYPE).equalsIgnoreCase(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH)){
					newlyPublishedList.put(object);
					newUserNotificationsCount++;
					userNotification.setDelivered(true);
					UserNotificationEventLocalServiceUtil.updateUserNotificationEvent(userNotification);
				}	
			}
		}
		if(newUserNotificationsCount > 0){
			pollerResponse.setParameter(
					Constant.NEW_USER_NOTIFICATIONS_COUNT,
				String.valueOf(newUserNotificationsCount));

			pollerResponse.setParameter(
				Constant.TIME_STAMP, String.valueOf(System.currentTimeMillis()));
			
			pollerResponse.setParameter(
					Constant.NEWLY_PUBLISHED_LIST, newlyPublishedList);
		}
		
	}

	@Override
	protected void doSend(PollerRequest pollerRequest) throws Exception {
		System.out.println("do doSend");
	}

}

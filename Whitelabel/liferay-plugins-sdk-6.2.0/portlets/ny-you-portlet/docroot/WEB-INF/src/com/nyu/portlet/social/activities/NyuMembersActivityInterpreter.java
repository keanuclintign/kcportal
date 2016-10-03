package com.nyu.portlet.social.activities;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.HtmlUtil;
import com.liferay.portal.kernel.util.StringBundler;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.model.User;
import com.liferay.portal.security.permission.PermissionChecker;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portlet.social.model.BaseSocialActivityInterpreter;
import com.liferay.portlet.social.model.SocialActivity;
import com.nyu.NoSuchLessonException;
import com.nyu.model.Lesson;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.util.CommonUtil;

public class NyuMembersActivityInterpreter extends BaseSocialActivityInterpreter{

	private static Log _log = LogFactoryUtil.getLog(
			NyuMembersActivityInterpreter.class);
	
	private static final String[] _CLASS_NAMES = {Lesson.class.getName()};
	
	@Override
	public String[] getClassNames() {
		return _CLASS_NAMES;
	}
	
/*	@Override
	public SocialActivityFeedEntry interpret(
		SocialActivity activity, ServiceContext serviceContext) {

		try {
			return doInterpret(activity, serviceContext);
		}
		catch (Exception e) {
			_log.error("Unable to interpret activity", e);
		}

		return null;
	}
	
	@Override
	protected SocialActivityFeedEntry doInterpret(SocialActivity activity, ServiceContext serviceContext) throws Exception{
	
		String link = getLink(activity, serviceContext);

		String title = getTitle(activity, serviceContext);
	
			if (Validator.isNull(title)) {
				return null;
			}
	
		String body = getBody(activity, serviceContext);
		
		return new SocialActivityFeedEntry(link, title, body);
		
	}*/

	protected String getLink(
			SocialActivity activity, ServiceContext serviceContext)
		throws Exception {

		//int activityType = activity.getType();

		/*if (activityType != NyuMemberActivityKeys.ADD_LESSON) {
			return StringPool.BLANK;
		}*/

		StringBundler sb = new StringBundler(5);

		sb.append(serviceContext.getPortalURL());
		sb.append(serviceContext.getPathFriendlyURLPublic());
		sb.append(StringPool.SLASH);

		User creatorUser = UserLocalServiceUtil.getUserById(
			activity.getUserId());

		sb.append(HtmlUtil.escapeURL(creatorUser.getScreenName()));

		sb.append("/profile");

		return sb.toString();
	}

	protected String getTitle(SocialActivity activity, ServiceContext serviceContext) throws Exception {

		String title = null;

		int activityType = activity.getType();
		
		Lesson lesson = null;
		
		try {
			lesson = LessonLocalServiceUtil.getLesson(activity.getClassPK());
			if (activityType == NyuMemberActivityKeys.ADD_LESSON){
				title = "Added \"" + lesson.getLessonName() +"\"";
			}
			
			if (activityType == NyuMemberActivityKeys.UPDATE_LESSON){
				title = "Updated \"" + lesson.getLessonName() +"\"";
			}
			
			if (activityType == NyuMemberActivityKeys.VIEW_LESSON){
				title = "Viewed \"" + lesson.getLessonName() +"\"";
			}
			
			if (activityType == NyuMemberActivityKeys.APPRECIATE_LESSON){
				title = "Appreciated \"" + lesson.getLessonName() +"\"";
			}
			
			if (activityType == NyuMemberActivityKeys.ADD_COMMENT){
				title = "Commented \"" + lesson.getLessonName() +"\"";
			}
			
		} catch (NoSuchLessonException e) {}
		
		return title;
	}

	
	protected String getBody(SocialActivity activity, ServiceContext serviceContext) throws Exception {

		return CommonUtil.getDatesDuration(activity.getCreateDate(), 0);
	}
		
		
	@Override
	protected boolean hasPermissions(
		PermissionChecker permissionChecker, SocialActivity activity,
		String actionId, ServiceContext serviceContext) {

		return true;
	}
}

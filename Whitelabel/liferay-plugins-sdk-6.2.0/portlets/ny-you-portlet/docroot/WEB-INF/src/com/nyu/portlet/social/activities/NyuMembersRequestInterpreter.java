package com.nyu.portlet.social.activities;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.Organization;
import com.liferay.portal.model.User;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.service.OrganizationLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.social.model.BaseSocialRequestInterpreter;
import com.liferay.portlet.social.model.SocialRequest;
import com.liferay.portlet.social.model.SocialRequestFeedEntry;

public class NyuMembersRequestInterpreter extends BaseSocialRequestInterpreter {

	private static Log _log = LogFactoryUtil.getLog(NyuMembersRequestInterpreter.class);
	
	private static final String[] _CLASS_NAMES = new String[] {
		Group.class.getName(), Organization.class.getName()
	};
	
	@Override
	public String[] getClassNames() {
		return _CLASS_NAMES;
	}

	@Override
	protected SocialRequestFeedEntry doInterpret(SocialRequest request,
			ThemeDisplay themeDisplay) throws Exception {
		String creatorUserName = getUserName(request.getUserId(), themeDisplay);

		User creatorUser = UserLocalServiceUtil.getUserById(
			request.getUserId());

		int requestType = request.getType();

		Group group = null;

		String className = request.getClassName();

		if (className.equals(Group.class.getName())) {
			group = GroupLocalServiceUtil.getGroup(request.getClassPK());
		}
		else {
			Organization organization =
				OrganizationLocalServiceUtil.getOrganization(
					request.getClassPK());

			group = organization.getGroup();
		}

		// Title

		String title = StringPool.BLANK;

		if (requestType == NyuMemberActivityKeys.ADD_LESSON) {
			StringBuilder sb = new StringBuilder();

			sb.append("<a href=\"");
			sb.append(themeDisplay.getPortalURL());
			sb.append(themeDisplay.getPathFriendlyURLPublic());
			sb.append(StringPool.SLASH);
			sb.append(creatorUser.getScreenName());
			sb.append("/profile\">");
			sb.append(creatorUserName);
			sb.append("</a>");

			String creatorUserNameURL = sb.toString();

			sb = new StringBuilder();

			sb.append("<a href=\"");
			sb.append(themeDisplay.getPortalURL());
			sb.append(themeDisplay.getPathFriendlyURLPublic());
			sb.append(group.getFriendlyURL());
			sb.append("/profile\">");
			sb.append(group.getDescriptiveName(themeDisplay.getLocale()));
			sb.append("</a>");

			String organizationNameURL = sb.toString();

			title = themeDisplay.translate(
				"request-social-networking-summary-join-organization",
				new Object[] {creatorUserNameURL, organizationNameURL});
		}

		// Body

		String body = StringPool.BLANK;

		return new SocialRequestFeedEntry(title, body);
	}

	@Override
	protected boolean doProcessConfirmation(SocialRequest request,
			ThemeDisplay themeDisplay) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}
}

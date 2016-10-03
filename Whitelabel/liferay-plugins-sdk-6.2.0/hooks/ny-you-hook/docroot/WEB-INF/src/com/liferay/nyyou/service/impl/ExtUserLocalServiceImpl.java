package com.liferay.nyyou.service.impl;

import java.util.Arrays;

import org.apache.log4j.Logger;

import com.liferay.portal.service.UserLocalService;
import com.liferay.portal.service.UserLocalServiceWrapper;

/** The code is not used currently. Just for reference. */
public class ExtUserLocalServiceImpl extends UserLocalServiceWrapper {
    
	private static Logger _log = Logger.getLogger(ExtUserLocalServiceImpl.class);
	
	/* (non-Java-doc)
     * @see com.liferay.portal.service.UserLocalServiceWrapper#UserLocalServiceWrapper(UserLocalService userLocalService)
     */
    public ExtUserLocalServiceImpl(UserLocalService userLocalService) {
        super(userLocalService);
    }

    @Override
	public com.liferay.portal.model.User addUserWithWorkflow(
		long creatorUserId, long companyId, boolean autoPassword,
		java.lang.String password1, java.lang.String password2,
		boolean autoScreenName, java.lang.String screenName,
		java.lang.String emailAddress, long facebookId,
		java.lang.String openId, java.util.Locale locale,
		java.lang.String firstName, java.lang.String middleName,
		java.lang.String lastName, int prefixId, int suffixId, boolean male,
		int birthdayMonth, int birthdayDay, int birthdayYear,
		java.lang.String jobTitle, long[] groupIds, long[] organizationIds,
		long[] roleIds, long[] userGroupIds, boolean sendEmail,
		com.liferay.portal.service.ServiceContext serviceContext)
		throws com.liferay.portal.kernel.exception.PortalException,
			com.liferay.portal.kernel.exception.SystemException {
    	
    	/*_log.info("Assigns " + screenName + " to the group:" + PortletProps.get("liferay.nyu.eds.site.name"));
    	Group group = GroupLocalServiceUtil.getGroup(companyId, PortletProps.get("liferay.nyu.eds.site.name"));
    	if(groupIds != null){
	    	groupIds = addElement(groupIds, group.getGroupId());
    	}else{
    		groupIds = new long[]{group.getGroupId()};
    	}*/
    	
		return super.addUserWithWorkflow(creatorUserId, companyId,
			autoPassword, password1, password2, autoScreenName, screenName,
			emailAddress, facebookId, openId, locale, firstName, middleName,
			lastName, prefixId, suffixId, male, birthdayMonth, birthdayDay,
			birthdayYear, jobTitle, groupIds, organizationIds, roleIds,
			userGroupIds, sendEmail, serviceContext);
	}
    
    private long[] addElement(long[] groupIds, long groupId) {
    	groupIds  = Arrays.copyOf(groupIds, groupIds.length + 1);
    	groupIds[groupIds.length - 1] = groupId;
        return groupIds;
    }
   
}
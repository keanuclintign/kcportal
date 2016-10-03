/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.nyu.service.impl;

import java.util.List;

import com.liferay.portal.kernel.exception.SystemException;
import com.nyu.model.Lesson;
import com.nyu.model.UserGroupRequest;
import com.nyu.service.base.UserGroupRequestLocalServiceBaseImpl;

/**
 * The implementation of the user group request local service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the {@link com.nyu.service.UserGroupRequestLocalService} interface.
 *
 * <p>
 * This is a local service. Methods of this service will not have security checks based on the propagated JAAS credentials because this service can only be accessed from within the same VM.
 * </p>
 *
 * @author Allwins Rajaiah
 * @see com.nyu.service.base.UserGroupRequestLocalServiceBaseImpl
 * @see com.nyu.service.UserGroupRequestLocalServiceUtil
 */
public class UserGroupRequestLocalServiceImpl
	extends UserGroupRequestLocalServiceBaseImpl {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never reference this interface directly. Always use {@link com.nyu.service.UserGroupRequestLocalServiceUtil} to access the user group request local service.
	 */
	
	public UserGroupRequest getRequestStatusByUsers(long userGroupId,long userId) {
		UserGroupRequest userGroupRequest = null;

		try{
			userGroupRequest = userGroupRequestPersistence.fetchByfindRequestStatusByUser(userGroupId, userId);
		}catch(SystemException e){
			e.printStackTrace();
			userGroupRequest=null;
		}

		return userGroupRequest;
	}
	
	public List<UserGroupRequest> getGroupRequestByStatus(long userGroupId,String status) {
		List<UserGroupRequest> userGroupRequest = null;

		try{
			userGroupRequest = userGroupRequestPersistence.findByfindGroupRequestByStatus(userGroupId, status);
		}catch(SystemException e){
			e.printStackTrace();
			userGroupRequest=null;
		}

		return userGroupRequest;
	}
	
}
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

import java.util.ArrayList;
import java.util.List;

import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.nyu.NoSuchKeywordsCollaborationException;
import com.nyu.NoSuchLessonException;
import com.nyu.model.KeywordsCollaboration;
import com.nyu.model.Lesson;
import com.nyu.model.LessonCollaboration;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.base.KeywordsCollaborationLocalServiceBaseImpl;
import com.nyu.util.Constant;

/**
 * The implementation of the keywords collaboration local service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the {@link com.nyu.service.KeywordsCollaborationLocalService} interface.
 *
 * <p>
 * This is a local service. Methods of this service will not have security checks based on the propagated JAAS credentials because this service can only be accessed from within the same VM.
 * </p>
 *
 * @author Allwins Rajaiah
 * @see com.nyu.service.base.KeywordsCollaborationLocalServiceBaseImpl
 * @see com.nyu.service.KeywordsCollaborationLocalServiceUtil
 */
public class KeywordsCollaborationLocalServiceImpl
	extends KeywordsCollaborationLocalServiceBaseImpl {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never reference this interface directly. Always use {@link com.nyu.service.KeywordsCollaborationLocalServiceUtil} to access the keywords collaboration local service.
	 */
	public KeywordsCollaboration getKeyWordCollaborationStatus(long keywordId,long userId) {
		try {
			KeywordsCollaboration keywordsCollaboration = keywordsCollaborationPersistence.findByrequestStatus(keywordId, userId);
			return keywordsCollaboration;
		} catch (SystemException e) {
		} catch (NoSuchKeywordsCollaborationException e) {
		}
		return null;
	}
	
	public List<KeywordsCollaboration> getKeyWordCollaborationStatusList(long keywordId) {
		try {
			List<KeywordsCollaboration> keywordsCollaboration = keywordsCollaborationPersistence.findBykeywordExistence(keywordId);
			return keywordsCollaboration;
		} catch (SystemException e) {
		}
		return null;
	}
	
	public List<KeywordsCollaboration> getPendingRequestByStatus(String status) {
		try {
			List<KeywordsCollaboration> keywordsCollaboration = keywordsCollaborationPersistence.findBykeywordCollaListbyStatus(status);
			return keywordsCollaboration;
		} catch (SystemException e) {
		}
		return null;
	}
	
	public List<KeywordsCollaboration> getRequestStatusByUserId(long userId) {
		try {
			List<KeywordsCollaboration> keywordsCollaboration ;
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(KeywordsCollaboration.class);
			dynamicQuery.add(PropertyFactoryUtil.forName("userId").eq(userId));
			dynamicQuery.add(PropertyFactoryUtil.forName("status").ne(Constant.KEYWORD_STATUS_REQUEST));
			dynamicQuery.add(PropertyFactoryUtil.forName("markAs").ne(Constant.KEYWORD_MARK_AS_READ));
			keywordsCollaboration = keywordsCollaborationLocalService.dynamicQuery(dynamicQuery);
			return keywordsCollaboration;
		} catch (SystemException e) {
		}
		return null;
	}
}
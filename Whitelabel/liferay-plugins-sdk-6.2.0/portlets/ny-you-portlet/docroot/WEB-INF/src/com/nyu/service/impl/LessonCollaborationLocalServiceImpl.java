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

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.nyu.NoSuchLessonCollaborationException;
import com.nyu.NoSuchLessonException;
import com.nyu.model.Lesson;
import com.nyu.model.LessonCollaboration;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.base.LessonCollaborationLocalServiceBaseImpl;
import com.nyu.service.persistence.LessonFinderUtil;

/**
 * The implementation of the lesson collaboration local service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the {@link com.nyu.service.LessonCollaborationLocalService} interface.
 *
 * <p>
 * This is a local service. Methods of this service will not have security checks based on the propagated JAAS credentials because this service can only be accessed from within the same VM.
 * </p>
 *
 * @author Allwins Rajaiah
 * @see com.nyu.service.base.LessonCollaborationLocalServiceBaseImpl
 * @see com.nyu.service.LessonCollaborationLocalServiceUtil
 */
public class LessonCollaborationLocalServiceImpl
	extends LessonCollaborationLocalServiceBaseImpl {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never reference this interface directly. Always use {@link com.nyu.service.LessonCollaborationLocalServiceUtil} to access the lesson collaboration local service.
	 */

	public LessonCollaboration getUserExistence(long lessonId, long userId) {

		try {
			return lessonCollaborationPersistence
					.findBylessonCollabUserExistence(lessonId, userId);
		} catch (NoSuchLessonCollaborationException e) {
		} catch (SystemException e) {
		}
		return null;
	}

	public List<LessonCollaboration> getLessonUsers(long lessonId,
			String memberStatus) {

		try {
			return lessonCollaborationPersistence.
					findBylessonCollabUserList(lessonId, memberStatus);
		} catch (SystemException e) {
		}
		return null;
	}
	
	public List<LessonCollaboration> getLessonUsersByType(long lessonId,
			String type) {

		try {
			return lessonCollaborationPersistence.findBylessonCollabUserListByType(lessonId, type);
					
		} catch (SystemException e) {
		}
		return null;
	}
	
	public List<Lesson> getCollaborationLessonsByUser(long userId, String memberStatus) {

		try {
			List<LessonCollaboration> lessonCollaborations = lessonCollaborationPersistence.findByallLessonCollabByUserId(userId, memberStatus);
			List<Lesson> lessons = new ArrayList<Lesson>();
			for(LessonCollaboration lessonCollaboration:lessonCollaborations){
				try{
				lessons.add(LessonLocalServiceUtil.getLesson(lessonCollaboration.getLessonId()));
				}catch(NoSuchLessonException e){
					
				} catch (PortalException e) {
					
				}
			}
			return lessons;
		} catch (SystemException e) {
		}
		return null;
	}
	
	public List<LessonCollaboration> getallLessonAccessPermissionByUserId(long userId,String accessPermission) {
		try {
			return lessonCollaborationPersistence.findByallLessonAccessPermissionByUserId(userId, accessPermission);
		} catch (SystemException e) {
		}
		return null;
	}
	
	public List<LessonCollaboration> getallLessonAccessPermissionByLessonId(long lessonId,String accessPermission) {
		try {
			return lessonCollaborationPersistence.findByallLessonAccessPermissionByLessonId(lessonId, accessPermission);
		} catch (SystemException e) {
		}
		return null;
	}

}
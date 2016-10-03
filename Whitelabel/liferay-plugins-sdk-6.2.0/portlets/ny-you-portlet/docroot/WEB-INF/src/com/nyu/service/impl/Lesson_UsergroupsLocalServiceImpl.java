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
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.model.UserGroup;
import com.liferay.portal.service.UserGroupLocalServiceUtil;
import com.nyu.model.Lesson;
import com.nyu.model.Lesson_Usergroups;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.base.Lesson_UsergroupsLocalServiceBaseImpl;
import com.nyu.util.LessonSortByTime;

/**
 * The implementation of the lesson_ usergroups local service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the {@link com.nyu.service.Lesson_UsergroupsLocalService} interface.
 *
 * <p>
 * This is a local service. Methods of this service will not have security checks based on the propagated JAAS credentials because this service can only be accessed from within the same VM.
 * </p>
 *
 * @author Allwins Rajaiah
 * @see com.nyu.service.base.Lesson_UsergroupsLocalServiceBaseImpl
 * @see com.nyu.service.Lesson_UsergroupsLocalServiceUtil
 */
public class Lesson_UsergroupsLocalServiceImpl
	extends Lesson_UsergroupsLocalServiceBaseImpl {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never reference this interface directly. Always use {@link com.nyu.service.Lesson_UsergroupsLocalServiceUtil} to access the lesson_ usergroups local service.
	 */
	
	
	
	public List<Lesson> getLessonsByGroupId(long groupId) {
		List<Lesson_Usergroups> lesson_usergroups = null;
		List<Lesson> lessons = new ArrayList<Lesson>(); 

		try {
			lesson_usergroups = lesson_UsergroupsPersistence.findBylessonsByGroupId(groupId);
		} catch (SystemException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		for(Lesson_Usergroups lesson_usergroup: lesson_usergroups){
			Lesson l=null;
			try {
				l = lessonLocalService.getLesson(lesson_usergroup.getLessonId());
			} catch (PortalException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SystemException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if(l != null)
				lessons.add(l);
		}
		Collections.sort(lessons,new LessonSortByTime());
		return lessons;
	}
	
	public List<Lesson_Usergroups> getLesson_UserGroupId(long groupId) {
		List<Lesson_Usergroups> lesson_usergroups = null;
		 

		try {
			lesson_usergroups = lesson_UsergroupsPersistence.findBylessonsByGroupId(groupId);
		} catch (SystemException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		return lesson_usergroups;
	}
	
	
	public List<UserGroup> getGroupsByLessonId(long lessonId) {
		List<Lesson_Usergroups> lesson_usergroups = null;
		List<UserGroup> userGroups = new ArrayList<UserGroup>(); 

			try {
				lesson_usergroups = lesson_UsergroupsPersistence.findBygroupsByLessonId(lessonId);
			} catch (SystemException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			for(Lesson_Usergroups lesson_usergroup: lesson_usergroups){
				try {
					if(lesson_usergroup.getGroupId() > 0){
						userGroups.add(UserGroupLocalServiceUtil.getUserGroup(lesson_usergroup.getGroupId()));
					}
				} catch (PortalException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SystemException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}


		return userGroups;
	}
	
	
	public List<Lesson_Usergroups> getLesson_UserGroupLessonId(long lessonId) {
		List<Lesson_Usergroups> lesson_usergroups = null;		 
		
			try {
				lesson_usergroups= lesson_UsergroupsPersistence.findBygroupsByLessonId(lessonId);
			} catch (SystemException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
			return lesson_usergroups;
	}
	
}
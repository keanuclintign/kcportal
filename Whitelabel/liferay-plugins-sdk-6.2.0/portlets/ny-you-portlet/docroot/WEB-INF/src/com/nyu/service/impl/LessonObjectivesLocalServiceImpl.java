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
import com.nyu.model.LessonObjectives;
import com.nyu.service.base.LessonObjectivesLocalServiceBaseImpl;
import com.nyu.service.persistence.LessonObjectivesUtil;

/**
 * The implementation of the lesson objectives local service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the {@link com.nyu.service.LessonObjectivesLocalService} interface.
 *
 * <p>
 * This is a local service. Methods of this service will not have security checks based on the propagated JAAS credentials because this service can only be accessed from within the same VM.
 * </p>
 *
 * @author Allwins Rajaiah
 * @see com.nyu.service.base.LessonObjectivesLocalServiceBaseImpl
 * @see com.nyu.service.LessonObjectivesLocalServiceUtil
 */
public class LessonObjectivesLocalServiceImpl
	extends LessonObjectivesLocalServiceBaseImpl {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never reference this interface directly. Always use {@link com.nyu.service.LessonObjectivesLocalServiceUtil} to access the lesson objectives local service.
	 */
	
	@Override
	public List<LessonObjectives> getLessonObjectivesList(long lessonId) throws SystemException{
		List<LessonObjectives> lessonObjectivesList;

		try{
			lessonObjectivesList = LessonObjectivesUtil.findBylessonObjectivesList(lessonId);
			
		}catch(Exception e){
			throw new SystemException();
		}

		return lessonObjectivesList;
	}
}
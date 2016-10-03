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
import com.nyu.model.AnswerRequest;
import com.nyu.model.DocumentSection;
import com.nyu.service.base.AnswerRequestLocalServiceBaseImpl;
import com.nyu.service.persistence.AnswerRequestUtil;
import com.nyu.service.persistence.DocumentSectionUtil;

/**
 * The implementation of the answer request local service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the {@link com.nyu.service.AnswerRequestLocalService} interface.
 *
 * <p>
 * This is a local service. Methods of this service will not have security checks based on the propagated JAAS credentials because this service can only be accessed from within the same VM.
 * </p>
 *
 * @author Allwins Rajaiah
 * @see com.nyu.service.base.AnswerRequestLocalServiceBaseImpl
 * @see com.nyu.service.AnswerRequestLocalServiceUtil
 */
public class AnswerRequestLocalServiceImpl
	extends AnswerRequestLocalServiceBaseImpl {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never reference this interface directly. Always use {@link com.nyu.service.AnswerRequestLocalServiceUtil} to access the answer request local service.
	 */
	
	public List<AnswerRequest> getAnsweredCollaborationLessons(long requestId, long userId) throws SystemException{
		List<AnswerRequest> answerRequestList;

		try{
			answerRequestList = AnswerRequestUtil.findByCollaborationLesson(requestId, userId);
			
		}catch(Exception e){
			throw new SystemException();
		}

		return answerRequestList;
	}
	
	public List<AnswerRequest> getCollaborationLessonList(long requestId) throws SystemException{
		List<AnswerRequest> answerRequestList;

		try{
			answerRequestList = AnswerRequestUtil.findByAnswerRequestList(requestId);
			
		}catch(Exception e){
			throw new SystemException();
		}

		return answerRequestList;
	}
	
}
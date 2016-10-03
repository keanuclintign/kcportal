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
import com.nyu.model.DocumentSection;
import com.nyu.model.LessonObjectives;
import com.nyu.service.base.DocumentSectionLocalServiceBaseImpl;
import com.nyu.service.persistence.DocumentSectionUtil;
import com.nyu.service.persistence.LessonObjectivesUtil;

/**
 * The implementation of the document section local service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the {@link com.nyu.service.DocumentSectionLocalService} interface.
 *
 * <p>
 * This is a local service. Methods of this service will not have security checks based on the propagated JAAS credentials because this service can only be accessed from within the same VM.
 * </p>
 *
 * @author Allwins Rajaiah
 * @see com.nyu.service.base.DocumentSectionLocalServiceBaseImpl
 * @see com.nyu.service.DocumentSectionLocalServiceUtil
 */
public class DocumentSectionLocalServiceImpl
	extends DocumentSectionLocalServiceBaseImpl {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never reference this interface directly. Always use {@link com.nyu.service.DocumentSectionLocalServiceUtil} to access the document section local service.
	 */
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(DocumentSectionLocalServiceImpl.class);
	
	public List<DocumentSection> getDocumentSectionList(long lessonId){
		List<DocumentSection> documentSectionList = null;
		try{
			documentSectionList = DocumentSectionUtil.findBydocumentSectionList(lessonId);
		}catch(Exception e){
			LOG.error("[Issue in DocumentSectionListByLessonId]"+e.getMessage());
		}
		return documentSectionList;
	}
}
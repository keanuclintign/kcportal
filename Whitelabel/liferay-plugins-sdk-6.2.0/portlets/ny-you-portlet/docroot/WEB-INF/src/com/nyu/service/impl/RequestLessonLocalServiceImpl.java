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
import java.util.Map;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.util.Validator;
import com.nyu.model.RequestLesson;
import com.nyu.service.RequestLessonLocalServiceUtil;
import com.nyu.service.base.RequestLessonLocalServiceBaseImpl;
import com.nyu.service.persistence.RequestLessonFinderUtil;


/**
 * The implementation of the request lesson local service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the {@link com.nyu.service.RequestLessonLocalService} interface.
 *
 * <p>
 * This is a local service. Methods of this service will not have security checks based on the propagated JAAS credentials because this service can only be accessed from within the same VM.
 * </p>
 *
 * @author Allwins Rajaiah
 * @see com.nyu.service.base.RequestLessonLocalServiceBaseImpl
 * @see com.nyu.service.RequestLessonLocalServiceUtil
 */
public class RequestLessonLocalServiceImpl extends RequestLessonLocalServiceBaseImpl {
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(RequestLessonLocalServiceImpl.class);
	
	public List<RequestLesson> getRequestLessons(long companyId) throws SystemException {
          RequestLessonLocalServiceUtil.getAllRequestCategories();
		return requestLessonPersistence.findByrequestLessons(companyId);
	}
	/*This to get  all the requests and answer of all categories which are showing in subject page */
	public String getAllRequestCategories(){
		
		Map<String, List<String>> subjectRequests = null;
		Map<String, String> subjectRequestAnswers = null;
		
		subjectRequests=RequestLessonFinderUtil.findAllrequestCategories();
		subjectRequestAnswers=RequestLessonFinderUtil.findAllrequestCategoryAnswer();
		JSONArray SubjectJson=JSONFactoryUtil.createJSONArray();
		
		if(Validator.isNotNull(subjectRequests) && !subjectRequests.isEmpty()){
			for (Map.Entry<String,List<String>> entry : subjectRequests.entrySet()) {
				
				JSONObject subject=JSONFactoryUtil.createJSONObject();
			    String key = entry.getKey();
			   
			    List<String> category=entry.getValue();
			    subject.put("categoryId",entry.getKey());
			    subject.put("categoryName",category.get(0));
			    subject.put("RequestCount",category.get(1));
			    if(Validator.isNotNull((subjectRequestAnswers.get(key)))){
			    	  subject.put("answerCount",subjectRequestAnswers.get(key));
			    }else{
			    	 subject.put("answerCount","0");
			    }
			    SubjectJson.put(subject);   
			}
		}
		return SubjectJson.toString();
	}
	
	/*This to get  all the requests of particular category which are showing in allRequest page when we click on category link of subject page */
	public List<RequestLesson> getAllRequestByCategory(long categoryId,int start,int end ){
		List<RequestLesson> requests = RequestLessonFinderUtil.findAssetRequestsByCategory(categoryId, start, end);
		return requests;
	}
	
	public List<Long> getUserContribution(long startPeriod,int start,int end){
		
		List<Long> userStats= RequestLessonFinderUtil.findUsersContribution(startPeriod, start, end);
		return userStats;
	}
	
}
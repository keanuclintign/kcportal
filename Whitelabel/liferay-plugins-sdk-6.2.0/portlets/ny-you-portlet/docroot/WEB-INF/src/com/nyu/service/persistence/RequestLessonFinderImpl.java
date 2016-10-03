package com.nyu.service.persistence;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.liferay.portal.kernel.dao.orm.QueryPos;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.dao.orm.SQLQuery;
import com.liferay.portal.kernel.dao.orm.Session;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.model.User;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.persistence.impl.BasePersistenceImpl;
import com.liferay.util.dao.orm.CustomSQLUtil;
import com.nyu.model.RequestLesson;
import com.nyu.model.impl.RequestLessonImpl;
import com.nyu.portlet.requestlesson.RequestLessonController;



public class RequestLessonFinderImpl extends BasePersistenceImpl<RequestLesson> implements RequestLessonFinder{
	
	public static final String ALL_REQUEST_CATEGORIES= RequestLessonFinder.class.getName() +".findAllRequestCategories";
	public static final String ALL_REQUEST_CATEGORY_ANSWERS= RequestLessonFinder.class.getName() +".findAllRequestCategoryAnswer";
	public static final String FIND_ASSET_REQUEST_BY_CATEGORY=RequestLessonFinder.class.getName() +".findAssetRequestByCategory";
	public static final String FIND_USER_CONTRIBUTION= RequestLessonFinder.class.getName() +".findUserContribution";
	private static org.apache.log4j.Logger LOG= Logger.getLogger(RequestLessonController.class);
	
	public Map<String, List<String>> findAllrequestCategories() { 
		 
		Session session=null;
		Map<String,List<String>> subjectRequest = new HashMap<String, List<String>>();
		try {
	       	session = openSession();
	        String sql = CustomSQLUtil.get(ALL_REQUEST_CATEGORIES);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(RequestLesson.class));
	        Iterator itr = q.list().iterator();
	        
	        while (itr.hasNext()) { 
	        	Object data [] = (Object [])itr.next();
	        	List<String> category=new ArrayList<String>();
	        	category.add( data[1].toString());
	        	category.add(data[2].toString());
	        	subjectRequest.put(data[0].toString(), category);
	        }
	    }catch (Exception e) {
		    	LOG.error("[RequestLessonFinderImpl: findAllrequestCategories() ]"+e);
		}finally {
		    closeSession(session);
		}
		return subjectRequest; 
	}
	
	public  Map<String, String> findAllrequestCategoryAnswer() { 
		 
		Session session=null;
		Map<String, String> subjectAnswers = new HashMap<String, String>();
		try {
		 	session = openSession();
	        String sql = CustomSQLUtil.get(ALL_REQUEST_CATEGORY_ANSWERS);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(RequestLesson.class));
	        Iterator itr = q.list().iterator();
	       
	        while (itr.hasNext()) { 
	        	Object data [] = (Object [])itr.next();
	        	subjectAnswers.put(data[0].toString(), data[1].toString());
	        }
	    }catch (Exception e) {
		    	LOG.error("[RequestLessonFinderImpl: findAllrequestCategoryAnswer() ]"+e);
		}finally {
		    closeSession(session);
		}
		 return subjectAnswers; 
	}
	
	@SuppressWarnings("unchecked")
	public List<RequestLesson> findAssetRequestsByCategory(long categoryId, int start, int end) { 
		
		List<RequestLesson> requests =null;
	    Session session = null;
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_ASSET_REQUEST_BY_CATEGORY);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("RequestLesson",RequestLessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(RequestLesson.class));
	        qPos.add(categoryId);
	        requests = (List<RequestLesson>) QueryUtil.list(q, getDialect(),start,end);
	    }catch (Exception e) {
	    	LOG.error("[RequestLessonFinderImpl: findAssetRequestsByCategory() ]"+e);
	    }finally {
	        closeSession(session);
	    }
	    return requests;
	}
	
	public List<Long> findUsersContribution(long startPeriod,int start,int end) { 
		
		List<Long> contributorMap = new ArrayList<Long>();
	    Session session = null;
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_USER_CONTRIBUTION);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(startPeriod);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(User.class));
	        Iterator itr = q.list().iterator();
	        
	        while (itr.hasNext()) { 
	        	Object data [] = (Object [])itr.next();
	        	contributorMap.add(GetterUtil.getLong(data[0]));
	        }
	    }catch (Exception e) {
	    	LOG.error("[RequestLessonFinderImpl: findUsersContribution() ]"+e);
	    }finally {
	        closeSession(session);
	    }
	    return contributorMap;
	}
	
}

package com.nyu.service.persistence;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.liferay.portal.kernel.dao.orm.QueryPos;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.dao.orm.SQLQuery;
import com.liferay.portal.kernel.dao.orm.Session;
import com.liferay.portal.kernel.transaction.Transactional;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.persistence.impl.BasePersistenceImpl;
import com.liferay.portlet.social.model.SocialRelation;
import com.liferay.util.dao.orm.CustomSQLUtil;
import com.nyu.model.DocumentFile;
import com.nyu.model.Lesson;
import com.nyu.model.impl.DocumentFileImpl;
import com.nyu.model.impl.LessonImpl;
import com.nyu.portlet.social.activities.NyuMemberActivityKeys;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.util.Constant;

@Transactional 
public class LessonFinderImpl extends BasePersistenceImpl<SocialRelation> implements LessonFinder {
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(LessonFinderImpl.class);

	public static final String FIND_MOST_FOLLOWED_AUTHORS = LessonFinder.class.getName() +".findMostFollowedAuthors";
	
	public static final String FIND_FOLLOWING_AUTHORS = LessonFinder.class.getName() +".findFollowingAuthors";
	
	public static final String FIND_LESSON_BY_TYPE = LessonFinder.class.getName() +".findLessonByType";
	
	public static final String FIND_RECENT_ACTIVITY = LessonFinder.class.getName() +".findRecentActivity";
	
	public static final String FIND_LESSON_ACTIVITY = LessonFinder.class.getName() +".findLessonActivity";
	
	public static final String FIND_DELETE_USER_ACTIVITY = LessonFinder.class.getName() +".findAndDeleteUserActivity";
	
	public static final String FIND_DELETE_USER_ACTIVITY_BY_TYPE = LessonFinder.class.getName() +".findAndDeleteUserActivityByType";
	
	public static final String FIND_ASSET_LESSONS = LessonFinder.class.getName() +".findAssetLessons";
	
	public static final String FIND_ASSET_FEATURED_LESSONS = LessonFinder.class.getName() +".findAssetFeaturedLessons";
	
	public static final String FIND_LESSONS_WITH_COLLABORATIONS = LessonFinder.class.getName() +".findLessonsWithCollaborations";
	
	public static final String FIND_PRIVATE_LESSONSIDS_BELONG_TO_USER = LessonFinder.class.getName() +".findPrivateLessonsIdsBelongToUser";
	
	public static final String FIND_PRIVATE_LESSONSIDS = LessonFinder.class.getName() +".findPrivateLessonsIds";
	
	public static final String FIND_ASSET_LESSONS_BY_CATEGORY = LessonFinder.class.getName() +".findAssetLessonsByCategory";
	
	public static final String FIND_ASSET_LESSONS_BY_TAG = LessonFinder.class.getName() +".findAssetLessonsByTag";
	
	public static final String FIND_ASSET_FEATURED_LESSONS_BY_TAG = LessonFinder.class.getName() +".findAssetFeaturedLessonsByTag";
	
	public static final String FIND_ARCHIVED_MARKED_AS_LESSONS_BY_TAG = LessonFinder.class.getName() +".findArchivedMarkedAsLessonsByTag";
	
	public static final String FIND_ARCHIVED_MARKED_AS_LESSONS_BY_CATEGORY = LessonFinder.class.getName() +".findArchivedMarkedAsLessonsByCategory";
	
	public static final String FIND_ASSET_USER_GROUP_LESSONS = LessonFinder.class.getName() +".findAssetUserGroupLessons";
	
	public static final String FIND_ASSET_USER_GROUP_LESSONS_BY_CATEGORY = LessonFinder.class.getName() +".findAssetUserGroupLessonsByCategory";
	
	public static final String FIND_ASSET_USER_GROUP_LESSONS_BY_TAG = LessonFinder.class.getName() +".findAssetUserGroupLessonsByTag";
	
	public static final String FIND_ASSET_FEATURED_USER_GROUP_LESSONS_BY_TAG = LessonFinder.class.getName() +".findAssetFeaturedUserGroupLessonsByTag";
	
	public static final String FIND_FEATURED_USER_GROUP_LESSONS = LessonFinder.class.getName() +".findFeaturedUserGroupLessons";

	public static final String FIND_ASSET_LESSONS_BY_CATEGORY_AND_USER = LessonFinder.class.getName() +".findAssetLessonsByCategoryAndUser";
	
	public static final String FIND_ASSET_LESSONS_BY_TAG_AND_USER = LessonFinder.class.getName() +".findAssetLessonsByTagAndUser";
	
	public static final String FIND_ASSET_LESSONS_BY_CATEGORY_AND_FEATURED = LessonFinder.class.getName() +".findAssetLessonsByCategoryAndFeatured";
	
	public static final String FIND_ASSET_LESSONS_BY_TAG_AND_FEATURED = LessonFinder.class.getName() +".findAssetLessonsByTagAndFeatured";
	
	public static final String DELETE_OBJECTIVES_OF_LESSON = LessonFinder.class.getName() +".deleteObjectivesOfLesson";
	
	public static final String FIND_DELETE_LESSON_SECTION = LessonFinder.class.getName() +".findAndDeleteLessonSection";
	
	public static final String FIND_DELETE_LESSON_COLLABORATION = LessonFinder.class.getName() +".findAndDeleteLessonCollaboration";
	
	public static final String FIND_DELETE_FAVOURITE_LESSON = LessonFinder.class.getName() +".findAndDeleteFavouriteLesson";
	
	public static final String FIND_RESOURCE_DOCUMENT_WITH_PERMISSION = LessonFinder.class.getName() +".findResourceDocumentsWithPermission";
	
	public static final String FIND_RESOURCE_DOCUMENT_IDS_WITH_PERMISSION = LessonFinder.class.getName() +".findResourceDocumentsIdsWithPermission";
	
	public static final String FIND_MY_FAVOURITE_LESSONS = LessonFinder.class.getName() +".findMyFavouriteLessons";
	
	public static final String FIND_MY_LESSONS_WITH_COLLABORATION = LessonFinder.class.getName() +".findMyLessonsWithCollaborations";
	
	public Map<Long, Long> findMostFollowedAuthors() { 

			LOG.info("[LessonFinderImpl: findMostFollowedAuthors]");
			
			Map<Long, Long> mFollowedAuthors = new HashMap<Long, Long>();
		    Session session = null;
		    
		    try {
		        session = openSession();

		        String sql = CustomSQLUtil.get(FIND_MOST_FOLLOWED_AUTHORS);

		        SQLQuery q = session.createSQLQuery(sql);
		
		        q.setCacheable(false); 
		        
		        Iterator itr = q.list().iterator();
		       
		        while (itr.hasNext()) { 
		        	Object data [] = (Object [])itr.next();
		        	mFollowedAuthors.put(Long.valueOf(data[0].toString()), Long.valueOf(data[1].toString()));
		        }
		        
		        LOG.info("[MOST FOLLOWED AUTHORS MAP]" + mFollowedAuthors);
		        
		    } catch (Exception e) {
		    	
		        e.printStackTrace();
		        
		    } finally {
		    	
		        closeSession(session);
		    }

		    return mFollowedAuthors;
		}
	
	public Map<Long, Long> findFollowingAuthors(long userId1) { 

		LOG.info("[LessonFinderImpl: findFollowingAuthors]");
		
		Map<Long, Long> mFollowingAuthors = new HashMap<Long, Long>();
	    Session session = null;
	    
	    try {
	        session = openSession();

	        String sql = CustomSQLUtil.get(FIND_FOLLOWING_AUTHORS);

	        SQLQuery q = session.createSQLQuery(sql);
	
	        q.setCacheable(false); 
	        
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(userId1);
	        
	        Iterator itr = q.list(false).iterator();
	       
	        while (itr.hasNext()) { 
	        	Object data [] = (Object [])itr.next();
	        	mFollowingAuthors.put(Long.valueOf(data[0].toString()), Long.valueOf(data[1].toString()));
	        }
	        
	        LOG.info("[FOLLOWING AUTHORS MAP]" + mFollowingAuthors);
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }

	    return mFollowingAuthors;
	}

	public Map<Long, Long> findLessonByType(long clasNameId, long lessonId, int type) { 

		LOG.info("[LessonFinderImpl: findLessonByType]");
		LOG.info("Class Name Id: "+clasNameId+"Lesson Id: "+lessonId+"Type: "+type);
		Map<Long, Long> lessonsByType = new HashMap<Long, Long>();
	    Session session = null;
	    
	    try {
	        session = openSession();
	        
	        String sql = CustomSQLUtil.get(FIND_LESSON_BY_TYPE);
	        SQLQuery q = session.createSQLQuery(sql);
	      
	        q.setCacheable(false); 
	       
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(clasNameId);
	        qPos.add(lessonId);
	        qPos.add(type);

	        Iterator itr = q.list(false).iterator();

	        while (itr.hasNext()) { 
	        	Object data [] = (Object [])itr.next();
	        	lessonsByType.put(Long.valueOf(data[0].toString()), Long.valueOf(data[1].toString()));
	        }
	        
	        LOG.info("[LESSONS BY "+type+"]" + lessonsByType);
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }

	    return lessonsByType;
	}
	
	public Map<Long, Long> findRecentActivity(long clasNameId, long userId) { 

		LOG.info("[LessonFinderImpl: findRecentActivity]");
		
		Map<Long, Long> recentActivityMap = new HashMap<Long, Long>();
	    Session session = null;
	    try {
	        session = openSession();

	        String sql = CustomSQLUtil.get(FIND_RECENT_ACTIVITY);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(clasNameId);
	        qPos.add(userId);
	        
	        Iterator itr = q.list(false).iterator();
	       
	        while (itr.hasNext()) { 
	        	Object data [] = (Object [])itr.next();
	        	recentActivityMap.put(Long.valueOf(data[0].toString()), Long.valueOf(data[1].toString()));
	        }
	        
	        LOG.info("[RECENT ACTIVITY ]" + recentActivityMap);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        closeSession(session);
	    }

	    return recentActivityMap;
	}
	
	public Map<Long, Long> findLessonActivity(long clasNameId, long classPK, long userId) { 

		LOG.info("[LessonFinderImpl: findRecentActivity]");
		
		Map<Long, Long> recentActivityMap = new HashMap<Long, Long>();
	    Session session = null;
	    try {
	        session = openSession();

	        String sql = CustomSQLUtil.get(FIND_LESSON_ACTIVITY);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(clasNameId);
	        qPos.add(classPK);
	        qPos.add(userId);
	        
	        Iterator itr = q.list(false).iterator();
	       
	        while (itr.hasNext()) { 
	        	Object data [] = (Object [])itr.next();
	        	recentActivityMap.put(Long.valueOf(data[0].toString()), Long.valueOf(data[1].toString()));
	        }
	        
	        LOG.info("[RECENT ACTIVITY ]" + recentActivityMap);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        closeSession(session);
	    }

	    return recentActivityMap;
	}	
	
	public void findAndDeleteUserActivity(long userId, long clasPk, long createdDate, int type){
		
		LOG.info("[LessonFinderImpl: findAndDeleteUserActivity]");
		LOG.info("User Id: "+userId+"Lesson Id: "+clasPk+" Created Date: "+createdDate);
		
	    Session session = null;
	    try {
	        session = openSession();

	        String sql = CustomSQLUtil.get(FIND_DELETE_USER_ACTIVITY);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(userId);
	        qPos.add(clasPk);
	        qPos.add(createdDate);
	        
	        q.executeUpdate();
	        
	    } catch (Exception e) {
	    	LOG.info("[ERROR: LessonFinderImpl > findAndDeleteUserActivity() ]" + e);
	    	
	    } finally {
	    	
	        closeSession(session);
	    }
	}
	
	
public void findAndDeleteUserActivityByType(long userId, long clasPk, long createdDate, int type){
		
		LOG.info("[LessonFinderImpl: findAndDeleteUserActivityByType]");
		LOG.info("User Id: "+userId+"Lesson Id: "+clasPk+" Created Date: "+createdDate);
		
	    Session session = null;
	    try {
	        session = openSession();

	        String sql = CustomSQLUtil.get(FIND_DELETE_USER_ACTIVITY_BY_TYPE);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(userId);
	        qPos.add(clasPk);
	        qPos.add(createdDate);
	        qPos.add(type);
	       
		    q.executeUpdate();
	        
	    } catch (Exception e) {
	    	LOG.info("[ERROR: LessonFinderImpl > findAndDeleteUserActivityByType() ]" + e);
	    } finally {
	        closeSession(session);
	    }
	}

	public List<Lesson> findAssetLessons(String status, long userId,String[] privacy, String orderBy,String[] markedAs, int start, int end) { 
		
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    StringBuffer markedAsBuffer = new StringBuffer();
	    for(String s: privacy){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    for(String s: markedAs){
	    	markedAsBuffer.append("'"+s+"'");
	    	markedAsBuffer.append(",");
	    }
	    if(markedAsBuffer.toString().endsWith(",")){
	    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
	    }
	    try {
	        session = openSession();
	        
	        String sql = CustomSQLUtil.get(FIND_ASSET_LESSONS);
	        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
	        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
	        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
	        qPos.add(status);
	        qPos.add(userId);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
	    return lessons;
	}
	
public List<Lesson> findAssetFeaturedLessons(String status, long userId,String[] privacy, String orderBy,String[] markedAs, int start, int end) { 
		
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    StringBuffer markedAsBuffer = new StringBuffer();
	    for(String s: privacy){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    for(String s: markedAs){
	    	markedAsBuffer.append("'"+s+"'");
	    	markedAsBuffer.append(",");
	    }
	    if(markedAsBuffer.toString().endsWith(",")){
	    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
	    }
	    try {
	        session = openSession();
	        
	        String sql = CustomSQLUtil.get(FIND_ASSET_FEATURED_LESSONS);
	        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
	        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
	        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
	        qPos.add(status);
	        qPos.add(userId);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
	    return lessons;
	}
	
public List<Lesson> findLessonsWithCollaborations(String status, long userId,String[] privacy, String orderBy,String[] markedAs, int start, int end) { 
		
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    StringBuffer markedAsBuffer = new StringBuffer();
	    for(String s: privacy){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    for(String s: markedAs){
	    	markedAsBuffer.append("'"+s+"'");
	    	markedAsBuffer.append(",");
	    }
	    if(markedAsBuffer.toString().endsWith(",")){
	    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
	    }
	    try {
	        session = openSession();
	        
	        String sql = CustomSQLUtil.get(FIND_LESSONS_WITH_COLLABORATIONS);
	        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
	        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
	        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(status);
	        qPos.add(userId);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
	    return lessons;
	}

public Set<Long> findPrivateLessonsIdsBelongToUser(long userId) { 
	Set<Long> privateLessonIds = new HashSet<Long>();
    Session session = null;
    try {
        session = openSession();
        String sql = CustomSQLUtil.get(FIND_PRIVATE_LESSONSIDS_BELONG_TO_USER);
        SQLQuery q = session.createSQLQuery(sql);
        q.setCacheable(false); 
        QueryPos qPos = QueryPos.getInstance(q);
        qPos.add(userId);
        qPos.add(userId);
        Iterator itr = q.list(false).iterator();
        while (itr.hasNext()) { 
        	long data = GetterUtil.getLong(itr.next());
        	privateLessonIds.add(Long.valueOf(data));
        }
        
    } catch (Exception e) {
    	
        e.printStackTrace();
        
    } finally {
    	
        closeSession(session);
    }

    return privateLessonIds;
}

public Set<Long> findPrivateLessonsIds(String[] privacy) { 
	Set<Long> privateLessonIds = new HashSet<Long>();
	Session session = null;
    StringBuffer sb = new StringBuffer();
    for(String s: privacy){
    	sb.append("'"+s+"'");
    	sb.append(",");
    }
    if(sb.toString().endsWith(",")){
    	sb.replace(sb.length()-1, sb.length(), "");
    }
    try {
        session = openSession();
        
        String sql = CustomSQLUtil.get(FIND_PRIVATE_LESSONSIDS);
        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
        SQLQuery q = session.createSQLQuery(sql);
        q.setCacheable(false); 

        Iterator itr = q.list(false).iterator();
        while (itr.hasNext()) { 
        	long data = GetterUtil.getLong(itr.next());
        	privateLessonIds.add(Long.valueOf(data));
        }
        
    } catch (Exception e) {
    	
        e.printStackTrace();
        
    } finally {
    	
        closeSession(session);
    }

    return privateLessonIds;
}

	public List<Lesson> findAssetLessonsByCategory(long categoryId,long userId ,String status, String[] privacy, String orderBy,String[] markedAs, int start, int end) { 
	
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    StringBuffer markedAsBuffer = new StringBuffer();
	    for(String s: privacy){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    for(String s: markedAs){
	    	markedAsBuffer.append("'"+s+"'");
	    	markedAsBuffer.append(",");
	    }
	    if(markedAsBuffer.toString().endsWith(",")){
	    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
	    }
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_ASSET_LESSONS_BY_CATEGORY);
	        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
	        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
	        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
	        qPos.add(categoryId);
	        qPos.add(status);
	        qPos.add(userId);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
	    return lessons;
	}
	
	public List<Lesson> findAssetLessonsByTag(long tagId,long userId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end) { 
		
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    StringBuffer markedAsBuffer = new StringBuffer();
	    for(String s: privacy){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    for(String s: markedAs){
	    	markedAsBuffer.append("'"+s+"'");
	    	markedAsBuffer.append(",");
	    }
	    if(markedAsBuffer.toString().endsWith(",")){
	    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
	    }
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_ASSET_LESSONS_BY_TAG);
	        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
	        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
	        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
	        qPos.add(tagId);
	        qPos.add(status);
	        qPos.add(userId);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
	    return lessons;
	}
public List<Lesson> findAssetFeaturedLessonsByTag(long tagId,long userId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end) { 
		
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    StringBuffer markedAsBuffer = new StringBuffer();
	    for(String s: privacy){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    for(String s: markedAs){
	    	markedAsBuffer.append("'"+s+"'");
	    	markedAsBuffer.append(",");
	    }
	    if(markedAsBuffer.toString().endsWith(",")){
	    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
	    }
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_ASSET_FEATURED_LESSONS_BY_TAG);
	        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
	        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
	        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
	        qPos.add(tagId);
	        qPos.add(status);
	        qPos.add(userId);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
	    return lessons;
	}

	public List<Lesson> findAssetUserGroupLessons(long userGroupId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end) { 
		
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    StringBuffer markedAsBuffer = new StringBuffer();
	    for(String s: privacy){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    for(String s: markedAs){
	    	markedAsBuffer.append("'"+s+"'");
	    	markedAsBuffer.append(",");
	    }
	    if(markedAsBuffer.toString().endsWith(",")){
	    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
	    }
	    try {
	        session = openSession();
	        
	        String sql = CustomSQLUtil.get(FIND_ASSET_USER_GROUP_LESSONS);
	        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
	        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
	        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
	        qPos.add(userGroupId);
	        qPos.add(status);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
	    return lessons;
	}	

	public List<Lesson> findAssetUserGroupLessonsByCategory(long userGroupId, long categoryId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end) { 
		
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    StringBuffer markedAsBuffer = new StringBuffer();
	    for(String s: privacy){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    for(String s: markedAs){
	    	markedAsBuffer.append("'"+s+"'");
	    	markedAsBuffer.append(",");
	    }
	    if(markedAsBuffer.toString().endsWith(",")){
	    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
	    }
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_ASSET_USER_GROUP_LESSONS_BY_CATEGORY);
	        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
	        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
	        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
	        qPos.add(userGroupId);
	        qPos.add(categoryId);
	        qPos.add(status);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
	    return lessons;
	}
	public List<Lesson> findAssetMarkedAsLessonsByTag(long tagId, String markedAs, int start, int end) {
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_ARCHIVED_MARKED_AS_LESSONS_BY_TAG);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
	        qPos.add(tagId);
	        qPos.add(markedAs);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
		return lessons; 
	
	}
	
	public List<Lesson> findAssetMarkedAsLessonsByCategory(long categoryId, String markedAs, int start, int end) {
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_ARCHIVED_MARKED_AS_LESSONS_BY_CATEGORY);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
	        qPos.add(categoryId);
	        qPos.add(markedAs);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
		return lessons; 
	
	}
	
	public List<Lesson> findAssetUserGroupLessonsByTag(long userGroupId, long tagId, String status, String[] privacy, String orderBy, String[] markedAs, int start, int end) { 
		
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    StringBuffer markedAsBuffer = new StringBuffer();
	    for(String s: privacy){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    for(String s: markedAs){
	    	markedAsBuffer.append("'"+s+"'");
	    	markedAsBuffer.append(",");
	    }
	    if(markedAsBuffer.toString().endsWith(",")){
	    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
	    }
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_ASSET_USER_GROUP_LESSONS_BY_TAG);
	        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
	        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
	        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
	        qPos.add(userGroupId);
	        qPos.add(tagId);
	        qPos.add(status);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
	    return lessons;
	}	
	
public List<Lesson> findAssetFeaturedUserGroupLessonsByTag(long userGroupId, long tagId, String status, String[] privacy, String orderBy, String[] markedAs, int start, int end) { 
		
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    StringBuffer markedAsBuffer = new StringBuffer();
	    for(String s: privacy){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    for(String s: markedAs){
	    	markedAsBuffer.append("'"+s+"'");
	    	markedAsBuffer.append(",");
	    }
	    if(markedAsBuffer.toString().endsWith(",")){
	    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
	    }
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_ASSET_FEATURED_USER_GROUP_LESSONS_BY_TAG);
	        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
	        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
	        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
	        qPos.add(userGroupId);
	        qPos.add(tagId);
	        qPos.add(status);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
	    return lessons;
	}
	
public List<Lesson> findFeaturedUserGroupLessons(long userGroupId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end) { 
		
		List<Lesson> lessons = new ArrayList<Lesson>();
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    StringBuffer markedAsBuffer = new StringBuffer();
	    for(String s: privacy){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    for(String s: markedAs){
	    	markedAsBuffer.append("'"+s+"'");
	    	markedAsBuffer.append(",");
	    }
	    if(markedAsBuffer.toString().endsWith(",")){
	    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
	    }
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_FEATURED_USER_GROUP_LESSONS);
	        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
	        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
	        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("Lesson",LessonImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(userGroupId);
	        qPos.add(status);
	        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	
	    return lessons;
	}	

public List<Lesson> findAssetLessonsByCategoryAndUser(long categoryId,long userId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end) { 
	
	List<Lesson> lessons = new ArrayList<Lesson>();
    Session session = null;
    StringBuffer sb = new StringBuffer();
    StringBuffer markedAsBuffer = new StringBuffer();
    for(String s: privacy){
    	sb.append("'"+s+"'");
    	sb.append(",");
    }
    if(sb.toString().endsWith(",")){
    	sb.replace(sb.length()-1, sb.length(), "");
    }
    for(String s: markedAs){
    	markedAsBuffer.append("'"+s+"'");
    	markedAsBuffer.append(",");
    }
    if(markedAsBuffer.toString().endsWith(",")){
    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
    }
    try {
        session = openSession();
        String sql = CustomSQLUtil.get(FIND_ASSET_LESSONS_BY_CATEGORY_AND_USER);
        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
        SQLQuery q = session.createSQLQuery(sql);
        q.setCacheable(false); 
        q.addEntity("Lesson",LessonImpl.class);
        QueryPos qPos = QueryPos.getInstance(q);
        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
        qPos.add(categoryId);
        qPos.add(status);
        qPos.add(userId);
        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
    } catch (Exception e) {
    	
        e.printStackTrace();
        
    } finally {
    	
        closeSession(session);
    }

    return lessons;
}

public List<Lesson> findAssetLessonsByTagAndUser(long tagId,long userId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end) { 
	
	List<Lesson> lessons = new ArrayList<Lesson>();
    Session session = null;
    StringBuffer sb = new StringBuffer();
    StringBuffer markedAsBuffer = new StringBuffer();
    for(String s: privacy){
    	sb.append("'"+s+"'");
    	sb.append(",");
    }
    if(sb.toString().endsWith(",")){
    	sb.replace(sb.length()-1, sb.length(), "");
    }
    for(String s: markedAs){
    	markedAsBuffer.append("'"+s+"'");
    	markedAsBuffer.append(",");
    }
    if(markedAsBuffer.toString().endsWith(",")){
    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
    }
    try {
        session = openSession();
        String sql = CustomSQLUtil.get(FIND_ASSET_LESSONS_BY_TAG_AND_USER);
        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
        SQLQuery q = session.createSQLQuery(sql);
        q.setCacheable(false); 
        q.addEntity("Lesson",LessonImpl.class);
        QueryPos qPos = QueryPos.getInstance(q);
        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
        qPos.add(tagId);
        qPos.add(status);
        qPos.add(userId);
        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
        
    } catch (Exception e) {
    	
        e.printStackTrace();
        
    } finally {
    	
        closeSession(session);
    }

    return lessons;
}


public List<Lesson> findAssetLessonsByCategoryAndFeatured(long categoryId,boolean featured, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end) { 
	
	List<Lesson> lessons = new ArrayList<Lesson>();
    Session session = null;
    StringBuffer sb = new StringBuffer();
    StringBuffer markedAsBuffer = new StringBuffer();
    for(String s: privacy){
    	sb.append("'"+s+"'");
    	sb.append(",");
    }
    if(sb.toString().endsWith(",")){
    	sb.replace(sb.length()-1, sb.length(), "");
    }
    for(String s: markedAs){
    	markedAsBuffer.append("'"+s+"'");
    	markedAsBuffer.append(",");
    }
    if(markedAsBuffer.toString().endsWith(",")){
    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
    }
    try {
        session = openSession();
        String sql = CustomSQLUtil.get(FIND_ASSET_LESSONS_BY_CATEGORY_AND_FEATURED);
        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
        SQLQuery q = session.createSQLQuery(sql);
        q.setCacheable(false); 
        q.addEntity("Lesson",LessonImpl.class);
        QueryPos qPos = QueryPos.getInstance(q);
        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
        qPos.add(categoryId);
        qPos.add(status);
        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
    } catch (Exception e) {
    	
        e.printStackTrace();
        
    } finally {
    	
        closeSession(session);
    }

    return lessons;
}

public List<Lesson> findAssetLessonsByTagAndFeatured(long tagId,boolean featured, String status, String[] privacy, String orderBy, String[] markedAs,int start, int end) { 
	
	List<Lesson> lessons = new ArrayList<Lesson>();
    Session session = null;
    StringBuffer sb = new StringBuffer();
    StringBuffer markedAsBuffer = new StringBuffer();
    for(String s: privacy){
    	sb.append("'"+s+"'");
    	sb.append(",");
    }
    if(sb.toString().endsWith(",")){
    	sb.replace(sb.length()-1, sb.length(), "");
    }
    for(String s: markedAs){
    	markedAsBuffer.append("'"+s+"'");
    	markedAsBuffer.append(",");
    }
    if(markedAsBuffer.toString().endsWith(",")){
    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
    }
    try {
        session = openSession();
        String sql = CustomSQLUtil.get(FIND_ASSET_LESSONS_BY_TAG_AND_FEATURED);
        sql = StringUtil.replace(sql, "[$privacy$]", sb.toString());
        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
        SQLQuery q = session.createSQLQuery(sql);
        q.setCacheable(false); 
        q.addEntity("Lesson",LessonImpl.class);
        QueryPos qPos = QueryPos.getInstance(q);
        qPos.add(ClassNameLocalServiceUtil.getClassNameId(Lesson.class));
        qPos.add(tagId);
        qPos.add(status);
        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
        
    } catch (Exception e) {
    	
        e.printStackTrace();
        
    } finally {
    	
        closeSession(session);
    }

    return lessons;
}

public List<Lesson> findMyLessonsWithCollaborations(long userId, String orderBy, String[] markedAs,int start, int end) { 
	
	List<Lesson> lessons = new ArrayList<Lesson>();
    Session session = null;
    StringBuffer markedAsBuffer = new StringBuffer();
    for(String s: markedAs){
    	markedAsBuffer.append("'"+s+"'");
    	markedAsBuffer.append(",");
    }
    if(markedAsBuffer.toString().endsWith(",")){
    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
    }
    try {
        session = openSession();
        String sql = CustomSQLUtil.get(FIND_MY_LESSONS_WITH_COLLABORATION);
        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
        sql = StringUtil.replace(sql, "[$memberType$]", Constant.LESSON_ACCESS_CAN_EDIT);
        SQLQuery q = session.createSQLQuery(sql);
        q.setCacheable(false); 
        q.addEntity("Lesson",LessonImpl.class);
        QueryPos qPos = QueryPos.getInstance(q);
        qPos.add(userId);
        qPos.add(userId);
        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
        
    } catch (Exception e) {
    	
        e.printStackTrace();
        
    } finally {
    	
        closeSession(session);
    }

    return lessons;
}

public List<Lesson> findMyFavouriteLessons( long userId,String status, String orderBy, String[] markedAs,int start, int end) { 
	
	List<Lesson> lessons = new ArrayList<Lesson>();
    Session session = null;
    StringBuffer markedAsBuffer = new StringBuffer();
    
    for(String s: markedAs){
    	markedAsBuffer.append("'"+s+"'");
    	markedAsBuffer.append(",");
    }
    if(markedAsBuffer.toString().endsWith(",")){
    	markedAsBuffer.replace(markedAsBuffer.length()-1, markedAsBuffer.length(), "");
    }
    try {
        session = openSession();
        String sql = CustomSQLUtil.get(FIND_MY_FAVOURITE_LESSONS);
        sql = StringUtil.replace(sql, "[$orderBy$]", orderBy);
        sql = StringUtil.replace(sql, "[$markedAs$]", markedAsBuffer.toString());
        SQLQuery q = session.createSQLQuery(sql);
        q.setCacheable(false); 
        q.addEntity("Lesson",LessonImpl.class);
        QueryPos qPos = QueryPos.getInstance(q);
        qPos.add(status);
        qPos.add(userId);
        lessons = (List<Lesson>) QueryUtil.list(q, getDialect(), start, end);
        
    } catch (Exception e) {
    	
        e.printStackTrace();
        
    } finally {
    	
        closeSession(session);
    }

    return lessons;
}
	public void deleteObjectivesOfLesson(long lessonId){
	
		LOG.info("[LessonFinderImpl: deleteObjectivesOfLesson]");
		LOG.info("Lesson Id: "+lessonId);
		
	    Session session = null;
	    try {
	        session = openSession();
	
	        String sql = CustomSQLUtil.get(DELETE_OBJECTIVES_OF_LESSON);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(lessonId);
	              
		    q.executeUpdate();
	        
	    } catch (Exception e) {
	    	LOG.info("[ERROR: LessonFinderImpl > deleteObjectivesOfLesson() ]" + e);
	    } finally {
	        closeSession(session);
	    }
	}
	
	public void deleteSectionOfLesson(long lessonId){
		
		LOG.info("[LessonFinderImpl: deleteSectionOfLesson]");
		LOG.info("Lesson Id: "+lessonId);
		
	    Session session = null;
	    try {
	        session = openSession();
	
	        String sql = CustomSQLUtil.get(FIND_DELETE_LESSON_SECTION);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(lessonId);
	              
		    q.executeUpdate();
	        
	    } catch (Exception e) {
	    	LOG.info("[ERROR: LessonFinderImpl > deleteSectionOfLesson() ]" + e);
	    } finally {
	        closeSession(session);
	    }
	}
	
	public void deleteCollaborationOfLesson(long lessonId){
		
		LOG.info("[LessonFinderImpl: deleteCollaborationOfLesson]");
		LOG.info("Lesson Id: "+lessonId);
		
	    Session session = null;
	    try {
	        session = openSession();
	
	        String sql = CustomSQLUtil.get(FIND_DELETE_LESSON_COLLABORATION);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(lessonId);
	              
		    q.executeUpdate();
	        
	    } catch (Exception e) {
	    	LOG.info("[ERROR: LessonFinderImpl > deleteCollaborationOfLesson() ]" + e);
	    } finally {
	        closeSession(session);
	    }
	}
	
	public void deleteFavouriteLesson(long lessonId){
		
		LOG.info("[LessonFinderImpl: deleteFavouriteLesson]");
		LOG.info("Lesson Id: "+lessonId);
		
	    Session session = null;
	    try {
	        session = openSession();
	
	        String sql = CustomSQLUtil.get(FIND_DELETE_FAVOURITE_LESSON);
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(lessonId);
	              
		    q.executeUpdate();
	        
	    } catch (Exception e) {
	    	LOG.info("[ERROR: LessonFinderImpl > deleteFavouriteLesson() ]" + e);
	    } finally {
	        closeSession(session);
	    }
	}
	
	public List<DocumentFile> findResourceDocumentsWithPermission(String resourceType,String status,String[] permission) { 

		List<DocumentFile> documentFiles = null;
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    for(String s: permission){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_RESOURCE_DOCUMENT_WITH_PERMISSION);
	        sql = StringUtil.replace(sql, "[$permission$]", sb.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        q.addEntity("DocumentFile",DocumentFileImpl.class);
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(resourceType);
	        qPos.add(status);
	        documentFiles = (List<DocumentFile>) QueryUtil.list(q, getDialect(), -1, -1);
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }
	    return documentFiles;
	}
	
	public Set<Long> findResourceDocumentsIdsWithPermission(String resourceType,String[] permission,long lessonId) { 
		Set<Long> resourceIds = new HashSet<Long>();
	    Session session = null;
	    StringBuffer sb = new StringBuffer();
	    for(String s: permission){
	    	sb.append("'"+s+"'");
	    	sb.append(",");
	    }
	    if(sb.toString().endsWith(",")){
	    	sb.replace(sb.length()-1, sb.length(), "");
	    }
	    try {
	        session = openSession();
	        String sql = CustomSQLUtil.get(FIND_RESOURCE_DOCUMENT_IDS_WITH_PERMISSION);
	        sql = StringUtil.replace(sql, "[$permission$]", sb.toString());
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false); 
	        QueryPos qPos = QueryPos.getInstance(q);
	        qPos.add(resourceType);
	        qPos.add(lessonId);
	        Iterator itr = q.list(false).iterator();
	        while (itr.hasNext()) { 
	        	long data = GetterUtil.getLong(itr.next());
	        	resourceIds.add(Long.valueOf(data));
	        }
	        
	    } catch (Exception e) {
	    	
	        e.printStackTrace();
	        
	    } finally {
	    	
	        closeSession(session);
	    }

	    return resourceIds;
	}
}

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
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.util.StringUtils;

import com.liferay.portal.kernel.dao.orm.Criterion;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactory;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.jsonwebservice.JSONWebService;
import com.liferay.portal.kernel.util.OrderByComparator;
import com.liferay.portal.kernel.util.OrderByComparatorFactoryUtil;
import com.liferay.portal.kernel.util.PortalClassLoaderUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.asset.model.AssetEntry;
import com.liferay.portlet.asset.model.AssetTag;
import com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil;
import com.liferay.portlet.asset.service.persistence.AssetEntryQuery;
import com.liferay.portlet.documentlibrary.model.DLFileEntry;
import com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil;
import com.liferay.portlet.messageboards.model.MBMessage;
import com.liferay.util.portlet.PortletProps;
import com.nyu.NoSuchLessonException;
import com.nyu.model.DocumentFile;
import com.nyu.model.FavouriteLessons;
import com.nyu.model.Lesson;
import com.nyu.model.Lesson_Usergroups;
import com.nyu.model.impl.LessonImpl;
import com.nyu.model.impl.LessonModelImpl;
import com.nyu.portlet.social.activities.NyuMemberActivityKeys;
import com.nyu.service.DocumentFileLocalServiceUtil;
import com.nyu.service.FavouriteLessonsLocalServiceUtil;
import com.nyu.service.LessonLocalService;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.Lesson_UsergroupsLocalServiceUtil;
import com.nyu.service.base.LessonLocalServiceBaseImpl;
import com.nyu.service.persistence.DocumentFileUtil;
import com.nyu.service.persistence.LessonFinderUtil;
import com.nyu.util.Constant;
import com.nyu.util.DateUtil;

/**
 * The implementation of the lesson local service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the {@link com.nyu.service.LessonLocalService} interface.
 *
 * <p>
 * This is a local service. Methods of this service will not have security checks based on the propagated JAAS credentials because this service can only be accessed from within the same VM.
 * </p>
 *
 * @author Allwins Rajaiah
 * @see com.nyu.service.base.LessonLocalServiceBaseImpl
 * @see com.nyu.service.LessonLocalServiceUtil
 */
public class LessonLocalServiceImpl extends LessonLocalServiceBaseImpl {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never reference this interface directly. Always use {@link com.nyu.service.LessonLocalServiceUtil} to access the lesson local service.
	 */
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(LessonLocalServiceImpl.class);
	
	@Autowired
    private MessageSource messageSource;

	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never reference this interface directly. Always use {@link com.nyu.service.LessonLocalServiceUtil} to access the lesson local service.
	 */
	
/*	public Lesson addLesson(Lesson lesson, ServiceContext serviceContext) throws SystemException, PortalException {
		lesson = updateLesson(lesson);
		assetEntryLocalService.updateEntry(serviceContext.getUserId(), serviceContext.getScopeGroupId(), 
				Lesson.class.getName(), lesson.getPrimaryKey(), serviceContext.getAssetCategoryIds(), serviceContext.getAssetTagNames());
		addSocialActivity(serviceContext.getUserId(), lesson.getGroupId(), Lesson.class.getName(), lesson.getPrimaryKey(), NyuMemberActivityKeys.ADD_LESSON);
		return lesson;
	}*/
	
	public Lesson updateLesson(Lesson lesson, ServiceContext serviceContext, int type, String[] unpublishDocIds) throws SystemException, PortalException {
		lesson = updateLesson(lesson);
		performCleanUp(lesson.getLessonId(),"editLesson",serviceContext.getUserId(),type, unpublishDocIds);
		assetEntryLocalService.updateEntry(serviceContext.getUserId(), serviceContext.getScopeGroupId(), 
				Lesson.class.getName(), lesson.getPrimaryKey(), serviceContext.getAssetCategoryIds(), serviceContext.getAssetTagNames());
		addSocialActivity(serviceContext.getUserId(), lesson.getGroupId(), Lesson.class.getName(), lesson.getPrimaryKey(), type);
		return lesson;
	}
	

	@Override
	public List<DocumentFile> getDocumentFileList(long lessonId) throws SystemException{
		List<DocumentFile> documentFileList;

		try{
			//documentFileList = LessonUtil.getDocumentFiles( lessonId );
			documentFileList = DocumentFileUtil.findBydocumentFilesList(lessonId);
			
		}catch(Exception e){
			throw new SystemException();
		}

		return documentFileList;
	}



	public DocumentFile getDocumentFile(long lessonId) throws SystemException{
		DocumentFile documentFile = null;

		try{
			//List<DocumentFile> documentFileList = LessonUtil.getDocumentFiles( lessonId );
			List<DocumentFile> documentFileList = DocumentFileUtil.findBydocumentFilesList(lessonId);
			if( CollectionUtils.isNotEmpty(documentFileList)){
				documentFile = documentFileList.get(0);
			}
		}catch(Exception e){
			throw new SystemException();
		}

		return documentFile;   
	}

	//Get lessons based on the search text

	@Override
	@SuppressWarnings("unchecked")
	public List<Lesson> search(String searchText, String searchType) throws SystemException{
		List<Lesson> lessons;
		DynamicQuery dynamicQuery;
		try{
			dynamicQuery = DynamicQueryFactoryUtil.forClass(LessonImpl.class);
			if( StringUtils.hasText(searchText))
			{
				Criterion criterion = null;
				String[] searchTypeArr = searchType.split(StringPool.COMMA);
				
				criterion = RestrictionsFactoryUtil.like( searchTypeArr[0], StringPool.PERCENT + searchText + StringPool.PERCENT);
				if( searchTypeArr.length > 1 ){
					for ( int i = 1; i < searchTypeArr.length; i++ ){
						criterion = RestrictionsFactoryUtil.or(criterion , RestrictionsFactoryUtil.like(searchTypeArr[i], StringPool.PERCENT + searchText + StringPool.PERCENT));
					}
				}
				dynamicQuery.add(criterion);
			}
			
			lessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
		}catch(Exception e){
			throw new SystemException();
		}

		return lessons;
	}
	
	@SuppressWarnings("unchecked")
	public List<Lesson> search(String searchText, String searchType, long companyId) throws SystemException{
		List<Lesson> lessons;
		DynamicQuery dynamicQuery;
		try{
			dynamicQuery = DynamicQueryFactoryUtil.forClass(LessonImpl.class);
			if( StringUtils.hasText(searchText))
			{
				Criterion criterion = null;
				String[] searchTypeArr = searchType.split(StringPool.COMMA);
				
				criterion = RestrictionsFactoryUtil.like( searchTypeArr[0], StringPool.PERCENT + searchText + StringPool.PERCENT);
				if( searchTypeArr.length > 1 ){
					for ( int i = 1; i < searchTypeArr.length; i++ ){
						criterion = RestrictionsFactoryUtil.or(criterion , RestrictionsFactoryUtil.like(searchTypeArr[i], StringPool.PERCENT + searchText + StringPool.PERCENT));
					}
				}
				
				criterion = RestrictionsFactoryUtil.and(criterion,  RestrictionsFactoryUtil.eq("companyId", companyId));
				
				dynamicQuery.add(criterion);
			}
			
			lessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
		}catch(Exception e){
			throw new SystemException();
		}

		return lessons;
	}

	//Get lessons based on the selected tag

	/*@Override
	public List<Lesson> getLessons(String tag) throws SystemException{
		List<Lesson> lessons;

		try{
			lessons = LessonUtil.findBytagCollection(tag);
		}catch(Exception e){
			throw new SystemException();
		}

		return lessons;
	}*/

	//Get Tags with distinct

	/*@Override
	@SuppressWarnings("unchecked")
	public List<String> getTags() throws SystemException{
		List<String> tags = null;
		DynamicQuery dynamicQuery;
		try {
			ClassLoader loader = PortalClassLoaderUtil.getClassLoader();
			DynamicQueryFactory fc = DynamicQueryFactoryUtil.getDynamicQueryFactory();
			dynamicQuery = fc.forClass( LessonImpl.class, "lesson", loader );
			dynamicQuery.setProjection( ProjectionFactoryUtil.distinct( ProjectionFactoryUtil.property("tag")));
			tags = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
		} catch (Exception e) {
			LOG.error( e.getMessage(), e );
		}

		return tags;
	}*/
	
	@JSONWebService("/launcher")
	public String launcher( String key, long lessonId ) throws SystemException{
		String launch = null;
		try {
			Lesson lesson = LessonLocalServiceUtil.getLesson(lessonId);
			launch = fillPlaceHolder( key, lesson ).toString();
			
		} catch (PortalException e) {
			LOG.error(e);
		}
		return launch;
	}
	
	private String fillPlaceHolder( String launcherKey, Lesson lesson ) {
		//String engageLaunchUrl = NyuUtil.getProperty( messageSource, "engage.launch.url"); 
		String engageLaunchUrl = PortletProps.get("engage.launch.url");
				//"https://engage-dev.nyugts.com/recorder/launcher/?Date=#uploadedTime&LiveMode=False&LauncherKey=#launcher.key&Moderator=False&courseId=#courseId&user=#uploadedByName"; 
				//NyuUtil.getProperty( messageSource, "engage.launch.url");
		Map<String,String> replaceMap = new HashMap<String,String>();
		replaceMap.put("#launcher.key", launcherKey );
		replaceMap.put("#uploadedTime", DateUtil.toString( lesson.getUploadedTime()));
		replaceMap.put("#courseId", lesson.getCourseId());
		replaceMap.put("#uploadedByName", lesson.getUploadedByName());
		
		for( String key : replaceMap.keySet() ){
			engageLaunchUrl = engageLaunchUrl.replaceAll( key, replaceMap.get(key));
		}
		LOG.info("[engageLaunchUrl][" + engageLaunchUrl +"]");
		
		return engageLaunchUrl;
	}
	
	
	/*public List<Lesson> getLessonsBySubCategories(String tag) throws SystemException{
		List<Lesson> lessons;

		try{
			lessons = LessonUtil.findBysubCategories(tag);
		}catch(Exception e){
			throw new SystemException();
		}

		return lessons;
	}
	*/

	/*@SuppressWarnings("unchecked")
	public List<String> getSubCategories() throws SystemException{
		List<String> tags = null;
		DynamicQuery dynamicQuery;
		try {
			ClassLoader loader = PortalClassLoaderUtil.getClassLoader();
			DynamicQueryFactory fc = DynamicQueryFactoryUtil.getDynamicQueryFactory();
			dynamicQuery = fc.forClass( LessonImpl.class, "lesson", loader );
			dynamicQuery.setProjection( ProjectionFactoryUtil.distinct( ProjectionFactoryUtil.property("subcategory")));
			tags = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
		} catch (Exception e) {
			LOG.error( e.getMessage(), e );
		}

		return tags;
	}*/
	
	
	/*@SuppressWarnings("unchecked")
	public List<Lesson> getLessonNameWithCompanyId(long companyId, String tag) throws SystemException{
		List<Lesson> lessons;

		try{
			lessons = LessonUtil.findBytagWithCompanyIdCollection(companyId, tag);
		}catch(Exception e){
			throw new SystemException();
		}

		return lessons;
	}
	*/
	
	/*@SuppressWarnings("unchecked")
	public List<String> getTagWithCompanyIdCollection(long companyId) throws SystemException{
		List<String> tags = null;
		DynamicQuery dynamicQuery;
		try {
			ClassLoader loader = PortalClassLoaderUtil.getClassLoader();
			DynamicQueryFactory fc = DynamicQueryFactoryUtil.getDynamicQueryFactory();
			dynamicQuery = fc.forClass( LessonImpl.class, "lesson", loader );
			dynamicQuery.add(PropertyFactoryUtil.forName("companyId").eq(companyId));
			dynamicQuery.setProjection( ProjectionFactoryUtil.distinct( ProjectionFactoryUtil.property("tag")));
			tags = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
		} catch (Exception e) {
			LOG.error( e.getMessage(), e );
		}

		return tags;
	}*/
	
	
	/*@SuppressWarnings("unchecked")
	public List<String> getSubCategoriesWithCompanyId() throws SystemException{
		List<String> tags = null;
		DynamicQuery dynamicQuery;
		try {
			ClassLoader loader = PortalClassLoaderUtil.getClassLoader();
			DynamicQueryFactory fc = DynamicQueryFactoryUtil.getDynamicQueryFactory();
			dynamicQuery = fc.forClass( LessonImpl.class, "lesson", loader );
			dynamicQuery.setProjection( ProjectionFactoryUtil.distinct( ProjectionFactoryUtil.property("companyId")));
			dynamicQuery.setProjection( ProjectionFactoryUtil.distinct( ProjectionFactoryUtil.property("subcategory")));
			tags = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
		} catch (Exception e) {
			LOG.error( e.getMessage(), e );
		}

		return tags;
	}*/
	
	
	/*public List<Lesson> getLessonsBySubCategoriesWithCompanyId(long companyId, String tag) throws SystemException{
		List<Lesson> lessons;

		try{
			lessons = LessonUtil.findBysubCategoriesWithCompanyId(companyId, tag);
		}catch(Exception e){
			throw new SystemException();
		}

		return lessons;
	}
	*/

	public List<Lesson> getLessonsByStatus(String status, int start, int end) {
		List<Lesson> lessons = null;

		try{
			lessons = lessonPersistence.findBylessons_status(status, start, end);
		}catch(SystemException e){
			LOG.error(e);
		}

		return lessons;
	}
	
	public List<Lesson> getLessonsByPrivacy(String lessonPrivacy, String orderBy, String orderByType, int start, int end) {
		List<Lesson> lessons = null;

		try{
			OrderByComparator comparator = OrderByComparatorFactoryUtil.create(LessonModelImpl.TABLE_NAME, orderBy, orderByType.equals("asc"));
			lessons = lessonPersistence.findBylessons_privacy(lessonPrivacy, start, end, comparator);
		}catch(SystemException e){
			LOG.error(e);
		}

		return lessons;
	}

	public List<Lesson> getLessonsByPrivacy(String[] lessonPrivacy, String orderBy, String orderByType, int start, int end) {
		List<Lesson> lessons = null;

		try{
			OrderByComparator comparator = OrderByComparatorFactoryUtil.create(LessonModelImpl.TABLE_NAME, orderBy, orderByType.equals("asc"));
			lessons = lessonPersistence.findBylessons_privacy(lessonPrivacy, start, end, comparator);
		}catch(SystemException e){
			LOG.error(e);
		}

		return lessons;
	}

	/*@Override
	public List<Lesson> getLessons(String tag) throws SystemException {
		return null;
	}



	@Override
	public List<Lesson> getLessonsBySubCategories(String tag)
			throws SystemException {
		return null;
	}*/



	/*@Override
	public List<Lesson> getLessonNameWithCompanyId(long companyId, String tag)
			throws SystemException {
		return null;
	}*/



	/*@Override
	public List<Lesson> getLessonsBySubCategoriesWithCompanyId(long companyId,
			String tag) throws SystemException {
		return null;
	}*/



	@Override
	public List<Lesson> getLessonsByCategoryId(long categoryId)
			throws SystemException {
		return null;
	}
	
	/*public List<Lesson> getLessonsByCategoryId(long categoryId) throws SystemException{
		List<Lesson> lessons;

		try{
			lessons = LessonUtil.findByCategory(categoryId);
		}catch(Exception e){
			throw new SystemException();
		}

		return lessons;
	}	*/
	
	@SuppressWarnings("unchecked")
	public void addUser(long userId,long lessionId,long groupId){
		List<AssetEntry> entries = null;
		DynamicQuery dynamicQuery = null;
		try {
			ClassLoader loader = PortalClassLoaderUtil.getClassLoader();
			DynamicQueryFactory fc = DynamicQueryFactoryUtil.getDynamicQueryFactory();
			dynamicQuery = fc.forClass(AssetEntry.class, "lesson", loader );
			dynamicQuery.add(PropertyFactoryUtil.forName("userId").eq(userId));
			dynamicQuery.add(PropertyFactoryUtil.forName("classPK").eq(lessionId));
		
			entries = assetEntryLocalService.dynamicQuery(dynamicQuery);
		} catch (Exception e) {
			LOG.error( e.getMessage(), e );
			if(Validator.isNull(entries)) return;
		}
		
		AssetEntry entry = null;
		if(entries.size()==0l){
		//	long classNameId = PortalUtil.getClassNameId(Lesson.class.getName());
			long entryId = 0l;
			try {
				entryId = counterLocalService.increment();
			} catch (SystemException e) {
				LOG.error(e);
				return;
			}

			entry = assetEntryPersistence.create(entryId);

			entry.setCompanyId(PortalUtil.getDefaultCompanyId());
			entry.setUserId(userId);
			entry.setCreateDate(new Date());
			
			entry.setClassPK(lessionId);
			entry.setVisible(true);
			entry.setGroupId(groupId);
			entry.setClassNameId(entryId);

		}else{
			entry = entries.get(0);
		}
		
		entry.setModifiedDate(new Date());
		try {
			assetEntryPersistence.update(entry);
		} catch (SystemException e) {
			LOG.error(e);
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<AssetEntry> getEntries(long lessonId){
		List<AssetEntry> entries = null;
		DynamicQuery dynamicQuery = null;
		try {
			ClassLoader loader = PortalClassLoaderUtil.getClassLoader();
			DynamicQueryFactory fc = DynamicQueryFactoryUtil.getDynamicQueryFactory();
			dynamicQuery = fc.forClass(AssetEntry.class, "lesson", loader );
			dynamicQuery.add(PropertyFactoryUtil.forName("classPK").eq(lessonId));
		
			entries = assetEntryLocalService.dynamicQuery(dynamicQuery);
		} catch (Exception e) {
			LOG.error( e.getMessage(), e );
		}
			
		return entries;
	}
	
	public String getTimeDifference(long diff){
		String timeDifference = StringPool.BLANK;
		
		long diffDays = diff / (24 * 60 * 60 * 1000);
		long diffHours = diff / (60 * 60 * 1000) % 24;
		long diffMinutes = diff / (60 * 1000) % 60;
		long diffSeconds = diff / 1000 % 60;
		
		if(diffDays>0){
			timeDifference = diffDays +" days ";
			
		}else if(diffHours > 0){
			timeDifference = diffHours+" hrs ";
			
		}else if(diffMinutes > 0){
			timeDifference = diffMinutes+" minutes ";
			
		}else if(diffSeconds > 0){
			timeDifference = diffSeconds +" seconds ";
		}
		
		return timeDifference+" ago";
	}
	
	/*public String getTimeDifference(long diff){
		String timeDifference = StringPool.BLANK;
		
		long diffDays = diff / (24 * 60 * 60 * 1000);
		if(diffDays>0){
			timeDifference = diffDays +" days ";
			diff = diff - diffDays*24 * 60 * 60 * 1000;
		}
		
		long diffHours = diff / (60 * 60 * 1000) % 24;
		if(diffDays == 0 && diffHours > 0){
			timeDifference = timeDifference + diffHours+" hrs ";
			diff = diff - diffHours* 60 * 60 * 1000;
		}
		
		long diffMinutes = diff / (60 * 1000) % 60;
		if(diffDays == 0 && diffHours == 0 && diffMinutes > 0){
			timeDifference = timeDifference + diffMinutes+" minutes ";
			diff = diff - diffMinutes*60 * 1000;
		}
		long diffSeconds = diff / 1000 % 60;
		if(diffDays == 0 && diffHours == 0 && diffMinutes == 0 && diffSeconds > 0){
			timeDifference = timeDifference + diffSeconds +" seconds ";
		}
		
		return timeDifference+" ago";
	}*/
	
	public List<Lesson> getLessonsUploadedByAuthor(long authorId) {
		List<Lesson> lessons = null;

		try{
			lessons = lessonPersistence.findBylessonsUploadedByAuthor(authorId);
		}catch(Exception e){}

		return lessons;
	}
	
	public List<Lesson> getLessonsUploadedByAuthorAndStatus(long authorId,String status) {
		List<Lesson> lessons = null;

		try{
			lessons = lessonPersistence.findBylessonsUploadedByAuthorAndStatus(authorId, status);
		}catch(Exception e){}

		return lessons;
	}
	
	@SuppressWarnings("unchecked")
	public List<Lesson> findUserAliveLessons(long userId) {
		List<Lesson> lessons = null;
		String[] markedAs ={Constant.MARKEDAS_RELEASE,StringPool.BLANK};
		try{
			DynamicQuery lessonTableQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
			lessonTableQuery.add(RestrictionsFactoryUtil.eq("currentAuthor",userId));
			lessonTableQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
			lessonTableQuery.add(PropertyFactoryUtil.forName(Constant.MARKED_AS).in(markedAs));
			lessons = (List<Lesson>)lessonLocalService.dynamicQuery(lessonTableQuery);
		}catch(Exception e){
			 LOG.error("[ERROR: LessonLocalServiceImpl : findUserAliveLessons() >Exception ] " + e);
			 lessons = new ArrayList<Lesson>();
		}
		return lessons;
	}
	
	@SuppressWarnings("unchecked")
	public List<Lesson> findGroupAliveLessons(long groupId) {
		List<Lesson> lessons = null;
		String[] markedAs ={Constant.MARKEDAS_RELEASE,StringPool.BLANK};
		try{
			List<Lesson_Usergroups> usergroupLessons = lesson_UsergroupsLocalService.getLesson_UserGroupId(groupId);
			List<Long> lessonIds = new ArrayList<Long>();
			for(Lesson_Usergroups usergroupLesson : usergroupLessons){
				lessonIds.add(usergroupLesson.getLessonId());
			}
			DynamicQuery lessonTableQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
			lessonTableQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_LESSON_ID).in(lessonIds));
			lessonTableQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH));
			lessonTableQuery.add(PropertyFactoryUtil.forName(Constant.MARKED_AS).in(markedAs));
			lessons = (List<Lesson>)lessonLocalService.dynamicQuery(lessonTableQuery);
		}catch(Exception e){
			 LOG.error("[ERROR: LessonLocalServiceImpl : findGroupAliveLessons() >Exception ] " + e);
			 lessons = new ArrayList<Lesson>();
		}
		return lessons;
	}
	
	public List<Lesson> getLessonsUploadedByAuthorAndStatus(long authorId,String status,long userId) {
		List<Lesson> lessons = new ArrayList<Lesson>();
		List<Lesson> checklessonPrivacy = null;
		 String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE, Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE};
		 //String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_DELETED_BY_USER,Constant.MARKEDAS_QUARANTINE};
		 Set<Long> userPrivateLessonIds =  LessonFinderUtil.findPrivateLessonsIdsBelongToUser(userId);
		 Set<Long> allPrivateLessonIds = LessonFinderUtil.findPrivateLessonsIds(lessonPrivacy);
		try{
			checklessonPrivacy = lessonPersistence.findBylessonsUploadedByAuthorAndStatus(authorId, status);
			for(Lesson lesson:checklessonPrivacy){
				if((!(lesson.getMarkedAs().equalsIgnoreCase(Constant.LESSON_DELETED_BY_USER))) && (!(lesson.getMarkedAs().equalsIgnoreCase(Constant.LESSON_FROM_DELETED_GROUP))) && (!(lesson.getMarkedAs().equalsIgnoreCase(Constant.MARKEDAS_QUARANTINE)))){
					 boolean privacyCheck = allPrivateLessonIds.contains(lesson.getLessonId())? userPrivateLessonIds.contains(lesson.getLessonId()) : true;
					 if(privacyCheck || authorId == userId){
						 lessons.add(lesson);
					 }
				}
			}
		}catch(Exception e){}

		return lessons;
	}
	
	public Lesson getLessonsUploadedByAuthor(long lessonId, long authorId) {
		Lesson lesson = null;

		try{
			lesson = lessonPersistence.findBylessonsUploadedByAuthorByLessonId(lessonId, authorId);
			
		}catch(NoSuchLessonException e){} 
		catch (SystemException e) {}
		return lesson;
	}
	
	public Map<Long, Long> findMostFollowedAuthors(){
		
		return LessonFinderUtil.findMostFollowedAuthors(); 
	}
	
	public Map<Long, Long> findFollowingAuthors(long userId1){
		
		return LessonFinderUtil.findFollowingAuthors(userId1); 
	}
	
	public Map<Long, Long> findLessonByType(long clasNameId, long lessonId, int type){
		
		return LessonFinderUtil.findLessonByType(clasNameId, lessonId, type); 
	}
	
	public Map<Long, Long> findRecentActivity(long clasNameId, long userId){
		
		return LessonFinderUtil.findRecentActivity(clasNameId, userId); 
	}
	
	public Map<Long, Long> findLessonActivity(long clasNameId, long classPK, long userId){
		
		return LessonFinderUtil.findLessonActivity(clasNameId, classPK, userId); 
	}
	
	public void findAndDeleteUserActivity(long userId, long clasPk, long createdDate, int type){
		if(type == NyuMemberActivityKeys.DELETE_LESSON)
			LessonFinderUtil.findAndDeleteUserActivity(userId, clasPk, createdDate, type);
		else
			LessonFinderUtil.findAndDeleteUserActivityByType(userId, clasPk, createdDate, type);
	}
	
	public void addSocialActivity(long userId, long groupId, String cls, long classPk, int type) throws PortalException, SystemException{
		socialActivityLocalService.addActivity(userId, groupId, cls, classPk,
				type, StringPool.BLANK, 0);
	}
	
	public void deleteUserSocialActivity(long activityId) throws PortalException, SystemException{
		socialActivityLocalService.deleteActivity(activityId);
	}
	
	public Set<Lesson> getLessonsByCategoryAndTags(String className, long classPK) throws SystemException, PortalException{
		
		 Set<Lesson> lessonsByCategoryTags = null;
		 
		 AssetEntryQuery entryQuery = null; 
		 List<AssetEntry> assetEntries = null;
		 
		 long categoryIds[] = assetEntryLocalService.getEntry(className, classPK).getCategoryIds();
		 List<AssetTag> assetTags = assetEntryLocalService.getEntry(className, classPK).getTags();
		 try {
			 if(categoryIds.length > 0){
				lessonsByCategoryTags = new LinkedHashSet<Lesson>();
			 	entryQuery = new AssetEntryQuery();
				entryQuery.setClassName(Lesson.class.getName());
				entryQuery.setAnyCategoryIds(categoryIds);
				assetEntries = assetEntryLocalService.getEntries(entryQuery);
				for(AssetEntry assetEntry:assetEntries){
				  try {
					  	if(assetEntry.getClassPK() != classPK){
					  		lessonsByCategoryTags.add(lessonLocalService.getLesson(assetEntry.getClassPK()));
					  	}
					  } catch (NoSuchLessonException e) {}
				}
			 }
			 
			 if(assetTags != null && assetTags.size() > 0){
				 if(lessonsByCategoryTags == null){
					 lessonsByCategoryTags = new LinkedHashSet<Lesson>();
				 }
				 long tagIds[] = new long[assetTags.size()];
				 for(int i=0; i < assetTags.size(); i++){
					 tagIds[i] = assetTags.get(i).getTagId();
				 }
			 	 entryQuery = new AssetEntryQuery();
				 entryQuery.setClassName(Lesson.class.getName());
				 entryQuery.setAnyTagIds(tagIds);
				 assetEntries = assetEntryLocalService.getEntries(entryQuery);
				 for(AssetEntry assetEntry:assetEntries){
					try {
						if(assetEntry.getClassPK() != classPK){
							lessonsByCategoryTags.add(lessonLocalService.getLesson(assetEntry.getClassPK()));
						}
					} catch (NoSuchLessonException e) {}
				 }	
			 }
			 
		 } catch (PortalException e) {
			 LOG.error("[ERROR: LessonLocalServiceImpl : getLessonsByCategoryAndTags() > PortalException ] " + e);
		 } catch (Exception e) {
			 LOG.error("[ERROR: LessonLocalServiceImpl : getLessonsByCategoryAndTags() > Exception ] " + e);
		 }
		 
		return lessonsByCategoryTags;
		
	}
	
	public Set<Lesson> getLessonsByCategoryAndTags(String className, long classPK,long userId) throws SystemException, PortalException{
		
		 Set<Lesson> lessonsByCategoryTags = null;
		 String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE, Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE};
		 Set<Long> userPrivateLessonIds =  LessonFinderUtil.findPrivateLessonsIdsBelongToUser(userId);
		 Set<Long> allPrivateLessonIds = LessonFinderUtil.findPrivateLessonsIds(lessonPrivacy);
		 
		 AssetEntryQuery entryQuery = null; 
		 List<AssetEntry> assetEntries = null;
		 
		 long categoryIds[] = assetEntryLocalService.getEntry(className, classPK).getCategoryIds();
		 List<AssetTag> assetTags = assetEntryLocalService.getEntry(className, classPK).getTags();
		 try {
			 if(categoryIds.length > 0){
				lessonsByCategoryTags = new LinkedHashSet<Lesson>();
			 	entryQuery = new AssetEntryQuery();
				entryQuery.setClassName(Lesson.class.getName());
				entryQuery.setAnyCategoryIds(categoryIds);
				assetEntries = assetEntryLocalService.getEntries(entryQuery);
				for(AssetEntry assetEntry:assetEntries){
				  try {
					  boolean privacyCheck = allPrivateLessonIds.contains(assetEntry.getClassPK())? userPrivateLessonIds.contains(assetEntry.getClassPK()) : true;
					  	if(assetEntry.getClassPK() != classPK && privacyCheck){
					  		lessonsByCategoryTags.add(lessonLocalService.getLesson(assetEntry.getClassPK()));
					  	}
					  } catch (NoSuchLessonException e) {}
				}
			 }
			 
			 if(assetTags != null && assetTags.size() > 0){
				 if(lessonsByCategoryTags == null){
					 lessonsByCategoryTags = new LinkedHashSet<Lesson>();
				 }
				 long tagIds[] = new long[assetTags.size()];
				 for(int i=0; i < assetTags.size(); i++){
					 tagIds[i] = assetTags.get(i).getTagId();
				 }
			 	 entryQuery = new AssetEntryQuery();
				 entryQuery.setClassName(Lesson.class.getName());
				 entryQuery.setAnyTagIds(tagIds);
				 assetEntries = assetEntryLocalService.getEntries(entryQuery);
				 for(AssetEntry assetEntry:assetEntries){
					 boolean privacyCheck = allPrivateLessonIds.contains(assetEntry.getClassPK())? userPrivateLessonIds.contains(assetEntry.getClassPK()) : true;
					try {
						if(assetEntry.getClassPK() != classPK && privacyCheck){
							lessonsByCategoryTags.add(lessonLocalService.getLesson(assetEntry.getClassPK()));
						}
					} catch (NoSuchLessonException e) {}
				 }	
			 }
			 
		 } catch (PortalException e) {
			 LOG.error("[ERROR: LessonLocalServiceImpl : getLessonsByCategoryAndTags() > PortalException ] " + e);
		 } catch (Exception e) {
			 LOG.error("[ERROR: LessonLocalServiceImpl : getLessonsByCategoryAndTags() > Exception ] " + e);
		 }
		 
		return lessonsByCategoryTags;
		
	}
	
	public void performCleanUp(long lessonId, String funType, long userId, int type, String[] unpublishDocIds){
		 LOG.info("[LessonLocalServiceImpl : performCleanUp() > START] ");
		try {
			
			deleteSocialActivity(userId, lessonId, type);
			if(type == NyuMemberActivityKeys.DELETE_LESSON){
				
				LessonFinderUtil.deleteCollaborationOfLesson(lessonId);
				LessonFinderUtil.deleteObjectivesOfLesson(lessonId);
				LessonFinderUtil.deleteFavouriteLesson(lessonId);
				LessonFinderUtil.deleteSectionOfLesson(lessonId);
				
				deleteAssetEntries(lessonId);
				lessonLocalService.deleteLesson(lessonId);
				long fileEntryId=deleteDocumentLibrary(lessonId);
				
				
				try{
					mbMessageLocalService.deleteDiscussionMessages(DLFileEntry.class.getName(),fileEntryId);
					List<MBMessage> mbMsgsDl = mbMessageLocalService.getMessages(DLFileEntry.class.getName(), fileEntryId, 0);
					if(mbMsgsDl!=null && mbMsgsDl.size()>0){
						for(MBMessage msg : mbMsgsDl){
							LOG.info("mb DL msg: "+msg.getMessageId());
							mbMessageLocalService.deleteMBMessage(msg);
						}
					}
					
					List<Lesson_Usergroups> lesson_groups=Lesson_UsergroupsLocalServiceUtil.getLesson_UserGroupLessonId(lessonId); 
					for(Lesson_Usergroups lesson_group:lesson_groups)
					{
						Lesson_UsergroupsLocalServiceUtil.deleteLesson_Usergroups(lesson_group);
					}
					
				}
				catch(Exception e)
				{
					LOG.info(e.getMessage());
				}
				mbMessageLocalService.deleteDiscussionMessages(Lesson.class.getName(), lessonId);
				List<MBMessage> mbMsgs = mbMessageLocalService.getMessages(Lesson.class.getName(), lessonId, 0);
				LOG.info("Msg Size: "+mbMsgs.size());
				if(mbMsgs!=null && mbMsgs.size()>0){
					for(MBMessage msg : mbMsgs){
						LOG.info("mb msg: "+msg.getMessageId());
						mbMessageLocalService.deleteMBMessage(msg);
					}
				}
			}
			
			if(type == NyuMemberActivityKeys.DELETE_LESSON || funType.equalsIgnoreCase("editLesson"))
				deleteDocuments(lessonId, unpublishDocIds);
			
		} catch (PortalException e) {
			 LOG.error("[ERROR: LessonLocalServiceImpl : performCleanUp() > PortalException ] " + e);
		} catch (SystemException e) {
			 LOG.error("[ERROR: LessonLocalServiceImpl : performCleanUp() > SystemException ] " + e);
		} catch (Exception e) {
			 LOG.error("[ERROR: LessonLocalServiceImpl : performCleanUp() > Exception ] " + e);
		}
		
	}
	
	private void deleteAssetEntries(long lessonId ){
		LOG.info("[LessonLocalServiceImpl : deleteAssetEntries() > START] ");
		
		List<AssetEntry> entries = LessonLocalServiceUtil.getEntries(lessonId);
		if(entries!=null){
			for(AssetEntry entry:entries){
				try {
					AssetEntryLocalServiceUtil.deleteAssetEntry(entry.getEntryId());
				} catch (PortalException e) {
					LOG.error("[ERROR: LessonLocalServiceImpl : deleteAssetEntries() > PortalException ] " + e);
				} catch (SystemException e) {
					LOG.error("[ERROR: LessonLocalServiceImpl : deleteAssetEntries() > SystemException ] " + e);
				}
			}
		}
	}	
	
	@SuppressWarnings("unchecked")
	private long deleteDocumentLibrary(long lessonId) {
		LOG.info("[LessonLocalServiceImpl : deleteDocumentLibrary()] > START ");
		long lessonClassNameId = ClassNameLocalServiceUtil.getClassNameId(Lesson.class);
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(DLFileEntry.class);
		dynamicQuery.add(RestrictionsFactoryUtil.eq("classNameId", lessonClassNameId));
		dynamicQuery.add(RestrictionsFactoryUtil.eq("classPK", lessonId));
		long fileEntryId=0l;
		List<DLFileEntry> dlFileEntries = null;
		try {
			dlFileEntries = DLFileEntryLocalServiceUtil.dynamicQuery(dynamicQuery);
		} catch (SystemException e) {
			LOG.error(e);
		}
		if(dlFileEntries!=null && dlFileEntries.size()>0){
			DLFileEntry dlFileEntry = dlFileEntries.get(0);
			try {
			 fileEntryId=dlFileEntry.getFileEntryId();
				DLFileEntryLocalServiceUtil.deleteDLFileEntry(dlFileEntry);
				return fileEntryId;
			} catch (SystemException e) {
				LOG.error("[ERROR: LessonLocalServiceImpl : deleteDocumentLibrary() > SystemException ] " + e);
				return fileEntryId;
			}
		}
		return fileEntryId;
	}
	
	private void deleteDocuments(long lessonId, String[] unpublishDocIds){
		LOG.info("[LessonLocalServiceImpl : deleteDocuments() > START] ");
		List<DocumentFile> documentFileList = null; 
		try {
				documentFileList = LessonLocalServiceUtil.getDocumentFileList(lessonId);
				
				if(unpublishDocIds!=null && unpublishDocIds.length>0){
					for(String docId : unpublishDocIds){
						DocumentFileLocalServiceUtil.deleteDocumentFile(Long.parseLong(docId));
					}
					/*List<String> rscIdList = Arrays.asList(unpublishRscIds); 
					for(DocumentFile df : documentFileList){
						if(rscIdList.contains(String.valueOf(df.getResourceId()))){
							LOG.info("[UNPUBLISH DOCUMENTS WHILE EDIT LESSON] [" + df.getResourceId() +"]");
							DocumentFileLocalServiceUtil.deleteDocumentFile(df);
						}
					}*/
				}else{
					for( DocumentFile documentFile : documentFileList ){
						DocumentFileLocalServiceUtil.deleteDocumentFile(documentFile.getDocumentId());
						LOG.info("[DELETE DOCUMENTS] [" + documentFile +"]");
					}
				}
				
		} catch (NumberFormatException e) {
			LOG.error("[ERROR: LessonLocalServiceImpl : deleteDocuments() > NumberFormatException ] " + e);
		} catch (PortalException e) {
			LOG.error("[ERROR: LessonLocalServiceImpl : deleteDocuments() > PortalException ] " + e);
		} catch (SystemException e) {
			LOG.error("[ERROR: LessonLocalServiceImpl : deleteDocuments() > SystemException ] " + e);
		}
	}
	
	private void deleteSocialActivity(long userId, long lessonId, int type){
		LOG.info("[LessonLocalServiceImpl: deleteSocialActivity() > START]");
		try {
			if(type == NyuMemberActivityKeys.DELETE_LESSON){
				Map<Long, Long> recentActivityMap = lessonLocalService.findLessonActivity(ClassNameLocalServiceUtil.getClassNameId(Lesson.class), lessonId,  userId);
				lessonLocalService.deleteUserSocialActivity(recentActivityMap.entrySet().iterator().next().getKey());// Delete all activities done on the lesson
				
				/** Cleaning other social activity entries **/
				socialActivityCounterLocalService.deleteActivityCounters(Lesson.class.getName(), lessonId);
				List<AssetEntry> entries = LessonLocalServiceUtil.getEntries(lessonId);
				if(entries!=null && entries.size() > 0){
					for(AssetEntry ae : entries){
						socialActivityLocalService.deleteActivities(ae);
						socialActivityCounterLocalService.deleteActivityCounters(ae);
					}
				}
				
			} else {
				Calendar cal = Calendar.getInstance();
				cal.add(Calendar.MONTH, -1);
				Date date = cal.getTime();
				long timeRange = date.getTime();
				lessonLocalService.findAndDeleteUserActivity(userId, lessonId, timeRange, type);// Delete 1 month old activity history of the user
			}
		} catch (PortalException e) {
			LOG.error("[LessonLocalServiceImpl: deleteSocialActivity() > PortalException] " + e);
		} catch (SystemException e) {
			LOG.error("[LessonLocalServiceImpl: deleteSocialActivity() >  SystemException] " + e);
		} catch (Exception e) {
			LOG.error("[LessonLocalServiceImpl: deleteSocialActivity() >  Exception] " + e);
		} 
	}

	public List<Lesson> findAssetLessons(String status,long userId, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetLessons(status,userId, privacy, orderBy,markedAs,start, end); 
	}
	
	public List<Lesson> findAssetFeaturedLessons(String status,long userId, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetFeaturedLessons(status,userId, privacy, orderBy,markedAs,start, end); 
	}
	
	public List<Lesson> findAssetLessonsByCategory(long categoryId, long userId,String status, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetLessonsByCategory(categoryId, userId,status, privacy, orderBy,markedAs ,start, end); 
	}
	
	public List<Lesson> findAssetLessonsByTag(long tagId,long userId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetLessonsByTag(tagId,userId, status, privacy, orderBy, markedAs ,start, end); 
	}
	
	public List<Lesson> findAssetFeaturedLessonsByTag(long tagId,long userId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetFeaturedLessonsByTag(tagId,userId, status, privacy, orderBy, markedAs ,start, end); 
	}
	
	public List<Lesson> findAssetFeaturedUserGroupLessonsByTag(long userGroupId, long tagId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetFeaturedUserGroupLessonsByTag(userGroupId, tagId, status, privacy, orderBy,markedAs, start, end); 
	}	
	
	public List<Lesson> findAssetUserGroupLessons(long userGroupId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetUserGroupLessons(userGroupId, status, privacy, orderBy,markedAs, start, end); 
	}
	
	public List<Lesson> findAssetUserGroupLessonsByCategory(long userGroupId, long categoryId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetUserGroupLessonsByCategory(userGroupId, categoryId, status, privacy, orderBy, markedAs, start, end); 
	}
	
	public List<Lesson> findAssetUserGroupLessonsByTag(long userGroupId, long tagId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetUserGroupLessonsByTag(userGroupId, tagId, status, privacy, orderBy,markedAs, start, end); 
	}	
	
	public List<Lesson> findFeaturedUserGroupLessons(long userGroupId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end){
			
			return LessonFinderUtil.findFeaturedUserGroupLessons(userGroupId, status, privacy, orderBy,markedAs, start, end); 
		}
	public List<Lesson> findAssetLessonsByCategoryAndUser(long categoryId, long userId,String status, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetLessonsByCategoryAndUser(categoryId,userId, status, privacy, orderBy,markedAs, start, end); 
	}
	
	public List<Lesson> findAssetLessonsByTagAndUser(long tagId,long userId, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetLessonsByTagAndUser(tagId,userId, status, privacy, orderBy,markedAs, start, end); 
	}
	
	public List<Lesson> findAssetLessonsByCategoryAndFeatured(long categoryId, boolean featured,String status, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetLessonsByCategoryAndFeatured(categoryId,featured, status, privacy, orderBy,markedAs, start, end); 
	}
	
	public List<Lesson> findAssetLessonsByTagAndFeatured(long tagId,boolean featured, String status, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findAssetLessonsByTagAndFeatured(tagId,featured, status, privacy, orderBy,markedAs, start, end); 
	}

	public List<Lesson> findMyFavouriteLessons(long userId, String status, String orderBy,String[] markedAs, int start, int end){
			
			return LessonFinderUtil.findMyFavouriteLessons(userId, status, orderBy, markedAs, start, end);
		}
	
	public List<Lesson> findMyLessonsWithCollaborations(long userId, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findMyLessonsWithCollaborations(userId, orderBy, markedAs, start, end); 
	}
	
	public void deleteObjectivesOfLesson(long lessonId){
		LessonFinderUtil.deleteObjectivesOfLesson(lessonId);
		
	}
	
	@SuppressWarnings("unchecked")
	public Boolean getFavouriteLesson(long userId,long lessonId){
		
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(FavouriteLessons.class);
		dynamicQuery.add(PropertyFactoryUtil.forName("primaryKey.userId").eq(userId));
		dynamicQuery.add(PropertyFactoryUtil.forName("primaryKey.lessonId").eq(lessonId));
		List<FavouriteLessons> favouriteLesson=null;
		try {
			favouriteLesson = FavouriteLessonsLocalServiceUtil.dynamicQuery(dynamicQuery);
			if(favouriteLesson.isEmpty()){
				return true;
			}else{
				return false;
			}
			
		} catch (SystemException e) {
			LOG.error(e);
		}
		return null;
	}
	
	public List<Lesson> getFavouriteLessonsByUserId(long userId){
		List<FavouriteLessons> favouriteLessons=null;
		List<Lesson> myFavouriteLessons=new ArrayList<Lesson>();
		try {
			favouriteLessons=favouriteLessonsPersistence.findByfavouriteLessonsByUserId(userId);
			if(!favouriteLessons.isEmpty()){
			for(FavouriteLessons favouriteLesson:favouriteLessons){
				Lesson lesson=LessonLocalServiceUtil.getLesson(favouriteLesson.getLessonId());
				myFavouriteLessons.add(lesson);
			}
			return myFavouriteLessons;
			}
		} catch (SystemException e) {
			LOG.error(e);
		} catch (PortalException e) {
			LOG.error(e);
		}
		return myFavouriteLessons;
	
	}
	
	public List<Lesson> findLessonsWithCollaborations(String status,long userId, String[] privacy, String orderBy,String[] markedAs, int start, int end){
		
		return LessonFinderUtil.findLessonsWithCollaborations(status,userId, privacy, orderBy,markedAs, start, end); 
	}
	
	public Set<Long> findPrivateLessonsIdsBelongToUser(long userId){
		return LessonFinderUtil.findPrivateLessonsIdsBelongToUser(userId) ;
	}
	
	public Set<Long> findPrivateLessonsIds(String[] status){
		return LessonFinderUtil.findPrivateLessonsIds(status) ;
	}
	public List<Lesson> getLessonsMarkedAs(String markedAs,int start,int end){
		List<Lesson> lessons=null;
		 try {
			lessons=lessonPersistence.findByLessonsMarkedAs(markedAs, start, end);
		} catch (SystemException e) {
			LOG.error(e);
		}
		return lessons;
		
	}
	public List<Lesson> findArchivedMarkedAsLessonsByTag(long tagId,String markedAs, int start, int end){
		return LessonFinderUtil.findAssetMarkedAsLessonsByTag(tagId, markedAs, start, end);
	}
	public List<Lesson> findArchivedMarkedAsLessonsByCategory(long categoryId,String markedAs, int start, int end){
		return LessonFinderUtil.findAssetMarkedAsLessonsByCategory(categoryId, markedAs, start, end);
	}
}
package com.nyu.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.portlet.PortletRequest;
import javax.portlet.PortletSession;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.asset.model.AssetEntry;
import com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil;
import com.liferay.portlet.asset.service.persistence.AssetEntryQuery;
import com.liferay.util.portlet.PortletProps;
import com.nyu.model.Lesson;
import com.nyu.model.RequestLesson;
import com.nyu.portlet.lessons.LessonsController;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.RequestLessonLocalServiceUtil;

public class SortLessonUtil {
	
	public static List<Lesson> getLessonsByItem(long categoryId,long userId, long tagId, String filterType, int start, int end) {
		List<Lesson> lessons=null;
		String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP,Constant.MARKEDAS_QUARANTINE};
			
			if(filterType.equalsIgnoreCase("viewCount")) {
				String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
				String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
				
				if(Validator.isNotNull(categoryId)){
					lessons = LessonLocalServiceUtil.findAssetLessonsByCategory(categoryId,userId,
							status, lessonPrivacy, filterType, markedAs ,start, end);
				}
				else if(Validator.isNotNull(tagId)){
					lessons = LessonLocalServiceUtil.findAssetLessonsByTag(tagId,userId,
							status, lessonPrivacy, filterType, markedAs ,start, end);	
				}
				else{
					lessons = LessonLocalServiceUtil.findAssetLessons(status,userId,lessonPrivacy, filterType, markedAs , start, end);
					
				}
			}
			
			if(filterType.equalsIgnoreCase("appreciateCount")) {
				
				String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
				String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
				if(Validator.isNotNull(categoryId)){
					lessons = LessonLocalServiceUtil.findAssetLessonsByCategory(categoryId,userId,
							status, lessonPrivacy, filterType, markedAs , start, end);
				}
				else if(Validator.isNotNull(tagId)){
					lessons = LessonLocalServiceUtil.findAssetLessonsByTag(tagId,userId,
							status, lessonPrivacy, filterType, markedAs , start, end);	
				}
				else{
					lessons=LessonLocalServiceUtil.findLessonsWithCollaborations("published",userId,lessonPrivacy,  filterType,  markedAs , start, end);
					
				}
			}
			
			if(filterType.equalsIgnoreCase("mostRecent")) {
				
				String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR, Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC};
				
				String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
				if(Validator.isNotNull(categoryId)){
					lessons = LessonLocalServiceUtil.findAssetLessonsByCategory(categoryId,userId, 
							status, lessonPrivacy, "uploadedTime", markedAs , start, end);	
				}
				else if(Validator.isNotNull(tagId)){
					lessons = LessonLocalServiceUtil.findAssetLessonsByTag(tagId,userId,
							status, lessonPrivacy, "uploadedTime", markedAs , start, end);	
				}
				else{
					lessons = LessonLocalServiceUtil.findLessonsWithCollaborations("published",userId,lessonPrivacy,  "uploadedTime", markedAs ,  start, end);
					
				}
			}
		
		return lessons;
	}
	
public static List<Lesson> getUserGroupLessonsByItem(long userGroupId,long categoryId, long tagId, String filterType, int start, int end) {
		
		List<Lesson> lessons=null;
		String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP,Constant.MARKEDAS_QUARANTINE};
			
			if(filterType.equalsIgnoreCase("viewCount")) {
				String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE};
				String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
				
				if(Validator.isNotNull(categoryId)){
					lessons = LessonLocalServiceUtil.findAssetUserGroupLessonsByCategory(userGroupId,categoryId, 
							status, lessonPrivacy, filterType, markedAs,start, end);
				}
				else if(Validator.isNotNull(tagId)){
					lessons = LessonLocalServiceUtil.findAssetUserGroupLessonsByTag(userGroupId, tagId, 
							status, lessonPrivacy, filterType, markedAs, start, end);	
				}
				else{
					lessons = LessonLocalServiceUtil.findAssetUserGroupLessons(userGroupId, status, lessonPrivacy, filterType,markedAs, start, end);
					
				}
			}
			
			if(filterType.equalsIgnoreCase("appreciateCount")) {
				
				String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE};
				String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
				if(Validator.isNotNull(categoryId)){
					lessons = LessonLocalServiceUtil.findAssetUserGroupLessonsByCategory(userGroupId,categoryId, 
							status, lessonPrivacy, filterType,markedAs, start, end);
				}
				else if(Validator.isNotNull(tagId)){
					lessons = LessonLocalServiceUtil.findAssetUserGroupLessonsByTag(userGroupId, tagId, 
							status, lessonPrivacy, filterType,markedAs, start, end);	
				}
				else{
					lessons = LessonLocalServiceUtil.findAssetUserGroupLessons(userGroupId, status, lessonPrivacy, filterType,markedAs, start, end);
					
				}
			}
			
			if(filterType.equalsIgnoreCase("mostRecent")) {
				
				String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE};
				String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
				if(Validator.isNotNull(categoryId)){
					lessons = LessonLocalServiceUtil.findAssetUserGroupLessonsByCategory(userGroupId,categoryId, 
							status, lessonPrivacy, "uploadedTime", markedAs,start, end);
				}
				else if(Validator.isNotNull(tagId)){
					lessons = LessonLocalServiceUtil.findAssetUserGroupLessonsByTag(userGroupId, tagId, 
							status, lessonPrivacy, "uploadedTime",markedAs, start, end);	
				}
				else{
					lessons = LessonLocalServiceUtil.findAssetUserGroupLessons(userGroupId, status, lessonPrivacy, "uploadedTime", markedAs,start, end);
					
				}
			}
		
		return lessons;
	}
	public static List<Lesson> getFeaturedUserGroupLessons(long userGroupId, int start, int end) {
		List<Lesson> lessons=null;
		String[] lessonPrivacy = {Constant.LIFERAY_VENDOR_LESSON_PRIVACY_VENDOR,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PUBLIC,Constant.LIFERAY_VENDOR_LESSON_PRIVACY_PRIVATE};
		String[] markedAs ={Constant.LESSON_DELETED_BY_USER,Constant.LESSON_FROM_DELETED_GROUP,Constant.MARKEDAS_QUARANTINE};
		String status =Constant.LIFERAY_VENDOR_LESSON_STATUS_PUBLISH;
		lessons = LessonLocalServiceUtil.findFeaturedUserGroupLessons(userGroupId, status, lessonPrivacy, "uploadedTime", markedAs,start, end);
		return lessons;
	}
	public static List<Lesson> getArchivedLessonsMarkedAs(long categoryId,long tagId,String markedAs, int start, int end) {
		List<Lesson> lessons=null;
		if(Validator.isNotNull(categoryId)){
			
			lessons = LessonLocalServiceUtil.findArchivedMarkedAsLessonsByCategory(categoryId,markedAs,start,end);
		}
		else if(Validator.isNotNull(tagId)){
			lessons = LessonLocalServiceUtil.findArchivedMarkedAsLessonsByTag(tagId,markedAs,start,end);
		}
		else{
			lessons = LessonLocalServiceUtil.getLessonsMarkedAs(markedAs,start,end);
			
		}
		
		return lessons;
	}
/*	private static List<Lesson> authorLessons(long authorId,List<Lesson> lessons){
		List<Lesson> authorLessons=new ArrayList<Lesson>();
		
		for(Lesson lesson:lessons) {
			
			if(Validator.equals(lesson.getAuthor(), authorId)) 
				authorLessons.add(lesson);
		}
		
		return authorLessons;
	}*/
	
	private static List<Lesson> getSortedLessonsByAppreciateCount(List<Lesson> lessons) {
		
		List<Lesson> sortedLessons=new ArrayList<Lesson>();
		sortedLessons.addAll(lessons);
		if(sortedLessons.size()>0)
		Collections.sort(sortedLessons,new LessonSortByAppreciates());
		Collections.reverse(sortedLessons);
		return sortedLessons;
	}
	
/*	private static List<Lesson> getLessonsByAuthor(PortletRequest request,long categoryId) {
		
		List<Lesson> sortedlessons=new ArrayList<Lesson>();
		AssetEntryQuery entryQuery=null;
		List<AssetEntry> assetEntries=null;
		List<Lesson> lessons=null;
		try {
			
			lessons=LessonLocalServiceUtil.getLessons(PortletProps.get("liferay.nyu.lesson.status.publish"), -1, -1);
			if(Validator.isNotNull(categoryId)){
				entryQuery=new AssetEntryQuery();
				entryQuery.setClassName(Lesson.class.getName());
				entryQuery.setAnyCategoryIds(new long[]{categoryId});
				assetEntries = AssetEntryLocalServiceUtil.getEntries(entryQuery);
				lessons=null;
				lessons=new ArrayList<Lesson>();
	
				for(AssetEntry assetEntry:assetEntries) 
			          lessons.add(LessonLocalServiceUtil.getLesson(assetEntry.getClassPK()));
		
			}		
			sortedlessons.addAll(lessons);
			Collections.sort(sortedlessons,new LessonSortByusers());
			
		} catch (SystemException e) {
			e.printStackTrace();
		} catch (PortalException e) {
			e.printStackTrace();
		} 
	
		return sortedlessons;
	}*/
	
	public static List<RequestLesson> getRequestLessonsByItem(long categoryId,String sortByItem,PortletRequest request,String order) {
		
		List<RequestLesson> requestLesson=null;
		List<AssetEntry> assetEntries=null;
		AssetEntryQuery entryQuery=null;
		PortletSession session=request.getPortletSession();
		long authorId=0l;
		if(Validator.isNotNull(session.getAttribute("authorId"))) {
			authorId=(Long) session.getAttribute("authorId");
		}

			
			if(sortByItem.equalsIgnoreCase("appreciatedCount")) {
				
				if(Validator.isNull(categoryId)) {
					try {
						requestLesson=RequestLessonLocalServiceUtil.getRequestLessons(PortalUtil.getCompanyId(request));
					} catch (SystemException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				} else {
					entryQuery=new AssetEntryQuery();
					entryQuery.setClassName(RequestLesson.class.getName());
					entryQuery.setAnyCategoryIds(new long[]{categoryId});
					requestLesson=new ArrayList<RequestLesson>();
					try {
						assetEntries = AssetEntryLocalServiceUtil.getEntries(entryQuery);
					} catch (SystemException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
					
					for(AssetEntry assetEntry:assetEntries){
						try {
							requestLesson.add(RequestLessonLocalServiceUtil.getRequestLesson(assetEntry.getClassPK()));
						} catch (PortalException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (SystemException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					
					entryQuery=null;
				}
				
				requestLesson=getSortedRequestLesson(requestLesson);	
			}
			
/*			if(Validator.isNotNull(authorId)){
				lessons=authorLessons(authorId,lessons);
			}*/
		
		return requestLesson;
	}
	
private static List<RequestLesson> getSortedRequestLesson(List<RequestLesson> requestlessons) {
		List<RequestLesson> sortedLessons=new ArrayList<RequestLesson>();
		sortedLessons.addAll(requestlessons);
		if(sortedLessons.size()>0)
		Collections.sort(sortedLessons,new RequestLessonsSortByAppreciates());
		Collections.reverse(sortedLessons);
		
		return sortedLessons;
	}
	
}
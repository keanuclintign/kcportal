package com.nyu.search.indexer;

import java.util.List;
import java.util.Locale;

import javax.portlet.PortletURL;

import com.liferay.portal.kernel.dao.orm.ActionableDynamicQuery;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.search.BaseIndexer;
import com.liferay.portal.kernel.search.Document;
import com.liferay.portal.kernel.search.Field;
import com.liferay.portal.kernel.search.SearchContext;
import com.liferay.portal.kernel.search.SearchEngineUtil;
import com.liferay.portal.kernel.search.Summary;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.model.UserGroup;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.nyu.model.Lesson;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.service.Lesson_UsergroupsLocalServiceUtil;
import com.nyu.service.persistence.LessonActionableDynamicQuery;
import com.nyu.util.Constant;

public class LessonIndexer extends BaseIndexer{
	
	private static org.apache.log4j.Logger _log = org.apache.log4j.Logger.getLogger(LessonIndexer.class);

	public static final String[] CLASS_NAMES = {Lesson.class.getName()};

	public static final String PORTLET_ID = Constant.PORTLET_LESSON;

/*	public LessonIndexer() {
		setPermissionAware(true);
	}*/
	
	@Override
	public String[] getClassNames() {
		return CLASS_NAMES;
	}

	@Override
	public String getPortletId() {
		return PORTLET_ID;
	}

	@Override
	protected void doDelete(Object obj) throws Exception {
		Lesson entry = (Lesson)obj;
		deleteDocument(entry.getCompanyId(), entry.getLessonId());
	}

	@Override
	protected Document doGetDocument(Object obj) throws Exception {
		Lesson entry = (Lesson)obj;
		_log.info("doGetDocument....");
		Document document = getBaseModelDocument(PORTLET_ID, entry);
		
		//_log.info("document:"+document);
		document.addKeyword(Field.ENTRY_CLASS_PK, entry.getLessonId());
		document.addKeyword(Field.PORTLET_ID, getPortletId());
		document.addKeyword(Field.COMPANY_ID, entry.getCompanyId());
		
		document.addText(Field.ENTRY_CLASS_PK, entry.getLessonId()+StringPool.BLANK);
		
		document.addKeyword(Field.STATUS, entry.getStatus());
		
		document.addKeyword(Field.TITLE, entry.getLessonName());
		document.addText(Field.TITLE, entry.getLessonName());
		
		document.addKeyword(Field.USER_NAME,UserLocalServiceUtil.getUser(entry.getAuthor()).getFullName());
		document.addText(Field.USER_NAME,UserLocalServiceUtil.getUser(entry.getAuthor()).getFullName());
		
		document.addKeyword(Field.DESCRIPTION, entry.getDescription());
		document.addText(Field.DESCRIPTION, entry.getDescription());
		String lessonGroups = Constant.COMMON_NONE;
		List<UserGroup> userGroupList = Lesson_UsergroupsLocalServiceUtil.getGroupsByLessonId(GetterUtil.getLong(document.get(Field.ENTRY_CLASS_PK)));
		   for(UserGroup userGroup:userGroupList){
			   if(lessonGroups.equals(Constant.COMMON_NONE)){
				   lessonGroups = userGroup.getName();
			   }else{
				   lessonGroups =lessonGroups+","+userGroup.getName();
			   }
		   }
		document.addKeyword(Field.CONTENT,lessonGroups);
		//_log.info("document:"+document);
		return document;
	}

	@Override
	protected Summary doGetSummary(Document document, Locale locale,
			String snippet, PortletURL portletURL) throws Exception {
		_log.info("doGetSummary....");
		String lessonId = document.get(Field.ENTRY_CLASS_PK);
		portletURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION, Constant.COMMON_SHOW_DOCUMENT);
		portletURL.setParameter(Constant.COMMON_STRING_CONSTANT_LESSON_ID, lessonId);

		Summary summary = createSummary(document, Field.TITLE, Field.URL);

		summary.setPortletURL(portletURL);
		//_log.info("doGetSummary:portletURL==>"+portletURL);	
		return summary;
	}

	@Override
	protected void doReindex(Object obj) throws Exception {
		_log.info("doReindex obj....");
		Lesson entry = (Lesson)obj;

		Document document = getDocument(entry);

		SearchEngineUtil.updateDocument(
			getSearchEngineId(), entry.getCompanyId(), document);
	}

	@Override
	protected void doReindex(String className, long classPK) throws Exception {
		_log.info("doReindex classpk....");
		Lesson entry = LessonLocalServiceUtil.getLesson(classPK);

		doReindex(entry);
	}

	@Override
	protected void doReindex(String[] ids) throws Exception {
		_log.info("doReindex all....");
		long companyId = GetterUtil.getLong(ids[0]);
		
/*		List<Lesson> lessons = LessonLocalServiceUtil.getLessons(0, LessonLocalServiceUtil.getLessonsCount());
		if(lessons.isEmpty()){
			return;
		}
		Collection<Document> documents = new ArrayList<Document>();
		for(Lesson lesson: lessons){
			Document document = getDocument(lesson);
			documents.add(document);
		}
		SearchEngineUtil.updateDocuments(getSearchEngineId(), companyId, documents);
*/
		ActionableDynamicQuery actionableDynamicQuery =
				new LessonActionableDynamicQuery() {
					
					@Override
					protected void performAction(Object object) throws PortalException,
							SystemException {
						Lesson lesson = (Lesson)object;
						Document document = getDocument(lesson);
						addDocument(document);
					}
				};

			actionableDynamicQuery.setCompanyId(companyId);
			actionableDynamicQuery.setSearchEngineId(getSearchEngineId());

			actionableDynamicQuery.performActions();		
	}

	@Override
	protected String getPortletId(SearchContext searchContext) {
		return PORTLET_ID;
	}
	

}

package com.nyu.search.indexer;

import java.util.Locale;

import javax.portlet.PortletURL;
import javax.portlet.WindowState;

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
import com.liferay.portal.service.UserLocalServiceUtil;
import com.nyu.model.RequestLesson;
import com.nyu.service.RequestLessonLocalServiceUtil;
import com.nyu.service.persistence.RequestLessonActionableDynamicQuery;
import com.nyu.util.Constant;

public class RequestLessonIndexer extends BaseIndexer{
	
	private static org.apache.log4j.Logger _log = org.apache.log4j.Logger.getLogger(RequestLessonIndexer.class);

	public static final String[] CLASS_NAMES = {RequestLesson.class.getName()};

	public static final String PORTLET_ID = Constant.PORTLET_REQUEST_LESSON;

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
		RequestLesson entry = (RequestLesson)obj;
		deleteDocument(entry.getCompanyId(), entry.getRequestLessonId());
	}

	@Override
	protected Document doGetDocument(Object obj) throws Exception {
		RequestLesson entry = (RequestLesson)obj;
		String userName = UserLocalServiceUtil.getUser(entry.getCreatedBy()).getFullName();
		_log.info("doGetDocument....");
		Document document = getBaseModelDocument(PORTLET_ID, entry);
		_log.info("document:"+document);
		document.addKeyword(Field.ENTRY_CLASS_PK, entry.getRequestLessonId());
		document.addKeyword(Field.PORTLET_ID, getPortletId());
		document.addKeyword(Field.COMPANY_ID, entry.getCompanyId());
		//document.addKeyword(Field.GROUP_ID, entry.getGroupId());
		document.addText(Field.ENTRY_CLASS_PK, entry.getRequestLessonId()+"");
		
		document.addText(Field.DESCRIPTION, entry.getDescription());
		//document.addKeyword(Field.FOLDER_ID, entry.getFolderId());
		document.addKeyword(Field.TITLE, entry.getName());
		document.addKeyword(Field.DESCRIPTION, entry.getDescription());
		document.addText(Field.TITLE, entry.getName());
		
		document.addKeyword(Field.USER_NAME,userName);
		document.addText(Field.USER_NAME,userName);
		//document.addText(Constant.AUTHOR, entry.getAuthor());
		/*document.addKeyword(
			Field.TREE_PATH,
			StringUtil.split(entry.getTreePath(), CharPool.SLASH));
		document.addText(Field.URL, entry.getUrl());*/
		_log.info("document:"+document);
		return document;
	}

	@Override
	protected Summary doGetSummary(Document document, Locale locale,
			String snippet, PortletURL portletURL) throws Exception {
		_log.info("doGetSummary....");
		String requestLessonId = document.get(Field.ENTRY_CLASS_PK);
		
		Summary summary = createSummary(document, Field.TITLE, Field.URL);
		portletURL.setParameter(Constant.COMMON_STRING_CONSTANT_ACTION,Constant.REQUEST_DETAILS);
		portletURL.setParameter(Constant.COMMON_STRING_CONSTANT_REQUEST_LESSON_ID, requestLessonId);
		portletURL.setWindowState(WindowState.MAXIMIZED);
		summary.setPortletURL(portletURL);
		_log.info("doGetSummary:portletURL==>"+portletURL);	
		
		
		return summary;
	}

	@Override
	protected void doReindex(Object obj) throws Exception {
		_log.info("doReindex obj....");
		RequestLesson entry = (RequestLesson)obj;

		Document document = getDocument(entry);

		SearchEngineUtil.updateDocument(
			getSearchEngineId(), entry.getCompanyId(), document);
	}

	@Override
	protected void doReindex(String className, long classPK) throws Exception {
		_log.info("doReindex classpk....");
		RequestLesson entry = RequestLessonLocalServiceUtil.getRequestLesson(classPK);

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
				new RequestLessonActionableDynamicQuery() {
									
					@Override
					protected void performAction(Object object) throws PortalException,
							SystemException {
						RequestLesson lesson = (RequestLesson)object;
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

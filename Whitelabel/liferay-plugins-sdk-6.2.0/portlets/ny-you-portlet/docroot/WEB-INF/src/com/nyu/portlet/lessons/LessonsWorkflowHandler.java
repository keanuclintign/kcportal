package com.nyu.portlet.lessons;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.workflow.BaseWorkflowHandler;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil;
import com.nyu.model.Lesson;
import com.nyu.service.LessonLocalServiceUtil;

import java.io.Serializable;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

public class LessonsWorkflowHandler extends BaseWorkflowHandler{

	@Override
	public String getClassName() {
		return _CLASSNAME;
	}

	@Override
	public String getType(Locale locale) {
		return _LESSON;
	}

	@Override
	public Object updateStatus(int status, Map<String, Serializable> workflowContext)
			throws PortalException, SystemException {
		
		long userId = GetterUtil.getLong(workflowContext.get(WorkflowConstants.CONTEXT_USER_ID));
		long resourcePrimKey = GetterUtil.getLong(workflowContext.get(WorkflowConstants.CONTEXT_ENTRY_CLASS_PK));
		Lesson lesson = LessonLocalServiceUtil.getLesson(resourcePrimKey);
		lesson.setLessonStatus(status);
		lesson.setStatusByUserId(userId);
		lesson.setStatusDate(new Date());
		lesson = LessonLocalServiceUtil.updateLesson(lesson);
		
		if(status == WorkflowConstants.STATUS_APPROVED){
			AssetEntryLocalServiceUtil.updateVisible(Lesson.class.getName(), resourcePrimKey, true);
		}else{
			AssetEntryLocalServiceUtil.updateVisible(Lesson.class.getName(), resourcePrimKey, false);
		}
		
		return lesson;
	}
	
	
	private static final String _CLASSNAME = Lesson.class.getName();
	private static final String _LESSON = "Lesson";
}

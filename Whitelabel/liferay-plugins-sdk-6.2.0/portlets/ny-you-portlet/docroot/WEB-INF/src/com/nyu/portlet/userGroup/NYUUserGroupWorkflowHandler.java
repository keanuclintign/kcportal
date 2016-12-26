package com.nyu.portlet.userGroup;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.workflow.BaseWorkflowHandler;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil;
import com.nyu.model.NYUUserGroup;
import com.nyu.service.NYUUserGroupLocalServiceUtil;

import java.io.Serializable;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

public class NYUUserGroupWorkflowHandler extends BaseWorkflowHandler{

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
		NYUUserGroup userGroup = NYUUserGroupLocalServiceUtil.getNYUUserGroup(resourcePrimKey);
		userGroup.setStatus(status);
		userGroup.setStatusByUserId(userId);
		userGroup.setStatusDate(new Date());
		userGroup = NYUUserGroupLocalServiceUtil.updateNYUUserGroup(userGroup);
		
		if(status == WorkflowConstants.STATUS_APPROVED){
			AssetEntryLocalServiceUtil.updateVisible(NYUUserGroup.class.getName(), resourcePrimKey, true);
		}else{
			AssetEntryLocalServiceUtil.updateVisible(NYUUserGroup.class.getName(), resourcePrimKey, false);
		}
		
		return userGroup;
	}
	
	
	private static final String _CLASSNAME = NYUUserGroup.class.getName();
	private static final String _LESSON = "NYUUserGroup";
}

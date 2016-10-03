package com.nyu.util;

import java.util.Date;

import javax.portlet.PortletRequest;
import javax.servlet.http.HttpServletRequest;

import org.apache.http.HttpRequest;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.model.User;
import com.liferay.portal.util.PortalUtil;
import com.nyu.model.AuditReport;
import com.nyu.service.AuditReportLocalServiceUtil;

public class AuditNyuUtil {

	
	public static AuditReport createReport(HttpServletRequest request,String eventType,String classPK,String className,String addInfo) throws PortalException, SystemException
	{
		long companyId = PortalUtil.getCompanyId(request);
		User user = PortalUtil.getUser(request);
		String ipAddress =request.getHeader("X-FORWARDED-FOR");  
		   if (ipAddress == null) {  
			   ipAddress =request.getRemoteAddr();  
		   }
		
		AuditReport auditReport= AuditReportLocalServiceUtil.createAuditReport((CounterLocalServiceUtil.increment(AuditReport.class.getName())));
		
		auditReport.setCompanyId(companyId);
		auditReport.setGroupId(companyId);
		auditReport.setUserId(user.getUserId());
		auditReport.setUserName(user.getFullName());
		auditReport.setCreateDate(new Date());
		auditReport.setClassName(className);
		auditReport.setClassPK(classPK);
		auditReport.setClientIP(ipAddress);
		auditReport.setClientHost(ipAddress);
		auditReport.setEventType(eventType);
		auditReport.setServerName(PortalUtil.getHost(request));
		auditReport.setAdditionalInfo(addInfo);
		
		
		return auditReport;
	}
}

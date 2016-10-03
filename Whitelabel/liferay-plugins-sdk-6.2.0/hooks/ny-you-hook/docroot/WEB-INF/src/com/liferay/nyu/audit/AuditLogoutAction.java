package com.liferay.nyu.audit;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.events.Action;
import com.liferay.portal.kernel.events.ActionException;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.model.User;
import com.liferay.portal.util.PortalUtil;
import com.nyu.model.AuditReport;
import com.nyu.service.AuditReportLocalServiceUtil;


public class AuditLogoutAction extends Action
{
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(AuditLogoutAction.class);

	@Override
	public void run(final HttpServletRequest request, final HttpServletResponse response)
			throws ActionException
			{
				try
				{
					boolean fromTou = ParamUtil.getBoolean(request,"fromTou",false);
					if(fromTou){
						User user = PortalUtil.getUser(request);
						user.getExpandoBridge().setAttribute("agree-date", new Date());
					}
					doRun(request, response);
					
				} catch (Exception e)
				{
					LOG.error(""+e.getMessage());
				}
			}

	protected void doRun(final HttpServletRequest request, final HttpServletResponse response)
			throws SystemException, PortalException
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
			auditReport.setClassName("User");
			auditReport.setClassPK(user.getUserId()+"");
			auditReport.setClientIP(ipAddress);
			auditReport.setClientHost(ipAddress);
			auditReport.setEventType("LOGOUT");
			auditReport.setServerName(PortalUtil.getHost(request));
			auditReport.setAdditionalInfo("none");
			AuditReportLocalServiceUtil.addAuditReport(auditReport);
			
			
			}

}
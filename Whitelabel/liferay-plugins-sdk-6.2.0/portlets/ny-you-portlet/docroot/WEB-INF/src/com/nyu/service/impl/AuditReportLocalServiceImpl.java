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

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.OrderFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.GetterUtil;
import com.nyu.model.AuditReport;
import com.nyu.portlet.audit.Audit;
import com.nyu.service.AuditReportLocalServiceUtil;
import com.nyu.service.base.AuditReportLocalServiceBaseImpl;

/**
 * The implementation of the audit report local service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the {@link com.nyu.service.AuditReportLocalService} interface.
 *
 * <p>
 * This is a local service. Methods of this service will not have security checks based on the propagated JAAS credentials because this service can only be accessed from within the same VM.
 * </p>
 *
 * @author Allwins Rajaiah
 * @see com.nyu.service.base.AuditReportLocalServiceBaseImpl
 * @see com.nyu.service.AuditReportLocalServiceUtil
 */
public class AuditReportLocalServiceImpl extends AuditReportLocalServiceBaseImpl {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never reference this interface directly. Always use {@link com.nyu.service.AuditReportLocalServiceUtil} to access the audit report local service.
	 */
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(Audit.class);
	public List<AuditReport> getByeventType(String eventType, int start,int end){
		try {
			return auditReportPersistence.findByeventType(eventType, start, end);
		} catch (SystemException e) {
			LOG.info("Error in " + getClass().getName() + "\n" + e);
			return new ArrayList<AuditReport>();
		}
	}
	
	public int countByeventType(String eventType){
		try {
			return auditReportPersistence.countByeventType(eventType);
		} catch (SystemException e) {
			LOG.info("Error in " + getClass().getName() + "\n" + e);
			return 0;
		}
	}
	
	public List<AuditReport> getByeventTypeWithDate(String eventType,String fromDatestr,String toDatestr,int start,int end){
		try {
			SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
			Date  fromDate = formatter.parse(fromDatestr+" 00:00:00");
			Date  toDate = null;
			if(toDatestr != null)
				toDate = formatter.parse(toDatestr+" 23:59:59");
			
			DynamicQuery auditReportQuery = DynamicQueryFactoryUtil.forClass(AuditReport.class);
			if(!eventType.equals("-1")){
				auditReportQuery.add(PropertyFactoryUtil.forName("eventType").eq(eventType));
			}
			auditReportQuery.addOrder(OrderFactoryUtil.desc("createDate"));
			if(toDatestr != null){
				auditReportQuery.add(PropertyFactoryUtil.forName("createDate").between(fromDate, toDate));
			}	
			else{
				auditReportQuery.add(PropertyFactoryUtil.forName("createDate").ge(fromDate));
			}	
			List<AuditReport> auditReportsFilter = AuditReportLocalServiceUtil.dynamicQuery(auditReportQuery,start,end);
			return auditReportsFilter;
		} catch (Exception e) {
			LOG.info("Error in " + getClass().getName() + "\n" + e);
			return new ArrayList<AuditReport>();
		}
	}
	
	public int countByeventTypeWithDate(String eventType,String fromDatestr,String toDatestr){
		try {
			SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
			Date  fromDate = formatter.parse(fromDatestr+" 00:00:00");
			Date  toDate = null;
			if(toDatestr != null)
				toDate = formatter.parse(toDatestr+" 23:59:59");

			DynamicQuery auditReportQuery = DynamicQueryFactoryUtil.forClass(AuditReport.class);
			if(!eventType.equals("-1")){
				auditReportQuery.add(PropertyFactoryUtil.forName("eventType").eq(eventType));
			}
			auditReportQuery.addOrder(OrderFactoryUtil.desc("createDate"));
			if(toDatestr != null){
				auditReportQuery.add(PropertyFactoryUtil.forName("createDate").between(fromDate, toDate));
			}	
			else{
				auditReportQuery.add(PropertyFactoryUtil.forName("createDate").ge(fromDate));
			}
			long auditReportsFilterCount=AuditReportLocalServiceUtil.dynamicQueryCount(auditReportQuery);
			return GetterUtil.getInteger(auditReportsFilterCount);
		} catch (Exception e) {
			LOG.info("Error in " + getClass().getName() + "\n" + e);
			return 0;
		}
	}
	
	
}
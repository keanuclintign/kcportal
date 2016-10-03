package com.nyu.portlet.audit;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.StringReader;
import java.text.ParseException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.portlet.ResourceURL;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.html.simpleparser.HTMLWorker;
import com.itextpdf.text.pdf.PdfWriter;
import com.liferay.portal.kernel.dao.search.SearchContainer;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.nyu.model.AuditReport;
import com.nyu.service.AuditReportLocalServiceUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;
import com.nyu.util.RenderHelper;


@Controller
@RequestMapping(value = "VIEW")
public class Audit {
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(Audit.class);
	
	
	@RenderMapping
	public String view(RenderRequest request,RenderResponse response) throws SystemException, PortalException, ParseException {
		
	ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);	
	
	int delta = ParamUtil.getInteger(request,Constant.DELTA,10);
	int cur = ParamUtil.getInteger(request,Constant.CUR,1);
	String eventType = ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_EVENT_TYPE,Constant.MINUS_ONE);
	String fromDate = ParamUtil.getString(request,Constant.FROM_DATE,StringPool.BLANK);
	String toDate = ParamUtil.getString(request,Constant.TO_DATE,StringPool.BLANK);
		
    PortletURL portletURL = PortletURLFactoryUtil.create(request,PortalUtil.getPortletId(request), themeDisplay.getPlid(), PortletRequest.RENDER_PHASE);
    portletURL.setParameter(Constant.COMMON_STRING_CONSTANT_EVENT_TYPE, eventType);
    portletURL.setParameter(Constant.FROM_DATE, fromDate);
    portletURL.setParameter(Constant.TO_DATE, toDate);
    
    ResourceURL generateReportURL=response.createResourceURL();
    generateReportURL.setResourceID(Constant.GENERATE_REPORT);
    generateReportURL.setParameter(Constant.REPORT_TYPE, Constant.PDF);
    generateReportURL.setParameter(Constant.COMMON_STRING_CONSTANT_EVENT_TYPE, eventType);
    generateReportURL.setParameter(Constant.FROM_DATE, fromDate);
    generateReportURL.setParameter(Constant.TO_DATE, toDate);
    
    SearchContainer<AuditReport> searchContainer = new SearchContainer<AuditReport>(request, null, null, Constant.CUR, cur, delta, portletURL, null, null);
    searchContainer.setEmptyResultsMessage(CommonUtil.JavaClassI18N(request, themeDisplay, "sorry-there-are-no-items-to-display"));
	if(!eventType.equals(Constant.MINUS_ONE) && fromDate.equals(StringPool.BLANK) && toDate.equals(StringPool.BLANK)){
	    searchContainer.setResults(AuditReportLocalServiceUtil.getByeventType(eventType, searchContainer.getStart(),searchContainer.getEnd()));
	    searchContainer.setTotal(AuditReportLocalServiceUtil.countByeventType(eventType));
	    fromDate = StringPool.BLANK;
	    toDate = StringPool.BLANK;
	}else if(!fromDate.equals(StringPool.BLANK) && !toDate.equals(StringPool.BLANK)){
		searchContainer.setResults(AuditReportLocalServiceUtil.getByeventTypeWithDate(eventType,fromDate,toDate,searchContainer.getStart(),searchContainer.getEnd()));
		searchContainer.setTotal(AuditReportLocalServiceUtil.countByeventTypeWithDate(eventType,fromDate,toDate));
	}else if(!fromDate.equals(StringPool.BLANK) && toDate.equals(StringPool.BLANK)){
		searchContainer.setResults(AuditReportLocalServiceUtil.getByeventTypeWithDate(eventType,fromDate,null,searchContainer.getStart(),searchContainer.getEnd()));
		searchContainer.setTotal(AuditReportLocalServiceUtil.countByeventTypeWithDate(eventType,fromDate,null));
		toDate = StringPool.BLANK;
	}else{
		searchContainer.setResults(AuditReportLocalServiceUtil.getAuditReports(searchContainer.getStart(),searchContainer.getEnd()));
	    searchContainer.setTotal(AuditReportLocalServiceUtil.getAuditReportsCount());
	    fromDate = StringPool.BLANK;
	    toDate = StringPool.BLANK;
	}
    request.setAttribute(Constant.SEARCH_CONTAINER, searchContainer);
    request.setAttribute(Constant.COMMON_STRING_CONSTANT_EVENT_TYPE, eventType);
    request.setAttribute(Constant.FROM_DATE, fromDate);
    request.setAttribute(Constant.TO_DATE, toDate);
    request.setAttribute(Constant.GENERATE_REPORT_URL, generateReportURL);
	return Constant.LESSON_PERMISSION_VIEW_ONLY;
	}
	
	@ResourceMapping(value="detailReport")
	public void detailReport(ResourceRequest request,ResourceResponse response) throws SystemException, PortalException, IOException, ServletException {
		
	long auditEventId=ParamUtil.getLong(request,Constant.AUDIT_EVENT_ID);
	AuditReport auditReport=	AuditReportLocalServiceUtil.getAuditReport(auditEventId);  
	request.setAttribute(Constant.AUDIT_REPORT,auditReport);  
	response.setCharacterEncoding(Constant.UTF_EIGHT);
	   
	HttpServletRequest  httpRequest = PortalUtil.getHttpServletRequest(request);
	HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
	ServletContext context = httpRequest.getSession().getServletContext();
	
	String jspFile = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.AUDIT_DETAILED_REPORT_JSP);
	response.getWriter().write(jspFile);
	}
	
	@ActionMapping(params="action=auditSearch")
	public void auditSearch(ActionRequest request,ActionResponse response) throws SystemException, PortalException, ParseException {
		
		String eventType=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_EVENT_TYPE); 
		String fromDatestr=ParamUtil.getString(request,Constant.FROM_DATE);
		String toDatestr=ParamUtil.getString(request,Constant.TO_DATE); 
		request.setAttribute(Constant.COMMON_STRING_CONSTANT_EVENT_TYPE,eventType);
		request.setAttribute(Constant.FROM_DATE,fromDatestr);
		request.setAttribute(Constant.TO_DATE,toDatestr);
		
		response.setRenderParameter(Constant.FROM_DATE,fromDatestr);
		response.setRenderParameter(Constant.TO_DATE,toDatestr);
		response.setRenderParameter(Constant.COMMON_STRING_CONSTANT_EVENT_TYPE,eventType);
	}

	


@ResourceMapping(value="generateReport")
private void generateReport(ResourceRequest request,
		ResourceResponse response) {
	
	ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
	try {                
		String msg = CommonUtil.JavaClassI18N(request, themeDisplay, "audit-report");
		Document document = new Document();
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		PdfWriter.getInstance(document, baos);

		document.open();
		document.add(new Paragraph(msg));
		document.add(Chunk.NEWLINE);
		//document.add(new Paragraph("Lesson Details."));
		HTMLWorker htmlWorker = new HTMLWorker(document);

		String eventType=ParamUtil.getString(request,Constant.COMMON_STRING_CONSTANT_EVENT_TYPE); 
		String fromDatestr=ParamUtil.getString(request,Constant.FROM_DATE);
		String toDatestr=ParamUtil.getString(request,Constant.TO_DATE); 
		
		if(!eventType.equals(Constant.MINUS_ONE) && (fromDatestr.equals(StringPool.BLANK) || toDatestr.equals(StringPool.BLANK))){
		   request.setAttribute(Constant.AUDIT_REPORTS,AuditReportLocalServiceUtil.getByeventType(eventType,-1,-1));
		}else if(!fromDatestr.equals(StringPool.BLANK) && !toDatestr.equals(StringPool.BLANK)){
			request.setAttribute(Constant.AUDIT_REPORTS,AuditReportLocalServiceUtil.getByeventTypeWithDate(eventType,fromDatestr,toDatestr,-1,-1));
		}else{
			request.setAttribute(Constant.AUDIT_REPORTS,AuditReportLocalServiceUtil.getAuditReports(-1,-1));
		}
		
		HttpServletRequest httpRequest = PortalUtil
				.getHttpServletRequest(request);
		HttpSession session=PortalUtil
				.getHttpServletRequest(request).getSession();
		HttpServletResponse httpResponse = PortalUtil
				.getHttpServletResponse(response);
		ServletContext context = httpRequest.getSession()
				.getServletContext();
		String jspFile = StringPool.BLANK;
	
		jspFile = RenderHelper.renderPage(context, httpRequest, httpResponse, Constant.AUDIT_GENERATE_REPORT_JSP);
			
		//htmlWorker.parse(new StringReader(str));
		htmlWorker.parse(new StringReader(jspFile));
		document.close();

		response.setContentType(Constant.SET_CONTENT_TYPE_APPLICATION_PDF);
		//response.addProperty(HttpHeaders.CACHE_CONTROL, "max-age=3600, must-revalidate");

		response.setContentLength(baos.size());

		java.io.OutputStream out = response.getPortletOutputStream();
		baos.writeTo(out);

		out.flush();
		out.close();
	} catch (Exception e2) {
		LOG.info("Error in " + getClass().getName() + "\n" + e2);
	}

}

	
}

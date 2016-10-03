package com.nyu.portlet.homepage;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.OrderFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.portlet.PortletProps;
import com.nyu.model.Lesson;
import com.nyu.service.LessonLocalServiceUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.RenderHelper;


/**
 * Portlet implementation class NyuWelcome
 */
@Controller
@RequestMapping(value = "VIEW")
public class HomepageController  {
	private static Logger _log = Logger.getLogger(HomepageController.class);
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws SystemException 
	 */
	@RenderMapping
	public String view(RenderRequest request,RenderResponse response) throws SystemException {
		
			ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
			List<Lesson> lessons =new ArrayList<Lesson>();
				DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
				dynamicQuery.add(PropertyFactoryUtil.forName("lessonPrivacy").eq("public"));
				dynamicQuery.add(PropertyFactoryUtil.forName("status").eq("published"));
				dynamicQuery.addOrder(OrderFactoryUtil.desc("uploadedTime"));
				lessons = LessonLocalServiceUtil.dynamicQuery(dynamicQuery);
				String jsonLessons;
				try {
					jsonLessons = CommonUtil.getJSONLessons(lessons, themeDisplay);
					JSONObject AllLessonData=JSONFactoryUtil.createJSONObject();
					AllLessonData.put("getLessons",jsonLessons);
					request.setAttribute("allLessons", AllLessonData);
				} catch (PortalException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
					
		
		return "view";    
	}
	
	
	@RenderMapping(params="action=showDocument")
	public String showDocument(RenderRequest request,RenderResponse response) throws SystemException {
		request.setAttribute("lessonId", request.getParameter("lessonId") );
		return "viewLesson";    
	}
	
	
	@ResourceMapping(value="scrollLoad")
    public void scrollLoad(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException  {
			
		List<Lesson> lessons = new ArrayList<Lesson>();
		resourceResponse.setCharacterEncoding("UTF-8");
		int count = Integer.parseInt(resourceRequest.getParameter("count"));
		int LessonCount=Integer.parseInt(PortletProps.get("show.lessons.count.value"));
		int showLessonCount=Integer.parseInt(PortletProps.get("show.more.lessons.count"));
		HttpServletRequest httpRequest = PortalUtil
				.getHttpServletRequest(resourceRequest);
		HttpServletResponse httpResponse = PortalUtil
				.getHttpServletResponse(resourceResponse);
		ServletContext context = httpRequest.getSession()
				.getServletContext();
		//DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(Lesson.class);
		//dynamicQuery.add(PropertyFactoryUtil.forName("lessonPrivacy").eq("public"));
		try {
			String lessonPrivacy = PortletProps.get("liferay.nyu.lesson.privacy.public");
			lessons = LessonLocalServiceUtil.getLessonsByPrivacy(lessonPrivacy,  "uploadedTime", "desc", -1, -1);
			String jspFile="";
			if(lessons.size()>LessonCount)
			{
				if(lessons.size()>count+showLessonCount){
					httpRequest.setAttribute("lessons", lessons.subList(count,count+showLessonCount));
					jspFile = RenderHelper.renderPage(context, httpRequest, httpResponse, "/WEB-INF/jsp/homepage/middleHome.jsp");
				}
				else{
					if(lessons.size()>count){
						httpRequest.setAttribute("lessons", lessons.subList(count,lessons.size()));
						jspFile = RenderHelper.renderPage(context, httpRequest, httpResponse, "/WEB-INF/jsp/homepage/middleHome.jsp");
					}
						
				}
				
			}	
			
			resourceResponse.getWriter().write(jspFile);
		}
		catch (Exception e) {
			// TODO: handle exception
		}

	}
	
	
	
	
}

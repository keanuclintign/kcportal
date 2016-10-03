
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portal.service.UserGroupLocalServiceUtil"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="com.nyu.model.Lesson"%>
<%@page import="com.nyu.model.Lesson_Usergroups"%>
<%@page import="com.nyu.util.CommonUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portlet.asset.service.AssetCategoryLocalServiceUtil"%>
<%@page import="com.liferay.portlet.asset.service.AssetTagLocalServiceUtil"%>
<%@page import="com.nyu.service.Lesson_UsergroupsLocalServiceUtil"%>
<%@page import="com.nyu.service.LessonLocalServiceUtil"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%Set<Long> userIds=new HashSet<Long>();%>
<c:forEach items="${lessons}" var="lesson" varStatus="i">
<c:set var="authorId" value="${lesson.author}"/>
<%
    long authorId = GetterUtil.getLong(pageContext.getAttribute("authorId"));
    userIds.add(authorId);
%>
</c:forEach>
<% request.setAttribute("userIds", userIds); %>
<c:forEach items="${userIds}" var="author" varStatus="i">
<c:set var="authorId" value="${author}"/>
<%
long authorId =GetterUtil.getLong(pageContext.getAttribute("authorId"));
List<Lesson> authorLessonsList = LessonLocalServiceUtil.getLessonsUploadedByAuthor(authorId);
request.setAttribute("authorLessonsList", authorLessonsList);
%>
<h3><b>Contributor : </b><%=UserLocalServiceUtil.getUser(authorId).getFirstName()+" "+UserLocalServiceUtil.getUser(authorId).getLastName()%></h3> 
<table border="1">
<tr>
             <th><b>S.No.</b></th>
			<th><b>Lesson Name</b></th>
			<th><b>Description</b></th>
			<th><b>Categories</b></th>
			<th><b>Tags</b></th>
			<th><b>Groups</b></th>
			<th><b>Created Date</b></th>
			</tr>
<c:forEach items="${authorLessonsList}" var="authorLesson" varStatus="i" >
<c:set var="authorLessonId">${authorLesson.lessonId}</c:set>
<c:set var="lessonDescription">${authorLesson.description}</c:set>
<% long authorLessonId = Long.parseLong((String) pageContext.getAttribute("authorLessonId")); 
List<Lesson_Usergroups> lesson_groupsList=Lesson_UsergroupsLocalServiceUtil.getLesson_UserGroupLessonId(authorLessonId);

String lessonDescription = (String)pageContext.getAttribute("lessonDescription"); 
 %>
		<tr >
		    
		    <td><c:out value="${i.count}"/></td>
			<td>${authorLesson.lessonName}</td>
			<td><% if(lessonDescription.toString().length()>40)
				out.println(lessonDescription.toString().substring(0,40)+"...");
			else
				out.println(lessonDescription.toString()); %></td>
			<td><span class="category">
					<%
						StringBuilder sb = new StringBuilder();
							String[] categoriesList = AssetCategoryLocalServiceUtil
									.getCategoryNames(Lesson.class.getName(), authorLessonId);
						    if(categoriesList.length > 0){
						    	for (String st : categoriesList) { 
						    		sb.append(st).append(',').append(' ');
						   	 }
						    	if (categoriesList.length != 0) sb.deleteCharAt(sb.length()-2);{
						    		if(sb.toString().length()>50)
							    		out.println(sb.toString().substring(0,50)+"...");
						    		else
						    			out.println(sb.toString());
						    	}
						    }
						    else{
						    	out.println("&nbsp;");
						    }
					%>
			</span></td>
			<td><span class="category">
					<%
						   StringBuilder sb1 = new StringBuilder();
							String[] tagsList = AssetTagLocalServiceUtil
									.getTagNames(Lesson.class.getName(), authorLessonId);
						    if(tagsList.length > 0){
						    	for (String st : tagsList) { 
						    		sb1.append(st).append(',').append(' ');
						   	 }
						    	if (tagsList.length != 0) sb1.deleteCharAt(sb1.length()-2);{
						    		if(sb1.toString().length()>50)
							    		out.println(sb1.toString().substring(0,50)+"...");
						    		else
						    			out.println(sb1.toString());
						    	}
						    }
						    else{
						    	out.println("&nbsp;");
						    }
							
							
							
							
					%>
			</span></td>
			<td><span class="category">
					<%
					StringBuilder sb2 = new StringBuilder();
					if (lesson_groupsList.size() > 0) {
						for (Lesson_Usergroups st : lesson_groupsList) {
							try{
							sb2.append( UserGroupLocalServiceUtil.getUserGroup(st.getGroupId()).getName()).append(',').append(' ');
							}
							catch(Exception e){
								
							}
						}
				    		if(sb2.toString().length()>50)
					    		out.println(sb2.toString().substring(0,50)+"...");
				    		else
				    			out.println(sb2.toString());
				    	
					} else {
						out.println("&nbsp;");
					}
					%>
			</span></td>
			<td><fmt:formatDate pattern="MM-dd-yyyy" value="${authorLesson.uploadedTime}" /></td>
		</tr>
		
 
	</c:forEach>
		</table>&nbsp;&nbsp;
		</c:forEach>

package com.nyu.Scheduler;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

import org.apache.commons.lang.time.DateUtils;
import org.apache.velocity.VelocityContext;

import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.messaging.Message;
import com.liferay.portal.kernel.messaging.MessageListener;
import com.liferay.portal.kernel.messaging.MessageListenerException;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.Layout;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.User;
import com.liferay.portal.model.UserNotificationEvent;
import com.liferay.portal.security.auth.PrincipalThreadLocal;
import com.liferay.portal.security.permission.PermissionChecker;
import com.liferay.portal.security.permission.PermissionCheckerFactoryUtil;
import com.liferay.portal.security.permission.PermissionThreadLocal;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.service.LayoutLocalServiceUtil;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.service.UserNotificationDeliveryLocalServiceUtil;
import com.liferay.portal.util.PortalUtil;
import com.nyu.model.RequestLesson;
import com.nyu.service.RequestLessonLocalServiceUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;

public class EmailScheduler implements MessageListener { 
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(EmailScheduler.class);
    public void receive(Message arg0) throws MessageListenerException {  
    	String host = Constant.PORTLET_PROP_CURRENT_SERVER_HOST;
    	
    	PermissionChecker oldPermissionChecker = PermissionThreadLocal.getPermissionChecker();
    	
    	try {
			DynamicQuery notificationsQuery,acceptedRequestQuery;
			List<User> userList;
			List<UserNotificationEvent> userNotifactionList;
			List<RequestLesson> requestLessonList;
			userList = (List<User>)UserLocalServiceUtil.getUsers(-1, -1);
			long scopeGroupId = 0l;
			long companyId =0l;
			boolean isEmailDigestEnabled = false;
			
			// TO GET GROUP WITHOUT THEMEDISPLAY OR ANY REQUEST OBJECT
			Group group = null;
			try{
            	List<Layout> layoutList = LayoutLocalServiceUtil.getLayouts(-1, 50);
                
    			for (Layout layout: layoutList) {
                  if (layout.getFriendlyURL().equals(Constant.PAGE_CREATE_LESSON)) {
                        scopeGroupId = layout.getGroupId();
                        companyId = layout.getCompanyId();
                        break;
                    }   
                }
            	group = GroupLocalServiceUtil.getGroup(scopeGroupId);
            }catch(Exception e){
            	LOG.error("Issue in GET GROUP:::"+e.getMessage());
            	group = null;
            }
            
			//CHECKING IF GROUP IS NULL OR NOT
			if(group != null){
            	try{
	        		Role role = RoleLocalServiceUtil.getRole(companyId,Constant.ADMINISTRATOR);
	        		long tempUserId = UserLocalServiceUtil.getRoleUsers(role.getRoleId()).size() > 0?UserLocalServiceUtil.getRoleUsers(role.getRoleId()).get(0).getUserId():0l;
	        		if(tempUserId > 0){
		        		User tempUser = UserLocalServiceUtil.getUser(tempUserId); 
		        		PrincipalThreadLocal.setName(String.valueOf(tempUser.getUserId()));
						PermissionThreadLocal.setPermissionChecker(PermissionCheckerFactoryUtil.create(tempUser));
						isEmailDigestEnabled = GetterUtil.getBoolean(group.getExpandoBridge().getAttribute(Constant.EMAIL_DIGEST_ATTRIBUTE),false);
	        		}else{
	        			isEmailDigestEnabled = false;
	        		}
            	}catch(Exception e){
            		isEmailDigestEnabled = false;
            		LOG.error("Issue in group.getExpandoBridge:::"+e.getMessage());
            	}
            }
			
            if(isEmailDigestEnabled && host.contains("kc-whitelabel-portal")){
	            for(User user:userList){
					PrincipalThreadLocal.setName(String.valueOf(user.getUserId()));
					PermissionThreadLocal.setPermissionChecker(PermissionCheckerFactoryUtil.create(user));
					boolean isSubscribed = GetterUtil.getBoolean(user.getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_SUBSCRIBE_MAIL_DIGEST),false);
					int DateDeadLine = GetterUtil.getInteger(user.getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_NOTIFY_EMAIL_DIGEST),10);
					DateDeadLine = DateDeadLine > 0 ? DateDeadLine :GetterUtil.getInteger(Constant.PORTLET_PROP_EMAIL_DIGEST_NUMBER_OF_DAYS_NOT_LOGIN);
					Date DeadLine = DateUtils.addDays(new Date(),-DateDeadLine);
					int dateComparing = user.getLoginDate().compareTo(DeadLine);
					
					if((!user.getEmailAddress().isEmpty()) && (isSubscribed)  && (dateComparing < 0)){
						 InternetAddress[] to = new InternetAddress[1];
							to[0] = new InternetAddress(user.getEmailAddress());
							
							notificationsQuery = DynamicQueryFactoryUtil.forClass(UserNotificationEvent.class);
							notificationsQuery.add(PropertyFactoryUtil.forName(Constant.COMMON_STRING_CONSTANT_USER_ID).eq(user.getUserId()));
							notificationsQuery.add(PropertyFactoryUtil.forName(Constant.ARCHIVED).eq(false));
							userNotifactionList = UserNotificationDeliveryLocalServiceUtil.dynamicQuery(notificationsQuery);
							
							acceptedRequestQuery = DynamicQueryFactoryUtil.forClass(RequestLesson.class);
							acceptedRequestQuery.add(PropertyFactoryUtil.forName(Constant.ACCEPTED_BY).eq(user.getUserId()));
							acceptedRequestQuery.add(PropertyFactoryUtil.forName(Constant.STATUS).eq(Constant.REQUEST_LESSON_STATUS_IN_PROGRESS));
							requestLessonList = RequestLessonLocalServiceUtil.dynamicQuery(acceptedRequestQuery);
							
							VelocityContext velocityContext = new VelocityContext();
							velocityContext.put(Constant.COMMON_DATE, CommonUtil.dateAsPerFormat(Constant.EEEE_MMM_D_YYYY));
							velocityContext.put(Constant.FROM, Constant.KNOWLEDGE_COMMONS );
							velocityContext.put(Constant.TO,user.getFullName());
							velocityContext.put(Constant.REQUEST_LESSON_SUBJECT_JSP, Constant.EMAIL_DIGEST_FROM_KNOWLEDGE_COMMONS);
							velocityContext.put(Constant.NOTIFICATION_COUNT, userNotifactionList.size());
							velocityContext.put(Constant.REQUEST_ACCEPT_COUNT, requestLessonList.size());
							velocityContext.put(Constant.HOST,host);
							CommonUtil.emailNotification(user.getUserId(), String.valueOf(user.getUserId()), Constant.EMAIL_DIGEST_FROM_KNOWLEDGE_COMMONS, Constant.EMAIL_DIGEST_FROM_KNOWLEDGE_COMMONS, Constant.CONTENT_TEMPLATES_EMAIL_DIGEST_TO_USER_VM,velocityContext);
					 }
				}
            }
		} catch (SystemException e) {
			LOG.error(e);
		} catch (AddressException e) {
			LOG.error(e);
		} catch (PortalException e) {
			LOG.error(e);
		} catch (IOException e) {
			LOG.error(e);
		} catch (Exception e) {
			LOG.error(e);
		}
        finally{
        	try{
        	PrincipalThreadLocal.setName(String.valueOf(oldPermissionChecker.getUserId()));
        	PermissionThreadLocal.setPermissionChecker(oldPermissionChecker);
        	}catch(Exception e){
        		PermissionThreadLocal.setPermissionChecker(oldPermissionChecker);
        	}
        }
    }  
 }  
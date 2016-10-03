package com.nyu.portlet.contact;



import java.io.File;
import java.util.List;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;

import com.liferay.mail.service.MailServiceUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.mail.MailMessage;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.User;
import com.liferay.portal.model.UserGroup;
import com.liferay.portal.service.UserGroupLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.nyu.util.Constant;

@Controller
@RequestMapping(value = "VIEW")
public class ContactUsController {
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(ContactUsController.class);
	
	@RenderMapping
	public String view(RenderRequest request,RenderResponse response) throws SystemException, PortalException {
		
		String closePopup = ParamUtil.getString(request, Constant.CLOSE_POPUP,Constant.COMMON_STRING_CONSTANT_FALSE);
	   request.setAttribute(Constant.CLOSE_POPUP, closePopup);
	   return Constant.USER_PROFILE_VIEW_JSP;
	}
	@ActionMapping(params = "action=contactUs")
	public void contactUs(ActionRequest actionRequest,ActionResponse actionResponse)throws PortalException, SystemException
	{
		
		UploadPortletRequest uploadRequest = PortalUtil.getUploadPortletRequest(actionRequest);
		ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		
		String fromAddress=UserLocalServiceUtil.getUser(themeDisplay.getUserId()).getEmailAddress();
		
		String toAddress= Constant.PORTLET_PROP_ADMIN_CONTACTUS_TO_ADDRESS;
		String toAddressType= Constant.PORTLET_PROP_ADMIN_CONTACTUS_TYPE;
		String message=ParamUtil.getString(uploadRequest, Constant.COMMON_STRING_CONSTANT_MESSAGE);
		String subject=ParamUtil.getString(uploadRequest, Constant.REQUEST_LESSON_SUBJECT_JSP);
		boolean isFileAdded = ParamUtil.getBoolean(uploadRequest, Constant.IS_FILE_ADDED);
		File file = uploadRequest.getFile(Constant.MSG_ATTACHED_FILE);
		
		InternetAddress[] to=null;
		InternetAddress from=null;
		
		try {
			int i=0;
			from = new InternetAddress(fromAddress);
			if(toAddressType.equals(Constant.USER_GROUP)){
				UserGroup userGroup = UserGroupLocalServiceUtil.getUserGroup(PortalUtil.getCompanyId(actionRequest), toAddress);
				List<User> users = UserLocalServiceUtil.getUserGroupUsers(userGroup.getUserGroupId());
				to = new InternetAddress[users.size()];
				for(User address:users){
					if(!address.getEmailAddress().isEmpty()){
						to[i] = new InternetAddress(address.getEmailAddress());
						i++;
					}
				}
			}
			else{
				String[] toAdd = toAddress.split(StringPool.COMMA);
				to = new InternetAddress[toAdd.length];
				for(String address:toAdd){
					to[i] = new InternetAddress(address);
					i++;
				}
			}
			
		} catch (AddressException e) {
			LOG.error("[ContactUsController: contactUs() ]"+e);
		}
		if(to != null && to.length>0){
			MailMessage mailMessage = new MailMessage();
			mailMessage.setFrom(from);
			mailMessage.setTo(to);
			mailMessage.setBody(message);
			mailMessage.setSubject(subject);
			if(Validator.isNotNull(file) && isFileAdded){
				mailMessage.addFileAttachment(file);
			}
			MailServiceUtil.sendEmail(mailMessage);
			SessionMessages.add(actionRequest,Constant.COMMON_SUCESS);
			actionResponse.setRenderParameter(Constant.CLOSE_POPUP, Constant.COMMON_STRING_CONSTANT_TRUE);
		}else
		{
			SessionMessages.add(actionRequest,Constant.ERROR);
		}
	}

}

package com.liferay.portal.security.auth;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.nyu.action.ShibbolethPostLogin;
import com.liferay.portal.events.NYouGlobalAction;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.model.Contact;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.LayoutSet;
import com.liferay.portal.model.User;
import com.liferay.portal.service.AccountLocalServiceUtil;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.ContactLocalServiceUtil;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.service.LayoutSetLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.portlet.PortletProps;

public class ShibbolethLogin implements AutoLogin {
	
//	@Autowired
  //  private MessageSource messageSource;
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(ShibbolethLogin.class);
	
	private final String ssoUrl = PortletProps.get("liferay.nyu.login.ssourl");//"https://shibbolethqa.es.its.nyu.edu/idp/profile/SAML2/Unsolicited/SSO";
	//private final String providerIdUrl = "https://portal.nyugts.edu/samlLoginHandler";
	private final String providerIdUrl = PortletProps.get("liferay.nyu.login.provideridurl");//"https://portal.nyugts.com/samlLoginHandler";
	
	@Override
	public String[] login(HttpServletRequest request,
			HttpServletResponse response) throws AutoLoginException {

		LOG.info("auto login");
		LOG.info("URI ServerName ====>"+request.getServerName()+"<=== Host===>"+request.getHeader("Host")+"<====");
		
		String domainName=""+request.getServerName();
		if(domainName.equalsIgnoreCase("ny-you.nyugts.com")) {
			try{
				response.sendRedirect("https://knowledgecommons.nyu.edu");
			}catch(IOException e) {
				LOG.error("Error while redirection :",e);
			}
		}
		
		NYouGlobalAction.setBadgeURLToContext(PortletProps.get("liferay.nyu.basno.best.lesson.badge.id"), request, response);
		String samlResponse = request.getParameter("SAMLResponse");
		if(samlResponse!=null && !samlResponse.trim().equals("")){
			try {
				String targetUrl = request.getParameter("RelayState");
				HttpClient httpClient = new DefaultHttpClient();  
				//HttpPost httpPost = new HttpPost("https://services-dev.nyugts.com:9443/services/SamlValidator");  
				HttpPost httpPost = new HttpPost(PortletProps.get("liferay.nyu.login.validator"));
			    List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();  
			    nameValuePairs.add(new BasicNameValuePair("samlMessage", samlResponse));  
			    nameValuePairs.add(new BasicNameValuePair("appname", "liferay"));
			    nameValuePairs.add(new BasicNameValuePair("relaystate", targetUrl));
			    nameValuePairs.add(new BasicNameValuePair("requestorUrl", domainName.substring(domainName.indexOf(".")+1)));
			    httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));  
		    
			    HttpResponse httpResponse =  httpClient.execute(httpPost);
				JAXBContext jaxbContext = JAXBContext.newInstance(SamlAuthResponse.class);
				
				Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
				SamlAuthResponse samlAuthResponse = (SamlAuthResponse) jaxbUnmarshaller.unmarshal(httpResponse.getEntity().getContent());
				
				
				if(samlAuthResponse==null){ 
					LOG.info("samlAuthResponse is null");
					return null;
				}else if(samlAuthResponse!=null && "failed".equalsIgnoreCase(samlAuthResponse.getStatus())){
					LOG.info(samlAuthResponse.getStatusMessage());
					return null;
				}
				
				/* Local Testing: START
				 * Uncomment below 3 lines .its only for testiong
				   Test URL from local: http://localhost:8080/group/SiteName?SAMLResponse=tst424&RelayState=/group/SiteName
										e.ghttp://localhost:8080/group/ny-you1?SAMLResponse=tst424&RelayState=/group/ny-you1
				
				SamlAuthResponse samlAuthResponse = new SamlAuthResponse ();
				samlAuthResponse.setUser(request.getParameter("SAMLResponse"));
				samlAuthResponse.setEmailId(request.getParameter("SAMLResponse")+"@liferay.com");
				samlAuthResponse.setFirstName(request.getParameter("SAMLResponse"));
				samlAuthResponse.setLastName(request.getParameter("SAMLResponse"));
				//samlAuthResponse.setDestination("/group/ny-you"); Use this line or samlAuthResponse.setDestination(targetUrl);
				samlAuthResponse.setDestination(targetUrl); //RelayState=/group/siteName e.g /group/ny-you
				
				 Local Testing: END **/
				
				long companyId = PortalUtil.getCompanyId(request);
				if(!"".equalsIgnoreCase(samlAuthResponse.getDestination())){
					request.setAttribute(AutoLogin.AUTO_LOGIN_REDIRECT_AND_CONTINUE,samlAuthResponse.getDestination() );
				}else{
					request.setAttribute(AutoLogin.AUTO_LOGIN_REDIRECT_AND_CONTINUE,"/");
				}
				User user = null;
				try{
					user = UserLocalServiceUtil.getUserByScreenName(companyId,samlAuthResponse.getUser());
				}catch (PortalException e) {
					LOG.error("User does not exist in liferay. Creating user account...");
					user = addUser(companyId,samlAuthResponse);
					LOG.error("User has been created successfully.");
				} 
				LOG.info(user.getUserId());
				LOG.info(user.getPassword());
				LOG.info(user.isPasswordEncrypted());
				return new String[] { String.valueOf(user.getUserId()),
	                    user.getPassword(),
	                    String.valueOf(user.isPasswordEncrypted()) };
			} catch (SystemException e) {
				e.printStackTrace();
			}catch(Error e){
				e.printStackTrace();
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			} catch (ClientProtocolException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (JAXBException e) {
				e.printStackTrace();
			}
			
		}else{
				
			if (request.getRequestURL() != null && 
					request.getRequestURL().indexOf(
							PortletProps.get("liferay.nyu.shibboleth.login")+PortletProps.get("liferay.nyu.site.shibboleth.login")) > -1) {
				try {
					String target = request.getRequestURI();
					if(request.getQueryString()!=null){
						target = target+"?"+request.getQueryString();
					}
					
					String redirectionUrl = ssoUrl+"?providerId="+providerIdUrl+"&target="+target;
					response.sendRedirect(redirectionUrl);
					
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
					return new String[] { "", "", "" };
			}
		}
		return null;
	}
	
	private User addUser(long companyId,SamlAuthResponse samlAuthResponse){
		
		try {
			long userId = CounterLocalServiceUtil.increment();
			long contactId = CounterLocalServiceUtil.increment();
			long groupId = CounterLocalServiceUtil.increment();
			long publicLayoutSetId = CounterLocalServiceUtil.increment();
			long privateLayoutSetId = CounterLocalServiceUtil.increment();
			
			//create user
            User user = UserLocalServiceUtil.createUser(userId);
            user.setCompanyId(companyId);
            user.setContactId(contactId);
            user.setFirstName(samlAuthResponse.getFirstName());
            user.setLastName(samlAuthResponse.getLastName());
            user.setEmailAddress(samlAuthResponse.getEmailId());
            user.setScreenName(samlAuthResponse.getUser());
            user.setPassword(samlAuthResponse.getUser());
            user.setPasswordEncrypted(false);
            user.setAgreedToTermsOfUse(false);
            user.setReminderQueryAnswer(samlAuthResponse.getUser());
            user.setReminderQueryQuestion("Your userName");
            user.setLanguageId(LanguageUtil.getLanguageId(Locale.US));
            user.setCreateDate(new Date());
            user.setModifiedDate(new Date());
			
            Contact contact =ContactLocalServiceUtil.createContact(contactId);
            contact.setCompanyId(companyId);
            contact.setUserId(UserLocalServiceUtil.getDefaultUserId(companyId));
            contact.setBirthday(new Date());
            contact.setAccountId(AccountLocalServiceUtil.getAccounts(0,1).get(0).getAccountId());
            contact.setFirstName(samlAuthResponse.getFirstName());
            contact.setLastName(samlAuthResponse.getLastName());
            contact.setEmailAddress(samlAuthResponse.getEmailId());
            contact.setCreateDate(new Date());
            contact.setModifiedDate(new Date());
            ContactLocalServiceUtil.addContact(contact);
            
			user = UserLocalServiceUtil.addUser(user);
			
            contact.setClassNameId(ClassNameLocalServiceUtil.getClassNameId("com.liferay.portal.model.User"));
            contact.setClassPK(userId);
            ContactLocalServiceUtil.updateContact(contact);

            UserLocalServiceUtil.addDefaultRoles(userId);
            UserLocalServiceUtil.addDefaultGroups(userId);
            
            // Create user's group (it's mandatory)
            
            Group group = GroupLocalServiceUtil.createGroup(groupId);
            group.setCreatorUserId(userId);
            group.setClassNameId(ClassNameLocalServiceUtil.getClassNameId("com.liferay.portal.model.User"));
            group.setClassPK(userId);
            group.setActive(true);
            group.setCompanyId(companyId);
            group.setName("" + userId);
            group.setFriendlyURL("/" + samlAuthResponse.getUser());
            GroupLocalServiceUtil.addGroup(group);
            
            // Create user's private and public layout (it's mandatory)
            
            LayoutSet publicLayoutSet = LayoutSetLocalServiceUtil.createLayoutSet(publicLayoutSetId);
            publicLayoutSet.setCompanyId(companyId);
            publicLayoutSet.setGroupId(groupId);
            publicLayoutSet.setThemeId("classic");
            publicLayoutSet.setColorSchemeId("01");
            LayoutSetLocalServiceUtil.updateLayoutSet(publicLayoutSet);
            
            LayoutSet privateLayoutSet = LayoutSetLocalServiceUtil.createLayoutSet(privateLayoutSetId);
            privateLayoutSet.setCompanyId(companyId);
            privateLayoutSet.setGroupId(groupId);
            privateLayoutSet.setThemeId("classic");
            privateLayoutSet.setColorSchemeId("01");
            privateLayoutSet.setPrivateLayout(true);
            LayoutSetLocalServiceUtil.updateLayoutSet(privateLayoutSet);
            return user;
		} catch (SystemException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (PortalException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		return null;
	}

	@Override
	public String[] handleException(HttpServletRequest request,
			HttpServletResponse response, Exception e)
			throws AutoLoginException {
		// TODO Auto-generated method stub
		return null;
	}

}

package com.nyu.portlet.userprofile;

import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.awt.image.RenderedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.MimeResponse;
import javax.portlet.PortletRequest;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.ServletException;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.liferay.portal.ImageTypeException;
import com.liferay.portal.NoSuchRepositoryException;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.image.ImageBag;
import com.liferay.portal.kernel.image.ImageToolUtil;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.repository.model.FileEntry;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.upload.UploadException;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.Base64;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.MimeTypesUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StreamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.TempFileUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Contact;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.User;
import com.liferay.portal.service.ContactLocalServiceUtil;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.asset.service.AssetEntryLocalServiceUtil;
import com.liferay.portlet.documentlibrary.NoSuchFileEntryException;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;

@Controller
@RequestMapping(value = "VIEW")
public class UserProfileController {
	
	private static org.apache.log4j.Logger _log = Logger.getLogger(UserProfileController.class);
	
	@RenderMapping
	public String view(RenderRequest request,RenderResponse response) throws PortalException, SystemException {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		User user = UserLocalServiceUtil.getUser(themeDisplay.getUserId());
		Group group = GroupLocalServiceUtil.getGroup(PortalUtil.getScopeGroupId(request));
		boolean isEmailDigestEnabled = GetterUtil.getBoolean(group.getExpandoBridge().getAttribute(Constant.EMAIL_DIGEST_ATTRIBUTE),false);
			
		request.setAttribute(Constant.COMMON_LOGGED_IN_USER, user);
		
		if(isEmailDigestEnabled){
			request.setAttribute(Constant.COMMON_EMAIL_DIGEST_STATUS,GetterUtil.getBoolean(user.getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_SUBSCRIBE_MAIL_DIGEST),false));
			request.setAttribute(Constant.COMMON_NOTIFY_EMAIL_DIGEST,GetterUtil.getInteger(user.getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_NOTIFY_EMAIL_DIGEST),10));
		}
		
		if(Constant.IS_FOR_VENDOR){				//condition by asif
			request.setAttribute(Constant.COMMON_ALUMNI_STATUS,GetterUtil.getBoolean(user.getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_VENDOR_ALUMNI),true));
		}
		String genderValue = user.getExpandoBridge().getAttribute(Constant.EXPANDO_FIELD_CUSTOM_GENDER).toString();
		String customisedGenderValue = null;
		
		if(!genderValue.equalsIgnoreCase(Constant.COMMON_MALE) && !genderValue.equalsIgnoreCase(Constant.COMMON_FEMALE) && !genderValue.equalsIgnoreCase(Constant.COMMON_NTD)){
			 customisedGenderValue = genderValue;
		}
		user.getPortraitURL(themeDisplay);
		request.setAttribute(Constant.COMMON_GENDER_VALUE, genderValue);
		request.setAttribute("isEmailDigestEnabled", isEmailDigestEnabled);
		request.setAttribute(Constant.COMMON_CUSTOMISED_GENDER_VALUE, customisedGenderValue);
				
		return Constant.USER_PROFILE_VIEW_JSP;  
	}
	
	@RenderMapping(params="action=uploadImage")
	public String uploadImage(RenderRequest request,RenderResponse response) throws PortalException, SystemException {
	
		
		return Constant.USER_PROFILE_USER_PROFILE_PIC_JSP;  
	}
	
	@ActionMapping(params="action=userProfile")
	public void userProfile(ActionRequest request,ActionResponse response) throws Exception {
	  
		SimpleDateFormat sdf = new SimpleDateFormat(Constant.COMMON_MM_DD_YYYY_DATE_FORMAT);
		ServiceContext serviceContext = ServiceContextFactory.getInstance(request);

		String birthDay = ParamUtil.getString(request, Constant.COMMON_BD_DAY);
		String birthMonth = ParamUtil.getString(request, Constant.COMMON_BD_MONTH);
		String birthYear = ParamUtil.getString(request, Constant.COMMON_BD_YEAR);
		birthDay = birthDay.length()<=1?Constant.COMMON_STRING_ZERO+birthDay:birthDay;
		birthMonth = birthMonth.length()<=1?Constant.COMMON_STRING_ZERO+birthMonth:birthMonth;
		String fullBirthDate = birthMonth+StringPool.FORWARD_SLASH+birthDay+StringPool.FORWARD_SLASH+birthYear;
		
		User user= UserLocalServiceUtil.getUser(PortalUtil.getUserId(request));
		user.setScreenName(ParamUtil.getString(request, Constant.COMMON_SCREEN_NAME));
		user.setEmailAddress(ParamUtil.getString(request, Constant.COMMON_STRING_CONSTANT_EMAIL_ADDRESS));
		user.setFirstName(ParamUtil.getString(request, Constant.COMMON_FIRST_NAME));
		user.setLastName(ParamUtil.getString(request, Constant.COMMON_LAST_NAME));
		user.setMiddleName(ParamUtil.getString(request, Constant.COMMON_MIDDLE_NAME));
		
		Group group = GroupLocalServiceUtil.getGroup(PortalUtil.getScopeGroupId(request));
		boolean isEmailDigestEnabled = GetterUtil.getBoolean(group.getExpandoBridge().getAttribute(Constant.EMAIL_DIGEST_ATTRIBUTE),false);
		
		if(Constant.IS_FOR_VENDOR){			//condition by asif
			user.getExpandoBridge().setAttribute(Constant.EXPANDO_FIELD_VENDOR_SCHOOL, ParamUtil.getString(request, Constant.COMMON_EXPANDO_ATTRIBUTE_VENDOR_SCHOOL));
		}
		
		user.getExpandoBridge().setAttribute(Constant.EXPANDO_FIELD_ANONYMOUS_USER, ParamUtil.getString(request, Constant.COMMON_EXPANDO_ATTRIBUTE_ANONUMOUS_USER));
		user.getExpandoBridge().setAttribute(Constant.EXPANDO_FIELD_AUTHOR_INFO, ParamUtil.getString(request, Constant.COMMON_EXPANDO_ATTRIBUTE_AUTHOR_INFO));
		
		if(Constant.IS_FOR_VENDOR){			//condition by asif 
			user.getExpandoBridge().setAttribute(Constant.EXPANDO_FIELD_YEAR_OF_PASSING, ParamUtil.getString(request, Constant.COMMON_EXPANDO_ATTRIBUTE_YEAR_OF_PASSING));
		}
		
		if(isEmailDigestEnabled){
			user.getExpandoBridge().setAttribute(Constant.EXPANDO_FIELD_SUBSCRIBE_MAIL_DIGEST,ParamUtil.getString(request, Constant.COMMON_SUBSCRIBE_EMAIL_DIGEST));
			user.getExpandoBridge().setAttribute(Constant.EXPANDO_FIELD_NOTIFY_EMAIL_DIGEST,ParamUtil.getString(request, Constant.COMMON_EMAIL_DIGEST_INACTIVE));
		}
		
		if(Constant.IS_FOR_VENDOR){			//condition by asif 
			user.getExpandoBridge().setAttribute(Constant.EXPANDO_FIELD_VENDOR_ALUMNI,ParamUtil.getBoolean(request, Constant.COMMON_VENDOR_ALUMNI));
		}
		Contact contact=ContactLocalServiceUtil.getContact(user.getContactId());
		contact.setUserId(user.getUserId());
		contact.setUserName(user.getFullName());
		contact.setPrefixId(ParamUtil.getInteger(request, Constant.COMMON_PREFIX_LIST));
		contact.setSuffixId(ParamUtil.getInteger(request, Constant.COMMON_SUFFIX_LIST));
		
		String customGender = ParamUtil.getString(request, Constant.COMMON_GENDER);
		user.getExpandoBridge().setAttribute(Constant.EXPANDO_FIELD_CUSTOM_GENDER,customGender);
		
		if(customGender.equalsIgnoreCase(Constant.COMMON_MALE)){
			contact.setMale(true);
		}else if(customGender.equalsIgnoreCase(Constant.COMMON_FEMALE)){
			contact.setMale(false);
		}else if(customGender.equalsIgnoreCase(Constant.COMMON_NTD)){
		}else{
			user.getExpandoBridge().setAttribute(Constant.EXPANDO_FIELD_CUSTOM_GENDER,ParamUtil.getString(request, Constant.COMMON_CUSTOM_GENDER));
		}
		contact.setJobTitle(ParamUtil.getString(request, Constant.COMMON_USER_PROFILE_JOB_TITLE));
		contact.setBirthday(GetterUtil.getDate(fullBirthDate,sdf));
		
		AssetEntryLocalServiceUtil.updateEntry  (serviceContext.getUserId(), serviceContext.getScopeGroupId(), 
				User.class.getName(), user.getPrimaryKey(), serviceContext.getAssetCategoryIds(), getValidatedTags(serviceContext));
		contact=ContactLocalServiceUtil.updateContact(contact);
		UserLocalServiceUtil.updateUser(user);
		SessionMessages.add(request,Constant.COMMON_SUCESS);
	}

	private String[] getValidatedTags(ServiceContext serviceContext) {
		String assetTags[] = serviceContext.getAssetTagNames();
		List<String> tagList = new ArrayList<String>();
	    for(String tag : assetTags) {
	       if(tag != null && tag.trim().length() > 0) {
	    	   tagList.add(tag);
	       }
	    }
	    return assetTags = tagList.toArray(new String[tagList.size()]);
	}
	
	@ResourceMapping(value = "getTempPic")
	public void getTempPic(ResourceRequest request, ResourceResponse response)
			throws SystemException, PortalException, IOException,
			ServletException {
		try {
			addTempImageFile(request);
			FileEntry tempFileEntry = getTempImageFileEntry(request);
			serveTempImageFile(response, tempFileEntry.getContentStream());
		} catch (NoSuchFileEntryException nsfee) {
			_log.info("nsfee" + nsfee.getMessage());
		} catch (Exception e) {
			_log.info("e" + e.getMessage());
		}
	}
	
	@ResourceMapping(value = "saveImage")
	public void saveImage(ResourceRequest request, ResourceResponse response)
			throws SystemException, PortalException, IOException,
			ServletException {
		FileEntry tempFileEntry = null;
		ThemeDisplay themeDisplay = (ThemeDisplay) request
				.getAttribute(WebKeys.THEME_DISPLAY);
		InputStream tempImageStream = null;

		try {
			tempFileEntry = getTempImageFileEntry(request);

			tempImageStream = tempFileEntry.getContentStream();

			ImageBag imageBag = ImageToolUtil.read(tempImageStream);

			RenderedImage renderedImage = imageBag.getRenderedImage();
			String cropRegionJSON = ParamUtil.getString(request, Constant.COMMON_CROP_REGION);
			if (Validator.isNotNull(cropRegionJSON)) {
				JSONObject jsonObject = JSONFactoryUtil
						.createJSONObject(cropRegionJSON);

				int height = jsonObject.getInt(Constant.HEIGHT);
				int width = jsonObject.getInt(Constant.WIDTH);
				int x = jsonObject.getInt(Constant.COMMON_X);
				int y = jsonObject.getInt(Constant.COMMON_Y);

				renderedImage = getCroppedRenderedImage(renderedImage, height,
						width, x, y);
			}

			byte[] bytes = ImageToolUtil.getBytes(renderedImage,
					imageBag.getType());

			saveTempImageFile(request, bytes);
		} catch (NoSuchFileEntryException nsfee) {
			throw new UploadException(nsfee);
		} catch (NoSuchRepositoryException nsre) {
			throw new UploadException(nsre);
		} catch (Exception e) {
			_log.error(e);
		} finally {
			StreamUtil.cleanUp(tempImageStream);

			if (tempFileEntry != null) {
				TempFileUtil.deleteTempFile(tempFileEntry.getFileEntryId());
			}
			response.getWriter().write(
					UserLocalServiceUtil.getUser(PortalUtil.getUserId(request))
							.getPortraitURL(themeDisplay));
		}
	}
	
	@ResourceMapping(value="deleteImageURL")
    public void deleteProfileImage(ResourceRequest request, ResourceResponse response)  {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		 try {
			User user= UserLocalServiceUtil.getUser(PortalUtil.getUserId(request));
			user.setPortraitId(0);
			UserLocalServiceUtil.updateUser(user);
			response.getWriter().write(UserLocalServiceUtil.getUser(themeDisplay.getUserId()).getPortraitURL(themeDisplay));
		} catch (PortalException e) {
			_log.error(e);
		} catch (SystemException e) {
			_log.error(e);
		} catch (IOException e) {
			_log.error(e);
		}
	}
	
	protected void addTempImageFile(PortletRequest portletRequest)
			throws Exception {

		UploadPortletRequest uploadPortletRequest = PortalUtil
				.getUploadPortletRequest(portletRequest);

		ThemeDisplay themeDisplay = (ThemeDisplay) portletRequest
				.getAttribute(WebKeys.THEME_DISPLAY);

		String contentType = uploadPortletRequest.getContentType(Constant.USER_PROFILE_FILE_UPLOAD);

		if (!MimeTypesUtil.isWebImage(contentType)) {
			throw new ImageTypeException();
		}

		try {
			TempFileUtil.deleteTempFile(themeDisplay.getScopeGroupId(),
					themeDisplay.getUserId(),
					getTempImageFileName(portletRequest),
					getTempImageFolderName());
		} catch (Exception e) {
		}

		InputStream inputStream = uploadPortletRequest
				.getFileAsStream(Constant.USER_PROFILE_FILE_UPLOAD);

		try {

			BufferedImage originalImage = ImageIO.read(inputStream);
			String ext = getFileExtension(uploadPortletRequest.getFile(Constant.USER_PROFILE_FILE_UPLOAD));
			
			
			int heightCalculatedPercentage = originalImage.getHeight(); 
        	int widthCalculatedPercentage =	originalImage.getWidth();
            if(originalImage.getHeight() > Constant.MAX_USER_IMG_FILE_HEIGTH_SIZE){
            	while(heightCalculatedPercentage >= Constant.MAX_USER_IMG_FILE_HEIGTH_SIZE){
            		heightCalculatedPercentage = heightCalculatedPercentage - ((originalImage.getHeight()*1)/100);
            		widthCalculatedPercentage = widthCalculatedPercentage - ((originalImage.getWidth()*1)/100);
            	}
            }
            if(widthCalculatedPercentage > Constant.MAX_USER_IMG_FILE_WIDTH_SIZE){
            	while(widthCalculatedPercentage >= Constant.MAX_USER_IMG_FILE_WIDTH_SIZE){
            		heightCalculatedPercentage = heightCalculatedPercentage - ((originalImage.getHeight()*1)/100);
            		widthCalculatedPercentage = widthCalculatedPercentage - ((originalImage.getWidth()*1)/100);
            	}
            }
            int imageHeight = heightCalculatedPercentage;
            int imageWidth = widthCalculatedPercentage;
			
			
			int type = originalImage.getType() == 0 ? BufferedImage.TYPE_INT_ARGB
					: originalImage.getType();
			BufferedImage resizeImageJpg = CommonUtil.resizeImage(
					originalImage, type, imageWidth, imageHeight);
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			ImageIO.write(resizeImageJpg, ext, os);
			InputStream is = new ByteArrayInputStream(os.toByteArray());
			FileEntry test = TempFileUtil.addTempFile(
					themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
					getTempImageFileName(portletRequest),
					getTempImageFolderName(), is, contentType);

		} catch (NullPointerException e) {
			_log.info(e.getMessage());
		} finally {
			StreamUtil.cleanUp(inputStream);
		}
	}
	 
	 
	 
	protected FileEntry getTempImageFileEntry(PortletRequest portletRequest)
			throws PortalException, SystemException {

		ThemeDisplay themeDisplay = (ThemeDisplay) portletRequest
				.getAttribute(WebKeys.THEME_DISPLAY);

		return TempFileUtil.getTempFile(themeDisplay.getScopeGroupId(),
				themeDisplay.getUserId(), getTempImageFileName(portletRequest),
				getTempImageFolderName());
	}

	protected String getTempImageFileName(PortletRequest portletRequest) {
		ThemeDisplay themeDisplay = (ThemeDisplay) portletRequest
				.getAttribute(WebKeys.THEME_DISPLAY);
		return themeDisplay.getUserId()+StringPool.BLANK;
	}

	protected String getTempImageFolderName() {
		Class<?> clazz = getClass();
		return clazz.getName();
	}

	protected void saveTempImageFile(PortletRequest portletRequest, byte[] bytes)
			throws Exception {

		long userId = PortalUtil.getUserId(portletRequest);
		UserLocalServiceUtil.updatePortrait(userId, bytes);
	}
	
	protected void serveTempImageFile(MimeResponse mimeResponse,
			InputStream tempImageStream) throws Exception {

		ImageBag imageBag = ImageToolUtil.read(tempImageStream);

		byte[] bytes = ImageToolUtil.getBytes(imageBag.getRenderedImage(),
				imageBag.getType());

		String contentType = MimeTypesUtil.getExtensionContentType(imageBag
				.getType());
		
		mimeResponse.setContentType(contentType);
		mimeResponse.getWriter().write(Base64.encode(bytes));
	}

	

	protected RenderedImage getCroppedRenderedImage(
			RenderedImage renderedImage, int height, int width, int x, int y) {

		Rectangle rectangle = new Rectangle(width, height);

		Rectangle croppedRectangle = rectangle.intersection(new Rectangle(
				renderedImage.getWidth(), renderedImage.getHeight()));

		BufferedImage bufferedImage = ImageToolUtil
				.getBufferedImage(renderedImage);

		return bufferedImage.getSubimage(x, y, croppedRectangle.width,
				croppedRectangle.height);
	}
	
	private String getFileExtension(File file) {
	    String name = file.getName();
	    try {
	        return name.substring(name.lastIndexOf(StringPool.PERIOD)+1);

	    } catch (Exception e) {
	        return StringPool.BLANK;
	    }
	}
	
}
	

	

package com.nyu.portlet.header;

import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.awt.image.RenderedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.imageio.ImageIO;
import javax.portlet.MimeResponse;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.ServletException;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.liferay.portal.ImageTypeException;
import com.liferay.portal.NoSuchRepositoryException;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.image.ImageBag;
import com.liferay.portal.kernel.image.ImageToolUtil;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.repository.model.FileEntry;
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
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.documentlibrary.NoSuchFileEntryException;
import com.nyu.model.Slides;
import com.nyu.model.impl.SlidesImpl;
import com.nyu.service.SlidesLocalServiceUtil;
import com.nyu.util.CommonUtil;
import com.nyu.util.Constant;
import com.nyu.util.NyuUtil;

/**
 * Portlet implementation class HeaderPortlet
 */
@Controller
@RequestMapping(value = "VIEW")
public class HeaderController {
	
	
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(HeaderController.class);
	
	@RenderMapping
	public String view(RenderRequest request,RenderResponse response) throws SystemException, PortalException {
		PortletPreferences preferences=request.getPreferences();
		request.setAttribute(Constant.TAKE_VIDEO_URL, preferences.getValue(Constant.TAKE_VIDEO_URL, StringPool.BLANK));
		
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		//List<Slides> slides = null;
		List<Slides> slides = new ArrayList<Slides>();
		Slides sld = new SlidesImpl();
		String slideImg = null;
		JSONArray slidesJSONArray = JSONFactoryUtil.createJSONArray();
		try {
			
			slides = SlidesLocalServiceUtil.getSlideses(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
			
			if(slides!=null && slides.size()>0){
				for(Slides slide : slides){
					 JSONObject jsonSlideObject=JSONFactoryUtil.createJSONObject();
					 slideImg = CommonUtil.getDocumentPath(GetterUtil.getLong(slide.getId()),ClassNameLocalServiceUtil.getClassNameId(Slides.class),themeDisplay);
						if(slideImg==null)
							slideImg=themeDisplay.getPathThemeImages()+Constant.VENDOR_COMP_IMAGE_PLACEHOLDER_PNG;
					 //slideImg=themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER ;
					 jsonSlideObject.put(Constant.SLIDE_ID,slide.getId());
					 jsonSlideObject.put(Constant.COMMON_STRING_CONSTANT_DESCRIPTION,slide.getDescription()); 
					 jsonSlideObject.put(Constant.DESC_POSITION,slide.getDescPosition()); 
					 jsonSlideObject.put(Constant.IMAGE_LINK,slide.getImageLink());
					 jsonSlideObject.put(Constant.SLIDE_IMAGE,slideImg); 
					 slidesJSONArray.put(jsonSlideObject);
			    }
				
				 request.setAttribute(Constant.SLIDES_JSON_ARRAY, slidesJSONArray);
			}
			
		
		} catch (SystemException e) {
			LOG.error("[HeaderController: view() ]"+e);
		}
		
		return Constant.USER_PROFILE_VIEW_JSP;
	}
	
	@RenderMapping(params="action=uploadImage")
	public String uploadImage(RenderRequest request,RenderResponse response) throws PortalException, SystemException {
		return Constant.SLIDE_IMAGE;  
	}
	
	@RenderMapping(params="action=addEditSlide")
	public String addEditSlide(RenderRequest request,RenderResponse response) throws PortalException, SystemException {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long slideId = ParamUtil.getLong(request,Constant.SLIDE_ID,0l); 
		String description = StringPool.BLANK;
		String slideImg = themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER ;
		String slidePosition = StringPool.BLANK;
		String imageLink = StringPool.BLANK;
		boolean isEditSlide = false;
		if(slideId >0 ){
			Slides slide = SlidesLocalServiceUtil.getSlides(slideId);
			description = slide.getDescription();
			imageLink = slide.getImageLink();
			slidePosition = slide.getDescPosition();
			isEditSlide = true;
			slideImg = CommonUtil.getDocumentPath(GetterUtil.getLong(slide.getId()),ClassNameLocalServiceUtil.getClassNameId(Slides.class),themeDisplay);
			if(slideImg==null || slideImg.equals(StringPool.BLANK))
				slideImg=themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER ;
		}
		request.setAttribute(Constant.SLIDE_ID, slideId);
		request.setAttribute(Constant.SLIDE_DESCRIPTION,description);
		request.setAttribute(Constant.SLIDE_IMG,slideImg);
		request.setAttribute(Constant.SLIDE_POSITION,slidePosition);
		request.setAttribute(Constant.IS_EDIT_SLIDE,isEditSlide);
		request.setAttribute(Constant.IMAGE_LINK,imageLink);
		return Constant.SLIDE_JSP;  
	}
	
	@ResourceMapping(value="addSlide")  
	public void addSlide(ResourceRequest request, ResourceResponse response) throws IOException, PortalException, SystemException  {  
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		
		try {
				long slideId = addUpdateSlide(request, themeDisplay);

				if(slideId > 0){
					response.getWriter().write("update-success");
				}else{
					response.getWriter().write("add-success");
				}
				
		
		} catch (PortalException e) {
			LOG.error("[HeaderController: addSlide() ]"+e);
			response.getWriter().write("fail");
		} catch (SystemException e) {
			LOG.error("[HeaderController: addSlide() ]"+e);
			response.getWriter().write(CommonUtil.JavaClassI18N(request, themeDisplay, "fail"));
		}

	}
	
	@ResourceMapping(value="editSlide")  
	public void editSlide(ResourceRequest request,ResourceResponse response)  throws IOException, PortalException, SystemException  {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		long slideId = ParamUtil.getLong(request, Constant.SLIDE_ID);
		String slideImg = null;
		Slides slide = null;
		JSONObject jsonSlideObject=JSONFactoryUtil.createJSONObject();
		try {
			
			slide = SlidesLocalServiceUtil.getSlides(slideId);
			
			slideImg = CommonUtil.getDocumentPath(GetterUtil.getLong(slide.getId()),ClassNameLocalServiceUtil.getClassNameId(Slides.class),themeDisplay);
			if(Validator.isNull(slideImg)){
				slideImg =	themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER ;// TOO DOOOOOOOO
			}
			jsonSlideObject.put(Constant.SLIDE_ID,slide.getId());
			jsonSlideObject.put(Constant.COMMON_STRING_CONSTANT_DESCRIPTION,slide.getDescription()); 
			jsonSlideObject.put(Constant.DESC_POSITION,slide.getDescPosition()); 
			jsonSlideObject.put(Constant.SLIDE_IMAGE,slideImg);
			response.getWriter().write(jsonSlideObject.toString());
			
		} catch (PortalException e) {
			LOG.error("[HeaderController: editSlide() ]"+e);
		} catch (SystemException e) {
			LOG.error("[HeaderController: editSlide() ]"+e);
		} catch (IOException e) {
			LOG.error("[HeaderController: editSlide() ]"+e);
		}
		
	}
	
	@ResourceMapping(value="deleteSlide")
    public void deleteSlide(ResourceRequest request, ResourceResponse response) throws IOException  {
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
		long slideId = 0;
		String status= CommonUtil.JavaClassI18N(request, themeDisplay, "success");
		try {
			slideId = ParamUtil.getLong(request, Constant.SLIDE_ID);
			try {
				NyuUtil.deleteDLFileEntry(Slides.class, slideId);
			} catch (Exception exc) {
				LOG.error("[HeaderController: deleteSlide() ]"+exc);
			}
			SlidesLocalServiceUtil.deleteSlides(slideId);
			
		} catch (PortalException e) {
			status= CommonUtil.JavaClassI18N(request, themeDisplay, "fail");
			LOG.error("[HeaderController: deleteSlide() ]"+e);
		} catch (SystemException e) {
			status= CommonUtil.JavaClassI18N(request, themeDisplay, "fail");
			LOG.error("[HeaderController: deleteSlide() ]"+e);
		}
		
		response.getWriter().write(status);
		
	}
	

	private long addUpdateSlide(ResourceRequest request, ThemeDisplay themeDisplay) throws PortalException, SystemException {
		ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
		
		//File file=null;
		Slides slide = new SlidesImpl();
		Slides existingSlide;
		UploadPortletRequest uploadRequest = PortalUtil.getUploadPortletRequest(request);
		
		slide.setDescription(ParamUtil.getString(uploadRequest, Constant.COMMON_STRING_CONSTANT_DESCRIPTION));
		slide.setImageLink(ParamUtil.getString(uploadRequest, Constant.IMAGE_LINK));
		slide.setDescPosition(ParamUtil.getString(uploadRequest, Constant.OPTIONS_RADIOS));
		slide.setUpdatedDate(new Date(System.currentTimeMillis()));
		slide.setUpdatedBy(themeDisplay.getUserId());
		
		if(ParamUtil.getLong(uploadRequest, Constant.SLIDE_ID)>0){
			existingSlide = SlidesLocalServiceUtil.getSlides(ParamUtil.getLong(uploadRequest, Constant.SLIDE_ID));
			slide.setId(existingSlide.getId());
			slide.setCreatedDate(existingSlide.getCreatedDate());
			slide.setCreatedBy(existingSlide.getCreatedBy());
			slide = SlidesLocalServiceUtil.updateSlides(slide);
		}else{
			slide.setCreatedDate(new Date(System.currentTimeMillis()));
			slide.setCreatedBy(themeDisplay.getUserId());
			slide = SlidesLocalServiceUtil.addSlides(slide);
		}
		
		
		
		try {
					processCroppedLessonImg(request,uploadRequest,themeDisplay, serviceContext, slide);
				
			
		} catch (Exception e) {
			LOG.error("[HeaderController: addUpdateSlide() ]"+e);
		}
		
		return ParamUtil.getLong(uploadRequest, Constant.SLIDE_ID);
	}
	
	private void processCroppedLessonImg(ResourceRequest actionRequest, UploadPortletRequest request, ThemeDisplay themeDisplay,ServiceContext serviceContext, Slides slide) throws PortalException, SystemException, IOException {
		
		FileEntry croppedImage = getTempImageFileEntry(actionRequest);
		if(Validator.isNotNull(croppedImage)){
			String contentType = croppedImage.getMimeType();
			long classNameId = ClassNameLocalServiceUtil.getClassNameId(Slides.class);
			String thumbnailName = slide.getId()+Constant.CAPITAL_SLIDE_IMAGE;
			BufferedImage originalImage = ImageIO.read(croppedImage.getContentStream());
			int type = originalImage.getType() == 0? BufferedImage.TYPE_INT_ARGB : originalImage.getType();
			BufferedImage resizeImageJpg = CommonUtil.resizeImage(originalImage, type, 
													Constant.SlIDE_IMAGE_WIDTH, Constant.SLIDE_IMAGE_HEIGHT);
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			String extension = croppedImage.getMimeType();
			
			if(extension.contains(Constant.IMAGE)){
			    ImageIO.write(resizeImageJpg, extension.substring(extension.lastIndexOf(StringPool.FORWARD_SLASH) + 1), os);
			}else{
				ImageIO.write(resizeImageJpg, Constant.JPEG, os);
			}
			
			NyuUtil.saveLessonThumbnail(themeDisplay, serviceContext, slide.getId(),
					contentType, classNameId, thumbnailName, os, Constant.SLIDES_IMAGES, extension);
			try{
			TempFileUtil.deleteTempFile(
                    themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
                    getTempImageFileName(actionRequest), getTempImageFolderName());
			}catch(Exception e){
				LOG.error("[HeaderController: processCroppedLessonImg() ]"+e);
			}
			
			
		}
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
			LOG.error("[HeaderController: getTempPic() ]"+nsfee.getMessage());
		} catch (Exception e) {
			LOG.error("[HeaderController: getTempPic() ]"+e.getMessage());
		}
	}
	
	private String getFileExtension(File file) {
		String name = file.getName();
	    try {
	        return name.substring(name.lastIndexOf(StringPool.PERIOD)+1);

	    } catch (Exception e) {
	    	LOG.error("[HeaderController: getFileExtension() ]"+e.getMessage());
	        return StringPool.BLANK;
	    }
	}
	
	 protected void addTempImageFile(PortletRequest portletRequest)
	                     throws Exception {
	                     UploadPortletRequest uploadPortletRequest =
	                             PortalUtil.getUploadPortletRequest(portletRequest);
	     
	                     ThemeDisplay themeDisplay = (ThemeDisplay)portletRequest.getAttribute(
	                             WebKeys.THEME_DISPLAY);
	     
	                     String contentType = uploadPortletRequest.getContentType(Constant.USER_PROFILE_FILE_UPLOAD);
	     
	                     if (!MimeTypesUtil.isWebImage(contentType)) {
	                             throw new ImageTypeException();
	                     }
	     
	                     try {
	                             TempFileUtil.deleteTempFile(
	                                     themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
	                                     getTempImageFileName(portletRequest), getTempImageFolderName());
	                     }
	                     catch (Exception e) {
	                    	 LOG.error("[HeaderController: addTempImageFile() ]"+e.getMessage());
	                     }
	     
	                     InputStream inputStream = uploadPortletRequest.getFileAsStream(Constant.USER_PROFILE_FILE_UPLOAD);
	                   
	                     try {
	                    	             			
	                    	BufferedImage originalImage = ImageIO.read(inputStream);
	                    	String ext = getFileExtension(uploadPortletRequest.getFile(Constant.USER_PROFILE_FILE_UPLOAD));
	             			int imageHeight = originalImage.getHeight()>Constant.MAX_SLIDE_IMAGE_HEIGHT?Constant.MAX_SLIDE_IMAGE_HEIGHT:originalImage.getHeight();
	             			int imageWidth = originalImage.getWidth()>Constant.MAX_SLIDE_IMAGE_WIDTH?Constant.MAX_SLIDE_IMAGE_WIDTH:originalImage.getWidth();
	             			if(originalImage.getHeight() > originalImage.getWidth() &&  originalImage.getHeight()>Constant.MAX_SLIDE_IMAGE_HEIGHT){
	             				imageWidth = imageWidth >150?imageWidth - 150:imageWidth;
	             			}
	             			int type = originalImage.getType() == 0? BufferedImage.TYPE_INT_ARGB : originalImage.getType();
	             			BufferedImage resizeImageJpg =CommonUtil.resizeImage(originalImage, type,imageWidth, imageHeight);
	             			ByteArrayOutputStream os = new ByteArrayOutputStream();
	             			ImageIO.write(resizeImageJpg,ext, os);
	             			InputStream is = new ByteArrayInputStream(os.toByteArray());
	             			FileEntry test =  TempFileUtil.addTempFile(
							             themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
							             	getTempImageFileName(portletRequest), getTempImageFolderName(),
							             	is, contentType);
     
	                     }
	                     catch(NullPointerException e){
	                    	 LOG.error("[HeaderController: addTempImageFile() ]"+e.getMessage());
	                     }
	                     finally {
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
		return themeDisplay.getUserId()+Constant.LESSONS;
	}

	protected String getTempImageFolderName() {
		Class<?> clazz = getClass();
		return clazz.getName();
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

	@ResourceMapping(value = "saveImage")
	public void saveImage(ResourceRequest request, ResourceResponse response)
			throws SystemException, PortalException, IOException,
			ServletException {
		FileEntry tempFileEntry = null;
		//ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		InputStream tempImageStream = null;

		try {
			tempFileEntry = getTempImageFileEntry(request);

			tempImageStream = tempFileEntry.getContentStream();

			ImageBag imageBag = ImageToolUtil.read(tempImageStream);

			RenderedImage renderedImage = imageBag.getRenderedImage();
			String cropRegionJSON = ParamUtil.getString(request,Constant.COMMON_CROP_REGION);
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

			saveTempImageFile(request,response,bytes);
		} catch (NoSuchFileEntryException nsfee) {
			throw new UploadException(nsfee);
		} catch (NoSuchRepositoryException nsre) {
			throw new UploadException(nsre);
		} catch (Exception e) {
			LOG.error("[HeaderController: saveImage() ]"+e.getMessage());
		} finally {
			StreamUtil.cleanUp(tempImageStream);
		}
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
	
	

	protected void saveTempImageFile(PortletRequest portletRequest,ResourceResponse portletResponse, byte[] bytes)
			throws Exception {
		ThemeDisplay themeDisplay = (ThemeDisplay) portletRequest
				.getAttribute(WebKeys.THEME_DISPLAY);
		InputStream is = new ByteArrayInputStream(bytes);
		String contentType = StringPool.BLANK;
		try {
			contentType = getTempImageFileEntry(portletRequest).getMimeType();
            TempFileUtil.deleteTempFile(
                    themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
                    getTempImageFileName(portletRequest), getTempImageFolderName());
			}
	    catch (Exception e) {
	    	LOG.error("[HeaderController: saveTempImageFile() ]"+e.getMessage());
	    }
		FileEntry tempfileEntry = TempFileUtil.addTempFile(
                themeDisplay.getScopeGroupId(), themeDisplay.getUserId(),
                getTempImageFileName(portletRequest), getTempImageFolderName(),is,contentType);
		serveTempImageFile(portletResponse, tempfileEntry.getContentStream());
		
	}
	
	@ResourceMapping(value="deleteSlideImageURL")
	public void deleteSlideImage(ResourceRequest request,
			ResourceResponse response) throws IOException {
		ThemeDisplay themeDisplay = (ThemeDisplay) request
				.getAttribute(WebKeys.THEME_DISPLAY);
		long slideId = ParamUtil.getLong(request, Constant.SLIDE_ID);
		try {
			TempFileUtil.deleteTempFile(themeDisplay.getScopeGroupId(),
					themeDisplay.getUserId(), getTempImageFileName(request),
					getTempImageFolderName());
		} catch (Exception e) {
			LOG.error("[HeaderController: deleteSlideImage() ]"+e.getMessage());
			
		}
		try {
			NyuUtil.deleteDLFileEntry(Slides.class, slideId);
		} catch (Exception exc) {
			LOG.error("[HeaderController: deleteSlideImage() ]"+exc.getMessage());
		}
		response.getWriter().write(
				themeDisplay.getPathThemeImages()+StringPool.SLASH+Constant.CURRENT_OWNER+StringPool.SLASH+Constant.LESSON_CARD_PLACEHOLDER);
	}
	
}

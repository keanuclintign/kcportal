package com.nyu.util;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.net.URL;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.context.MessageSource;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.repository.model.FileEntry;
import com.liferay.portal.kernel.util.MimeTypesUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.model.Role;
import com.liferay.portal.service.ClassNameLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.documentlibrary.NoSuchFolderException;
import com.liferay.portlet.documentlibrary.model.DLFileEntry;
import com.liferay.portlet.documentlibrary.model.DLFolder;
import com.liferay.portlet.documentlibrary.service.DLAppLocalServiceUtil;
import com.liferay.portlet.documentlibrary.service.DLFileEntryLocalServiceUtil;
import com.liferay.portlet.documentlibrary.service.DLFolderLocalServiceUtil;
import com.nyu.model.Lesson;

public class NyuUtil {

	//static Logger LOGGER = LoggerFactory.getLogger(NyuUtil.class);
	private static org.apache.log4j.Logger LOGGER = org.apache.log4j.Logger.getLogger(NyuUtil.class);

	public static String getProperty( MessageSource messageSource, String key ) {
		return messageSource.getMessage( key, new Object[]{}, Locale.ENGLISH );
	}
	
	public static String getContextPath( HttpServletRequest request ){
		final String contextPath = StringUtils.substringBeforeLast( request.getRequestURL().toString(), StringPool.SLASH );
		LOGGER.info( "Context Path > " + contextPath );
		return contextPath;
	}
	
	public static String getPathFromUrl(){
		String path = null;
		final URL classPath = NyuUtil.class.getResource( Constant.SITTE_UTIL_CLASS );
		path = classPath.toString();
		path = StringUtils.removeStart( StringUtils.remove( path, Constant.FILE_COLON_SLASH ), Constant.JAR_COLON );
		path = StringUtils.substringBefore( path, StringUtils.contains( path, Constant.LIB) ? Constant.LIB : Constant.CLASSES_STRING );
		path = StringUtils.contains( path , ':') ? path : StringPool.SLASH + path;
		LOGGER.info("CLASS PATH FINAL: " + path );
		return path;
	}
	
	public static String getClassPath(){
		return StringUtils.substringBeforeLast( NyuUtil.getPathFromUrl() , Constant.WEB_INF_STRING );
	}
	
	public static String getFullPath( String pathToAppend ){
		final String path = getClassPath()  + pathToAppend;
		LOGGER.info("FULL PATH: " + path );
		return path;
	}
	
	/**
	 * To upload file to the document library in Liferay
	 * 
	 * @param file to accept File Object
	 * @param repositoryId to accept repositoryId
	 * @param folderName to accept folderName
	 * @return
	 */
	public static long uploadFile(Class classObj, long id, File file, long repositoryId, String folderName, String fileName, ServiceContext serviceContext) {
		
		LOGGER.info("Entering uploadFile...");
		long companyId = PortalUtil.getDefaultCompanyId();
		//Role roleUser;

		/*try {
			roleUser = RoleLocalServiceUtil.getRole(companyId,
					RoleConstants.POWER_USER);
			long roleId = roleUser.getRoleId();
			ResourcePermissionLocalServiceUtil.setResourcePermissions(
					companyId,
					"com.liferay.portlet.documentlibrary.model.DLFolder",
					ResourceConstants.SCOPE_COMPANY, ("" + companyId), roleId,
					new String[] { ActionKeys.VIEW });
			ResourcePermissionLocalServiceUtil.setResourcePermissions(
					companyId,
					"com.liferay.portlet.documentlibrary.model.DLFileEntry",
					ResourceConstants.SCOPE_COMPANY, ("" + companyId), roleId,
					new String[] { ActionKeys.VIEW });
		} catch (Exception e) {
			LOGGER.warn("Exception::"+e.getMessage());
		} */

/*		MimeTypes mimeType = MimeTypesUtil.getMimeTypes();
		String fileMimeType = mimeType.getContentType(file);
		byte[] imageBytes = null;
		try {
			imageBytes = FileUtil.getBytes(file);
		} catch (IOException e1) {
			e1.printStackTrace();
		}
        InputStream is = new ByteArrayInputStream(imageBytes);
*/
		FileEntry fileEntry = null;
		DLFileEntry dlFileEntry = null;
		try {
			LOGGER.info("file name in >>>>>>>>>>>>"+fileName+", file"+file);
			DLFolder dlFolder = null;
			try {
				dlFolder = DLFolderLocalServiceUtil.getFolder(repositoryId, 0l, folderName);
			} catch (NoSuchFolderException e) {
				dlFolder = DLFolderLocalServiceUtil.createDLFolder(CounterLocalServiceUtil.increment(DLFolder.class.getName()));
				dlFolder.setCompanyId(companyId);
				dlFolder.setRepositoryId(repositoryId);
				dlFolder.setGroupId(repositoryId);
				dlFolder.setParentFolderId(0l);
				dlFolder.setName(folderName);
				dlFolder.setUserId(serviceContext.getUserId());
				dlFolder = DLFolderLocalServiceUtil.addDLFolder(dlFolder);
			}
			
			long classNameId = ClassNameLocalServiceUtil.getClassNameId(classObj);
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(DLFileEntry.class);
			dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID, classNameId));
			dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_PK, id));
			List<DLFileEntry> dlFileEntries = DLFileEntryLocalServiceUtil.dynamicQuery(dynamicQuery);
			if(dlFileEntries!=null && dlFileEntries.size()>0){
				dlFileEntry = dlFileEntries.get(0);
				//DLFileEntryLocalServiceUtil.deleteDLFileEntry(dlFileEntry);
				fileEntry = DLAppLocalServiceUtil.updateFileEntry(serviceContext.getUserId(), 
						dlFileEntry.getFileEntryId(), fileName, MimeTypesUtil.getContentType(file), id+StringPool.UNDERLINE+classObj.getName()+StringPool.UNDERLINE+fileName,
	                    fileName, Constant.CHANGE_LOG, true, file, serviceContext);
			} else {
				fileEntry = DLAppLocalServiceUtil.addFileEntry(serviceContext.getUserId(), 
                    dlFolder.getRepositoryId(), dlFolder.getFolderId(), fileName, MimeTypesUtil.getContentType(file), id+StringPool.UNDERLINE+classObj.getName()+StringPool.UNDERLINE+fileName,
                    fileName, Constant.CHANGE_LOG, file, serviceContext);
				dlFileEntry = DLFileEntryLocalServiceUtil.getDLFileEntry(fileEntry.getFileEntryId());
				dlFileEntry.setClassName(classObj.getName());
				dlFileEntry.setClassNameId(classNameId);
				dlFileEntry.setClassPK(id);
				DLFileEntryLocalServiceUtil.updateDLFileEntry(dlFileEntry);
				file.delete();
			}

		} catch (Exception e) {
			LOGGER.info(e);
		}
		return fileEntry.getFileEntryId();
	}	
	
	public static void deleteDLFileEntry(Class classObj, long id){
		long classNameId = ClassNameLocalServiceUtil.getClassNameId(classObj);
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(DLFileEntry.class);
		dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID, classNameId));
		dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_PK, id));
		List<DLFileEntry> dlFileEntries;
		try {
			dlFileEntries = DLFileEntryLocalServiceUtil.dynamicQuery(dynamicQuery);
			if(dlFileEntries!=null && dlFileEntries.size()>0){
				DLFileEntry dlFileEntry = dlFileEntries.get(0);
				DLFileEntryLocalServiceUtil.deleteDLFileEntry(dlFileEntry);
			}
		} catch (SystemException e) {
			LOGGER.info(e);
		}
		
	}
	
	public static void saveLessonThumbnail(ThemeDisplay themeDisplay,
			ServiceContext serviceContext, long id, String contentType,
			long classNameId, String thumbnailName, ByteArrayOutputStream os, String folderName, String extension)
			throws PortalException, SystemException {
		DLFileEntry dlFileEntry;
		FileEntry fileEntry;
		DLFolder dlFolder = null;
		try {
			dlFolder = DLFolderLocalServiceUtil.getFolder(themeDisplay.getScopeGroupId(), 0l, folderName);
		} catch (NoSuchFolderException e) {
			dlFolder = DLFolderLocalServiceUtil.createDLFolder(CounterLocalServiceUtil.increment(DLFolder.class.getName()));
			dlFolder.setCompanyId(themeDisplay.getCompanyId());
			dlFolder.setRepositoryId(themeDisplay.getScopeGroupId());
			dlFolder.setGroupId(themeDisplay.getScopeGroupId());
			dlFolder.setParentFolderId(0l);
			dlFolder.setName(folderName);
			dlFolder.setUserId(serviceContext.getUserId());
			dlFolder = DLFolderLocalServiceUtil.addDLFolder(dlFolder);
		}
		DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(DLFileEntry.class);
		dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_NAME_ID, classNameId));
		dynamicQuery.add(RestrictionsFactoryUtil.eq(Constant.COMMON_STRING_CONSTANT_CLASS_PK, id));
		List<DLFileEntry> dlFileEntries = DLFileEntryLocalServiceUtil.dynamicQuery(dynamicQuery);
		if(dlFileEntries!=null && dlFileEntries.size()>0){
			dlFileEntry = dlFileEntries.get(0);
			fileEntry = DLAppLocalServiceUtil.updateFileEntry(serviceContext.getUserId(), 
					dlFileEntry.getFileEntryId(), thumbnailName, contentType, thumbnailName,
					thumbnailName, Constant.CHANGE_LOG, true, os.toByteArray(), serviceContext);
		} else {
		 fileEntry = DLAppLocalServiceUtil.addFileEntry(serviceContext.getUserId(), 
		        dlFolder.getRepositoryId(), dlFolder.getFolderId(), thumbnailName, contentType, thumbnailName,
		        thumbnailName, Constant.CHANGE_LOG, os.toByteArray(),serviceContext);
		dlFileEntry = DLFileEntryLocalServiceUtil.getDLFileEntry(fileEntry.getFileEntryId());
		dlFileEntry.setClassName(Lesson.class.getName());
		dlFileEntry.setClassNameId(classNameId);
		dlFileEntry.setClassPK(id);
		dlFileEntry.setExtension(extension);
		DLFileEntryLocalServiceUtil.updateDLFileEntry(dlFileEntry);
		}
	}
}

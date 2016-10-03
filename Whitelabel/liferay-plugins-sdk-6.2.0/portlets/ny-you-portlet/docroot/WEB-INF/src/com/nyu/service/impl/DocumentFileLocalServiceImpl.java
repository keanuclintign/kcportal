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

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.exception.SystemException;
import com.nyu.NoSuchDocumentFileException;
import com.nyu.model.DocumentFile;
import com.nyu.service.DocumentFileLocalServiceUtil;
import com.nyu.service.base.DocumentFileLocalServiceBaseImpl;
import com.nyu.util.PublishListener;

/**
 * The implementation of the document file local service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the {@link com.nyu.service.DocumentFileLocalService} interface.
 *
 * <p>
 * This is a local service. Methods of this service will not have security checks based on the propagated JAAS credentials because this service can only be accessed from within the same VM.
 * </p>
 *
 * @author Allwins Rajaiah
 * @see com.nyu.service.base.DocumentFileLocalServiceBaseImpl
 * @see com.nyu.service.DocumentFileLocalServiceUtil
 */
public class DocumentFileLocalServiceImpl
	extends DocumentFileLocalServiceBaseImpl {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never reference this interface directly. Always use {@link com.nyu.service.DocumentFileLocalServiceUtil} to access the document file local service.
	 */
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(DocumentFile.class);
	public DocumentFile getDocumentFile(long resourceId, long lessonId){
		try {
			return documentFilePersistence.findBydocumentFile(resourceId, lessonId);
		} catch (NoSuchDocumentFileException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SystemException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return null;
	}
	
	public List<DocumentFile> getDocumentExisting(long resourceId){
		List<DocumentFile> docFile = null;
		try {
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(DocumentFile.class);
			dynamicQuery.add(PropertyFactoryUtil.forName("downloadUrl").ne(""));
			dynamicQuery.add(PropertyFactoryUtil.forName("resourceId").eq(resourceId));
			docFile = DocumentFileLocalServiceUtil.dynamicQuery(dynamicQuery);
			//docFile = documentFilePersistence.findBydocumentExisting(resourceId);
		}catch (SystemException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		return docFile;
	}
	public List<DocumentFile> CheckResourceIdExist(long resourceId){
		List<DocumentFile> docFile = null;
		try {
			DynamicQuery dynamicQuery = DynamicQueryFactoryUtil.forClass(DocumentFile.class);
			dynamicQuery.add(PropertyFactoryUtil.forName("resourceId").eq(resourceId));
			docFile = DocumentFileLocalServiceUtil.dynamicQuery(dynamicQuery);
			//docFile = documentFilePersistence.findBydocumentExisting(resourceId);
		}catch (SystemException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		return docFile;
	}
	public List<DocumentFile> getDocumentFiles(long lessonId){
		//List<DocumentFile> docFile = null;
		try {
			
			return documentFilePersistence.findBydocumentFilesList(lessonId);
			//docFile = documentFilePersistence.findBydocumentExisting(resourceId);
		}catch (SystemException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		return null ;
	}
	
	public List<DocumentFile> getDocumentFilesByDocUuid(String docId,long lessonId){
		//List<DocumentFile> docFile = null;
		try {
			
			return documentFilePersistence.findBydocumentFilesListByDocUuid(docId,lessonId);
			//docFile = documentFilePersistence.findBydocumentExisting(resourceId);
		}catch (SystemException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		return null ;
	}
	
	public DocumentFile getDocumentFilesByReferenceId(String referenceId){
		//List<DocumentFile> docFile = null;
		try {
			return documentFilePersistence.findBydocumentFileListByOnlyDocUuid(referenceId);
			
		}catch (SystemException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		} catch (NoSuchDocumentFileException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null ;
	}
	
	public List<DocumentFile> findResourceDocumentsWithPermission(String resourceType,String status,String[] permission){
		try {
			return lessonFinder.findResourceDocumentsWithPermission(resourceType,status,permission);
		}catch (Exception e2) {
			e2.printStackTrace();
		}
		return null ;
	}
	
	public Set<Long> findResourceDocumentsIdsWithPermission(String resourceType,String[] permission,long lessonId){
		try {
			return lessonFinder.findResourceDocumentsIdsWithPermission(resourceType, permission,lessonId);
		}catch (Exception e2) {
			e2.printStackTrace();
		}
		return null ;
	}
	
	public List<DocumentFile> findResourceDocumentsBylessonIdAndStatus(long lessonId, String resourceType, String status){
		List<DocumentFile> documentFileList = null;
		try {
			documentFileList =  documentFilePersistence.findBydocumentFilesListByStatus(lessonId, resourceType, status);
		}catch (Exception e) {
			documentFileList = new ArrayList<DocumentFile>(0);
			LOG.error("[findResourceDocumentsByStatus]::::[" +e.getMessage()+"]");
		}
		return documentFileList ;
	}
	
	public List<DocumentFile> findResourceDocumentsBylessonIdAndType(long lessonId, String resourceType){
		List<DocumentFile> documentFileList = null;
		try {
			documentFileList = documentFilePersistence.findBydocumentFilesListByType(lessonId, resourceType);
		}catch (Exception e) {
			documentFileList = new ArrayList<DocumentFile>(0);
			LOG.error("[findResourceDocumentsByType]::::[" +e.getMessage()+"]");
		}
		return documentFileList;
	}
	
	public boolean isLessonIsPublishable(long lessonId, String resourceType,String status){
		boolean overAllStatus = false;
		long documentcountByStatus =0l;
		long documentcount =0l;
		try {
			documentcountByStatus = documentFilePersistence.countBydocumentFilesListByStatus(lessonId, resourceType, status);
			documentcount = documentFilePersistence.countBydocumentFilesListByType(lessonId, resourceType);
			if(documentcount == documentcountByStatus){
				overAllStatus = true;
			}
		}catch (Exception e) {
			LOG.error("[isLessonIsPublishable]::::[" +e.getMessage()+"]");
		}
		return overAllStatus;
	}
	
	public DocumentFile findDocumentFileByUuidAndResourceId(String docUuid,long resourceId){
		//List<DocumentFile> docFile = null;
		try {
			return documentFilePersistence.findBydocumentFileByUuidAndResourceId(docUuid, resourceId);		
		}catch (NoSuchDocumentFileException e) {
			LOG.info("[findDocumentFileByUuidAndResourceId]::[NoSuchDocumentFileException]::[" +e.getMessage()+"]");			
		}
		catch (Exception e) {
			LOG.error("[findDocumentFileByUuidAndResourceId]::[" +e.getMessage()+"]");		
		} 
		return null ;
	}
}
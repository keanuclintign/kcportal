package com.nyu.portlet.vo;

import java.util.List;

import com.nyu.model.LessonObjectives;

public class DocumentVO {
	
	String hasAutoTranscript;
	long resourceId;
	long sectionId;
	long documentId;
	String uploadText;
	String resourceImgUrl;
	String resourceDownloadUrl;
	String resourceTitle;
	String docUuid;
	String title;
	String embedText;
	String documentPath;
	String textContent;
	String type;
	List<LessonObjectives> lessonObjective;
	List<Long> objectiveIds;
	String ExistingObjIds;
	
	
	public String getExistingObjIds() {
		return ExistingObjIds;
	}
	public void setExistingObjIds(String existingObjIds) {
		ExistingObjIds = existingObjIds;
	}
	public String getHasAutoTranscript() {
		return hasAutoTranscript;
	}
	public void setHasAutoTranscript(String hasAutoTranscript) {
		this.hasAutoTranscript = hasAutoTranscript;
	}
	public long getResourceId() {
		return resourceId;
	}
	public void setResourceId(long resourceId) {
		this.resourceId = resourceId;
	}
	public String getDocUuid() {
		return docUuid;
	}
	public void setDocUuid(String docUuid) {
		this.docUuid = docUuid;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDocumentPath() {
		return documentPath;
	}
	public void setDocumentPath(String documentPath) {
		this.documentPath = documentPath;
	}
	public String getTextContent() {
		return textContent;
	}
	public void setTextContent(String textContent) {
		this.textContent = textContent;
	}
	
	public long getSectionId() {
		return sectionId;
	}
	public void setSectionId(long sectionId) {
		this.sectionId = sectionId;
	}
	public long getDocumentId() {
		return documentId;
	}
	public void setDocumentId(long documentId) {
		this.documentId = documentId;
	}
	public String getEmbedText() {
		return embedText;
	}
	public void setEmbedText(String embedText) {
		this.embedText = embedText;
	}
	public String getUploadText() {
		return uploadText;
	}
	public void setUploadText(String uploadText) {
		this.uploadText = uploadText;
	}
	public String getResourceImgUrl() {
		return resourceImgUrl;
	}
	public void setResourceImgUrl(String resourceImgUrl) {
		this.resourceImgUrl = resourceImgUrl;
	}
	public String getResourceTitle() {
		return resourceTitle;
	}
	public void setResourceTitle(String resourceTitle) {
		this.resourceTitle = resourceTitle;
	}
	public String getResourceDownloadUrl() {
		return resourceDownloadUrl;
	} 
	public void setResourceDownloadUrl(String resourceDownloadUrl) {
		this.resourceDownloadUrl = resourceDownloadUrl;
	}
	public List<LessonObjectives> getLessonObjective() {
		return lessonObjective;
	}
	public void setLessonObjective(List<LessonObjectives> lessonObjective) {
		this.lessonObjective = lessonObjective;
	}
	public List<Long> getObjectiveIds() {
		return objectiveIds;
	}
	public void setObjectiveIds(List<Long> objectiveIds) {
		this.objectiveIds = objectiveIds;
	}
	
	
}

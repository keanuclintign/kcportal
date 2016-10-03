package com.nyu.portlet.vo;

import java.util.List;

public class RequestLessonVO {
	
	long requestLessonId;
	long createdBy;
	long userId;
	long acceptedBy;
	long appreciateCount;
	boolean hasAppreciated = false;
	String appreciatedUserIds;
	String createdDate;
	String acceptedNote;
	String requestLessonName;
	String description;
	String userImage;
	String userName;
	String status;
	String statusValue;
	String publishStatusValue;
	List<CategoryTagsVO> categories;
	List<CategoryTagsVO> tags;
	List<MBMessageVO> mbMessages;
	
	public String getPublishStatusValue() {
		return publishStatusValue;
	}
	public void setPublishStatusValue(String publishStatusValue) {
		this.publishStatusValue = publishStatusValue;
	}
	public List<MBMessageVO> getMbMessages() {
		return mbMessages;
	}
	public void setMbMessages(List<MBMessageVO> mbMessages) {
		this.mbMessages = mbMessages;
	}
	public long getRequestLessonId() {
		return requestLessonId;
	}
	public void setRequestLessonId(long requestLessonId) {
		this.requestLessonId = requestLessonId;
	}
	public long getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(long createdBy) {
		this.createdBy = createdBy;
	}
	public long getUserId() {
		return userId;
	}
	public void setUserId(long userId) {
		this.userId = userId;
	}
	public long getAcceptedBy() {
		return acceptedBy;
	}
	public void setAcceptedBy(long acceptedBy) {
		this.acceptedBy = acceptedBy;
	}
	public long getAppreciateCount() {
		return appreciateCount;
	}
	public void setAppreciateCount(long appreciateCount) {
		this.appreciateCount = appreciateCount;
	}
	public String getCreatedDate() {
		return createdDate;
	}
	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}
	public String getAcceptedNote() {
		return acceptedNote;
	}
	public void setAcceptedNote(String acceptedNote) {
		this.acceptedNote = acceptedNote;
	}
	public String getRequestLessonName() {
		return requestLessonName;
	}
	public void setRequestLessonName(String requestLessonName) {
		this.requestLessonName = requestLessonName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getUserImage() {
		return userImage;
	}
	public void setUserImage(String userImage) {
		this.userImage = userImage;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public List<CategoryTagsVO> getCategories() {
		return categories;
	}
	public void setCategories(List<CategoryTagsVO> categories) {
		this.categories = categories;
	}
	public List<CategoryTagsVO> getTags() {
		return tags;
	}
	public void setTags(List<CategoryTagsVO> tags) {
		this.tags = tags;
	}
	
	public String getAppreciatedUserIds() {
		return appreciatedUserIds;
	}
	public void setAppreciatedUserIds(String appreciatedUserIds) {
		this.appreciatedUserIds = appreciatedUserIds;
	}
	public boolean isHasAppreciated() {
		return hasAppreciated;
	}
	public void setHasAppreciated(boolean hasAppreciated) {
		this.hasAppreciated = hasAppreciated;
	}
	public String getStatusValue() {
		return statusValue;
	}
	public void setStatusValue(String statusValue) {
		this.statusValue = statusValue;
	}

}

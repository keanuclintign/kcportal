package com.nyu.portlet.vo;

import java.util.List;

public class LessonVO {
	
		long lessonId;
		long authorId;
		String lessonName;
		String lessonFullName;
		String description;
		String userImage;
		String userName;
		String documentPath;
		long appreciateCount;
		long viewCount;
		String uploadedTime;
		String status;
		String privacyIcon;
		String hasCollaborator;
		List<CategoryTagsVO> categories;
		List<CategoryTagsVO> tags;
		String userGroupDocumentPath;
		String userGroupName;
		
		
		public String getUserGroupName() {
			return userGroupName;
		}
		public void setUserGroupName(String userGroupName) {
			this.userGroupName = userGroupName;
		}
		public String getUserGroupDocumentPath() {
			return userGroupDocumentPath;
		}
		public void setUserGroupDocumentPath(String userGroupDocumentPath) {
			this.userGroupDocumentPath = userGroupDocumentPath;
		}
		public String getStatus() {
			return status;
		}
		public void setStatus(String status) {
			this.status = status;
		}
		public String getDocumentPath() {
			return documentPath;
		}
		public void setDocumentPath(String documentPath) {
			this.documentPath = documentPath;
		}
		
		public String getUploadedTime() {
			return uploadedTime;
		}
		public void setUploadedTime(String uploadedTime) {
			this.uploadedTime = uploadedTime;
		}

		String thumbnail;
		public String getUserImage() {
			return userImage;
		}
		public void setUserImage(String userImage) {
			this.userImage = userImage;
		}
		public String getThumbnail() {
			return thumbnail;
		}
		public void setThumbnail(String thumbnail) {
			this.thumbnail = thumbnail;
		}
		public String getUserName() {
			return userName;
		}
		public void setUserName(String userName) {
			this.userName = userName;
		}
		public long getAppreciateCount() {
			return appreciateCount;
		}
		public void setAppreciateCount(long appreciateCount) {
			this.appreciateCount = appreciateCount;
		}
		public long getViewCount() {
			return viewCount;
		}
		public void setViewCount(long viewCount) {
			this.viewCount = viewCount;
		}
		public String getLessonName() {
			return lessonName;
		}
		public void setLessonName(String lessonName) {
			this.lessonName = lessonName;
		}
		public String getLessonFullName() {
			return lessonFullName;
		}
		public void setLessonFullName(String lessonFullName) {
			this.lessonFullName = lessonFullName;
		}
		public String getDescription() {
			return description;
		}
		public void setDescription(String description) {
			this.description = description;
		}
		public long getLessonId() {
			return lessonId;
		}
		public void setLessonId(long lessonId) {
			this.lessonId = lessonId;
		}
		public long getAuthorId() {
			return authorId;
		}
		public void setAuthorId(long authorId) {
			this.authorId = authorId;
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
		public String getPrivacyIcon() {
			return privacyIcon;
		}
		public void setPrivacyIcon(String privacyIcon) {
			this.privacyIcon = privacyIcon;
		}
		public String getHasCollaborator() {
			return hasCollaborator;
		}
		public void setHasCollaborator(String hasCollaborator) {
			this.hasCollaborator = hasCollaborator;
		}
		
}

package com.nyu.portlet.vo;

import java.util.List;

import com.nyu.portlet.vo.CategoryTagsVO;

public class GroupsVO {

		int memberSize;
		String groupName;
		String groupLongName;
		String description;
		String userImage;
		String userName;
		String documentPath;
		String label;
		String classes;
		String dataSub;
		String uploadedTime;
		long appreciateCount;
		long viewCount;
		long groupId;
		long authorId;
		long userID;
		boolean groupPrivacy;
		boolean administrator;

		List<CategoryTagsVO> categories;
		List<CategoryTagsVO> tags;
		
		
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
		
		public long getGroupId() {
			return groupId;
		}
		public void setGroupId(long groupId) {
			this.groupId = groupId;
		}
		public String getGroupName() {
			return groupName;
		}
		public void setGroupName(String groupName) {
			this.groupName = groupName;
		}
		public String getDescription() {
			return description;
		}
		public void setDescription(String description) {
			this.description = description;
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
		public int getMemberSize() {
			return memberSize;
		}
		public void setMemberSize(int memberSize) {
			this.memberSize = memberSize;
		}
		
		
		public String getLabel() {
			return label;
		}
		public void setLabel(String label) {
			this.label = label;
		}
		public String getClasses() {
			return classes;
		}
		public void setClasses(String classes) {
			this.classes = classes;
		}
		public String getDataSub() {
			return dataSub;
		}
		public void setDataSub(String dataSub) {
			this.dataSub = dataSub;
		}
		public boolean isGroupPrivacy() {
			return groupPrivacy;
		}
		public void setGroupPrivacy(boolean groupPrivacy) {
			this.groupPrivacy = groupPrivacy;
		}
		public long getUserID() {
			return userID;
		}
		public void setUserID(long userID) {
			this.userID = userID;
		}
		public boolean isAdministrator() {
			return administrator;
		}
		public void setAdministrator(boolean administrator) {
			this.administrator = administrator;
		}
		public String getGroupLongName() {
			return groupLongName;
		}
		public void setGroupLongName(String groupLongName) {
			this.groupLongName = groupLongName;
		}

		
}

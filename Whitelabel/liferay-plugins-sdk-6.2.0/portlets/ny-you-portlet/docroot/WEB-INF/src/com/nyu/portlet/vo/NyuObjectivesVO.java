package com.nyu.portlet.vo;

import java.util.Date;

import com.nyu.service.LessonObjectivesLocalServiceUtil;

public class NyuObjectivesVO {
	
	long lessonId;
	String lessonObjective;
	Date modifiedDate;
	long objectiveId;
	 
	public long getLessonId() {
		return lessonId;
	}
	public void setLessonId(long lessonId) {
		this.lessonId = lessonId;
	}
	public String getLessonObjective() {
		return lessonObjective;
	}
	public void setLessonObjective(String lessonObjective) {
		this.lessonObjective = lessonObjective;
	}
	public Date getModifiedDate() {
		return modifiedDate;
	}
	public void setModifiedDate(Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}
	public long getObjectiveId() {
		return objectiveId;
	}
	public void setObjectiveId(long objectiveId) {
		this.objectiveId = objectiveId;
	}
}

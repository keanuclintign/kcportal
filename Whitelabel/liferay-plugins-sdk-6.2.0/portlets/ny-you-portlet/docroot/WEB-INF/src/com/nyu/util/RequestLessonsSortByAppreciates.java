package com.nyu.util;

import java.util.Comparator;

import com.nyu.model.RequestLesson;
import com.nyu.util.CommonUtil;

public class RequestLessonsSortByAppreciates implements Comparator<RequestLesson>{
	
	public int compare(RequestLesson lsn1, RequestLesson lsn2)
	{
		int value=0;
		
		if( CommonUtil.getAppreciatedCount(lsn1.getAppreciatedUserIds()) > CommonUtil.getAppreciatedCount(lsn2.getAppreciatedUserIds()))
			value = 1;
		else if(CommonUtil.getAppreciatedCount(lsn1.getAppreciatedUserIds()) < CommonUtil.getAppreciatedCount(lsn2.getAppreciatedUserIds()))
			value = -1;
		else if(CommonUtil.getAppreciatedCount(lsn1.getAppreciatedUserIds()) == CommonUtil.getAppreciatedCount(lsn2.getAppreciatedUserIds()))
			value = 0;
		
		return value;
	}

}

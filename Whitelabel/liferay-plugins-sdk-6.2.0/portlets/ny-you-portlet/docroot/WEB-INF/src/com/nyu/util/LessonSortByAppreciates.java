package com.nyu.util;

import java.util.Comparator;

import com.nyu.model.Lesson;
import com.nyu.util.CommonUtil;

public class LessonSortByAppreciates implements Comparator<Lesson>{

	public int compare(Lesson lsn1, Lesson lsn2)
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

package com.nyu.util;

import java.util.Comparator;

import com.liferay.portal.model.User;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.nyu.model.Lesson;



public class LessonSortByusers  implements Comparator<Lesson> {
	
	public int compare(Lesson lesson1, Lesson lesson2)
	{
		int value=0;
		try{
			 value=UserLocalServiceUtil.getUser(lesson1.getCurrentAuthor()).getFirstName().compareToIgnoreCase(UserLocalServiceUtil.getUser(lesson2.getCurrentAuthor()).getFirstName());
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return value;
		
	}
	

}

package com.nyu.util;

import java.util.Comparator;
import com.nyu.model.Lesson;

public class LessonSortByTime  implements Comparator<Lesson> {
	
	public int compare(Lesson lesson1, Lesson lesson2){
		try{
			return lesson2.getUploadedTime().compareTo(lesson1.getUploadedTime());
		}catch(Exception e){
			return -1;
		}
	}

}

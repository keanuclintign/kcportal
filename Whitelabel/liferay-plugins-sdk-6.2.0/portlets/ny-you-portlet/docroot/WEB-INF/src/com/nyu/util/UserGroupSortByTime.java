package com.nyu.util;

import java.util.Comparator;

import com.liferay.portal.model.UserGroup;

public class UserGroupSortByTime implements Comparator<UserGroup> {
	
	public int compare(UserGroup group1, UserGroup group2)
	{
	  return group2.getModifiedDate().compareTo(group1.getModifiedDate());
	}

}

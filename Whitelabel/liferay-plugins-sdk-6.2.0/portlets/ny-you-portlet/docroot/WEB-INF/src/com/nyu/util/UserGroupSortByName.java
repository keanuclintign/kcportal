package com.nyu.util;

import java.util.Comparator;

import com.liferay.portal.model.UserGroup;

public class UserGroupSortByName implements Comparator<UserGroup> {
	
	public int compare(UserGroup group1, UserGroup group2)
	{
	  return group1.getName().compareToIgnoreCase(group2.getName());
	}

}

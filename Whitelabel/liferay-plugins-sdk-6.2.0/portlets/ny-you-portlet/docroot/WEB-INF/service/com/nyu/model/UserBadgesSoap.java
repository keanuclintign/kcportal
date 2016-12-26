/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.nyu.model;

import java.io.Serializable;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * This class is used by SOAP remote services.
 *
 * @author Allwins Rajaiah
 * @generated
 */
public class UserBadgesSoap implements Serializable {
	public static UserBadgesSoap toSoapModel(UserBadges model) {
		UserBadgesSoap soapModel = new UserBadgesSoap();

		soapModel.setUserBadgeId(model.getUserBadgeId());
		soapModel.setUserId(model.getUserId());
		soapModel.setBadgeId(model.getBadgeId());
		soapModel.setBadgeUrl(model.getBadgeUrl());
		soapModel.setCreatedDate(model.getCreatedDate());

		return soapModel;
	}

	public static UserBadgesSoap[] toSoapModels(UserBadges[] models) {
		UserBadgesSoap[] soapModels = new UserBadgesSoap[models.length];

		for (int i = 0; i < models.length; i++) {
			soapModels[i] = toSoapModel(models[i]);
		}

		return soapModels;
	}

	public static UserBadgesSoap[][] toSoapModels(UserBadges[][] models) {
		UserBadgesSoap[][] soapModels = null;

		if (models.length > 0) {
			soapModels = new UserBadgesSoap[models.length][models[0].length];
		}
		else {
			soapModels = new UserBadgesSoap[0][0];
		}

		for (int i = 0; i < models.length; i++) {
			soapModels[i] = toSoapModels(models[i]);
		}

		return soapModels;
	}

	public static UserBadgesSoap[] toSoapModels(List<UserBadges> models) {
		List<UserBadgesSoap> soapModels = new ArrayList<UserBadgesSoap>(models.size());

		for (UserBadges model : models) {
			soapModels.add(toSoapModel(model));
		}

		return soapModels.toArray(new UserBadgesSoap[soapModels.size()]);
	}

	public UserBadgesSoap() {
	}

	public long getPrimaryKey() {
		return _userBadgeId;
	}

	public void setPrimaryKey(long pk) {
		setUserBadgeId(pk);
	}

	public long getUserBadgeId() {
		return _userBadgeId;
	}

	public void setUserBadgeId(long userBadgeId) {
		_userBadgeId = userBadgeId;
	}

	public long getUserId() {
		return _userId;
	}

	public void setUserId(long userId) {
		_userId = userId;
	}

	public long getBadgeId() {
		return _badgeId;
	}

	public void setBadgeId(long badgeId) {
		_badgeId = badgeId;
	}

	public String getBadgeUrl() {
		return _badgeUrl;
	}

	public void setBadgeUrl(String badgeUrl) {
		_badgeUrl = badgeUrl;
	}

	public Date getCreatedDate() {
		return _createdDate;
	}

	public void setCreatedDate(Date createdDate) {
		_createdDate = createdDate;
	}

	private long _userBadgeId;
	private long _userId;
	private long _badgeId;
	private String _badgeUrl;
	private Date _createdDate;
}
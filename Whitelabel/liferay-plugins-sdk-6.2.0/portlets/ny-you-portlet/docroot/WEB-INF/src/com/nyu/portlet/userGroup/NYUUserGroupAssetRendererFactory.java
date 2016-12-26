package com.nyu.portlet.userGroup;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portlet.asset.model.AssetRenderer;
import com.liferay.portlet.asset.model.BaseAssetRendererFactory;
import com.nyu.model.NYUUserGroup;
import com.nyu.service.NYUUserGroupLocalServiceUtil;

public class NYUUserGroupAssetRendererFactory extends BaseAssetRendererFactory {

	@Override
	public AssetRenderer getAssetRenderer(long classPK, int type) throws PortalException, SystemException {
		NYUUserGroup nyuUserGroup = NYUUserGroupLocalServiceUtil.getNYUUserGroup(classPK);
		return new NYUUserGroupAssetRenderer(nyuUserGroup);
	}

	@Override
	public String getClassName() {
		return _CLASSNAME;
	}

	@Override
	public String getType() {
		return _LESSON;
	}

	private static final String _CLASSNAME = NYUUserGroup.class.getName();
	private static final String _LESSON = "NYUUserGroup";

}

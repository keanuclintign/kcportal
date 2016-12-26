package com.nyu.portlet.userGroup;

import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portlet.asset.model.AssetRendererFactory;
import com.liferay.portlet.asset.model.BaseAssetRenderer;
import com.nyu.model.NYUUserGroup;
import com.nyu.util.Constant;

import java.util.Locale;

import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

public class NYUUserGroupAssetRenderer extends BaseAssetRenderer{

	private NYUUserGroup _nyuUserGroup;
	
	public NYUUserGroupAssetRenderer(NYUUserGroup nyuUserGroup) {
		_nyuUserGroup = nyuUserGroup;
	}
	
	@Override
	public String getClassName() {
		return NYUUserGroup.class.getName();
	}

	@Override
	public long getClassPK() {
		return _nyuUserGroup.getPrimaryKey();
	}

	@Override
	public long getGroupId() {
		return _nyuUserGroup.getGroupId();
	}

	@Override
	public String getSummary(Locale locale) {
		return _nyuUserGroup.getAbout(locale);
	}

	@Override
	public String getTitle(Locale locale) {
		return _nyuUserGroup.getTitle(locale);
	}

	@Override
	public long getUserId() {
		return _nyuUserGroup.getCreatedBy();
	}

	@Override
	public String getUserName() {
		String username = null;
		try {
			username = UserLocalServiceUtil.getUser(_nyuUserGroup.getCreatedBy()).getFullName();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return username;
	}

	@Override
	public String getUuid() {
		return _nyuUserGroup.getUuid();
	}

	@Override
	public String render(RenderRequest request, RenderResponse response, String template) throws Exception {
		if (template.equals(TEMPLATE_FULL_CONTENT)) {
			request.setAttribute(Constant.COMMON_STRING_CONSTANT_USER_GROUPS,_nyuUserGroup);
			return "/WEB-INF/jsp/userGroup/asset_view.jsp";
		}else{
			return null;
		}
	}
	
	public int getAssetRendererType() {
		return AssetRendererFactory.TYPE_LATEST;
	}

}

package com.nyu.portlet.lessons;

import com.liferay.portal.kernel.portlet.LiferayPortletRequest;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.portlet.LiferayWindowState;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.service.LayoutLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.liferay.portlet.asset.model.AssetRendererFactory;
import com.liferay.portlet.asset.model.BaseAssetRenderer;
import com.nyu.model.Lesson;
import com.nyu.util.Constant;

import java.util.Locale;

import javax.portlet.PortletURL;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

public class LessonsAssetRenderer extends BaseAssetRenderer{

	private Lesson _lesson;
	
	public LessonsAssetRenderer(Lesson lesson) {
		_lesson = lesson;
	}
	
	@Override
	public String getClassName() {
		return Lesson.class.getName();
	}

	@Override
	public long getClassPK() {
		return _lesson.getPrimaryKey();
	}

	@Override
	public long getGroupId() {
		return _lesson.getGroupId();
	}

	@Override
	public String getSummary(Locale locale) {
		return _lesson.getDescription(locale);
	}

	@Override
	public String getTitle(Locale locale) {
		return _lesson.getLessonName(locale);
	}

	@Override
	public long getUserId() {
		return _lesson.getUploadedById();
	}

	@Override
	public String getUserName() {
		return _lesson.getUploadedByName();
	}

	@Override
	public String getUuid() {
		return _lesson.getUuid();
	}

	@Override
	public String render(RenderRequest request, RenderResponse response, String template) throws Exception {
		if (template.equals(TEMPLATE_FULL_CONTENT)) {
			request.setAttribute(Constant.LESSON, _lesson);
			return "/WEB-INF/jsp/viewlesson/asset_view.jsp";
		}else{
			return null;
		}
	}
	
	public double getVersion(){
		return _lesson.getVersion();
	}
	
	@Override
	public int getAssetRendererType() {
		if (_lesson.getVersion() == 0) {
			return AssetRendererFactory.TYPE_LATEST;
		} else {
			return AssetRendererFactory.TYPE_LATEST_APPROVED;
		}
	}
	
}

package com.nyu.portlet.lessons;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portlet.asset.model.AssetRenderer;
import com.liferay.portlet.asset.model.BaseAssetRendererFactory;
import com.nyu.model.Lesson;
import com.nyu.service.LessonLocalServiceUtil;

public class LessonsAssetRendererFactory extends BaseAssetRendererFactory {

	@Override
	public AssetRenderer getAssetRenderer(long classPK, int type) throws PortalException, SystemException {
		Lesson lesson = LessonLocalServiceUtil.getLesson(classPK);
		return new LessonsAssetRenderer(lesson);
	}

	@Override
	public String getClassName() {
		return _CLASSNAME;
	}

	@Override
	public String getType() {
		return _LESSON;
	}

	private static final String _CLASSNAME = Lesson.class.getName();
	private static final String _LESSON = "Lesson";

}

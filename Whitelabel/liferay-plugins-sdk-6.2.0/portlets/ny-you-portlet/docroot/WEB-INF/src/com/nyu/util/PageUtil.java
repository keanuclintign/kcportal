package com.nyu.util;

import java.util.List;
import java.util.Locale;

import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.model.Layout;
import com.liferay.portal.service.LayoutLocalServiceUtil;

public class PageUtil {
/*	public static long getPageLayoutId(long groupId, String pageName, Locale locale) {
		
		long plid = 0l;
		try {
			List<Layout> layouts = LayoutLocalServiceUtil.getLayouts(groupId, true);
			for (Layout layout: layouts) {
				if (layout.getName(locale).equalsIgnoreCase(pageName)) {
					plid = layout.getPlid();
					break;
				}
			}
		} catch (SystemException e) {
			e.printStackTrace();
		}
		
		return plid;
	}*/
}
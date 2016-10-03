package com.nyu.util;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RenderHelper {

	public static String renderPage(
			ServletContext servletContext, HttpServletRequest request,
			HttpServletResponse response, String path)
		throws IOException, ServletException {

		RequestDispatcher requestDispatcher =
			servletContext.getRequestDispatcher(path);

		DSGStringServletResponse stringResponse = new DSGStringServletResponse(
			response);

		requestDispatcher.include(request, stringResponse);

		return stringResponse.getString();
	}
}

package org.sakaiproject.esb.client.impl;

import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;

import javax.xml.rpc.ServiceException;

import org.sakaiproject.esb.client.api.MediaService;
import org.sakaiproject.esb.model.xsd.MediaMetaData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;

import com.liferay.util.portlet.PortletProps;
import com.nyu.util.NyuUtil;

// TODO: Auto-generated Javadoc
/**
 * The Class MediaServiceImpl.
 */
public class MediaServiceImpl implements MediaService {

	@Autowired
    private MessageSource messageSource;
	
	/** The media service. */
	private org.sakaiproject.esb.client.stubs.MediaService mediaService;
	
	
	public org.sakaiproject.esb.client.stubs.MediaService getMediaService() {
		return mediaService;
	}
	public void setMediaService(
			org.sakaiproject.esb.client.stubs.MediaService mediaService) {
		this.mediaService = mediaService;
	}
	
	/** The end point url. */
	/*private static String endPointUrl;
	static{
		endPointUrl = "https://services-dev.nyugts.com:9443/services/MediaService";
	}*/
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.esb.client.api.MediaService#addMedia(org.sakaiproject.esb.model.xsd.MediaMetaData[])
	 */
	@Override
	public String addMedia(MediaMetaData[] mediaMetaDataList)
			throws RemoteException {
		try {
			
			//return mediaService.getMediaServiceHttpSoap11Endpoint(new URL(NyuUtil.getProperty( messageSource, "media.service"))).addMedia(mediaMetaDataList);
			return mediaService.getMediaServiceHttpSoap11Endpoint(new URL(PortletProps.get("media.service"))).addMedia(mediaMetaDataList);
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	/* (non-Javadoc)
	 * @see org.sakaiproject.esb.client.api.MediaService#addMedia(org.sakaiproject.esb.model.xsd.MediaMetaData[])
	 */
	@Override
	public String removeMedia(MediaMetaData[] mediaMetaDataList)
			throws RemoteException {
		try {
			
			//return (mediaService.getMediaServiceHttpSoap11Endpoint(new URL(NyuUtil.getProperty( messageSource, "media.service")))).removeMedia(mediaMetaDataList);
			return (mediaService.getMediaServiceHttpSoap11Endpoint(new URL(PortletProps.get("media.service")))).removeMedia(mediaMetaDataList);
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}	
}

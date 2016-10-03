package org.sakaiproject.esb.client.impl;

import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;

import javax.xml.rpc.ServiceException;

import org.sakaiproject.esb.client.api.CDNService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;

import com.liferay.util.portlet.PortletProps;

// TODO: Auto-generated Javadoc
/**
 * The Class CDNServiceImpl.
 */
public class CDNServiceImpl implements CDNService {
	
	@Autowired
    private MessageSource messageSource;

	/** The cdn service. */
	private org.sakaiproject.esb.client.stubs.CDNService cdnService;

	public org.sakaiproject.esb.client.stubs.CDNService getCdnService() {
		return cdnService;
	}

	public void setCdnService(
			org.sakaiproject.esb.client.stubs.CDNService cdnService) {
		this.cdnService = cdnService;
	}

	/** The end point url. */
	/*private static String endPointUrl;
	static{
		endPointUrl = "https://services-dev.nyugts.com:9443/services/CDNService";
	}
	*/
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.esb.client.api.CDNService#getDomainName(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String getDomainName(java.lang.String distributionId, java.lang.String videoFileId, java.lang.String mediaType) throws RemoteException{
		try {
			//return cdnService.getCDNServiceHttpSoap11Endpoint(new URL(NyuUtil.getProperty( messageSource, "cdn.service"))).getDomainName(distributionId, videoFileId, mediaType);
			return cdnService.getCDNServiceHttpSoap11Endpoint(new URL(PortletProps.get("cdn.service"))).getDomainName(distributionId, videoFileId, mediaType);
		}catch (ServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}

}

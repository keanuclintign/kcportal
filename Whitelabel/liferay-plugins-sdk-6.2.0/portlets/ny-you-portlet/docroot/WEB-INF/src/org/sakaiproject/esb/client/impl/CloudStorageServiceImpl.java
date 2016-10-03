package org.sakaiproject.esb.client.impl;

import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;

import javax.xml.rpc.ServiceException;

import org.sakaiproject.esb.client.api.CloudStorageService;
import org.sakaiproject.esb.model.xsd.CloudStorageServiceClass_CloudStorageRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;

import com.liferay.util.portlet.PortletProps;
import com.nyu.util.NyuUtil;

// TODO: Auto-generated Javadoc
/**
 * The Class CloudStorageServiceImpl.
 */
public class CloudStorageServiceImpl implements CloudStorageService {
	
	@Autowired
    private MessageSource messageSource;
	
	/** The cloud storage service. */
	private org.sakaiproject.esb.client.stubs.CloudStorageService cloudStorageService;
	
	public org.sakaiproject.esb.client.stubs.CloudStorageService getCloudStorageService() {
		return cloudStorageService;
	}
	public void setCloudStorageService(
			org.sakaiproject.esb.client.stubs.CloudStorageService cloudStorageService) {
		this.cloudStorageService = cloudStorageService;
	}
	
	/** The end point url. */
	/*private static String endPointUrl;
	static{
		endPointUrl = "https://services-dev.nyugts.com:9443/services/CloudStorageService";
	}*/
	
	/* (non-Javadoc)
	 * @see org.sakaiproject.esb.client.api.CloudStorageService#listObjectsFromCloudStorage(org.sakaiproject.esb.model.xsd.CloudStorageServiceClass_CloudStorageRequest)
	 */
	@Override
	public String[] listObjectsFromCloudStorage(
			CloudStorageServiceClass_CloudStorageRequest request)
			throws RemoteException {
		// TODO Auto-generated method stub
		try {
			//return cloudStorageService.getCloudStorageServiceHttpSoap11Endpoint(new URL(NyuUtil.getProperty( messageSource, "cloudstorage.service"))).listObjectsFromCloudStorage(request);
			return cloudStorageService.getCloudStorageServiceHttpSoap11Endpoint(new URL(PortletProps.get("cloudstorage.service"))).listObjectsFromCloudStorage(request);
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
	 * @see org.sakaiproject.esb.client.api.CloudStorageService#putObjectsToCloudStorage(org.sakaiproject.esb.model.xsd.CloudStorageServiceClass_CloudStorageRequest)
	 */
	@Override
	public String putObjectsToCloudStorage(
			CloudStorageServiceClass_CloudStorageRequest request)
			throws RemoteException {
		// TODO Auto-generated method stub
		try {
			//return cloudStorageService.getCloudStorageServiceHttpSoap11Endpoint(new URL(NyuUtil.getProperty( messageSource, "cloudstorage.service"))).putObjectsToCloudStorage(request);
			return cloudStorageService.getCloudStorageServiceHttpSoap11Endpoint(new URL(PortletProps.get("cloudstorage.service"))).putObjectsToCloudStorage(request);
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
	 * @see org.sakaiproject.esb.client.api.CloudStorageService#putObjectToS3(java.lang.String)
	 */
	@Override
	public String putObjectToS3(String fileId) throws RemoteException {
		try {
			//return cloudStorageService.getCloudStorageServiceHttpSoap11Endpoint(new URL(NyuUtil.getProperty( messageSource, "cloudstorage.service"))).putObjectToS3(fileId);
			return cloudStorageService.getCloudStorageServiceHttpSoap11Endpoint(new URL(PortletProps.get("cloudstorage.service"))).putObjectToS3(fileId);
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
	 * @see org.sakaiproject.esb.client.api.CloudStorageService#deleteObjectsFromCloudStorage(org.sakaiproject.esb.model.xsd.CloudStorageServiceClass_CloudStorageRequest)
	 */
	@Override
	public String deleteObjectsFromCloudStorage(
			CloudStorageServiceClass_CloudStorageRequest request)
			throws RemoteException {
		try {
			//return cloudStorageService.getCloudStorageServiceHttpSoap11Endpoint(new URL(NyuUtil.getProperty( messageSource, "cloudstorage.service"))).deleteObjectsFromCloudStorage(request);
			return cloudStorageService.getCloudStorageServiceHttpSoap11Endpoint(new URL(PortletProps.get("cloudstorage.service"))).deleteObjectsFromCloudStorage(request);
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

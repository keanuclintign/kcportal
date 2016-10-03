package com.nyu.service.persistence;

import java.util.List;

import com.liferay.portal.kernel.bean.PortalBeanLocatorUtil;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.dao.orm.SQLQuery;
import com.liferay.portal.kernel.dao.orm.Session;
import com.liferay.portal.kernel.dao.orm.SessionFactory;
import com.liferay.portal.kernel.util.PortalClassLoaderUtil;
import com.liferay.portal.model.UserGroup;
import com.liferay.portal.service.persistence.impl.BasePersistenceImpl;
import com.liferay.util.dao.orm.CustomSQLUtil;

public class NYUUserGroupFinderImpl extends BasePersistenceImpl<com.liferay.portal.model.UserGroup> implements NYUUserGroupFinder{
	private static org.apache.log4j.Logger LOG = org.apache.log4j.Logger.getLogger(NYUUserGroupFinderImpl.class);
	
	public static final String FIND_USERGROUP_BY_TYPE = NYUUserGroupFinder.class.getName() +".findUserGroupByType";
	
	public List<UserGroup> findUserGroupByType(int start,int end) { 
		
		List<UserGroup> groups = null;
		// fetch liferay's session factory
		SessionFactory sessionFactory = (SessionFactory) PortalBeanLocatorUtil.locate("liferaySessionFactory");

		Session session = null;

		try {
		    // open session using liferay's session factory
		    session = sessionFactory.openSession();

	        String sql = CustomSQLUtil.get(FIND_USERGROUP_BY_TYPE);
	       
	        SQLQuery q = session.createSQLQuery(sql);
	        q.setCacheable(false);
	        q.addEntity("UserGroup", PortalClassLoaderUtil.getClassLoader().loadClass("com.liferay.portal.model.impl.UserGroupImpl"));
/*	        
	        Iterator itr = q.list(false).iterator();
		       
	        while (itr.hasNext()) { 
	        	Object data [] = (Object [])itr.next();
	        	groups.add(GetterUtil.getLong(data[1]));
	        }
*/	        groups = (List<UserGroup>) QueryUtil.list(q, getDialect(), start, end);

			if(null==groups || groups.isEmpty()){
				LOG.info("No Such NYU User Group Exists in the System");
			}
	    } catch (Exception e) {
	    	LOG.error("ERROR IN NYU User Group "+e.getStackTrace());
	        
	    } finally {
	    	
	    	 sessionFactory.closeSession(session);
	    }
	
	    return groups;
	}



}

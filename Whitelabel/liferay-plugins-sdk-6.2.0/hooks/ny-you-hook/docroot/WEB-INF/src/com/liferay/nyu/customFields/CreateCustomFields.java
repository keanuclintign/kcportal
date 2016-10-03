package com.liferay.nyu.customFields;
import com.liferay.portal.kernel.events.ActionException;
import com.liferay.portal.kernel.events.SimpleAction;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.model.ResourceConstants;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.RoleConstants;
import com.liferay.portal.security.permission.ActionKeys;
import com.liferay.portal.service.ResourcePermissionLocalServiceUtil;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portlet.expando.DuplicateTableNameException;
import com.liferay.portlet.expando.model.ExpandoColumn;
import com.liferay.portlet.expando.model.ExpandoColumnConstants;
import com.liferay.portlet.expando.model.ExpandoTable;
import com.liferay.portlet.expando.model.ExpandoTableConstants;
import com.liferay.portlet.expando.service.ExpandoColumnLocalServiceUtil;
import com.liferay.portlet.expando.service.ExpandoTableLocalServiceUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;
public class CreateCustomFields extends SimpleAction {

	public void run(String[] arg0) throws ActionException {
		
		long companyId = Long.parseLong(arg0[0]);
		
		String customEntrys[]=GetterUtil.getString(PropsUtil.get("custom.fields.Entry.types")).split(",");
		
		for(String entry:customEntrys)
		{
			ExpandoTable table = getTable(companyId,entry);
			
			String customFieldsVariables=GetterUtil.getString(PropsUtil.get("custom.fields.keys."+entry));
			String customFieldsVariablestypes=GetterUtil.getString(PropsUtil.get("custom.fields.types."+entry));
			
			String [] customFields=customFieldsVariables.split(",") ;
			String [] customFieldsTypes=customFieldsVariablestypes.split(",") ;
			
			int[] customFieldsTypeValues=new int[customFieldsTypes.length+1];
			int j=0;
			for(String customtype:customFieldsTypes)
			{
				customFieldsTypeValues[j]=getType(customtype);
				j++;
			}
						
			int i=0;
			for (String field : customFields) {
				try {
					ExpandoColumn column = ExpandoColumnLocalServiceUtil.addColumn(
							table.getTableId(), field,
							customFieldsTypeValues[i]);
					
					if( customFieldsTypes[i].equalsIgnoreCase("dropdown")){
							ExpandoColumnLocalServiceUtil.updateTypeSettings(column.getColumnId(),"index-type=0\ndisplay-type=selection-list\nhidden=0\nvisible-with-update-permission=0");
					}
					if( customFieldsTypes[i].equalsIgnoreCase("textbox")){
						ExpandoColumnLocalServiceUtil.updateTypeSettings(column.getColumnId(),"display-type=text-box\nhidden=0\nvisible-with-update-permission=0\nheight=105\nindex-type=1\nwidth=450");
					}
					if( customFieldsTypes[i].equalsIgnoreCase("checkbox")){
						ExpandoColumnLocalServiceUtil.updateTypeSettings(column.getColumnId(),"index-type=0\ndisplay-type=check-box\nhidden=0\nvisible-with-update-permission=0");
					}
					if( customFieldsTypes[i].equalsIgnoreCase("radiobutton")){
						ExpandoColumnLocalServiceUtil.updateTypeSettings(column.getColumnId(),"index-type=0\ndisplay-type=radio\nhidden=0\nvisible-with-update-permission=0");
					}
					
					Role role = RoleLocalServiceUtil.getRole(companyId, RoleConstants.POWER_USER);
					ResourcePermissionLocalServiceUtil.setResourcePermissions(companyId, ExpandoColumn.class.getName(),
					ResourceConstants.SCOPE_INDIVIDUAL, String.valueOf(column.getColumnId()), role.getRoleId(), new String[] { ActionKeys.VIEW, ActionKeys.UPDATE });
					
				} catch (PortalException e) {
					
				} catch (SystemException e) {
					
				}
				i++;
			}
		}
	}

	
	private ExpandoTable getTable(long companyId,String entry) {
		ExpandoTable table = null;
		String className="com.liferay.portal.model."+entry;
		try {
			table = ExpandoTableLocalServiceUtil.addTable(companyId,className, ExpandoTableConstants.DEFAULT_TABLE_NAME);
		} catch (PortalException e) {
			if (e instanceof DuplicateTableNameException) {
				
				try {
					table = ExpandoTableLocalServiceUtil.getTable(companyId,
							className, ExpandoTableConstants.DEFAULT_TABLE_NAME);
				} catch (PortalException e1) {
					
				} catch (SystemException e1) {
					
				}
			}
		} catch (SystemException e) {
			// TODO Auto-generated catch block
		}
		return table;
	}
	
	
	
	
	
	private int getType(String customType) {
		int type=0;
		
		if(customType.equalsIgnoreCase("String") || customType.equalsIgnoreCase("textbox"))
			type=ExpandoColumnConstants.STRING;
		
		if(customType.equalsIgnoreCase("boolean"))
			type=ExpandoColumnConstants.BOOLEAN;
		
		if(customType.equalsIgnoreCase("int"))
			type=ExpandoColumnConstants.INTEGER;
		
		if(customType.equalsIgnoreCase("long"))
			type=ExpandoColumnConstants.INTEGER;
		
		if(customType.equalsIgnoreCase("double")){
			type=ExpandoColumnConstants.DOUBLE;
		}
		
		if(customType.equalsIgnoreCase("date")){
			type=ExpandoColumnConstants.DATE;
		}
		
		if(customType.equalsIgnoreCase("dropdown") || customType.equalsIgnoreCase("checkbox") || customType.equalsIgnoreCase("radiobutton"))
			type=ExpandoColumnConstants.STRING_ARRAY;
		
		return type;
	}
	
	
}
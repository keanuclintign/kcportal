// CONFIRM MODAL
function confirmModal(messasge,obj){
	var flag;
	AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p> <b>'+messasge+'</b></p>', 
	  				centered: true,
	  				headerContent: null, 
	  				modal: true,
	  				width: 350,
	  				zIndex: 999,
	  				resizable: false,
	  				toolbars: {
	  					footer: [
	  					{
	  						label: 'Yes',
	  						on: {
	  							click: function() {
	  								flag = true; 
	  								$(obj).closest('.advanced-page').remove();	
	  								modal.hide();
	  								showSuccessAlert('Section deleted successfully.');
	  								 
	  							}
	  						}
	  					},
	  					{
	  						label: 'Cancel',
	  						on: {
	  							click: function() {
	  								flag =false; 
	  								modal.hide();
	  							}
	  						}
	  					}
	  					]
	  				}
	  			}
	  		).render();
	  	  	});
	
		return flag;	
}



function showValidationAlert(messasge){
	AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p><b>'+messasge+'</b></p>',
	  				centered: true,
	  				modal: true,
	  				width: 350,
	  				zIndex: 999,
	  				resizable: false,
	  				toolbars: {
	  					footer: [
	  					{
	  						label: 'Ok',
	  						on: {
	  							click: function() {
	  								modal.hide();
	  							}
	  						}
	  					}
	  					]
	  				}
	  			}
	  		).render();
	  	  	});
}

function showSuccessAlert(message){
	
	AUI().use(
	  		'aui-modal',
	  		function(Y) {
	  			var modal = new Y.Modal(
	  			{
	  				bodyContent: '<p><b>'+message+'</b></p>',
	  				centered: true,
	  				modal: true,
	  				width: 350,
	  				zIndex: 999,
	  				resizable: false,
	  				toolbars: {
	  					footer: [
	  					{
	  						label: 'Close',
	  						on: {
	  							click: function() {
	  								modal.hide();
	  							}
	  						}
	  					}
	  					]
	  				}
	  			}
	  		).render();
	  	  	});
}

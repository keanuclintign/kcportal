AUI().ready(

	/*
	This function gets loaded when all the HTML, not including the portlets, is
	loaded.
	*/

	function() {
	}
);

Liferay.Portlet.ready(

	/*
	This function gets loaded after each and every portlet on the page.

	portletId: the current portlet's id
	node: the Alloy Node object of the current portlet
	*/

	function(portletId, node) {
	}
);

Liferay.on(
	'allPortletsReady',

	/*
	This function gets loaded when everything, including the portlets, is on
	the page.
	*/

	function() {
	}
);
//SuccessPopup for all
function closePopupForAllWithSuccessMsg(msg){
    AUI().use(
      		'aui-modal',
      		function(Y) {
      			var modal = new Y.Modal(
      			{
      				bodyContent: '<p><b>'+msg+'</b></p>',
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


// SMARTPHONE NAVIGATION

	var pid = $('.navbar-static-top').data('namespace');
	//$('#'+pid+'navAccountControls').css('float','none');
	
	$('#'+pid+'navSiteNavigationNavbarBtn').on('click',function(){
		
		//$('#'+pid+'navAddControlsNavbarCollapse').toggleClass('open');
		$('#'+pid+'navAccountControlsNavbarCollapse').toggleClass('open');
		
	});

	$('#'+pid+'navAddControlsNavbarBtn').on('click',function(){ 

		//$('#'+pid+'navAddControlsNavbarCollapse').toggleClass('open');
		$('#'+pid+'navAccountControlsNavbarCollapse').removeClass('open');
	});

//NYU TOOLTIP	
YUI().ready(
		  'aui-tooltip',
		  function(Y) {
		    new Y.TooltipDelegate(
		      {
		        trigger: 'body .nyu-tooltip',
		        zIndex:1000,
		      }
		    );
		  }
		);
	
function tooltipOver(currentElement){
	if($(currentElement).hasClass('nyu-tooltip')){
		$('.tooltip').removeClass('tooltip-hidden');
		$('.tooltip div div').html($(currentElement).data('title'));
	}
}function tooltipOut(currentElement){
	if($(currentElement).hasClass('nyu-tooltip')){
		$('.tooltip').addClass('tooltip-hidden')
	}
}

//NYU Poller

AUI().use('aui-base','aui-delayed-task','liferay-poller',
		function(A) {
			Liferay.namespace('NyuPoller');
			Liferay.NyuPoller.Manager = {
				init: function(portletId) {
					var instance = this;
					Liferay.Poller.addListener(portletId, instance._onPollerUpdate, instance);
					console.log("initiated");
				},
	               
				_onPollerUpdate: function(response, chunkId) {
					console.log(response);
					var instance = this;
					var lessonArray=response.newlyPublishedList;
					var content = "<ul class='unstyled'>";
			        for(lesson in lessonArray){
			        	content = content+"<li class='alert alert-warning'>Lesson <strong>"+lessonArray[lesson].lessonName+"</strong> is "+ lessonArray[lesson].type +". To view lesson <a class='btn btn-link' href='"+lessonArray[lesson].lessonUrl+"/-/lessons/browse/"+lessonArray[lesson].lessonId+"'>click here</a></li>"
			        }
					content=content+"</ul>";
					
					if(response.newUserNotificationsCount >0){
						YUI().use(
						  'aui-modal',
						  function(Y) {
						    var modal = new Y.Modal(
						      {
						    	  bodyContent: content, centered: true,
									headerContent:'<Strong>You have a new notification:</Strong>', 
									modal: true,
									cssClass:'popup_alert',
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
						  }
						);
					}
				},
			};    
	    	 A.augment(Liferay.NyuPoller.Manager, A.Attribute, true);
	    	 Liferay.NyuPoller.Manager.init('lessons_WAR_nyyouportlet');
	});    

	


     


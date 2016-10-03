<div class="columns-2 container" id="main-content" role="main">
	<div class="portlet-column portlet-column-only" id="column-1">
			$processor.processColumn("column-1", "portlet-column-content portlet-column-content-first")
	</div>
	<div class="portlet-layout row-fluid">	
		<div class="portlet-column portlet-column-first span3" id="column-2">
			$processor.processColumn("column-2", "portlet-column-content portlet-column-content-first")
		</div>	
		<div class="portlet-column portlet-column-last span9" id="column-3"> 
			$processor.processColumn("column-3", "portlet-column-content portlet-column-content-last")
		</div>	
	</div>
</div> 
<%@page import="org.joda.time.LocalDate"%>

<%              
				String lastMonth=new LocalDate().minusMonths(1).monthOfYear().getAsText() + " " + new LocalDate().minusMonths(1).year().getAsText(); 
				
                int startPeriod = SocialCounterPeriodUtil.getStartPeriod(new LocalDate().minusMonths(1).dayOfMonth().withMinimumValue().toDateMidnight().getMillis());
                //int endPeriod = SocialCounterPeriodUtil.getEndPeriod(new LocalDate().minusMonths(1).dayOfMonth().withMaximumValue().toDateMidnight().getMillis());
                Map<Long,SocialActivityCounter> countributionValue=new LinkedHashMap<Long, SocialActivityCounter>();
				Map<Long,SocialActivityCounter>  participationValue=new LinkedHashMap<Long, SocialActivityCounter>(); 
				Map<Long,Long> sortedMap=new LinkedHashMap<Long,Long>();

                DynamicQuery dynamicQuery1 = DynamicQueryFactoryUtil.forClass(SocialActivityCounter.class);

                dynamicQuery1.add(RestrictionsFactoryUtil.eq("classNameId",new Long(10005)));

                dynamicQuery1.add(RestrictionsFactoryUtil.eq("name",SocialActivityCounterConstants.NAME_PARTICIPATION));

                dynamicQuery1.add(RestrictionsFactoryUtil.eq("startPeriod",startPeriod));

                //dynamicQuery1.add(RestrictionsFactoryUtil.ge("endPeriod", startPeriod));   
                //dynamicQuery1.add(RestrictionsFactoryUtil.le("endPeriod", endPeriod));   
                
                List<SocialActivityCounter> participationActivities = SocialActivityCounterLocalServiceUtil.dynamicQuery(dynamicQuery1);
                for(SocialActivityCounter activity:participationActivities){
                	
                	participationValue.put(activity.getClassPK(),activity);
                }
               
               %>
             
               <%
                DynamicQuery dynamicQuery2 = DynamicQueryFactoryUtil.forClass(SocialActivityCounter.class);

                dynamicQuery2.add(RestrictionsFactoryUtil.eq("classNameId",new Long(10005)));

                dynamicQuery2.add(RestrictionsFactoryUtil.eq("name",SocialActivityCounterConstants.NAME_CONTRIBUTION));

                dynamicQuery2.add(RestrictionsFactoryUtil.eq("startPeriod",startPeriod));

                //dynamicQuery2.add(RestrictionsFactoryUtil.ge("endPeriod", startPeriod));   
                //dynamicQuery2.add(RestrictionsFactoryUtil.le("endPeriod", endPeriod));   
                
                List<SocialActivityCounter> countributionActivities = SocialActivityCounterLocalServiceUtil.dynamicQuery(dynamicQuery2);
                for(SocialActivityCounter activity:countributionActivities){
                	
                	countributionValue.put(activity.getClassPK(),activity); 
                    }
                
             
                if(participationActivities.size()>=countributionActivities.size()){
                	for (long key : participationValue.keySet()) {
                		if(countributionValue.containsKey(key)){
                			long total=countributionValue.get(key).getCurrentValue()+participationValue.get(key).getCurrentValue();  
                			sortedMap.put(key,total);
                		}
                		else{
                			long total=participationValue.get(key).getCurrentValue(); 
                        	sortedMap.put(key,total);
                		}
                	}
                }
                else{
                	for (long key : countributionValue.keySet()) {
                		if(participationValue.containsKey(key)){
                			long total=countributionValue.get(key).getCurrentValue()+participationValue.get(key).getCurrentValue();  
                			sortedMap.put(key,total);
                		}
                		else{
                			long total=countributionValue.get(key).getCurrentValue() ; 
                        	sortedMap.put(key,total);
                		}
                	}
                	
                }
           
              
               List<Entry<Long, Long>> list = new LinkedList<Entry<Long, Long>>(sortedMap.entrySet());

                // Sorting the list based on values
                Collections.sort(list, new Comparator<Entry<Long,Long>>()
                {
                    public int compare(Entry<Long,Long> o1,Entry<Long,Long> o2)
                    {     int value=0;
                          if( o1.getValue() > o2.getValue())
                    			value = -1;
                    		else if(o1.getValue() <o2.getValue())
                    			value = 1;
                    		else if(o1.getValue()==o2.getValue())
                    			value = 0;
                          return value;
                    }
                });
				
                // Maintaining insertion order with the help of LinkedList
                Map<Long, Long> newsortedMap = new LinkedHashMap<Long, Long>();
                for (Entry<Long,Long> entry : list)
                {
                    newsortedMap.put(entry.getKey(), entry.getValue());
                }%>
                
				<div class="row-fluid">
					<a href="javascript:void(0);" class="clearfix" id="contributorToggle" style="text-decoration: none;">
						<h2 class="alert clearfix"> Top contributor(s) of the last month <%=lastMonth %>
							<i class="pull-right icon-chevron-down"></i>
						</h2>
					</a> 
					<div class="last-month-contribution">	
                <%
                int rank=1;
               for (long userId: newsortedMap.keySet()) {
            	   int contributionCurrentValue=0;
            	   int particpationCurrentValue=0;
            	   int contributionTotalValue=0;
            	   int particpationTotalValue=0;
            	   
            	   if(countributionValue.containsKey(userId) && participationValue.containsKey(userId)){
            	   			SocialActivityCounter contributionActivity=countributionValue.get(userId);
            	   			SocialActivityCounter particpationActivity=participationValue.get(userId); 
            	   			contributionCurrentValue= contributionActivity.getCurrentValue();
            	   			particpationCurrentValue=particpationActivity.getCurrentValue();
            	   			contributionTotalValue=contributionActivity.getTotalValue();
            	   			particpationTotalValue=particpationActivity.getTotalValue();
            			   
            	  
            	   } 
            	   else if(participationValue.containsKey(userId)){
            			SocialActivityCounter particpationActivity=participationValue.get(userId); 
            			particpationCurrentValue=particpationActivity.getCurrentValue();
            			particpationTotalValue=particpationActivity.getTotalValue();
            	   }
            	   else {
            		   SocialActivityCounter contributionActivity=countributionValue.get(userId);
            		   contributionCurrentValue= contributionActivity.getCurrentValue();
            		   contributionTotalValue=contributionActivity.getTotalValue();
            	   }%>
     <div class="span4 thumbnail-content">
	     <article class="lesson shadow">
			<a href="javascript:void(0)" onClick="authorLesson('<%=topContributorUrl%>','<%=userId%>')">
	     	<liferay-ui:user-display	userId="<%= userId %>"	userName=""></a>
	     		
			<div class="user-rank">
				<span class="statistics-label"><liferay-ui:message key="rank" />:</span> <%=rank++ %>
			</div>
	
			<div class="contribution-score">
				<span class="statistics-label"><liferay-ui:message key='contribution-score' />:</span> <%=contributionCurrentValue%>
	
				<c:if test="<%= showTotals %>">
					<span>(<liferay-ui:message key="total" />: <%= contributionTotalValue%>)</span>
				</c:if>
			</div>
	
			<div class="participation-score">
				<span class="statistics-label"><liferay-ui:message key='participation-score' />:</span> <%= particpationCurrentValue%>
	
				<c:if test="<%= showTotals %>">
					<span>(<liferay-ui:message key="total" />: <%= particpationTotalValue%>)</span>
				</c:if>
			</div> <!-- end participation-score -->
		
			</liferay-ui:user-display>
		</article>
     </div>    <!-- end span4 -->	
      
          <% }                  
          %>
          </div> <!-- end last-month-contribution  -->
      </div><!-- end row-fluid -->    
          
          <script>
          function authorLesson(url,id){
        		AUI().use('aui-base','liferay-portlet-url','aui-node', function(A) {
        			$.ajax({
        				url:url+'&p_p_resource_id=userLessons',
        		        type: 'GET',
        		        datatype:'html',
        		        data:{
        		        	_lessons_WAR_nyyouportlet_authorId:id,
        		        },
        		        success: function(data){
        		        	$("#hidden").hide();
        					$(".tab-content>.active").html(data);
        					$("#display-top-contributors-180").html(data);
        					$("#top-contributors-180").hide();
        					$("#display-top-contributors-180").show();
        					$('#display-top-contributors-180').find('.thumbnail-content').each(function(i,val){	    
        					    if(i%3 == 0) {  
        					      $(this).addClass('no-margin clearfix');
        					    }
        					});
        		        	
        				}
        		    }); 
        		});
        	  
        	}

				$(document).ready(function(){
					
					$('#top-contributors-180 .last-month-contribution').find('.thumbnail-content').each(function(i,val){	    
					    if(i%3 == 0) {  
					      $(this).addClass('no-margin clearfix');
					    }
					});
					
					
					$('#top-contributors-180 .thumbnail-content').find('img.avatar').addClass('img-circle');	
					// TOGGLE EFFECT FOR COLLECT MY BADGE
					
					$('#contributorToggle').next().hide();
					
					$('#contributorToggle').on('click',function(evt){
					  evt.preventDefault();
					  $(this).next().slideToggle();
					  
					  if( $(this).find('i.pull-right') ) {
					      $(this).find('i.pull-right').toggleClass('icon-chevron-up icon-chevron-down');
					  } 
					     
					}); 
				});
          </script>
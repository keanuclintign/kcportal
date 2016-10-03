var RADIAL_TREE_VIZ = RADIAL_TREE_VIZ || {};

RADIAL_TREE_VIZ = (function(){

    var styleColors = [ 'fd78bd', 'a186be', '662d91', '5ea95c', 'ffdd00', '6dcff6', 'd74d94', '46142e', 'f26d7d', '5dbab9', '80bb42', 'cacec2', 'f1b867', '003663', 'f5989d', 'cd6f3c', '00a99d', '2e5a59', 'fff799', 'fbaf5d', '003663', '052a24', 'fff799', 'fbaf5d', '007236', 'aa71aa', 'bbbb42', '9ac2b9', '1d3b56', 'f26c4f', 'ee3224', 'fed42a', '82ca9c', 'aaa6ce', '455870', '0b6e5f', '00aeef', '448ccb', '7b0046', 'c4d9ec']
    var colorSelector = 0;
    var colorIndex = [];
    var styleVal = 0;
    var userDataFilterCategory = 0;
    var attributeVal =[];
    var dataFilters = [];
    var dataFile='data-file-1';

    /****************************************
    ** Module:: Global Initialization
    *****************************************/
    var init = function(){
       // //console.log('basic page initializations');

        initColorFilter();
        evtHandler();
        initAttributeFilter();
        hideVizContext(); // hide all the the containers that are viz sensitive on document load
        loadData('INI');
        setHotkeys();
    };

    function loadData(id){
        var code = id.slice( 0,3 );
        //////console.log(code);
        // Added to display the block only when user hovers
        if( ! /^INI/.test( code ) )
        {
            $('#wrapper-details').css("display", "block" );
            $('#wrapper-details').css("background", "rgba(190, 215, 53, 0.77)" );
            $('#list-usersummary').css("display", "block" );
        }

        switch(code){
            case 'DF1':
                path = '/ny-you-portlet/data/data-file-1.json'
                break;
            case 'DF2':
                path = '/ny-you-portlet/data/data-file-2.json'
                break;
            case 'DF3':
                path = '/ny-you-portlet/data/data-file-3.json'
                break;
            case 'DF4':
                path = '/ny-you-portlet/data/data-file-4.json'
                break;
            default:
                path = '/ny-you-portlet/data/data-file-1.json'
        }

        jQuery.getJSON( path,
            function( data ) {
                jQuery.each( data,
                    function( key, val ) {
                        if ( val.id == id ) {
                            $( '#usersummary-name' ).html( val.displayname );
                            $( '#info' ).html( val.info);
                         }
                    }
                );
            }
        );
    }

    var hideVizContext = function(){
        jQuery('.context-viz').hide();
    }
    
    var initColorFilter = function(){
        jQuery('#data-filter-category li').each(function(){
            var colorVal = jQuery(this).attr('data-hue');
            colorIndex.push(colorVal);
        });

         ////console.log("colorIndex:", colorIndex);
    };

    var initAttributeFilter = function(){
        jQuery('#list-attributes li').each(function(){
            var attrVal = jQuery(this).attr('data-attribute');
            attributeVal.push(attrVal);
        });
        ////console.log("attributeVal:", attributeVal);
    };

    function resetClass(selector,c){
        selector.parent().children().each(function(){

                 if(jQuery(this).hasClass('active')){
                     jQuery(this).removeClass('active');
                 }
             });
    }

    function evtHandler(){
        jQuery('#data-filter-category li').click(function(){
            var getColorVal = jQuery(this).attr('data-hue');
            resetClass(jQuery(this), 'active');
            jQuery(this).addClass('active');

            colorSelector = getColorVal;
            //console.log("getColorVal" , getColorVal);
            //console.log("styleVal" , styleVal);
            triggerViz(colorSelector, styleVal);
        });

        jQuery('#list-dataFile li').click(function(){
            resetClass(jQuery(this), 'active');
            jQuery(this).addClass('active');
            //console.log("colorSelector: ",colorSelector);
            triggerViz(colorSelector, styleVal);
        });
    }

    var triggerViz = function(colorVal, styleVal){
        jQuery('#dataFilterCategorySelection').css({
            "background-color": "#" + colorVal
        });

        var getColorIndex = jQuery.inArray(colorVal, colorIndex);
        var dataFilterCategory = 0;
        //console.log("colorVal",colorVal);
        //console.log("getColorIndex:",getColorIndex);
        switch(true){

            case (getColorIndex>0 && getColorIndex<=10):
                dataFilterCategory = 0; // Data filter category 1
                break;
            case (getColorIndex>10 && getColorIndex<=20):
                dataFilterCategory = 1; // Data filter category 2

                break;
            case (getColorIndex>20 && getColorIndex<=40):
                dataFilterCategory = 2; // Data filter category 3
                break;
            default:
                //console.log("unknown data filter category");
        }
        userDataFilterCategory = dataFilterCategory;

        $("#dataFilterCategory").val(userDataFilterCategory);
        //console.log("userDataFilterCategory*********",$('#dataFilterCategory').val());

        d3Example(userDataFilterCategory, styleVal);

        renderDataFilters();

        var vizPos = jQuery('#wrapper-viz').offset();

        jQuery('.context-viz').show();
        jQuery('#wrapper-viz').fadeIn(4000);
    }

    function renderDataFilters(dataFilters, bStylesColors){
        //console.log("style colors:", styleColors);

        var styleContainer = jQuery('#list-dataFilter');
        styleContainer.html('');

        styleContainer.html('');
        var header =   jQuery('#styleHead');  
        header.html('');

        switch (userDataFilterCategory){
            case 0:
                var type="All";
                break;
            case 1:
                var type="[INSERT DATA FILTER CATEGORY 2]";
                break;
            case 2:
                var type="[INSERT DATA FILTER CATEGORY 3]";
                break;
            default:
                var type="";
        }

        header.append("");
        //console.log("bStyles: ",dataFilters);
        if (dataFilters && dataFilters.length > -1){
            for(var i=0; i < dataFilters.length; i++){
                var tempInsertElement =
                    '<li><span class="user-role-name">'                              +
                    dataFilters[i]                                                       +
                    '</span><span class="user-role-color" style="background-color:#' +
                    styleColors[bStylesColors[i]-1]                                  +
                    '">&nbsp;</span></li>';
                styleContainer.append(tempInsertElement);
            }
        }
    }

    function d3Example(colorVal, styleVal) {
        var w = 1000,
            h = 1000,
            rx = w / 2 - 150,
            ry = h / 2 - 150,
            m0,
            rotate = 0;

        var splines = [];

        var cluster = d3.layout.cluster()
            .size([360, ry - 120])
            .sort(function(a, b) { return d3.ascending(a.key, b.key); });

        var bundle = d3.layout.bundle();

        var line = d3.svg.line.radial()
            .interpolate("bundle")
            .tension(.85)
            .radius(function(d) { return d.y; })
            .angle(function(d) { return d.x / 180 * Math.PI; });

        // Chrome 15 bug: <http://code.google.com/p/chromium/issues/detail?id=98951>
        jQuery('#wrapper-viz').html('');
        var div = d3.select("#wrapper-viz");

        var svg = div.append("svg:svg")
            .attr("width", w)
            .attr("height", w)
            .append("svg:g")
            .attr("transform", "translate(" + (rx + 100) + "," + (ry + 100)+ ")");

        svg.append("svg:path")
            .attr("class", "arc")
            .attr("d", d3.svg.arc().outerRadius(ry - 120).innerRadius(0).startAngle(0).endAngle(2 * Math.PI))
            .on("mousedown", mousedown);

        //Initialising dataFileChoice
        dataFile =  jQuery("#list-dataFile li.active").attr('data-dataFile');
        filename = '/ny-you-portlet/data/'+dataFile+'.json';
        //console.log("filename",filename);
        d3.json(filename, function(error, json){
            var nodes = cluster.nodes(packages.root(json)),
                  links = packages.imports(nodes),
                  splines = bundle(links);

            var path = svg.selectAll("path.link")
                  .data(links)
                .enter().append("svg:path")
                  .attr("class", function(d) { return "link source-" + d.source.key + " target-" + d.target.key; })
                  .attr("stroke", function(d,i){
                          return '#' + styleColors[d.source.style_color - 1];
                     })
                  .attr("d", function(d, i) { return line(splines[i]); });

            var label = svg.selectAll("g.node")
                              .data(nodes.filter(function(n) { return !n.children; }))
                        .enter().append("svg:g")
                              .attr("class", "node")
                              .attr("id", function(d) { return "node-" + d.key; })

                              .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")"; });

            label.append("circle")
                .attr("cx", 0)
                .attr("cy", 0)
                .attr("fill", function(d,i){
                    return '#' + styleColors[d.style_color - 1];
                })
                .attr("opacity", 1.0)
                .attr("r", function(d,i){ 
                    return Math.round( Math.pow( d.number_of_views, 1/2.7 ) );
                })
                .append( 'svg:title' )
                    .text(
                        function( d ) {
                            return '# views: ' + d.number_of_views;
                        }
                    );

            label.append("svg:text")
              .attr("dx", function(d) { return d.x < 180 ? 30 : -30; })
              .attr("dy", "0.31em")
              .attr("font-size", function(d,i){
                  textSize = 1.2;
                  return textSize + 'em';
              })
              .attr("fill", function(d,i){
                  return '#' + styleColors[d.style_color - 1];
              })
              .attr("item-id", function(d,i){
                  return d.id;
              })
              .attr("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; })
              .attr("transform", function(d) { return d.x < 180 ? null : "rotate(180)"; })
              .text(function(d) {
                      var name = d.displayname;
                      if(name.length > 20){
                          name = d.displayname.slice(0, 19);

                          name = name + '...';
                      }

                      return name;
                 })
             
              .on("mouseover", function(d,i){
                  //console.log("style color:", d.id);

                  loadData(d.id);

                  mouseover(d,i);
              })
              .on("mouseout", mouseout)
              .on("click", navigateLink)
              .append( 'svg:title' )
                  .text(
                    function(d){
                      return d.role + ': ' + d.displayname;
                    }
                  );
    });

        function mouse(e) {
          return [e.pageX - rx, e.pageY - ry];
        }

        function mousedown() {
          m0 = mouse(d3.event);
          d3.event.preventDefault();
        }

        function mousemove() {
          if (m0) {
            var m1 = mouse(d3.event),
                dm = Math.atan2(cross(m0, m1), dot(m0, m1)) * 180 / Math.PI;
            div.style("-webkit-transform", "translate3d(0," + (ry - rx) + "px,0)rotate3d(0,0,0," + dm + "deg)translate3d(0," + (rx - ry) + "px,0)");
          }
        }

        function mouseup() {
          if (m0) {
            var m1 = mouse(d3.event),
                dm = Math.atan2(cross(m0, m1), dot(m0, m1)) * 180 / Math.PI;

            rotate += dm;
            if (rotate > 360) rotate -= 360;
            else if (rotate < 0) rotate += 360;
            m0 = null;

            div.style("-webkit-transform", "rotate3d(0,0,0,0deg)");

            svg
                .attr("transform", "translate(" + rx + "," + ry + ")rotate(" + rotate + ")")
              .selectAll("g.node text")
                .attr("dx", function(d) { return (d.x + rotate) % 360 < 180 ? 30 : -30; })
                .attr("text-anchor", function(d) { return (d.x + rotate) % 360 < 180 ? "start" : "end"; })
                .attr("transform", function(d) { return (d.x + rotate) % 360 < 180 ? null : "rotate(180)"; });
          }
        }

        var pathOriginalColor = '';

        function mouseover(d) {
            jQuery('#wrapper-viz').addClass('chordhover');
            svg.selectAll("path.link.target-" + d.key)
                  .classed("target", true)
                  .each(updateNodes("source", true));

            svg.selectAll("path.link.source-" + d.key)
                  .classed("source", true)
                  .each(updateNodes("target", true));
            
            jQuery('.node:hover').css('cursor','default');
            
            if(d.href.length>0)
            	{
            	jQuery('.node:hover').css('cursor','pointer');
            	}
        }

        function mouseout(d) {
          jQuery('#wrapper-viz').removeClass('chordhover');


          svg.selectAll("path.link.source-" + d.key)
              .classed("source", false)
              .each(updateNodes("target", false));

          svg.selectAll("path.link.target-" + d.key)
              .classed("target", false)
              .each(updateNodes("source", false));
        }
        
        function navigateLink(d) {
        	if(d.href.length>0)
        		{
        		window.open(d.href,"_blank");
        		}
        }
        
        function updateNodes(name, value) {
          return function(d) {
            if (value) this.parentNode.appendChild(this);
            svg.select("#node-" + d[name].key).classed(name, value);
          };
        }

        function cross(a, b) {
          return a[0] * b[1] - a[1] * b[0];
        }

        function dot(a, b) {
          return a[0] * b[0] + a[1] * b[1];
        }

    };

    function setHotkeys() {
        $( document ).bind( 'keydown', 'alt+1', function () {
            $( '[ data-dataFile = "data-file-1" ]' ).click();
        } );

        $( document ).bind( 'keydown', 'alt+2', function () {
            $( '[ data-dataFile = "data-file-2" ]' ).click();
        } );

        $( document ).bind( 'keydown', 'alt+3', function () {
            $( '[ data-dataFile = "data-file-3" ]' ).click();
        } );

        $( document ).bind( 'keydown', 'alt+4', function () {
            $( '[ data-dataFile = "data-file-4" ]' ).click();
        } );
    }

    function keyify( string ) {
        return string.replace( ' ', '' );
    }

    return {
        'init' : init,
        'colorSelector' : colorSelector,
        'userDataFilterCategory' : userDataFilterCategory,
        'dataFilters': dataFilters,
        'renderDataFilters' : renderDataFilters,
        'keyify' : keyify
    };

})();

jQuery(document).ready(function(){
    RADIAL_TREE_VIZ.init()
   $( '[ data-dataFile = "data-file-1" ]' ).click();
});



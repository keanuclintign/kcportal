(function() {
  packages = {

    // Lazily construct the package hierarchy from class names.
    root: function(classes) {
      var map = {};

      //console.log("classes", classes);
      var userDataFilterCategory= $('#dataFilterCategory').val();
     // console.log("userDataFilterCategory in packages.js",userDataFilterCategory);
      var filteredClasses = [];
      var dataFilters = [];
      var dataFiltersColors = [];

       for (var i=0; i< classes.length; i++){

        if (userDataFilterCategory == 0){
          // Data filter group 1
          filteredClasses.push(classes[i]);
          var newFilter = classes[i].role;
          if(dataFilters.indexOf(newFilter) === -1){
            dataFilters.push(newFilter);
            dataFiltersColors.push(classes[i].style_color);
          }
        }

        // Not being used yet
        if(userDataFilterCategory == 1){
          // Data filter group 2
        }
        if(userDataFilterCategory == 2){
          // Data filter group 3
        }
      }

      RADIAL_TREE_VIZ.renderDataFilters(dataFilters, dataFiltersColors);

      function find( name, data ) {
        var node = map[ name ],
            // Is this function being called on an actual data record, or is this a
            // rollup category?
            isRecord = data ? true : false;

        if ( ! node ) {
          if ( isRecord ) {
              node = data;
          } else {
              // This is a rollup category that needs to be initialized
              node = { name: name, children: [] };
          }

          map[ name ] = node;

          if ( name.length ) {
            if ( isRecord ) {
                node.parent = find( node.role );
            } else {
                node.parent = find( '' );
            }
            node.parent.children.push( node) ;
            node.key = RADIAL_TREE_VIZ.keyify( name );
          }
        }
        return node;
      }

      filteredClasses.forEach(function(d) {
        find(d.name, d);
      });

      return map[""];
    },

    // Return a list of imports for the given array of nodes.
    imports: function(nodes) {
      var map = {},
          imports = [];

      // Compute a map from name to node.
      nodes.forEach(function(d) {
        map[d.name] = d;
      });

      // For each import, construct a link from the source to target node.
      nodes.forEach(function(d) {
        if (d.related) d.related.forEach(function(i) {
          imports.push({source: map[d.name], target: map[i]});
        });
      });

      return imports;
    }

  };
})();

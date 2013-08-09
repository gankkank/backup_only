    $(document).ready(function() {
      $('#typeahead').typeahead({
        minLength: 2,
        source: function (query, process) { 
          var srcObj = $.get('/users/search_fin', { query: query }, function (data) { return process(data.split(",")); });
          return srcObj;
        }
      });
      $("[data-provide='typeahead']").blur(function(e) {
        if ($('.dropdown-menu').is(":visible")) {
          $(this).data('typeahead').click(e);
        }
      });
      $("[data-provide='typeahead2']").blur(function(e) {
        if ($('.dropdown-menu').is(":visible")) {
          $(this).data('typeahead').click(e);
        }
      });
      $('#typeahead2').typeahead({
        source: function (query, process) { 
          var srcObj2 = $.get('/users/search_fin', { query: query }, function (data) { return process(data.split(",")); });
          return srcObj2;
        }
      });
      $( "#datepicker" ).datepicker({ startDate: '-1d' })
        .on('changeDate', function (ev) {
          $(this).datepicker('hide');
      }); 
      $( "#datepicker1" ).datepicker({ startDate: '-0d'})
        .on('changeDate', function (ev) {
          $(this).datepicker('hide');
      }); 
    });



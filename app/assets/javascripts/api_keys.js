

jQuery(function() {
  return $('#api_key_user_email').autocomplete({
    source: function( request, response ) {
      $.ajax({
          dataType: "json",
          type : 'Get',
          url: $('#api_key_user_email').data('autocomplete-source'),
          data: request,
          success: function(data) {
            response( $.map( data, function(item) {
              return item.email;
            }));
          },
          error: function(data) {
            response([]);
          }
      });
    },
    messages: {
        noResults: '',
        results: function() {}
    },
    minLength: 3,

  });
});
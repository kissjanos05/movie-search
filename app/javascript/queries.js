$(document).ready(function(){

  var movieSearch = function(url) {
    $.ajax({
      url: url,
      type: 'GET',
      dataType: 'TEXT',
      beforeSend: function() {
        $('#search-submit-text').text('Wait for response...')
        $('#search-spinner').removeClass('visually-hidden')
      },
      success: function(response){
        $('#results').html(response)
        $("#search-collapse").collapse(true);
      },
      error: function(response) {
        $('#results').html(response.responseText)
      },
      complete: function() {
        $('#search-submit-text').text('Search')
        $('#search-spinner').addClass('visually-hidden')
        $('#search-submit').attr('disabled', false)
      }
    })
  }

  $('body').on('click', '#search-submit', function(e) {
    let url = Routes.movies_search_path({ query:$('#search-input').val() })

    e.preventDefault()
    $("#search-collapse").collapse(false);
    $(this).attr('disabled', true)
    movieSearch(url)
  }) 

  $('body').on('click', 'ul#movies-paginator > li > a', function(e) {
    e.preventDefault()
    movieSearch($(this).attr('href'))
  })

})

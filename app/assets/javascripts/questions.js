$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  });
  $('.voting').on('ajax:success', function(e){
    console.log(e);
    var rating = e.detail[0]
    $('.rating').text(rating.rating)
  });
});

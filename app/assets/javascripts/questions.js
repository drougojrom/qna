$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  });
  $('.voting').on('ajax:success', function(e){
    var rating = e.detail[0];
    $('.rating').text("The questions rating is " + rating.rating);
  });
});

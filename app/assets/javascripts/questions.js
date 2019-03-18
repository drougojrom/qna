$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  });
  $('.voting').on('ajax:success', function(e){
    var vote = e.detail[0];
    var rating = vote.rating;
    $('.rating').text("The questions rating is " + rating);
    vote.vote_for ? $(vote.vote_for_id).removeClass('disabled') : $(vote.vote_for_id).addClass('disabled') 
    vote.vote_against ? $(vote.vote_against_id).removeClass('disabled') : $(vote.vote_against_id).addClass('disabled') 
    vote.vote_revoke ? $(vote.vote_revoke_id).removeClass('disabled') : $(vote.vote_revoke_id).addClass('disabled') 
  });
});

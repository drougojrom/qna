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
    var voteClass = vote.class
    var vote_for_id = "#vote_for_" + voteClass + "_" + vote.id
    var vote_against_id = "#vote_against_" + voteClass + "_" + vote.id
    var vote_revoke_id = "#vote_revoke_" + voteClass + "_" + vote.id

    vote.vote_for ? $(vote_for_id).removeClass('disabled') : $(vote_for_id).addClass('disabled') 
    vote.vote_against ? $(vote_against_id).removeClass('disabled') : $(vote_against_id).addClass('disabled') 
    vote.vote_revoke ? $(vote_revoke_id).removeClass('disabled') : $(vote_revoke_id).addClass('disabled') 
    
    $('.' + voteClass + '_rating').text("The " + voteClass + "s rating is " + rating);
  });
});

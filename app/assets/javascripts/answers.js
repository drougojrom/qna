$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('form.new_answer').on('ajax:success', function(e){
    var answer = e.detail[0];
  }).on('ajax:error', function(e){
    var errors = e.detail[0];
    $.each(errors, function(index, value) {
      $('.answer-errors').append('<p>' + value + '</p>');
    });
  });
  $('.answer_voting').on('ajax:success', function(e){
    var vote = e.detail[0];
    var rating = vote.rating;
    console.log(vote);
    $('.answer_rating').text("The answers rating is " + rating);
    vote.vote_for ? $(vote.vote_for_id).removeClass('disabled') : $(vote.vote_for_id).addClass('disabled') 
    vote.vote_against ? $(vote.vote_against_id).removeClass('disabled') : $(vote.vote_against_id).addClass('disabled') 
    vote.vote_revoke ? $(vote.vote_revoke_id).removeClass('disabled') : $(vote.vote_revoke_id).addClass('disabled') 
  });
});

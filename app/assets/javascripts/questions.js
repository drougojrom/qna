$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        var questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    });
    $(document).on('ajax:success','.voting', function(e){
        const vote = e.detail[0];
        const rating = vote.rating;
        const voteClass = vote.class
        const vote_for_id = "#vote_for_" + voteClass + "_" + vote.id
        const vote_against_id = "#vote_against_" + voteClass + "_" + vote.id
        const vote_revoke_id = "#vote_revoke_" + voteClass + "_" + vote.id

        vote.vote_for ? $(vote_for_id).removeClass('disabled') : $(vote_for_id).addClass('disabled')
        vote.vote_against ? $(vote_against_id).removeClass('disabled') : $(vote_against_id).addClass('disabled')
        vote.vote_revoke ? $(vote_revoke_id).removeClass('disabled') : $(vote_revoke_id).addClass('disabled')

        $('.' + voteClass + '_rating').text("The " + voteClass + "s rating is " + rating);
    });
    $(document).on('ajax:success', '.new-comment', function(e, data) {
        const comment = e.detail[0];

        $('.new-comment #comment_body').val('');
        const comments_list = '#comments-' + comment.class + '-' + comment.id;
        $(comments_list).append(JST["templates/comment"]({ data: comment }));
    });
});

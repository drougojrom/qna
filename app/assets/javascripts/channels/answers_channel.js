var ready;

ready = function() {
    App.cable.subscriptions.create('AnswersChannel', {
        connected: function() {
            const question_id = $('.question').data('id');
            console.log(question_id);
            if (question_id) {
                console.log(question_id);
                this.perform('follow_answers', {id: question_id});
            }
        },
        received: function(data) {
            var answer = JSON.parse(data)
            console.log(data);
            var current_user_id = gon.current_user_id;
            if (current_user_id !== answer.user_id) {
                $('.answers').append(JST["templates/answer"]({ data: answer}));
                if (current_user_id != null) {
                    $('.answer container').append(JST["templates/voting"]({ data: answer}));
                }
            }
        }
    });
}

$(document).on('turbolinks:load', ready);

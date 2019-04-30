var ready;

ready = function() {
    let subscriptionsList = App.cable.subscriptions.subscriptions

    if (subscriptionsList.filter(e => e.identifier === '{"channel":"QuestionsChannel"}').length > 0) {
        return
    } else {
        App.cable.subscriptions.create('QuestionsChannel', {
            connected: function() {
                this.perform('follow');
            },
            received: function(data) {
                var question = data.question
                var current_user_id = gon.current_user_id;
                $('.questions').append(JST["templates/question"]({ data: question}));
                console.log(data)
            }
        });
    }
};

$(document).on('turbolinks:load', ready);

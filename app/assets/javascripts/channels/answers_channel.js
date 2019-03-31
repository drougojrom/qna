var ready;

ready = function() {
  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      this.perform('follow_answers');
    },
    received: function(data) {
      var answer = JSON.parse(data)
      var current_user_id = gon.current_user_id;
      if (current_user_id !== answer.user_id) {
        $('.answers').append(JST["templates/answer"]({ data: answer}));
      }
    }
  });
}

$(document).on('turbolinks:load', ready);

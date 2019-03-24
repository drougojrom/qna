var ready;

ready = function() {
  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      this.perform('follow_answers');
    },
    received: function(data) {
      var answer = JSON.parse(data)
      var current_user_id = gon.current_user_id;
      $('.answers').append(JST["templates/answer"]({ data: answer}));
      console.log(answer)
    }
  });
}

$(document).on('turbolinks:load', ready);

var ready;

ready = function() {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      this.perform('follow');
    },
    received: function(data) {
      var question = JSON.parse(data['question'])
      var current_user_id = gon.current_user_id;
      $('.questions').append(JST["templates/question"]({ data: question}));
      console.log(data)
    }
  });
}

$(document).on('turbolinks:load', ready);

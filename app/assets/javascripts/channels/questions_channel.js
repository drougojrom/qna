var ready;

ready = function() {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      this.perform('follow');
    },
    received: function(data) {
      console.log(data)
    }
  });
}

$(document).on('turbolinks:load', ready);

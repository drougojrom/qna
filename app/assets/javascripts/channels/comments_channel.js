var ready;

ready = function() {
  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      this.perform('follow_comments');
    },
    received: function(data) {
      var comment = data
      var commentClass = comment.class
      var current_user_id = gon.current_user_id;
      if (current_user_id != comment.user_id) {
	$('.' + commentClass + '_comments').append(JST["templates/comment"]({ data: comment}));
      }
    }
  });
}

$(document).on('turbolinks:load', ready);

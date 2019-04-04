var ready;

ready = function() {
  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      var question_id = $(".question").data("id");
      this.perform('follow_comments', {id: question_id });
    },
    received: function(data) {
      var comment = data
      var commentClass = comment.class
      var current_user_id = gon.current_user_id;
      if (current_user_id != comment.user_id) {
        var comments_list = '#comments-' + data['class'] + '-' + data['id'];
        $(comments_list).append(JST["templates/comment"]({ data: comment }));
      }
    }
  });
}

$(document).on('turbolinks:load', ready);

$(document).on('turbolinks:load', function(){
  $('.links').on('click', '.edit-url-link-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var linkId = $(this).data('linkId');
    $('form#edit-link-' + linkId).removeClass('hidden');
  });
});

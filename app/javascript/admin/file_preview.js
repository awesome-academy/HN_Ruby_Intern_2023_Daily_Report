$(document).on('turbo:load', function () {
  $('.file-input-replacer').on('click', function (event) {
    const id = $(event.target).data('replace-for');
    $(`#${id}`).trigger('click');
    event.preventDefault();
  });

  $('.file-chooser').on('change', function (event) {
    const target = event.target;
    const files = target.files;
    if (FileReader && files && files.length) {
      let fr = new FileReader();
      fr.onload = function () {
        $(`[data-preview-for="${target.id}"]`)
          .attr('src', fr.result)
          .css('display', 'initial');
        $(`[data-original-for="${target.id}"]`).css('display', 'none');
      };
      fr.readAsDataURL(files[0]);
    }
  });
});

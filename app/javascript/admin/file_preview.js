$(function () {
  $('.file-input-replacer').on('click', function (event) {
    event.preventDefault();
    const id = $(event.target).data('replace-for');
    $(`#${id}`).trigger('click');
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
      };
      fr.readAsDataURL(files[0]);
    }
  });
});

import '@vendor/jquery-toast-plugin/jquery.toast.min';
import '@vendor/select2/select2.min';

import './file_preview';

$(document).on('turbo:load', function () {
  // const apply_select2 = (name) => {
  //   $(`#book_${name}`).select2({
  //     width: '100%',
  //     placeholder: $(this).text(),
  //   });
  // };
  $('.selector2').each(function () {
    const id = $(this).attr('id');
    $(this).select2({
      width: '100%',
      placeholder: $(`[data-placeholder-for="${id}"]`).text(),
    });
  });
  // apply_select2('genres');
  // apply_select2('authors');
  // apply_select2('publisher');
});

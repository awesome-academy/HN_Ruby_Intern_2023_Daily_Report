import '@vendor/jquery-toast-plugin/jquery.toast.min';
import 'select2';
import 'select2_locale_vi';

import './file_preview';
import './modal';

$(document).on('turbo:load', function () {
  $('.selector2').each(function () {
    const id = $(this).attr('id');
    $(this).select2({
      width: '100%',
      placeholder: $(`[data-placeholder-for="${id}"]`).text(),
    });
  });
});

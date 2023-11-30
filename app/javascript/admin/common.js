import '@vendor/js/vendor.bundle.base';

import '@vendor/off-canvas';
import '@vendor/hoverable-collapse';

$(document).on('turbo:load', function () {
  $('form input[type=submit]').on('submit', function (e) {
    $(this).children('input[type=submit]').attr('disabled', 'disabled');
  });
});

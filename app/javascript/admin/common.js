import '@vendor/js/vendor.bundle.base';

import './toast';

$(document).on('turbo:load', function () {
  $('form input[type=submit]').on('submit', function (e) {
    $(this).children('input[type=submit]').attr('disabled', 'disabled');
  });

  $('.form-check label,.form-radio label').append(
    '<i class="input-helper"></i>'
  );
});

import '@vendor/jquery-toast-plugin/jquery.toast.min';
import '@vendor/jq.tablesort';

import './file_preview';

$(function () {
  if ($('.sortable-table').length) {
    $('.sortable-table').tablesort();
  }
});

function showToast(
  text = '',
  icon = 'success',
  position = 'top-left',
  heading = '',
  stack = true
) {
  const bg = {
    success: '#f96868',
    info: '#46c35f',
    warning: '#57c7d4',
    error: '#f2a654',
  };
  resetToastPosition();
  $.toast({
    heading,
    text,
    icon,
    position,
    stack,
    loaderBg: bg[icon],
  });
}
const resetToastPosition = function () {
  $('.jq-toast-wrap').removeClass(
    'bottom-left bottom-right top-left top-right mid-center'
  ); // to remove previous position class
  $('.jq-toast-wrap').css({
    top: '',
    left: '',
    bottom: '',
    right: '',
  }); //to remove previous position style
};

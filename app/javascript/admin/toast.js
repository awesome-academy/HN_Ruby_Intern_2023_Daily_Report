import '@vendor/jquery-toast-plugin/jquery.toast.min';

$(function () {
  const BG_COLOR = {
    success: '#f96868',
    info: '#46c35f',
    warning: '#57c7d4',
    error: '#f2a654',
  };

  window.showToast = ({heading, text, icon = 'success'}) => {
    let alias = {alert: 'error', notice: 'info'};
    if (icon in alias) {
      icon = alias[icon];
    }
    // Use input to take advantage of remember form values -> prevent reshow toast on back
    let shown_checker = $('#application-notify input');
    if (text.length > 0 && shown_checker.val()) {
      $.toast({
        heading,
        text,
        icon,
        position: 'top-left',
        stack: true,
        hideAfter: 5000,
        loaderBg: BG_COLOR[icon],
      });
      shown_checker.val('');
    }
  };
});

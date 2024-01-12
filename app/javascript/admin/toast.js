import '@vendor/jquery-toast-plugin/jquery.toast.min';

const BG_COLOR = {
  success: '#f96868',
  info: '#46c35f',
  warning: '#57c7d4',
  error: '#f2a654',
};

window.showToast = (...content) => {
  let alias = {alert: 'error', notice: 'info'};
  let position = 'top-left';
  let stack = 5;
  let hideAfter = 5000;
  // Use input to take advantage of remember form values -> prevent reshow toast on back
  let shown_checker = $('#application-notify input');
  if (shown_checker.val()) {
    content.forEach(({heading, text, icon = 'success'}) => {
      $.toast({
        heading,
        text,
        icon: alias[icon] || icon,
        position,
        stack,
        hideAfter,
        loaderBg: BG_COLOR[icon],
      });
    });
    shown_checker.val('');
  }
};

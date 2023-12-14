import '@vendor/jquery-toast-plugin/jquery.toast.min';

$(function () {
  const BG_COLOR = {
    success: '#f96868',
    info: '#46c35f',
    warning: '#57c7d4',
    error: '#f2a654',
  };

  window.showToast = ({heading, text, icon = 'success'}) => {
    if (text.length > 0) {
      $.toast({
        heading,
        text,
        icon,
        position: 'top-left',
        stack: true,
        hideAfter: 5000,
        loaderBg: BG_COLOR[icon],
      });
    }
  };
});

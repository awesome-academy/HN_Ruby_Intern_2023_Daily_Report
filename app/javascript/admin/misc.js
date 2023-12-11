$(document).on('turbo:load', function () {
  var sidebar = $('.sidebar');
  // Close other submenu in sidebar on opening any

  sidebar.on('show.bs.collapse', '.collapse', function () {
    sidebar.find('.collapse.show').collapse('hide');
  });

  // Select2
  $('.selector2').each(function () {
    const id = $(this).attr('id');
    $(this).select2({
      width: '100%',
      placeholder: $(`[data-placeholder-for="${id}"]`).text(),
    });
  });

  // Active nav items with current url
  let current = location.pathname.replace(/\/$/, '');
  $('.menu-items .nav-link').each(function () {
    let $this = $(this);

    if ($this.attr('href') === current) {
      $this.addClass('active');
      let group = $this.closest('.menu-group .collapse');
      if (group.length) {
        group.addClass('show');
        group.parent().addClass('active');
      } else {
        $this.parent().addClass('active');
      }
      $this.attr('href', '');
    }
  });
});

$(function () {
  // Minimize sidebar
  var body = $('body');
  $('[data-toggle="minimize"]').on('click', function () {
    if (
      body.hasClass('sidebar-toggle-display') ||
      body.hasClass('sidebar-absolute')
    ) {
      body.toggleClass('sidebar-hidden');
    } else {
      body.toggleClass('sidebar-icon-only');
    }
  });
  // Check Notification
  $(document).on('click', '#notification-read-all', function () {
    $('.notification-item.unchecked')
      .removeClass('unchecked')
      .addClass('checked');
    $('#notification-uncheck-count').css('display', 'none');
  });
  $(document).on('click', '.notification-item.unchecked', function () {
    $(this).removeClass('unchecked').addClass('checked');
    let counter = $('#notification-uncheck-count');
    let count = counter.text();
    counter.text(count - 1);
    if (count == 1) {
      counter.css('display', 'none');
    }
  });
});

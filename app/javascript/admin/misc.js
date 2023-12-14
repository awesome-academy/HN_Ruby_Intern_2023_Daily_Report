$(document).on('turbo:load', function () {
  var body = $('body');
  var sidebar = $('.sidebar');
  // Minimize sidebar
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

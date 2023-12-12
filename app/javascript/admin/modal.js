$(document).on('turbo:load', function () {
  $('.modal-selector2').each(function () {
    const parent_id = $(this).data('parent-id');
    const id = $(this).attr('id');
    $(this).select2({
      width: '100%',
      placeholder: $(`[data-placeholder-for="${id}"]`).text(),
      dropdownParent: parent_id && $(`#${parent_id}`),
      minimumInputLength: 0, // only start searching when the user has input 3 or more characters
      tags: true, // allow create new value
    });
  });

  $('.modal').on('show.bs.modal', function (event) {
    let button = $(event.relatedTarget); // Button that triggered the modal
    let link = button.attr('href');
    $(this).find('.modal-body form').attr('action', link);
  });
});

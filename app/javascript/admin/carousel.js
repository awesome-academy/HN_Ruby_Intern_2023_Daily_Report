import '@vendor/owl-carousel-2/owl.carousel.min';

$(document).on('turbo:load', function () {
  $('.owl-carousel').owlCarousel({
    autoplay: true,
    loop: true,
    margin: 20,
    dots: false,
    autoplayTimeout: 5000,
    stagePadding: 200,
    autoWidth: true,
  });
});

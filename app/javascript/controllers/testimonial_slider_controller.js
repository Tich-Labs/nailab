import Swiper from 'swiper';
import 'swiper/css';

// This controller expects a .swiper-container element with .swiper-wrapper and .swiper-slide children
export default class extends window.Stimulus.Controller {
  connect() {
    console.log('TestimonialSliderController connected: initializing Swiper');
    this.swiper = new Swiper(this.element.querySelector('.swiper'), {
      loop: true,
      navigation: {
        nextEl: this.element.querySelector('.swiper-button-next'),
        prevEl: this.element.querySelector('.swiper-button-prev'),
      },
      pagination: {
        el: this.element.querySelector('.swiper-pagination'),
        clickable: true,
      },
      slidesPerView: 1,
      autoHeight: true,
      breakpoints: {
        768: { slidesPerView: 1 },
        1024: { slidesPerView: 1 }
      }
    });
  }
  disconnect() {
    if (this.swiper) this.swiper.destroy();
  }
}

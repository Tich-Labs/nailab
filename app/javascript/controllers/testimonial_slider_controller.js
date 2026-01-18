import Swiper from 'swiper';
import 'swiper/css';

// This controller expects a .swiper-container element with .swiper-wrapper and .swiper-slide children
export default class extends window.Stimulus.Controller {
  connect() {
    console.log('TestimonialSliderController connected: initializing Swiper');
    const el = this.element.querySelector('.swiper');
    if (!el) return;
    // If another initializer already set up Swiper, skip to avoid double-init
    if (el.dataset.swiperInitialized) { console.log('Swiper already initialized, skipping'); return; }
    this.swiper = new Swiper(el, {
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
    if (this.swiper) {
      const el = this.element.querySelector('.swiper');
      this.swiper.destroy();
      if (el && el.dataset.swiperInitialized) delete el.dataset.swiperInitialized;
    }
  }
}

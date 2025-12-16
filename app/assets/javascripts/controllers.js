import { Application, Controller } from 'https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.3.0/+esm';

const application = Application.start();

class NavigationController extends Controller {
  static targets = ['mobileMenu', 'network', 'resources'];

  connect() {
    this.menuOpen = false;
    this.networkOpen = false;
    this.resourcesOpen = false;
  }

  toggleMenu() {
    this.menuOpen = !this.menuOpen;
    this.mobileMenuTarget.classList.toggle('hidden', !this.menuOpen);
  }

  toggleNetwork() {
    this.networkOpen = !this.networkOpen;
    this.networkTarget.classList.toggle('hidden', !this.networkOpen);
  }

  toggleResources() {
    this.resourcesOpen = !this.resourcesOpen;
    this.resourcesTarget.classList.toggle('hidden', !this.resourcesOpen);
  }
}

application.register('navigation', NavigationController);

class HeroController extends Controller {
  static targets = ['slide', 'dot'];

  connect() {
    this.currentIndex = 0;
    this.showSlide(0);
    this.startAutoplay();
  }

  disconnect() {
    if (this.autoplay) {
      clearInterval(this.autoplay);
    }
  }

  startAutoplay() {
    if (this.autoplay) clearInterval(this.autoplay);
    this.autoplay = setInterval(() => this.next(), 5000);
  }

  showSlide(index) {
    if (!this.slideTargets?.length) return;
    this.currentIndex = index % this.slideTargets.length;

    this.slideTargets.forEach((slide, idx) => {
      slide.classList.toggle('opacity-100', idx === this.currentIndex);
      slide.classList.toggle('opacity-0', idx !== this.currentIndex);
      slide.classList.toggle('pointer-events-none', idx !== this.currentIndex);
    });

    this.dotTargets.forEach((dot, idx) => {
      dot.classList.toggle('bg-white', idx === this.currentIndex);
      dot.classList.toggle('bg-white/40', idx !== this.currentIndex);
    });
  }

  previous() {
    this.showSlide((this.currentIndex - 1 + this.slideTargets.length) % this.slideTargets.length);
    this.startAutoplay();
  }

  next() {
    this.showSlide((this.currentIndex + 1) % this.slideTargets.length);
    this.startAutoplay();
  }

  goTo(event) {
    const index = Number(event.currentTarget.dataset.heroIndex);
    if (!Number.isNaN(index)) {
      this.showSlide(index);
      this.startAutoplay();
    }
  }
}

application.register('hero', HeroController);

class FaqController extends Controller {
  static targets = ["answer", "button"];

  toggle(event) {
    const idx = event.currentTarget.dataset.faqIndex;
    this.answerTargets.forEach((el, i) => {
      if (i == idx) {
        el.classList.toggle("hidden");
        this.buttonTargets[i].querySelector('svg').classList.toggle('rotate-180');
      } else {
        el.classList.add("hidden");
        this.buttonTargets[i].querySelector('svg').classList.remove('rotate-180');
      }
    });
  }
}

application.register('faq', FaqController);

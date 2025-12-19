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
  static targets = ["slide", "dots"]

  connect() {
    this.current = 0;
    this.slidesCount = parseInt(this.element.dataset.heroSlidesCount) || this.slideTargets.length;
    this.startAutoSlide();
  }

  disconnect() {
    clearInterval(this.timer)
  }

  startAutoSlide() {
    this.timer = setInterval(() => this.next(), 5000)
  }

  update() {
    this.slideTargets.forEach((el, i) => {
      el.classList.toggle("opacity-100", i === this.current)
      el.classList.toggle("opacity-0", i !== this.current)
    })

    if (this.dotsTarget) {
      this.dotsTarget.innerHTML = this.slideTargets.map((_, i) =>
        `<button data-action="click->hero#goTo" data-index="${i}" class="${i === this.current ? 'bg-white w-8' : 'bg-white/50 hover:bg-white/75'} w-3 h-3 rounded-full mx-1 transition-all"></button>`
      ).join("")
    }
  }

  next() {
    this.current = (this.current + 1) % this.slidesCount;
    this.update();
  }

  previous() {
    this.current = (this.current - 1 + this.slidesCount) % this.slidesCount;
    this.update();
  }

  goTo(event) {
    this.current = parseInt(event.currentTarget.dataset.index)
    this.update()
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

class AdminSidebarController extends Controller {
  static targets = ['group'];

  toggle(event) {
    const button = event.currentTarget;
    const group = button.nextElementSibling;
    const expanded = button.getAttribute('aria-expanded') === 'true';

    this.groupTargets.forEach((el) => {
      if (el !== group) el.classList.add('hidden');
    });
    this.element.querySelectorAll("[aria-expanded='true']").forEach((b) => {
      if (b !== button) b.setAttribute('aria-expanded', 'false');
    });

    button.setAttribute('aria-expanded', String(!expanded));
    group.classList.toggle('hidden', expanded);
  }
}

application.register('admin-sidebar', AdminSidebarController);

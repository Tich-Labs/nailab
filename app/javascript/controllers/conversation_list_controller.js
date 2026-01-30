import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  select(event) {
    event.preventDefault();
    const url = event.currentTarget.getAttribute('href');
    if (url) {
      Turbo.visit(url);
    }
  }
}
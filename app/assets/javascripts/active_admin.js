document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll('svg.data-table-sorted-icon').forEach(function(el) {
    el.style.display = 'none';
  });
});// ActiveAdmin JavaScript disabled - using custom layout with Tailwind CSS
// The active_admin/base JavaScript is not available with Propshaft
// If you need ActiveAdmin JS features, you'll need to migrate to importmap or esbuild

// Collapsible sidebar for RailsAdmin
// This script toggles submenus under navigation labels

document.addEventListener('DOMContentLoaded', function () {
  var navLabels = document.querySelectorAll('.sidebar-nav .nav-header');
  navLabels.forEach(function (label) {
    var next = label.nextElementSibling;
    if (next && next.classList.contains('nav')) {
      // Hide sub-menu by default
      next.style.display = 'none';
      label.style.cursor = 'pointer';
      label.addEventListener('click', function () {
        if (next.style.display === 'none') {
          next.style.display = 'block';
        } else {
          next.style.display = 'none';
        }
      });
    }
  });
});

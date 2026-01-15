(function () {
  function escapeHtml(s) {
    return String(s || '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function currentPageFile() {
    const path = (location.pathname || '').split('/').pop();
    if (!path || path === '') return 'index.html';
    return path;
  }

  function isDocsActive(pageFile) {
    return pageFile === 'documentation.html' || pageFile === 'requirements.html';
  }

  function renderHeader(options) {
    const containerId = (options && options.containerId) || 'nailabHeader';
    const container = document.getElementById(containerId);
    if (!container) return;

    const bodyTitle = document.body && document.body.dataset ? document.body.dataset.pageTitle : '';
    const pageTitle = (options && options.pageTitle) || bodyTitle || document.title || 'Nailab';

    const pageFile = currentPageFile();
    const founderActive = pageFile === 'founder-features.html';
    const docsActive = isDocsActive(pageFile);

    const inactive = 'inline-flex items-center gap-2 rounded-md border border-slate-200 bg-white px-3 py-2 text-sm text-slate-800 shadow-sm hover:bg-slate-50';
    const active = 'inline-flex items-center gap-2 rounded-md border border-emerald-200 bg-emerald-200 px-3 py-2 text-sm font-semibold text-emerald-950 shadow-sm';

    container.innerHTML =
      '<header class="bg-white shadow-sm border-b border-gray-200">' +
      '  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">' +
      '    <div class="flex justify-between items-center py-4">' +
      '      <div class="flex items-center space-x-4">' +
      '        <a href="./?section=all" class="text-2xl font-bold text-gray-900 hover:underline">Nailab</a>' +
      '        <span class="text-gray-400">|</span>' +
      '        <h2 class="text-xl text-gray-600">' + escapeHtml(pageTitle) + '</h2>' +
      '      </div>' +
      '      <div class="flex items-center space-x-2">' +
      '        <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">' +
      '          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>' +
      '        </svg>' +
      '        <span class="text-sm text-gray-600">Last Updated: <span id="lastUpdated"></span></span>' +
      '      </div>' +
      '    </div>' +
      '  </div>' +
      '</header>' +
      '' +
      '<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">' +
      '  <nav class="mt-4" aria-label="Documentation pages">' +
      '    <a href="founder-features.html" ' + (founderActive ? 'aria-current="page" ' : '') + 'class="' + (founderActive ? active : inactive) + '">' +
      '      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
      '        <path d="M9 11l3 3L22 4"></path>' +
      '        <path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"></path>' +
      '      </svg>' +
      '      Founder Features Status' +
      '    </a>' +
      '' +
      '    <a href="documentation.html" ' + (docsActive ? 'aria-current="page" ' : '') + 'class="' + (docsActive ? active : inactive) + '">' +
      '      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
      '        <path d="M4 19.5A2.5 2.5 0 016.5 17H20"></path>' +
      '        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"></path>' +
      '      </svg>' +
      '      Documentation' +
      '    </a>' +
      '  </nav>' +
      '  <hr class="my-6 border-slate-200" />' +
      '</div>';

    const last = document.getElementById('lastUpdated');
    if (last && !last.textContent) {
      last.textContent = new Date().toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
      });
    }
  }

  function indentH3Sections(options) {
    const opts = options || {};
    const rootSelector = opts.rootSelector || 'article';
    const indentClass = opts.indentClass || 'ml-6';

    const run = function () {
      const root = document.querySelector(rootSelector);
      if (!root) return;

      const h3s = Array.from(root.querySelectorAll('h3'));
      h3s.forEach((h3) => {
        h3.classList.add(indentClass);

        let el = h3.nextElementSibling;
        while (el && el.tagName !== 'H2' && el.tagName !== 'H3') {
          el.classList.add(indentClass);
          el = el.nextElementSibling;
        }
      });
    };

    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', run, { once: true });
    } else {
      run();
    }
  }

  window.NailabShared = window.NailabShared || {};
  window.NailabShared.renderHeader = renderHeader;
  window.NailabShared.indentH3Sections = indentH3Sections;
})();

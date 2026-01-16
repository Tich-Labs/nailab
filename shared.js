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

  function navItems() {
    return [
      { href: 'founder-features.html', label: 'Founder Features' },
      { href: 'mentors-features.html', label: 'Mentors Features' },
      { href: 'matchmaking-features.html', label: 'Matchmaking Features' },
      { href: 'content-features.html', label: 'Content Features' },
      { href: 'subscription-features.html', label: 'Subscription Features' },
      { href: 'admin-features.html', label: 'Admin Features' },
      { href: 'technical-features.html', label: 'Technical Features' },
      { href: 'documentation.html', label: 'Documentation', isDocs: true }
    ];
  }

  function linkIconSvg(href) {
    if (href && href.endsWith('-features.html')) {
      return (
        '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
        '  <path d="M9 11l3 3L22 4"></path>' +
        '  <path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"></path>' +
        '</svg>'
      );
    }
    return (
      '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
      '  <path d="M4 19.5A2.5 2.5 0 016.5 17H20"></path>' +
      '  <path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"></path>' +
      '</svg>'
    );
  }

  function renderHeader(options) {
    const containerId = (options && options.containerId) || 'nailabHeader';
    const container = document.getElementById(containerId);
    if (!container) return;

    const bodyTitle = document.body && document.body.dataset ? document.body.dataset.pageTitle : '';
    const pageTitle = (options && options.pageTitle) || bodyTitle || document.title || 'Nailab';

    const pageFile = currentPageFile();
    const items = navItems();

    const inactive = 'inline-flex items-center gap-2 rounded-md border border-slate-200 bg-white px-3 py-2 text-sm text-slate-800 shadow-sm hover:bg-slate-50';
    const active = 'inline-flex items-center gap-2 rounded-md border border-emerald-200 bg-emerald-200 px-3 py-2 text-sm font-semibold text-emerald-950 shadow-sm';

    const navHtml =
      items
        .map((it) => {
          const activeNow = it.isDocs ? isDocsActive(pageFile) : pageFile === it.href;
          const a11y = activeNow ? 'aria-current="page" ' : '';
          const cls = activeNow ? active : inactive;
          return (
            '    <a href="' + it.href + '" ' + a11y + 'class="' + cls + '">' +
            linkIconSvg(it.href) +
            '      ' + escapeHtml(it.label) +
            '    </a>'
          );
        })
        .join('');

      // hide top-page nav when on the dedicated feedback page
      const navSection = (pageFile === 'feedback.html') ? '' : ('  <nav class="mt-4 flex flex-wrap gap-2" aria-label="Pages">' + navHtml + '  </nav>');

    container.innerHTML =
      '<header class="bg-gray-50 shadow-sm border-b border-gray-200">' +
      '  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">' +
      '    <div class="flex justify-between items-center py-4">' +
      '      <div class="flex items-center space-x-4">' +
      '        <a href="./?section=all" class="text-2xl font-bold text-black hover:underline">Nailab</a>' +
      '        <span class="text-gray-400">|</span>' +
      '        <h2 class="text-xl font-bold text-black">' + escapeHtml(pageTitle) + '</h2>' +
      '      </div>' +
      '      <div class="flex items-center space-x-2">' +
        // Feedback trigger (primary) - placed to the left of Info and Last Updated
        '        <a href="feedback.html" class="mr-3 inline-flex items-center rounded-md bg-emerald-600 px-3 py-2 text-sm font-medium text-white hover:bg-emerald-700 focus:outline-none">' +
        '          <svg class="w-4 h-4 mr-2" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">' +
        '            <path d="M2 5a2 2 0 012-2h12a2 2 0 012 2v8a2 2 0 01-2 2H8l-6 4V5z" />' +
        '          </svg>' +
        '          Give Feedback' +
        '        </a>' +
        // Info button

        '        <span class="text-sm text-gray-600">Last Updated: <span id="lastUpdated"></span></span>' +
        '      </div>' +
      '    </div>' +
      '  </div>' +
      '</header>' +


      // Feedback modal (hidden by default)
      '<div id="feedbackModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-black/50 p-4">' +
      '  <div role="dialog" aria-modal="true" aria-labelledby="feedbackTitle" class="max-w-lg w-full bg-white dark:bg-slate-800 rounded-lg shadow-xl p-6 relative transform transition-opacity duration-200 ease-out opacity-0" data-open="false">' +
      '    <button id="closeFeedbackModalBtn" class="absolute top-3 right-3 text-slate-500 hover:text-slate-700 dark:text-slate-300">' +
      '      <svg class="w-5 h-5" viewBox="0 0 20 20" fill="none" stroke="currentColor">' +
      '        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 6l8 8M6 14L14 6" />' +
      '      </svg>' +
      '    </button>' +
      '    <h3 id="feedbackTitle" class="text-lg font-bold text-black dark:text-slate-100">Give Feedback</h3>' +
      '    <form id="feedbackForm" class="mt-4 space-y-4" novalidate>' +
      '      <fieldset class="space-y-2">' +
      '        <legend class="text-sm font-bold text-black dark:text-slate-200">Type</legend>' +
        '        <div class="flex flex-col sm:flex-row sm:space-x-3">' +
      '          <label class="inline-flex items-center mt-2 sm:mt-0 px-2 py-1 rounded-md bg-red-50 text-red-800 border border-red-100 text-sm"><input type="radio" name="fbType" value="bug" class="mr-2" required><span>Report a bug/issue</span></label>' +
          '          <label class="inline-flex items-center mt-2 sm:mt-0 px-2 py-1 rounded-md bg-emerald-50 text-emerald-800 border border-emerald-100 text-sm"><input type="radio" name="fbType" value="feature" class="mr-2"><span>Request new feature</span></label>' +
          '          <label class="inline-flex items-center mt-2 sm:mt-0 px-2 py-1 rounded-md bg-amber-50 text-amber-800 border border-amber-100 text-sm"><input type="radio" name="fbType" value="general" class="mr-2"><span>General suggestion</span></label>' +
      '        </div>' +
      '      </fieldset>' +

      '      <div>' +
      '        <label class="block text-sm font-bold text-black dark:text-slate-200">Category</label>' +
        '        <select id="fbCategory" class="mt-1 block w-full rounded-md border-slate-200 bg-gray-50 dark:bg-slate-700 dark:border-slate-600 p-2">' +
      '          <option value="">Select a category</option>' +
      '          <option>Founder Features</option>' +
      '          <option>Mentor Features</option>' +
      '          <option>Matchmaking Features</option>' +
      '          <option>Content & Resources</option>' +
      '          <option>Subscription & Payments</option>' +
      '          <option>Admin / Dashboard</option>' +
      '          <option>Technical / Performance</option>' +
      '          <option>Other</option>' +
      '        </select>' +
      '        <input id="fbCategoryOther" class="mt-2 hidden w-full rounded-md border-slate-200 bg-gray-50 p-2 dark:bg-slate-700" type="text" placeholder="Please specify...">' +
      '      </div>' +

      '      <div>' +
      '        <label class="block text-sm font-bold text-black dark:text-slate-200">Details</label>' +
      '        <textarea id="fbDetails" rows="4" class="mt-1 block w-full rounded-md border-slate-200 bg-gray-50 p-2 dark:bg-slate-700" placeholder="Share your thoughts with us..." required></textarea>' +
      '      </div>' +

      '      <div>' +
      '        <label class="block text-sm font-bold text-black dark:text-slate-200">Screenshot (optional)</label>' +
      '        <input id="fbScreenshot" type="file" accept="image/*" class="mt-1" />' +
      '      </div>' +

      '      <div>' +
      '        <label class="block text-sm font-bold text-black dark:text-slate-200">Email (optional)</label>' +
      '        <input id="fbEmail" type="email" class="mt-1 block w-full rounded-md border-slate-200 p-2 dark:bg-slate-700" placeholder="you@example.com">' +
      '      </div>' +

      '      <div class="flex items-center justify-end space-x-2 pt-2">' +
      '        <button type="button" id="feedbackCancel" class="rounded-md px-3 py-2 bg-slate-100 text-slate-700 hover:bg-slate-200">Cancel</button>' +
      '        <button type="submit" id="feedbackSubmit" class="rounded-md px-4 py-2 bg-emerald-600 text-white disabled:opacity-40" disabled>Submit</button>' +
      '      </div>' +
      '    </form>' +
      '  </div>' +
      '</div>' +

      '<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">' +
      navSection +
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

    // wire up header modal and feedback modal handlers
    (function () {
      // Info modal
      const openInfoBtn = document.getElementById('openHeaderModalBtn');
      const infoModal = document.getElementById('headerModal');
      const closeInfoBtn = document.getElementById('closeHeaderModalBtn');

      function showInfoModal() {
        if (!infoModal) return;
        infoModal.classList.remove('hidden');
        infoModal.classList.add('flex');
        infoModal.setAttribute('aria-modal', 'true');
      }

      function hideInfoModal() {
        if (!infoModal) return;
        infoModal.classList.add('hidden');
        infoModal.classList.remove('flex');
        infoModal.removeAttribute('aria-modal');
      }

      if (openInfoBtn) openInfoBtn.addEventListener('click', showInfoModal);
      if (closeInfoBtn) closeInfoBtn.addEventListener('click', hideInfoModal);
      if (infoModal) infoModal.addEventListener('click', function (e) { if (e.target === infoModal) hideInfoModal(); });

      // Feedback modal
      const openFbBtn = document.getElementById('openFeedbackBtn');
      const fbModal = document.getElementById('feedbackModal');
      const fbPanel = fbModal && fbModal.querySelector('[role="dialog"]');
      const closeFbBtn = document.getElementById('closeFeedbackModalBtn');
      const fbForm = document.getElementById('feedbackForm');
      const fbSubmit = document.getElementById('feedbackSubmit');
      const fbCancel = document.getElementById('feedbackCancel');
      const fbTypeInputs = fbForm ? Array.from(fbForm.elements['fbType'] || []) : [];
      const fbCategory = document.getElementById('fbCategory');
      const fbCategoryOther = document.getElementById('fbCategoryOther');
      const fbDetails = document.getElementById('fbDetails');

      function openFeedback() {
        if (!fbModal) return;
        fbModal.classList.remove('hidden');
        // slight delay to allow transition classes if desired
        setTimeout(function () {
          if (fbPanel) {
            fbPanel.style.opacity = '1';
            fbPanel.setAttribute('data-open', 'true');
          }
        }, 10);
        // focus first radio
        if (fbTypeInputs && fbTypeInputs[0]) fbTypeInputs[0].focus();
        document.addEventListener('keydown', escHandler);
      }

      function closeFeedback() {
        if (!fbModal) return;
        if (fbPanel) {
          fbPanel.style.opacity = '0';
          fbPanel.setAttribute('data-open', 'false');
        }
        setTimeout(function () { fbModal.classList.add('hidden'); }, 180);
        document.removeEventListener('keydown', escHandler);
      }

      function escHandler(e) {
        if (e.key === 'Escape') {
          if (fbModal && !fbModal.classList.contains('hidden')) closeFeedback();
          if (infoModal && !infoModal.classList.contains('hidden')) hideInfoModal();
        }
      }

      if (openFbBtn) openFbBtn.addEventListener('click', openFeedback);
      if (closeFbBtn) closeFbBtn.addEventListener('click', closeFeedback);
      if (fbCancel) fbCancel.addEventListener('click', closeFeedback);
      if (fbModal) fbModal.addEventListener('click', function (e) { if (e.target === fbModal) closeFeedback(); });

      // dynamic form behavior
      function updateDetailsPlaceholder() {
        if (!fbDetails) return;
        const selected = (fbForm && fbForm.elements['fbType'] && Array.from(fbForm.elements['fbType']).find(i => i.checked) || {}).value;
        if (selected === 'bug') fbDetails.placeholder = 'Describe what went wrong and how to reproduce it...';
        else if (selected === 'feature') fbDetails.placeholder = 'What feature do you want and why is it useful for you?';
        else fbDetails.placeholder = 'Share your thoughts with us...';
      }

      if (fbTypeInputs.length) fbTypeInputs.forEach(i => i.addEventListener('change', function () { updateDetailsPlaceholder(); validateForm(); }));

      if (fbCategory) fbCategory.addEventListener('change', function () {
        if (fbCategory.value === 'Other') fbCategoryOther.classList.remove('hidden'); else fbCategoryOther.classList.add('hidden');
        validateForm();
      });

      if (fbDetails) fbDetails.addEventListener('input', validateForm);
      if (fbCategoryOther) fbCategoryOther.addEventListener('input', validateForm);
      // triage and persist feedback locally (queue) on submit
      function triageFeedback(data) {
        const text = (data.details || '').toLowerCase();
        const category = (data.category || '').toLowerCase();
        const triage = { labels: [], board: null, priority: 'normal' };

        // Bug priority and routing
        if (data.type === 'bug') {
          if ((text.includes('crash') || text.includes('error') || text.includes('exception') || text.includes("not working")) && (category.includes('founder') || text.includes('founder') || text.includes('dashboard'))) {
            triage.board = 'founder-features';
            triage.labels.push('bug', 'high-priority');
            triage.priority = 'high';
            return triage;
          }
          // generic bug mapping
          triage.labels.push('bug');
        }

        // Feature request routing
        if (data.type === 'feature') {
          triage.labels.push('feature-request');
        }

        // Internationalization
        if (text.includes('french') || text.includes('translation') || text.includes('translate')) {
          triage.labels.push('feature-request', 'internationalization');
          triage.board = 'technical-features';
        }

        // Positive feedback
        if (data.type === 'general' && (/love|great|awesome|nice|thanks|excellent|well done/).test(text)) {
          triage.labels.push('positive-feedback');
          triage.board = 'content-features';
          triage.archived = true;
          return triage;
        }

        // category-based board mapping
        if (!triage.board) {
          if (category.includes('founder')) triage.board = 'founder-features';
          else if (category.includes('mentor')) triage.board = 'mentors-features';
          else if (category.includes('matchmaking')) triage.board = 'matchmaking-features';
          else if (category.includes('content')) triage.board = 'content-features';
          else if (category.includes('subscription')) triage.board = 'subscription-features';
          else if (category.includes('admin')) triage.board = 'admin-features';
          else if (category.includes('technical') || category.includes('performance')) triage.board = 'technical-features';
        }

        // fallback: technical board
        if (!triage.board) triage.board = 'technical-features';

        return triage;
      }

      if (fbForm) fbForm.addEventListener('submit', function (e) {
        e.preventDefault();
        fbSubmit.disabled = true;
        fbSubmit.textContent = 'Sending...';

        // collect form data
        const formData = {
          type: (fbForm.elements['fbType'] && Array.from(fbForm.elements['fbType']).find(i => i.checked) || {}).value || '',
          category: fbCategory && fbCategory.value || '',
          categoryOther: fbCategoryOther && fbCategoryOther.value || '',
          details: fbDetails && fbDetails.value || '',
          email: document.getElementById('fbEmail') && document.getElementById('fbEmail').value || ''
        };

        // perform triage
        const triage = triageFeedback(formData);

        // push to local storage queue
        try {
          const key = 'nailab_feedback_queue';
          const existing = JSON.parse(localStorage.getItem(key) || '[]');
          const entry = Object.assign({}, formData, { triage: triage, createdAt: new Date().toISOString() });
          existing.push(entry);
          localStorage.setItem(key, JSON.stringify(existing));
        } catch (err) {
          console.error('Failed to store feedback:', err);
        }

        // UX: show triage summary briefly before closing
        setTimeout(function () {
          fbSubmit.textContent = 'Submitted';
          const summary = 'Triage: ' + (triage.board || 'technical-features') + ' — labels: ' + (triage.labels.join(', ') || 'none');
          // temporarily show summary in the submit button
          setTimeout(function () { fbSubmit.textContent = summary; }, 200);
          setTimeout(function () { fbSubmit.textContent = 'Submit'; fbSubmit.disabled = false; fbForm.reset(); closeFeedback(); }, 1200);
        }, 600);
      });

      function validateForm() {
        if (!fbForm) return;
        const typeSelected = !!(Array.from(fbForm.elements['fbType'] || []).find(i => i.checked));
        const categoryFilled = fbCategory && fbCategory.value;
        const detailsFilled = fbDetails && fbDetails.value.trim().length > 0;
        const otherOk = !(fbCategory && fbCategory.value === 'Other') || (fbCategoryOther && fbCategoryOther.value.trim().length > 0);
        fbSubmit.disabled = !(typeSelected && categoryFilled && detailsFilled && otherOk);
      }

      // initial validation state
      validateForm();
    })();

    // NOTE: per-page feedback column injection removed — feedback remains
    // available only on the dedicated feedback page (feedback.html).
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

/**
 * MIXIMOI HRM & PAYROLL — Master JavaScript
 * ============================================================
 * v2.0 — Hệ thống Page Transition Tăng Tốc Chuyên Nghiệp
 * - Top Loading Progress Bar (NProgress-style)
 * - Fade-in Page Transition
 * - Sidebar Link Prefetch
 * - Instant Click Feedback
 * - Auto-dismiss Alerts
 * ============================================================
 */

/* ============================================================
   1. TOP LOADING PROGRESS BAR
   Hiển thị ngay khi click link, giả lập tiến độ để cảm giác
   phản hồi tức thì, tạo cảm giác trang tải siêu nhanh
   ============================================================ */
const PageProgress = (() => {
  let bar = null;
  let timer = null;

  function create() {
    if (bar) return;
    bar = document.createElement('div');
    bar.id = 'page-progress-bar';
    bar.innerHTML = '<div id="page-progress-fill"></div><div id="page-progress-glow"></div>';
    document.body.appendChild(bar);
  }

  function setWidth(w) {
    const fill = document.getElementById('page-progress-fill');
    const glow = document.getElementById('page-progress-glow');
    if (fill) fill.style.width = Math.min(w, 99) + '%';
    if (glow) glow.style.left = Math.min(w, 99) + '%';
  }

  function start() {
    create();
    setWidth(0);
    if (bar) {
      bar.classList.remove('done', 'hidden');
      bar.classList.add('active');
    }
    clearInterval(timer);
    let w = 0;
    timer = setInterval(() => {
      if (w < 30)       { w += 12; }
      else if (w < 60)  { w += 6; }
      else if (w < 80)  { w += 2; }
      else if (w < 95)  { w += 0.5; }
      else { clearInterval(timer); }
      setWidth(w);
    }, 100);
  }

  function done() {
    clearInterval(timer);
    if (!bar) return;
    setWidth(100);
    bar.classList.add('done');
    setTimeout(() => {
      if (bar) bar.classList.add('hidden');
      setTimeout(() => {
        if (bar && bar.parentNode) {
          bar.parentNode.removeChild(bar);
          bar = null;
        }
      }, 400);
    }, 300);
  }

  return { start, done };
})();

/* ============================================================
   2. PAGE TRANSITION — FADE IN
   ============================================================ */
const PageTransition = (() => {
  function fadeIn() {
    const main = document.querySelector('.app-main') || document.body;
    main.style.opacity = '0';
    main.style.transition = 'none';
    void main.offsetHeight; // Force repaint
    main.style.transition = 'opacity 0.2s ease';
    main.style.opacity = '1';
  }
  return { fadeIn };
})();

/* ============================================================
   3. NAVIGATION INTERCEPTOR
   Bắt tất cả link nội bộ, thêm progress bar ngay khi click
   ============================================================ */
function initNavigationInterceptor() {
  function isInternalLink(a) {
    if (!a || !a.href) return false;
    if (a.target && a.target !== '_self') return false;
    const href = a.getAttribute('href') || '';
    if (href === '#' || href.startsWith('#') || href.startsWith('javascript:')) return false;
    if (a.getAttribute('data-bs-toggle')) return false;
    if (a.closest('[data-bs-toggle]')) return false;
    try {
      return new URL(a.href).hostname === window.location.hostname;
    } catch (e) { return false; }
  }

  document.addEventListener('click', (e) => {
    const a = e.target.closest('a');
    if (!a || !isInternalLink(a)) return;
    const href = a.href;
    if (href === window.location.href) { e.preventDefault(); return; }
    e.preventDefault();
    a.classList.add('nav-clicking');
    PageProgress.start();
    setTimeout(() => { window.location.href = href; }, 80);
  }, true);

  document.addEventListener('submit', (e) => {
    if (e.target && e.target.method !== 'get') PageProgress.start();
  });

  window.addEventListener('pageshow', () => {
    PageProgress.done();
    PageTransition.fadeIn();
  });
}

/* ============================================================
   4. LINK PREFETCH — Tải trước trang khi hover sidebar
   ============================================================ */
function initLinkPrefetch() {
  const prefetchedUrls = new Set();
  let prefetchTimer = null;

  function prefetch(url) {
    if (prefetchedUrls.has(url)) return;
    prefetchedUrls.add(url);
    const link = document.createElement('link');
    link.rel = 'prefetch';
    link.href = url;
    link.as = 'document';
    document.head.appendChild(link);
  }

  document.querySelectorAll('.sidebar-nav-link').forEach(link => {
    const href = link.getAttribute('href') || '';
    if (!href || href === '#' || href.startsWith('javascript:')) return;
    link.addEventListener('mouseenter', () => {
      clearTimeout(prefetchTimer);
      prefetchTimer = setTimeout(() => prefetch(link.href), 100);
    });
    link.addEventListener('mouseleave', () => clearTimeout(prefetchTimer));
  });
}

/* ============================================================
   5. PAGE LOAD ANIMATION
   ============================================================ */
function initPageLoadAnimation() {
  if (document.readyState !== 'loading') {
    PageTransition.fadeIn();
    PageProgress.done();
  } else {
    document.addEventListener('DOMContentLoaded', () => {
      PageTransition.fadeIn();
      PageProgress.done();
    });
  }
}

/* ============================================================
   6. SIDEBAR NAVIGATION & RESPONSIVE TOGGLE
   ============================================================ */
function initSidebar() {
  const sidebar = document.querySelector('.app-sidebar');
  const backdrop = document.querySelector('.sidebar-backdrop');
  const toggleBtn = document.querySelector('[data-toggle="sidebar"]');

  if (toggleBtn && sidebar) {
    toggleBtn.addEventListener('click', (e) => {
      e.preventDefault();
      sidebar.classList.toggle('show');
      if (backdrop) backdrop.classList.toggle('show');
    });
  }
  if (backdrop && sidebar) {
    backdrop.addEventListener('click', () => {
      sidebar.classList.remove('show');
      backdrop.classList.remove('show');
    });
  }

  // Highlight active nav link theo URL hiện tại
  const currentPath = window.location.pathname;
  const currentSearch = window.location.search;
  document.querySelectorAll('.sidebar-nav-link').forEach(link => {
    const href = link.getAttribute('href');
    if (!href || href === '#') return;
    try {
      const linkUrl = new URL(link.href);
      if (linkUrl.pathname === currentPath &&
          (linkUrl.search === '' || linkUrl.search === currentSearch)) {
        document.querySelectorAll('.sidebar-nav-link.active')
          .forEach(el => el.classList.remove('active'));
        link.classList.add('active');
      }
    } catch (e) { /* bỏ qua */ }
  });
}

/* ============================================================
   7. KEYBOARD SHORTCUT: Ctrl+K để focus search
   ============================================================ */
function initSearchShortcut() {
  const searchInput = document.querySelector('.topbar-search-input');
  if (!searchInput) return;
  window.addEventListener('keydown', (e) => {
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
      e.preventDefault();
      searchInput.focus();
      searchInput.select();
    }
  });
}

/* ============================================================
   8. DYNAMIC DATE DISPLAY (Tiếng Việt)
   ============================================================ */
function initDateDisplay() {
  const dateElements = document.querySelectorAll('[data-dynamic-date]');
  if (dateElements.length === 0) return;
  const now = new Date();
  const days = ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
  const formatted = `Hôm nay, ${days[now.getDay()]} ` +
    `${String(now.getDate()).padStart(2,'0')}/${String(now.getMonth()+1).padStart(2,'0')}/${now.getFullYear()}`;
  dateElements.forEach(el => { el.textContent = formatted; });
}

/* ============================================================
   9. AUTO DISMISS ALERTS
   ============================================================ */
function initAutoDismissAlerts() {
  document.querySelectorAll('.alert-dismissible').forEach(alert => {
    setTimeout(() => {
      try {
        if (typeof bootstrap !== 'undefined' && bootstrap.Alert) {
          new bootstrap.Alert(alert).close();
        } else {
          alert.style.transition = 'opacity 0.5s';
          alert.style.opacity = '0';
          setTimeout(() => alert.remove(), 500);
        }
      } catch (err) { /* ignore */ }
    }, 5000);
  });
}

/* ============================================================
   10. GLOBAL UTILITIES
   ============================================================ */
window.formatCurrencyVND = function(amount) {
  if (amount === undefined || amount === null) return '0 đ';
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' })
    .format(amount).replace('₫', 'đ');
};

window.calculateDaysBetween = function(startStr, endStr) {
  if (!startStr || !endStr) return 0;
  const start = new Date(startStr);
  const end = new Date(endStr);
  if (isNaN(start.getTime()) || isNaN(end.getTime()) || end < start) return 0;
  return Math.ceil(Math.abs(end - start) / (1000 * 60 * 60 * 24)) + 1;
};

window.initLeaveDurationCalculator = function(startSelector, endSelector, resultSelector) {
  const startEl = document.querySelector(startSelector);
  const endEl = document.querySelector(endSelector);
  const resultEl = document.querySelector(resultSelector);
  if (!startEl || !endEl || !resultEl) return;
  function update() {
    const days = window.calculateDaysBetween(startEl.value, endEl.value);
    resultEl.textContent = days > 0 ? days + ' ngày' : '0 ngày';
  }
  startEl.addEventListener('change', update);
  endEl.addEventListener('change', update);
  update();
};

/* ============================================================
   KHỞI ĐỘNG — Theo thứ tự ưu tiên
   ============================================================ */
// Khởi động ngay (không chờ DOMContentLoaded)
initPageLoadAnimation();
initNavigationInterceptor();

// Khởi động sau khi DOM sẵn sàng
document.addEventListener('DOMContentLoaded', () => {
  initSidebar();
  initSearchShortcut();
  initDateDisplay();
  initAutoDismissAlerts();
  initLinkPrefetch();
});




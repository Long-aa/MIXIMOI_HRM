/**
 * MIXIMOI HRM & PAYROLL — Master JavaScript
 * Global system scripts & interactions
 */

document.addEventListener('DOMContentLoaded', () => {
  initSidebar();
  initSearchShortcut();
  initDateDisplay();
  initAutoDismissAlerts();
});

/**
 * Sidebar Navigation & Responsive Toggle
 */
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

  // Highlight current active link based on pathname
  const currentPath = window.location.pathname;
  const navLinks = document.querySelectorAll('.sidebar-nav-link');

  navLinks.forEach(link => {
    const href = link.getAttribute('href');
    if (href && href !== '#' && currentPath.includes(href)) {
      // Remove default active
      document.querySelectorAll('.sidebar-nav-link.active').forEach(el => el.classList.remove('active'));
      link.classList.add('active');
    }
  });
}

/**
 * Global Keyboard Shortcut: Ctrl + K (or Cmd + K) to focus Search
 */
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

/**
 * Dynamic date display in Vietnamese format
 */
function initDateDisplay() {
  const dateElements = document.querySelectorAll('[data-dynamic-date]');
  if (dateElements.length === 0) return;

  const now = new Date();
  const days = ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
  const dayName = days[now.getDay()];
  const dateStr = String(now.getDate()).padStart(2, '0');
  const monthStr = String(now.getMonth() + 1).padStart(2, '0');
  const yearStr = now.getFullYear();

  const formattedDate = `Hôm nay, ${dayName} ${dateStr}/${monthStr}/${yearStr}`;

  dateElements.forEach(el => {
    el.textContent = formattedDate;
  });
}

/**
 * Auto dismiss alerts after 5 seconds
 */
function initAutoDismissAlerts() {
  const alerts = document.querySelectorAll('.alert-dismissible');
  alerts.forEach(alert => {
    setTimeout(() => {
      try {
        if (typeof bootstrap !== 'undefined' && bootstrap.Alert) {
          const bsAlert = new bootstrap.Alert(alert);
          bsAlert.close();
        } else {
          alert.style.transition = 'opacity 0.5s';
          alert.style.opacity = '0';
          setTimeout(() => alert.remove(), 500);
        }
      } catch (err) {
        // ignore
      }
    }, 5000);
  });
}

/**
 * Currency Formatter Utility (VND)
 */
window.formatCurrencyVND = function(amount) {
  if (amount === undefined || amount === null) return '0 đ';
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' })
    .format(amount)
    .replace('₫', 'đ');
};

/**
 * Calculate business/calendar days between two date strings (YYYY-MM-DD)
 */
window.calculateDaysBetween = function(startStr, endStr) {
  if (!startStr || !endStr) return 0;
  const start = new Date(startStr);
  const end = new Date(endStr);
  if (isNaN(start.getTime()) || isNaN(end.getTime()) || end < start) return 0;
  const diffTime = Math.abs(end - start);
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;
  return diffDays;
};

/**
 * Helper to auto bind leave duration calculator to inputs
 */
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


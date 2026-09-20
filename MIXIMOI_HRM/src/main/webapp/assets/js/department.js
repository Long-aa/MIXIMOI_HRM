/**
 * MIXIMOI HRM - department.js
 * Logic xu ly cho cac trang Quan ly Phong ban:
 *   - department-list.jsp (bo loc, xoa xac nhan, KPI animation, checkboxes)
 *   - department-form.jsp (live preview, char counter, color picker, validation)
 */

/* ===========================
   DEPARTMENT LIST FUNCTIONS
   =========================== */

/** Hien thi modal xoa phong ban */
function confirmDeleteDept(btn) {
    const id       = btn.getAttribute('data-id');
    const name     = btn.getAttribute('data-name');
    const empCount = parseInt(btn.getAttribute('data-emp-count') || '0', 10);
    document.getElementById('deleteDeptId').value     = id;
    document.getElementById('deleteDeptName').textContent = name;
    const warning = document.getElementById('deptWarning');
    if (warning) warning.classList.toggle('d-none', empCount === 0);
    new bootstrap.Modal(document.getElementById('deleteDeptModal')).show();
}

/** Toggle tat ca checkbox trong bang */
function toggleAll(master) {
    document.querySelectorAll('.row-cb').forEach(cb => cb.checked = master.checked);
    updateBulkActions();
}

/** Cap nhat hien thi thanh action nhom (neu co) */
function updateBulkActions() {
    const checked = document.querySelectorAll('.row-cb:checked').length;
    const bar = document.getElementById('bulkActionBar');
    if (bar) {
        bar.classList.toggle('d-none', checked === 0);
        const countEl = document.getElementById('selectedCount');
        if (countEl) countEl.textContent = checked;
    }
}

/** Bo loc bang - tim kiem + trang thai + quy mo */
function filterDeptTable() {
    const q      = (document.getElementById('deptSearchInput')?.value || '').toLowerCase().trim();
    const status = document.getElementById('deptStatusFilter')?.value || '';
    const size   = document.getElementById('deptSizeFilter')?.value   || '';
    let visible  = 0;

    document.querySelectorAll('#deptTableBody .dept-row').forEach(row => {
        const name    = (row.dataset.name   || '').toLowerCase();
        const code    = (row.dataset.code   || '').toLowerCase();
        const rStatus = row.dataset.status  || '';
        const emp     = parseInt(row.dataset.emp || '0', 10);

        const matchQ      = !q      || name.includes(q) || code.includes(q);
        const matchStatus = !status || rStatus === status;
        let   matchSize   = true;
        if (size === 'small')  matchSize = emp < 20;
        if (size === 'medium') matchSize = emp >= 20 && emp <= 50;
        if (size === 'large')  matchSize = emp > 50;

        const show = matchQ && matchStatus && matchSize;
        row.style.display = show ? '' : 'none';
        if (show) visible++;
    });

    const vc = document.getElementById('visibleCount');
    if (vc) vc.textContent = visible;

    // Show empty message if no results
    const emptyRow = document.getElementById('deptEmptyFilterRow');
    if (emptyRow) emptyRow.style.display = visible === 0 ? '' : 'none';
}

/** Reset bo loc */
function resetFilter() {
    const searchEl  = document.getElementById('deptSearchInput');
    const statusEl  = document.getElementById('deptStatusFilter');
    const sizeEl    = document.getElementById('deptSizeFilter');
    if (searchEl) searchEl.value = '';
    if (statusEl) statusEl.value = '';
    if (sizeEl)   sizeEl.value   = '';
    filterDeptTable();
}

/** Hieu ung dem so KPI (counter animation) */
function animateKpiCounters() {
    document.querySelectorAll('.dept-kpi-value').forEach(el => {
        const raw    = el.textContent.trim().replace(',', '.');
        const target = parseFloat(raw);
        if (isNaN(target) || target <= 0) return;
        let current = 0;
        const step  = target / 30;
        const timer = setInterval(() => {
            current = Math.min(current + step, target);
            el.textContent = Number.isInteger(target)
                ? Math.round(current)
                : current.toFixed(1);
            if (current >= target) clearInterval(timer);
        }, 20);
    });
}

/* ===========================
   DEPARTMENT FORM FUNCTIONS
   =========================== */

/** Cap nhat preview ten + avatar viet tat */
function updatePreview(input) {
    const val     = (input.value || '').trim();
    const nameEl  = document.getElementById('deptNamePreview');
    const avEl    = document.getElementById('deptAvatarPreview');
    if (nameEl) nameEl.textContent = val || 'Ten phong ban';
    if (avEl) {
        if (val.length >= 2) avEl.textContent = val.substring(0, 2).toUpperCase();
        else if (val.length === 1) avEl.textContent = val.toUpperCase();
        else avEl.textContent = 'PB';
    }
    // Char counter
    const counter = document.getElementById('nameCounter');
    if (counter) {
        const len = input.value.length;
        counter.textContent = len + ' / 120';
        counter.className = 'dept-char-counter'
            + (len > 100 ? ' warn' : '')
            + (len >= 120 ? ' over' : '');
    }
}

/** Cap nhat bo dem ky tu mo ta */
function updateDescCounter(textarea) {
    const counter = document.getElementById('descCounter');
    if (!counter) return;
    const len = textarea.value.length;
    counter.textContent = len + ' / 500';
    counter.className = 'dept-char-counter'
        + (len > 400 ? ' warn' : '')
        + (len >= 500 ? ' over' : '');
}

/** Chon mau sac nhan dien phong ban */
function selectColor(dot) {
    document.querySelectorAll('.dept-color-dot').forEach(d => d.classList.remove('selected'));
    dot.classList.add('selected');
    const color  = dot.dataset.color;
    const avEl   = document.getElementById('deptAvatarPreview');
    if (avEl) avEl.style.background = `linear-gradient(135deg, ${color}, ${color}bb)`;
    // Luu vao hidden input neu co
    const colorInput = document.getElementById('deptColorValue');
    if (colorInput) colorInput.value = color;
}

/** Validate form phong ban truoc khi submit */
function validateDeptForm(e) {
    const nameInput = document.getElementById('deptName');
    const feedback  = document.querySelector('.dept-invalid-feedback');
    if (!nameInput || !nameInput.value.trim()) {
        if (e) { e.preventDefault(); e.stopPropagation(); }
        if (nameInput) { nameInput.classList.add('invalid'); nameInput.focus(); }
        if (feedback)  { feedback.style.display = 'block'; }
        return false;
    }
    // Disable submit button khi dang luu
    const submitBtn = document.getElementById('btnSubmitDept');
    if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Dang luu...';
    }
    return true;
}

/* ===========================
   DOM READY
   =========================== */
document.addEventListener('DOMContentLoaded', function () {

    // --- List page ---
    animateKpiCounters();

    // Real-time search on input
    const searchInput = document.getElementById('deptSearchInput');
    if (searchInput) {
        searchInput.addEventListener('input', filterDeptTable);
    }

    // Individual row checkboxes update bulk actions
    document.querySelectorAll('.row-cb').forEach(cb => {
        cb.addEventListener('change', updateBulkActions);
    });

    // --- Form page ---
    const nameInput = document.getElementById('deptName');
    const descInput = document.getElementById('deptDesc');
    const form      = document.getElementById('deptForm');

    if (nameInput && nameInput.value) updatePreview(nameInput);
    if (descInput && descInput.value) updateDescCounter(descInput);

    if (form) {
        form.addEventListener('submit', validateDeptForm);
        if (nameInput) {
            nameInput.addEventListener('input', function () {
                if (this.value.trim()) {
                    this.classList.remove('invalid');
                    const fb = document.querySelector('.dept-invalid-feedback');
                    if (fb) fb.style.display = 'none';
                }
            });
        }
    }

    // Auto-dismiss alerts after 5 seconds
    document.querySelectorAll('.alert-dismissible').forEach(alert => {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) bsAlert.close();
        }, 5000);
    });
});

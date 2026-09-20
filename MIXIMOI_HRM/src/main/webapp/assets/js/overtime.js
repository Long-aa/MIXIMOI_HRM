/**
 * MIXIMOI HRM — OVERTIME MODULE JAVASCRIPT (overtime.js)
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('[Overtime] Module initialized.');
});

/**
 * Tính số giờ OT và hiển thị hệ số tức thời khi người dùng chọn thời gian
 */
function calculateOtHours() {
    const start = document.getElementById('otStartTime').value;
    const end = document.getElementById('otEndTime').value;
    const coeff = document.getElementById('otCoefficient').value;

    if (start && end) {
        const [sh, sm] = start.split(':').map(Number);
        const [eh, em] = end.split(':').map(Number);
        let sMinutes = sh * 60 + sm;
        let eMinutes = eh * 60 + em;
        if (eMinutes < sMinutes) eMinutes += 24 * 60; // qua đêm
        const diffHours = Math.max(0.5, Math.round(((eMinutes - sMinutes) / 60.0) * 10) / 10);
        var disp = document.getElementById('calcHoursDisplay');
        if (disp) disp.innerText = diffHours;
    }
    var coeffDisp = document.getElementById('calcCoeffDisplay');
    if (coeffDisp) coeffDisp.innerText = coeff + 'x';
}

/**
 * Mở modal Từ chối đơn OT
 * @param {string|number} id 
 * @param {string} name 
 * @param {string} project 
 */
function openRejectOtModal(id, name, project) {
    var idEl = document.getElementById('sharedRejectOtId');
    if (idEl) idEl.value = id;
    var empEl = document.getElementById('sharedRejectOtEmp');
    if (empEl) empEl.textContent = name;
    var projEl = document.getElementById('sharedRejectOtProj');
    if (projEl) projEl.textContent = project;

    var modalEl = document.getElementById('sharedRejectOtModal');
    if (modalEl) {
        var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        modal.show();
    }
}

/**
 * Mở modal Xem chi tiết đơn OT
 * @param {HTMLElement} btn 
 */
function openViewOtModal(btn) {
    var proj = document.getElementById('sharedViewOtProj');
    if (proj) proj.textContent = btn.getAttribute('data-project') || '—';

    var emp = document.getElementById('sharedViewOtEmp');
    if (emp) emp.textContent = btn.getAttribute('data-emp') || '—';

    var dt = document.getElementById('sharedViewOtDate');
    if (dt) dt.textContent = btn.getAttribute('data-date') || '—';

    var hrs = document.getElementById('sharedViewOtHours');
    if (hrs) hrs.textContent = btn.getAttribute('data-hours') || '—';

    var amt = document.getElementById('sharedViewOtAmount');
    if (amt) amt.textContent = btn.getAttribute('data-amount') || '—';

    var rsn = document.getElementById('sharedViewOtReason');
    if (rsn) rsn.textContent = btn.getAttribute('data-reason') || '—';

    var lead = document.getElementById('sharedViewOtLead');
    if (lead) lead.textContent = btn.getAttribute('data-lead') || '—';

    var hr = document.getElementById('sharedViewOtHr');
    if (hr) hr.textContent = btn.getAttribute('data-hr') || '—';

    var modalEl = document.getElementById('sharedViewOtModal');
    if (modalEl) {
        var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        modal.show();
    }
}

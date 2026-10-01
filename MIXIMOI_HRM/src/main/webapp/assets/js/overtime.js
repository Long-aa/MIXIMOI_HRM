/**
 * MIXIMOI HRM — OVERTIME MODULE JAVASCRIPT (overtime.js)
 * High-performance AJAX actions, Dynamic DOM state updates, No page reloads.
 */

document.addEventListener('DOMContentLoaded', function () {
    console.log('[Overtime] Module initialized with AJAX support.');

    // 1. Intercept Direct Approval Forms (Lead & HR)
    document.addEventListener('submit', function (e) {
        const form = e.target;
        if (!form) return;

        const actionInput = form.querySelector('input[name="action"]');
        const idInput = form.querySelector('input[name="id"]');
        if (!actionInput || !idInput) return;

        const action = actionInput.value;
        if (action === 'approve_lead' || action === 'approve_hr') {
            e.preventDefault();
            handleDirectOtApprove(form, action, idInput.value);
        } else if (action === 'reject') {
            e.preventDefault();
            handleRejectOtSubmit(form);
        }
    });
});

/**
 * Handle AJAX Lead & HR Overtime approval
 */
async function handleDirectOtApprove(form, action, otId) {
    const submitBtn = form.querySelector('button[type="submit"]');
    const originalBtnHtml = submitBtn ? submitBtn.innerHTML : '';
    if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status"></span>';
    }

    try {
        const formData = new URLSearchParams(new FormData(form));
        formData.set('ajax', 'true');

        const response = await fetch(form.action, {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: formData.toString()
        });

        const data = await response.json();
        if (data.success) {
            if (window.MixiToast) {
                window.MixiToast.success(data.message || 'Phê duyệt tăng ca thành công');
            }
            updateOtRowState(otId, action, data);
        } else {
            if (window.MixiToast) {
                window.MixiToast.error(data.message || 'Không thể phê duyệt đơn tăng ca');
            }
            if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalBtnHtml;
            }
        }
    } catch (err) {
        console.error('[Overtime] AJAX approval error:', err);
        if (window.MixiToast) {
            window.MixiToast.error('Lỗi kết nối khi gửi yêu cầu phê duyệt');
        }
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalBtnHtml;
        }
    }
}

/**
 * Handle Reject Modal AJAX submission
 */
async function handleRejectOtSubmit(form) {
    const submitBtn = form.querySelector('button[type="submit"]');
    const originalText = submitBtn ? submitBtn.innerHTML : '';
    if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Đang xử lý...';
    }

    const otId = form.querySelector('input[name="id"]')?.value;
    const reason = form.querySelector('textarea[name="rejectReason"]')?.value;

    try {
        const formData = new URLSearchParams(new FormData(form));
        formData.set('ajax', 'true');

        const response = await fetch(form.action, {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: formData.toString()
        });

        const data = await response.json();

        // Close modal
        const modalEl = document.getElementById('sharedRejectOtModal');
        if (modalEl) {
            const modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) modal.hide();
        }

        if (data.success) {
            if (window.MixiToast) {
                window.MixiToast.success(data.message || 'Đã từ chối đơn tăng ca thành công');
            }
            updateOtRowState(otId, 'reject', { ...data, rejectReason: reason });
        } else {
            if (window.MixiToast) {
                window.MixiToast.error(data.message || 'Không thể từ chối đơn tăng ca');
            }
        }
    } catch (err) {
        console.error('[Overtime] AJAX reject error:', err);
        if (window.MixiToast) {
            window.MixiToast.error('Lỗi kết nối khi từ chối đơn tăng ca');
        }
    } finally {
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
        }
    }
}

/**
 * Dynamically update table row DOM without reloading
 */
function updateOtRowState(otId, action, data) {
    const row = document.querySelector(`tr[data-ot-id="${otId}"]`);
    if (!row) return;

    const leadStep = row.querySelector('.ot-lead-step');
    const hrStep = row.querySelector('.ot-hr-step');
    const statusCell = row.querySelector('.ot-status-cell');
    const actionsCell = row.querySelector('.ot-actions-cell');
    const empCell = row.querySelector('td:first-child');

    if (action === 'approve_lead') {
        // Cấp 1 duyệt xong -> chuyển sang Chờ duyệt cấp 2
        if (statusCell) {
            statusCell.innerHTML = '<span class="ot-status-pill pending-hr">Chờ duyệt cấp 2</span>';
        }
        if (leadStep) {
            leadStep.innerHTML = `
                <i class="bi bi-check-circle-fill step-icon-approved"></i>
                <span class="text-dark fw-bold">${data.approverName || 'Lead đã duyệt'}</span>
            `;
        }
        // Remove approve_lead button
        const approveLeadForm = actionsCell ? actionsCell.querySelector('form input[value="approve_lead"]')?.closest('form') : null;
        if (approveLeadForm) approveLeadForm.remove();

        row.classList.add('row-highlight-success');
        setTimeout(() => row.classList.remove('row-highlight-success'), 2000);

    } else if (action === 'approve_hr') {
        // Cấp 2 duyệt xong -> Hoàn tất Đã phê duyệt
        if (statusCell) {
            statusCell.innerHTML = '<span class="ot-status-pill approved">Đã phê duyệt</span>';
        }
        if (hrStep) {
            hrStep.innerHTML = `
                <i class="bi bi-check-circle-fill step-icon-approved"></i>
                <span class="text-dark fw-bold">${data.approverName || 'HR đã duyệt'}</span>
            `;
        }
        // Remove approve & reject buttons, keep view button
        if (actionsCell) {
            const forms = actionsCell.querySelectorAll('form');
            forms.forEach(f => f.remove());
            const rejectBtn = actionsCell.querySelector('.btn-act.reject');
            if (rejectBtn) rejectBtn.remove();
        }

        row.classList.add('row-highlight-success');
        setTimeout(() => row.classList.remove('row-highlight-success'), 2500);

    } else if (action === 'reject') {
        // Từ chối
        if (statusCell) {
            statusCell.innerHTML = '<span class="ot-status-pill rejected">Từ chối</span>';
        }
        if (data.rejectReason && empCell) {
            const existingReason = empCell.querySelector('.text-danger');
            if (!existingReason) {
                const note = document.createElement('div');
                note.className = 'text-danger mt-1';
                note.style.fontSize = '0.74rem';
                note.innerHTML = `<i class="bi bi-x-circle me-1"></i> Lý do từ chối: "${data.rejectReason}"`;
                empCell.appendChild(note);
            }
        }
        // Remove action buttons except view
        if (actionsCell) {
            const forms = actionsCell.querySelectorAll('form');
            forms.forEach(f => f.remove());
            const rejectBtn = actionsCell.querySelector('.btn-act.reject');
            if (rejectBtn) rejectBtn.remove();
        }

        row.classList.add('row-highlight-danger');
        setTimeout(() => row.classList.remove('row-highlight-danger'), 2500);
    }
}

/**
 * Tính số giờ OT và hiển thị hệ số tức thời khi người dùng chọn thời gian
 */
function calculateOtHours() {
    const start = document.getElementById('otStartTime')?.value;
    const end = document.getElementById('otEndTime')?.value;
    const coeff = document.getElementById('otCoefficient')?.value;

    if (start && end) {
        const [sh, sm] = start.split(':').map(Number);
        const [eh, em] = end.split(':').map(Number);
        let sMinutes = sh * 60 + sm;
        let eMinutes = eh * 60 + em;
        if (eMinutes < sMinutes) eMinutes += 24 * 60; // qua đêm
        const diffHours = Math.max(0.5, Math.round(((eMinutes - sMinutes) / 60.0) * 10) / 10);
        const disp = document.getElementById('calcHoursDisplay');
        if (disp) disp.innerText = diffHours;
    }
    const coeffDisp = document.getElementById('calcCoeffDisplay');
    if (coeffDisp && coeff) coeffDisp.innerText = coeff + 'x';
}

/**
 * Mở modal Từ chối đơn OT
 */
function openRejectOtModal(id, name, project) {
    const idEl = document.getElementById('sharedRejectOtId');
    if (idEl) idEl.value = id;
    const empEl = document.getElementById('sharedRejectOtEmp');
    if (empEl) empEl.textContent = name;
    const projEl = document.getElementById('sharedRejectOtProj');
    if (projEl) projEl.textContent = project;

    const modalEl = document.getElementById('sharedRejectOtModal');
    if (modalEl) {
        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        modal.show();
    }
}

/**
 * Mở modal Xem chi tiết đơn OT
 */
function openViewOtModal(btn) {
    const proj = document.getElementById('sharedViewOtProj');
    if (proj) proj.textContent = btn.getAttribute('data-project') || '—';

    const emp = document.getElementById('sharedViewOtEmp');
    if (emp) emp.textContent = btn.getAttribute('data-emp') || '—';

    const dt = document.getElementById('sharedViewOtDate');
    if (dt) dt.textContent = btn.getAttribute('data-date') || '—';

    const hrs = document.getElementById('sharedViewOtHours');
    if (hrs) hrs.textContent = btn.getAttribute('data-hours') || '—';

    const amt = document.getElementById('sharedViewOtAmount');
    if (amt) amt.textContent = btn.getAttribute('data-amount') || '—';

    const rsn = document.getElementById('sharedViewOtReason');
    if (rsn) rsn.textContent = btn.getAttribute('data-reason') || '—';

    const lead = document.getElementById('sharedViewOtLead');
    if (lead) lead.textContent = btn.getAttribute('data-lead') || '—';

    const hr = document.getElementById('sharedViewOtHr');
    if (hr) hr.textContent = btn.getAttribute('data-hr') || '—';

    const modalEl = document.getElementById('sharedViewOtModal');
    if (modalEl) {
        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        modal.show();
    }
}

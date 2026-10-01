/**
 * MIXIMOI HRM — PAYROLL MANAGEMENT SCRIPTS (payroll.js)
 * Handles payroll engine calculation progress, AJAX status transitions, and bulk actions.
 */
document.addEventListener('DOMContentLoaded', function() {
    'use strict';

    // =========================================================================
    // 1. Payroll Engine Calculation Progress Overlay
    // =========================================================================
    const calcModalEl = document.getElementById('payrollCalculationModal');
    let calcModal = null;
    if (calcModalEl) {
        calcModal = new bootstrap.Modal(calcModalEl, { backdrop: 'static', keyboard: false });
    }

    const progressBar = document.getElementById('payrollCalcProgressBar');
    const statusTitle = document.getElementById('payrollCalcStatusTitle');
    const step1 = document.getElementById('pstep1');
    const step2 = document.getElementById('pstep2');
    const step3 = document.getElementById('pstep3');
    const step4 = document.getElementById('pstep4');
    const step5 = document.getElementById('pstep5');

    function resetCalcSteps() {
        if (progressBar) progressBar.style.width = '15%';
        if (statusTitle) statusTitle.textContent = 'Đang khởi chạy động cơ tính lương...';
        [step1, step2, step3, step4, step5].forEach((st, idx) => {
            if (!st) return;
            st.className = 'd-flex align-items-center gap-2 text-muted';
            const icon = st.querySelector('i');
            if (icon) icon.className = 'bi bi-circle';
        });
        if (step1) {
            step1.className = 'd-flex align-items-center gap-2 text-primary fw-semibold';
            const icon = step1.querySelector('i');
            if (icon) icon.className = 'bi bi-arrow-repeat spin';
        }
    }

    function setStepDone(currentStepEl, nextStepEl, pct, nextTitle) {
        if (currentStepEl) {
            currentStepEl.className = 'd-flex align-items-center gap-2 text-success fw-semibold';
            const icon = currentStepEl.querySelector('i');
            if (icon) icon.className = 'bi bi-check-circle-fill text-success';
        }
        if (nextStepEl) {
            nextStepEl.className = 'd-flex align-items-center gap-2 text-primary fw-semibold';
            const icon = nextStepEl.querySelector('i');
            if (icon) icon.className = 'bi bi-arrow-repeat spin';
        }
        if (progressBar && pct) progressBar.style.width = pct + '%';
        if (statusTitle && nextTitle) statusTitle.textContent = nextTitle;
    }

    window.runPayrollEngine = function(month, year, confirmLock) {
        if (calcModal) calcModal.show();
        resetCalcSteps();

        // Close timesheetLockGuardModal if open
        const guardModalEl = document.getElementById('timesheetLockGuardModal');
        if (guardModalEl) {
            const guardModal = bootstrap.Modal.getInstance(guardModalEl);
            if (guardModal) guardModal.hide();
        }

        // Animated step simulation timers
        const t1 = setTimeout(() => {
            setStepDone(step1, step2, 35, 'Đang tổng hợp dữ liệu công thực tế & giờ tăng ca (OT)...');
        }, 500);

        const t2 = setTimeout(() => {
            setStepDone(step2, step3, 60, 'Đang tính toán phụ cấp và tiền thưởng hiệu suất...');
        }, 1100);

        const t3 = setTimeout(() => {
            setStepDone(step3, step4, 80, 'Đang áp dụng biểu tỷ lệ BHXH (10.5%) & Thuế TNCN lũy tiến 7 bậc...');
        }, 1700);

        const t4 = setTimeout(() => {
            setStepDone(step4, step5, 95, 'Đang ghi nhận và tạo snapshot phiếu lương điện tử...');
        }, 2200);

        // Send AJAX Request to Servlet
        const formData = new FormData();
        formData.append('action', 'calculate');
        formData.append('month', month);
        formData.append('year', year);
        if (confirmLock) formData.append('confirmLock', 'true');
        formData.append('ajax', 'true');

        fetch(window.location.href, {
            method: 'POST',
            body: formData,
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(async res => {
            const data = await res.json().catch(() => null);
            if (!data) {
                throw new Error('Máy chủ phản hồi mã lỗi HTTP: ' + res.status);
            }
            return data;
        })
        .then(data => {
            clearTimeout(t1); clearTimeout(t2); clearTimeout(t3); clearTimeout(t4);
            [step1, step2, step3, step4, step5].forEach(st => {
                if (st) {
                    st.className = 'd-flex align-items-center gap-2 text-success fw-semibold';
                    const icon = st.querySelector('i');
                    if (icon) icon.className = 'bi bi-check-circle-fill text-success';
                }
            });
            if (progressBar) progressBar.style.width = '100%';
            if (statusTitle) statusTitle.textContent = 'Hoàn tất tính toán bảng lương!';

            setTimeout(() => {
                if (calcModal) calcModal.hide();
                if (data.success) {
                    if (window.MixiToast) {
                        MixiToast.success('Thành công', data.message || 'Tính toán bảng lương thành công!');
                    }
                    setTimeout(() => window.location.reload(), 800);
                } else {
                    if (window.MixiToast) {
                        MixiToast.error('Không thể tính lương', data.message || 'Có lỗi trong quá trình tính lương!');
                    } else {
                        alert(data.message || 'Có lỗi trong quá trình tính lương!');
                    }
                }
            }, 600);
        })
        .catch(err => {
            clearTimeout(t1); clearTimeout(t2); clearTimeout(t3); clearTimeout(t4);
            console.error('Payroll engine error:', err);
            if (calcModal) calcModal.hide();
            if (window.MixiToast) {
                MixiToast.error('Lỗi kết nối máy chủ khi tính lương', err.message || 'Vui lòng kiểm tra lại đường truyền mạng hoặc nhật ký máy chủ.');
            }
        });
    };

    // Bind triggers for calculate buttons
    const btnRunCalc = document.getElementById('btnRunPayrollCalc');
    if (btnRunCalc) {
        btnRunCalc.addEventListener('click', function(e) {
            e.preventDefault();
            const form = btnRunCalc.closest('form');
            const month = form.querySelector('input[name="month"]').value;
            const year = form.querySelector('input[name="year"]').value;
            window.runPayrollEngine(month, year, false);
        });
    }

    const btnGuardRunCalc = document.getElementById('btnGuardRunPayrollCalc');
    if (btnGuardRunCalc) {
        btnGuardRunCalc.addEventListener('click', function(e) {
            e.preventDefault();
            const form = btnGuardRunCalc.closest('form');
            const month = form.querySelector('input[name="month"]').value;
            const year = form.querySelector('input[name="year"]').value;
            window.runPayrollEngine(month, year, true);
        });
    }

    // =========================================================================
    // 2. AJAX Row Action Interceptor (submit_approval, approve, process_payment, pay)
    // =========================================================================
    document.addEventListener('submit', function(e) {
        const form = e.target.closest('form');
        if (!form) return;

        // Skip bulk approve all form which has its own listener below
        const actionInput = form.querySelector('input[name="action"]');
        if (!actionInput) return;
        const action = actionInput.value;
        if (!['approve', 'pay', 'submit_approval', 'process_payment'].includes(action)) return;

        e.preventDefault();

        const btn = form.querySelector('button[type="submit"]');
        const originalHtml = btn ? btn.innerHTML : '';
        if (btn) {
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status"></span>';
        }

        const formData = new FormData(form);
        formData.append('ajax', 'true');
        const row = form.closest('tr');

        fetch(form.action || window.location.pathname, {
            method: 'POST',
            body: formData,
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                if (window.MixiToast) {
                    MixiToast.success(data.message || 'Thao tác thành công!');
                }
                updatePayrollRowUI(row, data.newStatus || (action === 'pay' ? 'PAID' : action === 'approve' ? 'APPROVED' : 'PENDING_APPROVAL'));
            } else {
                if (window.MixiToast) {
                    MixiToast.error(data.message || 'Có lỗi xảy ra!');
                } else {
                    alert(data.message || 'Có lỗi xảy ra!');
                }
                if (btn) {
                    btn.disabled = false;
                    btn.innerHTML = originalHtml;
                }
            }
        })
        .catch(err => {
            console.error('Payroll action error:', err);
            if (window.MixiToast) {
                MixiToast.error('Lỗi kết nối máy chủ!');
            }
            if (btn) {
                btn.disabled = false;
                btn.innerHTML = originalHtml;
            }
        });
    });

    function updatePayrollRowUI(row, newStatus) {
        if (!row) return;
        const statusCell = row.querySelector('.status-cell') || (row.cells && row.cells.length > 10 ? row.cells[10] : null);
        const actionCell = row.querySelector('.action-cell') || (row.cells && row.cells.length > 11 ? row.cells[11] : null);

        if (statusCell) {
            if (newStatus === 'PAID') {
                statusCell.innerHTML = '<span class="badge bg-success-subtle text-success border"><i class="bi bi-patch-check-fill me-1"></i>Đã chi trả</span>';
            } else if (newStatus === 'PROCESSING_PAYMENT') {
                statusCell.innerHTML = '<span class="badge bg-info-subtle text-info border"><i class="bi bi-arrow-repeat me-1"></i>Đang chi trả</span>';
            } else if (newStatus === 'APPROVED') {
                statusCell.innerHTML = '<span class="badge bg-primary-subtle text-primary border"><i class="bi bi-check-circle-fill me-1"></i>Đã duyệt</span>';
            } else if (newStatus === 'PENDING_APPROVAL' || newStatus === 'PENDING') {
                statusCell.innerHTML = '<span class="badge bg-warning-subtle text-warning-emphasis border"><i class="bi bi-hourglass-split me-1"></i>Chờ duyệt</span>';
            } else {
                statusCell.innerHTML = '<span class="badge bg-secondary-subtle text-secondary border"><i class="bi bi-pencil-square me-1"></i>Bản nháp</span>';
            }
        }

        // Action cell buttons
        if (actionCell) {
            if (newStatus === 'PAID') {
                actionCell.querySelectorAll('.payroll-action-form').forEach(el => el.remove());
            } else if (newStatus === 'APPROVED') {
                // Remove approve and submit buttons
                actionCell.querySelectorAll('form[action*="approve"], form[action*="submit_approval"]').forEach(el => el.remove());
            }
        }

        // Highlight flash animation
        row.style.transition = 'background-color 0.4s ease';
        if (newStatus === 'PAID') {
            row.style.backgroundColor = '#dcfce7';
        } else if (newStatus === 'APPROVED') {
            row.style.backgroundColor = '#dbeafe';
        } else if (newStatus === 'PROCESSING_PAYMENT') {
            row.style.backgroundColor = '#e0e7ff';
        }
        setTimeout(() => row.style.backgroundColor = '', 1600);
    }

    // =========================================================================
    // 3. Approve All AJAX Interceptor
    // =========================================================================
    const approveAllForm = document.querySelector('form input[value="approve_all"]')?.closest('form');
    if (approveAllForm) {
        approveAllForm.addEventListener('submit', function(e) {
            e.preventDefault();
            if (!confirm('Xác nhận phê duyệt toàn bộ bảng lương tháng này?')) return;

            const btn = approveAllForm.querySelector('button[type="submit"]');
            const originalHtml = btn ? btn.innerHTML : '';
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Đang duyệt...';
            }

            const formData = new FormData(approveAllForm);
            formData.append('ajax', 'true');

            fetch(approveAllForm.action || window.location.pathname, {
                method: 'POST',
                body: formData,
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
            .then(res => res.json())
            .then(data => {
                if (btn) {
                    btn.disabled = false;
                    btn.innerHTML = originalHtml;
                }
                if (data.success) {
                    if (window.MixiToast) MixiToast.success(data.message);
                    document.querySelectorAll('.table-custom tbody tr').forEach(row => {
                        const statusCell = row.querySelector('.status-cell');
                        if (statusCell && !statusCell.textContent.includes('Đã chi trả')) {
                            updatePayrollRowUI(row, 'APPROVED');
                        }
                    });
                } else {
                    if (window.MixiToast) MixiToast.error(data.message);
                }
            })
            .catch(err => {
                console.error('Approve all error:', err);
                if (btn) {
                    btn.disabled = false;
                    btn.innerHTML = originalHtml;
                }
                if (window.MixiToast) MixiToast.error('Lỗi kết nối máy chủ!');
            });
        });
    }
});

/**
 * MIXIMOI HRM — LEAVE MANAGEMENT SCRIPTS (leave.js)
 */
document.addEventListener('DOMContentLoaded', function() {
    'use strict';

    // 0. Dynamic Progress Bar Hydration
    document.querySelectorAll('.dynamic-progress[data-pct]').forEach(function(el) {
        var pct = el.getAttribute('data-pct');
        if (pct !== null && pct !== '') {
            el.style.width = pct + '%';
        }
    });

    // 1. Bulk Selection & Toolbar Management
    const checkAll = document.getElementById('checkAllLeave');
    const bulkToolbar = document.getElementById('bulkToolbar');
    const bulkCount = document.getElementById('bulkCount');

    function updateBulkToolbar() {
        const checkedBoxes = document.querySelectorAll('.row-check-leave:checked');
        const count = checkedBoxes.length;
        if (bulkCount) bulkCount.textContent = count;
        if (bulkToolbar) {
            if (count > 0) {
                bulkToolbar.classList.remove('d-none');
                bulkToolbar.classList.add('d-flex');
            } else {
                bulkToolbar.classList.add('d-none');
                bulkToolbar.classList.remove('d-flex');
            }
        }
        if (checkAll) {
            const allBoxes = document.querySelectorAll('.row-check-leave');
            checkAll.checked = allBoxes.length > 0 && checkedBoxes.length === allBoxes.length;
        }
    }

    if (checkAll) {
        checkAll.addEventListener('change', function() {
            document.querySelectorAll('.row-check-leave').forEach(cb => {
                const tr = cb.closest('tr');
                if (!tr || tr.style.display !== 'none') {
                    cb.checked = checkAll.checked;
                }
            });
            updateBulkToolbar();
        });
    }

    document.addEventListener('change', function(e) {
        if (e.target && e.target.classList.contains('row-check-leave')) {
            updateBulkToolbar();
        }
    });

    window.clearLeaveSelection = function() {
        document.querySelectorAll('.row-check-leave').forEach(cb => cb.checked = false);
        if (checkAll) checkAll.checked = false;
        updateBulkToolbar();
    };

    // Helper function to update a row's UI after status transition
    function updateLeaveRowStatus(row, newStatus) {
        if (!row) return;
        row.setAttribute('data-status', newStatus);

        // 1. Status Pill (column before last)
        const statusCell = row.cells[row.cells.length - 2];
        if (statusCell) {
            if (newStatus === 'MANAGER_APPROVED') {
                statusCell.innerHTML = '<span class="status-pill-matrix" style="background:#fef3c7; color:#b45309; border:1px solid #fde68a;"><i class="bi bi-clock-history"></i> TP đã duyệt</span>';
            } else if (newStatus === 'APPROVED') {
                statusCell.innerHTML = '<span class="status-pill-matrix approved"><i class="bi bi-check-circle-fill"></i> Đã duyệt</span>';
            } else if (newStatus === 'REJECTED') {
                statusCell.innerHTML = '<span class="status-pill-matrix anomaly"><i class="bi bi-x-circle-fill"></i> Từ chối</span>';
            } else if (newStatus === 'CANCELLED') {
                statusCell.innerHTML = '<span class="status-pill-matrix" style="background:#f1f5f9; color:#64748b; border:1px solid #cbd5e1;"><i class="bi bi-dash-circle"></i> Đã hủy</span>';
            }
        }

        // 2. Multi-step TP -> HR Badge
        const stepSpan = row.querySelector('.step-tp-hr');
        if (stepSpan) {
            const badges = stepSpan.querySelectorAll('.badge');
            if (badges.length >= 2) {
                const tpBadge = badges[0];
                const hrBadge = badges[1];
                if (newStatus === 'MANAGER_APPROVED') {
                    tpBadge.className = 'badge bg-success text-white';
                    tpBadge.innerHTML = 'TP <i class="bi bi-check"></i>';
                } else if (newStatus === 'APPROVED') {
                    tpBadge.className = 'badge bg-success text-white';
                    tpBadge.innerHTML = 'TP <i class="bi bi-check"></i>';
                    hrBadge.className = 'badge bg-success text-white';
                    hrBadge.innerHTML = 'HR <i class="bi bi-check"></i>';
                } else if (newStatus === 'REJECTED') {
                    tpBadge.className = 'badge bg-danger text-white';
                    hrBadge.className = 'badge bg-danger text-white';
                }
            }
        }

        // 3. Remove action buttons that are no longer valid
        const actionGroup = row.querySelector('.laction-btn-group');
        if (actionGroup) {
            if (newStatus === 'APPROVED' || newStatus === 'REJECTED' || newStatus === 'CANCELLED') {
                // Remove approve/reject/cancel forms and buttons, preserve view and attachment
                actionGroup.querySelectorAll('.leave-action-form, button.no').forEach(el => el.remove());
            } else if (newStatus === 'MANAGER_APPROVED') {
                // If Manager just approved, remove TP approve/reject buttons
                actionGroup.querySelectorAll('form[action*="managerApprove"], button.no').forEach(el => el.remove());
            }
        }

        // 4. Highlight flash
        row.style.transition = 'background-color 0.5s ease';
        if (newStatus === 'APPROVED') {
            row.style.backgroundColor = '#dcfce7';
        } else if (newStatus === 'MANAGER_APPROVED') {
            row.style.backgroundColor = '#fef9c3';
        } else if (newStatus === 'REJECTED') {
            row.style.backgroundColor = '#fee2e2';
        } else if (newStatus === 'CANCELLED') {
            row.style.backgroundColor = '#f1f5f9';
            row.style.opacity = '0.65';
        }
        setTimeout(() => {
            if (newStatus !== 'CANCELLED') row.style.backgroundColor = '';
        }, 1800);
    }

    // Intercept single action forms (managerApprove, hrApprove, cancel)
    document.addEventListener('submit', function(e) {
        const form = e.target.closest('.leave-action-form');
        if (!form) return;
        e.preventDefault();

        const btn = form.querySelector('button[type="submit"]');
        const originalHtml = btn ? btn.innerHTML : '';
        if (btn) {
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status"></span>';
        }

        const formData = new FormData(form);
        formData.append('ajax', 'true');
        const row = form.closest('tr.leave-row');

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
                updateLeaveRowStatus(row, data.newStatus);
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
            console.error('Leave action error:', err);
            if (window.MixiToast) {
                MixiToast.error('Lỗi kết nối máy chủ!');
            }
            if (btn) {
                btn.disabled = false;
                btn.innerHTML = originalHtml;
            }
        });
    });

    // Intercept single reject modal form
    const rejectForm = document.getElementById('sharedRejectLeaveForm');
    if (rejectForm) {
        rejectForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const submitBtn = rejectForm.querySelector('button[type="submit"]');
            const originalHtml = submitBtn ? submitBtn.innerHTML : '';
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Đang xử lý...';
            }

            const formData = new FormData(rejectForm);
            formData.append('ajax', 'true');
            const leaveId = formData.get('id');

            fetch(rejectForm.action || window.location.pathname, {
                method: 'POST',
                body: formData,
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
            .then(res => res.json())
            .then(data => {
                if (submitBtn) {
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalHtml;
                }
                const modalEl = document.getElementById('sharedRejectLeaveModal');
                if (modalEl) {
                    const bsModal = bootstrap.Modal.getInstance(modalEl);
                    if (bsModal) bsModal.hide();
                }
                if (data.success) {
                    if (window.MixiToast) {
                        MixiToast.warning(data.message || 'Đã từ chối đơn thành công!');
                    }
                    const row = document.querySelector('tr.leave-row[data-id="' + leaveId + '"]');
                    updateLeaveRowStatus(row, 'REJECTED');
                } else {
                    if (window.MixiToast) {
                        MixiToast.error(data.message || 'Không thể từ chối đơn!');
                    }
                }
            })
            .catch(err => {
                console.error('Reject leave error:', err);
                if (submitBtn) {
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalHtml;
                }
                if (window.MixiToast) {
                    MixiToast.error('Lỗi kết nối máy chủ!');
                }
            });
        });
    }

    window.bulkApproveLeave = function() {
        const checkedBoxes = Array.from(document.querySelectorAll('.row-check-leave:checked'));
        if (checkedBoxes.length === 0) {
            if (window.MixiToast) MixiToast.warning('Vui lòng chọn ít nhất một đơn nghỉ phép.');
            else alert('Vui lòng chọn ít nhất một đơn nghỉ phép.');
            return;
        }
        if (!confirm('Bạn có chắc chắn muốn phê duyệt ' + checkedBoxes.length + ' đơn nghỉ phép đã chọn? Dữ liệu sẽ tự động đồng bộ sang bảng chấm công.')) {
            return;
        }

        const formData = new FormData();
        formData.append('action', 'bulkApprove');
        formData.append('ajax', 'true');
        checkedBoxes.forEach(cb => formData.append('ids', cb.value));

        fetch(window.location.pathname, {
            method: 'POST',
            body: formData,
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                if (window.MixiToast) MixiToast.success(data.message);
                checkedBoxes.forEach(cb => {
                    const row = cb.closest('tr.leave-row');
                    updateLeaveRowStatus(row, 'APPROVED');
                });
                window.clearLeaveSelection();
            } else {
                if (window.MixiToast) MixiToast.error(data.message);
            }
        })
        .catch(err => {
            console.error('Bulk approve error:', err);
            if (window.MixiToast) MixiToast.error('Lỗi kết nối khi duyệt hàng loạt!');
        });
    };

    window.bulkRejectLeave = function() {
        const checkedBoxes = Array.from(document.querySelectorAll('.row-check-leave:checked'));
        if (checkedBoxes.length === 0) {
            if (window.MixiToast) MixiToast.warning('Vui lòng chọn ít nhất một đơn nghỉ phép.');
            else alert('Vui lòng chọn ít nhất một đơn nghỉ phép.');
            return;
        }
        const reason = prompt('Nhập lý do từ chối các đơn đã chọn:', 'Không đủ điều kiện phê duyệt kỳ này');
        if (reason === null) return;

        const formData = new FormData();
        formData.append('action', 'bulkReject');
        formData.append('rejectReason', reason);
        formData.append('ajax', 'true');
        checkedBoxes.forEach(cb => formData.append('ids', cb.value));

        fetch(window.location.pathname, {
            method: 'POST',
            body: formData,
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                if (window.MixiToast) MixiToast.warning(data.message);
                checkedBoxes.forEach(cb => {
                    const row = cb.closest('tr.leave-row');
                    updateLeaveRowStatus(row, 'REJECTED');
                });
                window.clearLeaveSelection();
            } else {
                if (window.MixiToast) MixiToast.error(data.message);
            }
        })
        .catch(err => {
            console.error('Bulk reject error:', err);
            if (window.MixiToast) MixiToast.error('Lỗi kết nối khi từ chối hàng loạt!');
        });
    };

    window.bulkDeleteLeave = function() {
        const checkedBoxes = Array.from(document.querySelectorAll('.row-check-leave:checked'));
        if (checkedBoxes.length === 0) {
            if (window.MixiToast) MixiToast.warning('Vui lòng chọn ít nhất một đơn nghỉ phép.');
            else alert('Vui lòng chọn ít nhất một đơn nghỉ phép.');
            return;
        }
        if (!confirm('Bạn có chắc chắn muốn xóa ' + checkedBoxes.length + ' đơn nghỉ phép đã chọn không? Thao tác này không thể hoàn tác.')) {
            return;
        }

        const formData = new FormData();
        formData.append('action', 'bulkDelete');
        formData.append('ajax', 'true');
        checkedBoxes.forEach(cb => formData.append('ids', cb.value));

        fetch(window.location.pathname, {
            method: 'POST',
            body: formData,
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                if (window.MixiToast) MixiToast.success(data.message);
                checkedBoxes.forEach(cb => {
                    const row = cb.closest('tr.leave-row');
                    if (row) {
                        row.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
                        row.style.opacity = '0';
                        row.style.transform = 'scale(0.96)';
                        setTimeout(() => row.remove(), 400);
                    }
                });
                window.clearLeaveSelection();
            } else {
                if (window.MixiToast) MixiToast.error(data.message);
            }
        })
        .catch(err => {
            console.error('Bulk delete error:', err);
            if (window.MixiToast) MixiToast.error('Lỗi kết nối khi xóa đơn hàng loạt!');
        });
    };

    window.bulkExportLeave = function() {
        const checkedBoxes = document.querySelectorAll('.row-check-leave:checked');
        if (checkedBoxes.length === 0) {
            if (window.MixiToast) MixiToast.warning('Vui lòng chọn ít nhất một đơn nghỉ phép để xuất.');
            else alert('Vui lòng chọn ít nhất một đơn nghỉ phép để xuất.');
            return;
        }
        if (window.MixiToast) MixiToast.info('Đang xuất danh sách đơn nghỉ phép...');
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = window.location.pathname;

        const actInput = document.createElement('input');
        actInput.type = 'hidden';
        actInput.name = 'action';
        actInput.value = 'bulkExport';
        form.appendChild(actInput);

        checkedBoxes.forEach(cb => {
            const inp = document.createElement('input');
            inp.type = 'hidden';
            inp.name = 'ids';
            inp.value = cb.value;
            form.appendChild(inp);
        });

        document.body.appendChild(form);
        form.submit();
    };

    // 2. Realtime Search & Filter for Leave Table
    const searchInput = document.getElementById('leaveSearchInput');
    const filterStatus = document.getElementById('leaveFilterStatus');
    const filterDept = document.getElementById('leaveFilterDept');
    const filterType = document.getElementById('leaveFilterType');

    function filterLeaveTable() {
        const query = searchInput ? searchInput.value.toLowerCase().trim() : '';
        const status = filterStatus ? filterStatus.value.trim().toUpperCase() : '';
        const deptId = filterDept ? filterDept.value.trim() : '';
        const leaveType = filterType ? filterType.value.trim().toUpperCase() : '';

        const rows = document.querySelectorAll('.leave-row');
        let visibleCount = 0;

        rows.forEach(row => {
            const rowKeyword = (row.getAttribute('data-keyword') || '').toLowerCase();
            const rowStatus = (row.getAttribute('data-status') || '').toUpperCase();
            const rowDept = row.getAttribute('data-dept') || '';
            const rowType = (row.getAttribute('data-type') || '').toUpperCase();

            let matchKeyword = !query || rowKeyword.includes(query);
            let matchStatus = !status || status === 'ALL' || rowStatus === status;
            let matchDept = !deptId || rowDept === deptId;
            let matchType = !leaveType || leaveType === 'ALL' || rowType === leaveType;

            if (matchKeyword && matchStatus && matchDept && matchType) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
                const cb = row.querySelector('.row-check-leave');
                if (cb && cb.checked) {
                    cb.checked = false;
                }
            }
        });

        updateBulkToolbar();

        // Empty state row
        let emptyRow = document.getElementById('leaveEmptyFilterRow');
        const tbody = document.querySelector('#leaveTable tbody');
        if (tbody) {
            if (visibleCount === 0 && rows.length > 0) {
                if (!emptyRow) {
                    emptyRow = document.createElement('tr');
                    emptyRow.id = 'leaveEmptyFilterRow';
                    emptyRow.innerHTML = '<td colspan="12" class="text-center py-5 text-muted">' +
                        '<i class="bi bi-calendar-x fs-2 d-block mb-2 text-secondary"></i>' +
                        'Không tìm thấy đơn xin nghỉ phép nào phù hợp với bộ lọc hiện tại</td>';
                    tbody.appendChild(emptyRow);
                } else {
                    emptyRow.style.display = '';
                }
            } else if (emptyRow) {
                emptyRow.style.display = 'none';
            }
        }
    }

    let debounceTimer;
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(filterLeaveTable, 150);
        });
    }

    if (filterStatus) filterStatus.addEventListener('change', filterLeaveTable);
    if (filterDept) filterDept.addEventListener('change', filterLeaveTable);
    if (filterType) filterType.addEventListener('change', filterLeaveTable);

    // Form inputs auto calculate days
    var startInput = document.querySelector('input[name="startDate"]');
    var endInput = document.querySelector('input[name="endDate"]');
    if (startInput) startInput.addEventListener('change', calculateLeaveDays);
    if (endInput) endInput.addEventListener('change', calculateLeaveDays);
});

// Reject Modal Helper
function openRejectModal(id, code, name) {
    var idInput = document.getElementById('rejectLeaveId');
    var codeEl = document.getElementById('rejectLeaveCode');
    var nameEl = document.getElementById('rejectLeaveName');
    if (idInput) idInput.value = id;
    if (codeEl) codeEl.textContent = code;
    if (nameEl) nameEl.textContent = name;
    var modalEl = document.getElementById('rejectModal');
    if (modalEl) {
        new bootstrap.Modal(modalEl).show();
    }
}

// Quick Approve Helper
function confirmApprove(id, code) {
    if (confirm('Phê duyệt đơn nghỉ phép ' + code + '?')) {
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = window.location.pathname;
        var act = document.createElement('input');
        act.type = 'hidden'; act.name = 'action'; act.value = 'approve';
        var idIn = document.createElement('input');
        idIn.type = 'hidden'; idIn.name = 'id'; idIn.value = id;
        form.appendChild(act);
        form.appendChild(idIn);
        document.body.appendChild(form);
        form.submit();
    }
}

// Toggle between Full Day and Half Day mode
window.toggleDurationMode = function() {
    var isHalf = document.getElementById('durationHalf') && document.getElementById('durationHalf').checked;
    var sessionBlock = document.getElementById('sessionSelectBlock');
    var endDateCol = document.getElementById('endDateCol');
    var startDateCol = document.getElementById('startDateCol');
    var startDateLabel = document.getElementById('startDateLabel');
    var startInput = document.getElementById('leaveStartDate');
    var endInput = document.getElementById('leaveEndDate');

    if (isHalf) {
        if (sessionBlock) sessionBlock.classList.remove('d-none');
        if (endDateCol) endDateCol.classList.add('d-none');
        if (startDateCol) {
            startDateCol.classList.remove('col-md-6');
            startDateCol.classList.add('col-12');
        }
        if (startDateLabel) startDateLabel.textContent = 'Ngày nghỉ phép';
        if (startInput && endInput) {
            endInput.value = startInput.value;
        }
    } else {
        if (sessionBlock) sessionBlock.classList.add('d-none');
        if (endDateCol) endDateCol.classList.remove('d-none');
        if (startDateCol) {
            startDateCol.classList.remove('col-12');
            startDateCol.classList.add('col-md-6');
        }
        if (startDateLabel) startDateLabel.textContent = 'Bắt đầu nghỉ từ ngày';
    }
    calculateLeaveDays();
};

window.handleStartDateChange = function() {
    var isHalf = document.getElementById('durationHalf') && document.getElementById('durationHalf').checked;
    var startInput = document.getElementById('leaveStartDate');
    var endInput = document.getElementById('leaveEndDate');
    if (isHalf && startInput && endInput) {
        endInput.value = startInput.value;
    }
    calculateLeaveDays();
};

// Auto calculate days in Leave Form & Modal (excludes Saturday & Sunday)
window.calculateLeaveDays = function() {
    var startInput = document.querySelector('input[name="startDate"]');
    var endInput = document.querySelector('input[name="endDate"]');
    var daysInput = document.querySelector('input[name="days"]');
    var estBadge = document.getElementById('estimatedDays');
    var weekendNotice = document.getElementById('weekendNotice');
    var quotaNotice = document.getElementById('quotaExceededNotice');
    var isHalf = document.getElementById('durationHalf') && document.getElementById('durationHalf').checked;
    var leaveTypeSelect = document.getElementById('leaveTypeSelect');
    var availBadge = document.getElementById('userAvailDaysBadge');

    if (!startInput || !startInput.value) return;

    const VN_HOLIDAYS_2026 = new Set([
        '2026-01-01',
        '2026-02-16', '2026-02-17', '2026-02-18', '2026-02-19', '2026-02-20',
        '2026-04-26', '2026-04-30', '2026-05-01',
        '2026-09-01', '2026-09-02'
    ]);

    function formatDateYMD(d) {
        var y = d.getFullYear();
        var m = String(d.getMonth() + 1).padStart(2, '0');
        var day = String(d.getDate()).padStart(2, '0');
        return y + '-' + m + '-' + day;
    }

    if (isHalf) {
        if (endInput) endInput.value = startInput.value;
        var d1 = new Date(startInput.value);
        var dayOfWeek = d1.getDay();
        var ymd = formatDateYMD(d1);
        if (dayOfWeek === 0 || dayOfWeek === 6 || VN_HOLIDAYS_2026.has(ymd)) { // Thứ 7, CN hoặc Lễ
            if (weekendNotice) {
                weekendNotice.classList.remove('d-none');
                weekendNotice.innerHTML = '<i class="bi bi-exclamation-triangle-fill text-warning me-1"></i> Ngày bạn chọn rơi vào ngày nghỉ cuối tuần hoặc ngày lễ. Vui lòng chọn ngày làm việc trong tuần.';
            }
            if (estBadge) {
                estBadge.textContent = '0 ngày (Cuối tuần / Ngày lễ)';
                estBadge.className = 'badge bg-danger fs-6 px-3 py-2 font-monospace';
            }
            if (daysInput) daysInput.value = '0';
        } else {
            if (weekendNotice) weekendNotice.classList.add('d-none');
            var sessionName = (document.getElementById('sessionMorning') && document.getElementById('sessionMorning').checked) ? 'Sáng' : 'Chiều';
            if (estBadge) {
                estBadge.textContent = '0.5 ngày (Buổi ' + sessionName + ' - 4h)';
                estBadge.className = 'badge bg-warning text-dark fs-6 px-3 py-2 font-monospace';
            }
            if (daysInput) daysInput.value = '0.5';
        }
    } else {
        if (!endInput || !endInput.value) return;
        var d1 = new Date(startInput.value);
        var d2 = new Date(endInput.value);
        if (d2 >= d1) {
            var count = 0;
            var cur = new Date(d1);
            while (cur <= d2) {
                var dow = cur.getDay();
                var ymdCur = formatDateYMD(cur);
                if (dow !== 0 && dow !== 6 && !VN_HOLIDAYS_2026.has(ymdCur)) { // Bỏ qua T7, CN & Lễ
                    count++;
                }
                cur.setDate(cur.getDate() + 1);
            }

            if (count === 0) {
                if (weekendNotice) {
                    weekendNotice.classList.remove('d-none');
                    weekendNotice.innerHTML = '<i class="bi bi-exclamation-triangle-fill text-warning me-1"></i> Khoảng thời gian chọn rơi vào cuối tuần hoặc ngày lễ. Vui lòng chọn ngày làm việc.';
                }
                if (estBadge) {
                    estBadge.textContent = '0 ngày (Cuối tuần / Ngày lễ)';
                    estBadge.className = 'badge bg-danger fs-6 px-3 py-2 font-monospace';
                }
                if (daysInput) daysInput.value = '0';
            } else {
                if (weekendNotice) weekendNotice.classList.add('d-none');
                if (estBadge) {
                    estBadge.textContent = count + ' ngày làm việc';
                    estBadge.className = 'badge bg-primary fs-6 px-3 py-2 font-monospace';
                }
                if (daysInput) daysInput.value = count;
            }
        }
    }

    // Kiểm tra số dư phép năm nếu chọn ANNUAL
    if (leaveTypeSelect && leaveTypeSelect.value === 'ANNUAL' && availBadge && daysInput) {
        var avail = parseFloat(availBadge.getAttribute('data-avail') || '0');
        var req = parseFloat(daysInput.value || '0');
        if (req > avail && req > 0) {
            if (quotaNotice) quotaNotice.classList.remove('d-none');
        } else {
            if (quotaNotice) quotaNotice.classList.add('d-none');
        }
    } else {
        if (quotaNotice) quotaNotice.classList.add('d-none');
    }

    var modalDays = document.getElementById('leaveDaysCalculated');
    if (modalDays && daysInput) modalDays.value = daysInput.value;
};

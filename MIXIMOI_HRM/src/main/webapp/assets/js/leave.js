/**
 * MIXIMOI HRM — LEAVE MANAGEMENT SCRIPTS (leave.js)
 */
document.addEventListener('DOMContentLoaded', function() {
    'use strict';

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

    window.bulkApproveLeave = function() {
        const checkedBoxes = document.querySelectorAll('.row-check-leave:checked');
        if (checkedBoxes.length === 0) {
            alert('Vui lòng chọn ít nhất một đơn nghỉ phép.');
            return;
        }
        if (!confirm('Bạn có chắc chắn muốn phê duyệt ' + checkedBoxes.length + ' đơn nghỉ phép đã chọn? Dữ liệu sẽ tự động đồng bộ sang bảng chấm công.')) {
            return;
        }
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = window.location.pathname;

        const actInput = document.createElement('input');
        actInput.type = 'hidden';
        actInput.name = 'action';
        actInput.value = 'bulkApprove';
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

    window.bulkRejectLeave = function() {
        const checkedBoxes = document.querySelectorAll('.row-check-leave:checked');
        if (checkedBoxes.length === 0) {
            alert('Vui lòng chọn ít nhất một đơn nghỉ phép.');
            return;
        }
        const reason = prompt('Nhập lý do từ chối các đơn đã chọn:', 'Không đủ điều kiện phê duyệt kỳ này');
        if (reason === null) return;

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = window.location.pathname;

        const actInput = document.createElement('input');
        actInput.type = 'hidden';
        actInput.name = 'action';
        actInput.value = 'bulkReject';
        form.appendChild(actInput);

        const reasonInput = document.createElement('input');
        reasonInput.type = 'hidden';
        reasonInput.name = 'rejectReason';
        reasonInput.value = reason;
        form.appendChild(reasonInput);

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

    window.bulkDeleteLeave = function() {
        const checkedBoxes = document.querySelectorAll('.row-check-leave:checked');
        if (checkedBoxes.length === 0) {
            alert('Vui lòng chọn ít nhất một đơn nghỉ phép.');
            return;
        }
        if (!confirm('Bạn có chắc chắn muốn xóa ' + checkedBoxes.length + ' đơn nghỉ phép đã chọn không? Thao tác này không thể hoàn tác.')) {
            return;
        }
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = window.location.pathname;

        const actInput = document.createElement('input');
        actInput.type = 'hidden';
        actInput.name = 'action';
        actInput.value = 'bulkDelete';
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

    window.bulkExportLeave = function() {
        const checkedBoxes = document.querySelectorAll('.row-check-leave:checked');
        if (checkedBoxes.length === 0) {
            alert('Vui lòng chọn ít nhất một đơn nghỉ phép để xuất.');
            return;
        }
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

// Auto calculate days in Leave Form & Modal
function calculateLeaveDays() {
    var startInput = document.querySelector('input[name="startDate"]');
    var endInput = document.querySelector('input[name="endDate"]');
    var daysInput = document.querySelector('input[name="days"]');
    var estBadge = document.getElementById('estimatedDays');
    if (startInput && endInput && startInput.value && endInput.value) {
        var d1 = new Date(startInput.value);
        var d2 = new Date(endInput.value);
        if (d2 >= d1) {
            var count = 0;
            var cur = new Date(d1);
            while (cur <= d2) {
                var dayOfWeek = cur.getDay();
                if (dayOfWeek !== 0 && dayOfWeek !== 6) { // Không tính thứ 7, CN
                    count++;
                }
                cur.setDate(cur.getDate() + 1);
            }
            var days = Math.max(1, count);
            if (daysInput) daysInput.value = days;
            if (estBadge) estBadge.textContent = days + ' ngày';
            var modalDays = document.getElementById('leaveDaysCalculated');
            if (modalDays) modalDays.value = days;
        }
    }
}

/**
 * MIXIMOI HRM — ATTENDANCE MODULE SCRIPTS (attendance.js)
 */
document.addEventListener('DOMContentLoaded', function() {
    'use strict';

    // 1. Check all rows & Bulk Selection
    const checkAll = document.getElementById('checkAll');
    const bulkToolbar = document.getElementById('bulkToolbar');
    const bulkCount = document.getElementById('bulkCount');

    function updateBulkToolbar() {
        const checkedBoxes = document.querySelectorAll('.row-check:checked');
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
            const allBoxes = document.querySelectorAll('.row-check');
            checkAll.checked = allBoxes.length > 0 && checkedBoxes.length === allBoxes.length;
        }
    }

    if (checkAll) {
        checkAll.addEventListener('change', function() {
            document.querySelectorAll('.row-check').forEach(cb => {
                const tr = cb.closest('tr');
                if (!tr || tr.style.display !== 'none') {
                    cb.checked = checkAll.checked;
                }
            });
            updateBulkToolbar();
        });
    }

    document.addEventListener('change', function(e) {
        if (e.target && e.target.classList.contains('row-check')) {
            updateBulkToolbar();
        }
    });

    window.clearAttSelection = function() {
        document.querySelectorAll('.row-check').forEach(cb => cb.checked = false);
        if (checkAll) checkAll.checked = false;
        updateBulkToolbar();
    };

    window.bulkMarkOnTime = function() {
        const checkedBoxes = document.querySelectorAll('.row-check:checked');
        if (checkedBoxes.length === 0) {
            alert('Vui lòng chọn ít nhất một bản ghi chấm công.');
            return;
        }
        if (!confirm('Xác nhận đúng giờ cho ' + checkedBoxes.length + ' bản ghi chấm công đã chọn?')) {
            return;
        }
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = window.location.pathname;

        const actInput = document.createElement('input');
        actInput.type = 'hidden';
        actInput.name = 'action';
        actInput.value = 'bulkMarkOnTime';
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

    window.bulkDeleteAtt = function() {
        const checkedBoxes = document.querySelectorAll('.row-check:checked');
        if (checkedBoxes.length === 0) {
            alert('Vui lòng chọn ít nhất một bản ghi chấm công.');
            return;
        }
        if (!confirm('Bạn có chắc chắn muốn xóa ' + checkedBoxes.length + ' bản ghi chấm công đã chọn không? Thao tác này không thể hoàn tác.')) {
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

    window.bulkExportAtt = function() {
        const checkedBoxes = document.querySelectorAll('.row-check:checked');
        if (checkedBoxes.length === 0) {
            alert('Vui lòng chọn ít nhất một bản ghi chấm công.');
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

    // 2. Realtime Search & Filter for Attendance
    const searchInput = document.getElementById('searchEmp');
    const filterDept = document.getElementById('filterDept');
    const filterShift = document.getElementById('filterShift');
    const filterStatus = document.getElementById('filterStatus');
    const toggleAnomaly = document.getElementById('toggleAnomaly');

    function filterAttendanceTable() {
        const query = searchInput ? searchInput.value.toLowerCase().trim() : '';
        const deptText = filterDept && filterDept.selectedIndex > 0 ? filterDept.options[filterDept.selectedIndex].text.toLowerCase().trim() : '';
        const shiftVal = filterShift ? filterShift.value.toLowerCase().trim() : '';
        const statusVal = filterStatus ? filterStatus.value.trim() : '';
        const onlyAnomaly = toggleAnomaly ? toggleAnomaly.checked : false;

        const rows = document.querySelectorAll('.att-row');
        let visibleCount = 0;

        rows.forEach(row => {
            const rowKeyword = (row.getAttribute('data-keyword') || '').toLowerCase();
            const rowStatus = row.getAttribute('data-status') || '';
            const rowDept = (row.getAttribute('data-dept') || '').toLowerCase();
            const rowShift = (row.getAttribute('data-shift') || '').toLowerCase();

            let matchKeyword = !query || rowKeyword.includes(query);
            let matchDept = !deptText || rowDept.includes(deptText);
            let matchShift = !shiftVal || rowShift.includes(shiftVal);
            let matchStatus = !statusVal || rowStatus === statusVal;
            let matchAnomaly = true;
            if (onlyAnomaly) {
                matchAnomaly = row.classList.contains('row-late') || row.classList.contains('row-absent') || row.classList.contains('row-wfh');
            }

            if (matchKeyword && matchDept && matchShift && matchStatus && matchAnomaly) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
                const cb = row.querySelector('.row-check');
                if (cb && cb.checked) {
                    cb.checked = false;
                }
            }
        });

        updateBulkToolbar();

        // Empty state row
        let emptyRow = document.getElementById('attEmptyFilterRow');
        const tbody = document.querySelector('#attTable tbody');
        if (tbody) {
            if (visibleCount === 0 && rows.length > 0) {
                if (!emptyRow) {
                    emptyRow = document.createElement('tr');
                    emptyRow.id = 'attEmptyFilterRow';
                    emptyRow.innerHTML = '<td colspan="9" class="text-center py-4 text-muted">' +
                        '<i class="bi bi-clock-history fs-3 d-block mb-2 text-secondary"></i>' +
                        'Không tìm thấy dữ liệu chấm công nào phù hợp với bộ lọc hiện tại</td>';
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
            debounceTimer = setTimeout(filterAttendanceTable, 150);
        });
    }

    if (filterDept) filterDept.addEventListener('change', filterAttendanceTable);
    if (filterShift) filterShift.addEventListener('change', filterAttendanceTable);
    if (filterStatus) filterStatus.addEventListener('change', filterAttendanceTable);
    if (toggleAnomaly) toggleAnomaly.addEventListener('change', filterAttendanceTable);

    // 3. Open explain modal (Employee)
    window.openExplainModal = function(id, date) {
        const idInput = document.getElementById('explainAttId');
        const dateEl = document.getElementById('explainDate');
        if (idInput) idInput.value = id;
        if (dateEl) dateEl.textContent = date;
        
        const modalEl = document.getElementById('explainModal');
        if (modalEl) {
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        }
    };

    // 4. Edit attendance record (Admin/HR)
    window.editAttendance = function(btn) {
        const id = btn.getAttribute('data-id');
        const empId = btn.getAttribute('data-empid');
        const date = btn.getAttribute('data-date');
        const checkIn = btn.getAttribute('data-checkin');
        const checkOut = btn.getAttribute('data-checkout');
        const status = btn.getAttribute('data-status');
        const notes = btn.getAttribute('data-notes');

        const editId = document.getElementById('editAttId');
        const editEmp = document.getElementById('editAttEmpId');
        const editDate = document.getElementById('editAttDate');
        const editIn = document.getElementById('editAttCheckIn');
        const editOut = document.getElementById('editAttCheckOut');
        const editSt = document.getElementById('editAttStatus');
        const editNt = document.getElementById('editAttNotes');

        if (editId) editId.value = id || '';
        if (editEmp) editEmp.value = empId || '';
        if (editDate) editDate.value = date || '';
        if (editIn) editIn.value = checkIn || '';
        if (editOut) editOut.value = checkOut || '';
        if (editSt) editSt.value = status || 'ON_TIME';
        if (editNt) editNt.value = notes || '';

        const modalEl = document.getElementById('editAttendanceModal');
        if (modalEl) {
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        }
    };

    // 5. Approve explain
    window.approveExplain = function(id) {
        if (confirm('Phê duyệt giải trình công cho nhân viên này?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = window.location.pathname;
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'approveExplain';
            form.appendChild(actionInput);

            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'id';
            idInput.value = id;
            form.appendChild(idInput);

            document.body.appendChild(form);
            form.submit();
        }
    };

    // 6. Sync ZKTeco machine button
    window.syncAttendanceDevice = function(btn) {
        if (btn) {
            const originalHtml = btn.innerHTML;
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Đang đồng bộ...';
            setTimeout(function() {
                btn.innerHTML = '<i class="bi bi-check2 text-success me-1"></i> Đã đồng bộ!';
                setTimeout(function() {
                    btn.disabled = false;
                    btn.innerHTML = originalHtml;
                }, 2000);
            }, 1200);
        }
    };

    // 7. View History
    window.viewHistory = function(btnOrId) {
        if (typeof btnOrId === 'object' && btnOrId.getAttribute) {
            const nameEl = document.getElementById('histEmpName');
            const codeEl = document.getElementById('histEmpCode');
            const dateEl = document.getElementById('histDate');
            const shiftEl = document.getElementById('histShift');
            const inEl = document.getElementById('histCheckIn');
            const outEl = document.getElementById('histCheckOut');
            const methodEl = document.getElementById('histMethod');
            const hoursEl = document.getElementById('histHours');
            const statusEl = document.getElementById('histStatus');

            if (nameEl) nameEl.textContent = btnOrId.getAttribute('data-name') || '—';
            if (codeEl) codeEl.textContent = btnOrId.getAttribute('data-code') || '—';
            if (dateEl) dateEl.textContent = btnOrId.getAttribute('data-date') || '—';
            if (shiftEl) shiftEl.textContent = btnOrId.getAttribute('data-shift') || '—';
            if (inEl) inEl.textContent = btnOrId.getAttribute('data-checkin') || '—';
            if (outEl) outEl.textContent = btnOrId.getAttribute('data-checkout') || '—';
            if (methodEl) methodEl.textContent = btnOrId.getAttribute('data-method') || '—';
            if (hoursEl) hoursEl.textContent = btnOrId.getAttribute('data-hours') || '—';
            if (statusEl) statusEl.textContent = btnOrId.getAttribute('data-status') || '—';
        }
        const modalEl = document.getElementById('historyModal');
        if (modalEl) {
            bootstrap.Modal.getOrCreateInstance(modalEl).show();
        }
    };

    // 8. Form validation
    const forms = document.querySelectorAll('.needs-validation');
    Array.prototype.slice.call(forms).forEach(function(form) {
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
});

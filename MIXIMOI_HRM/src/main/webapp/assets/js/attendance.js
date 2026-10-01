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
            if (window.MixiToast) MixiToast.warning('Vui lòng chọn ít nhất một bản ghi chấm công.');
            else alert('Vui lòng chọn ít nhất một bản ghi chấm công.');
            return;
        }
        if (!confirm('Xác nhận đúng giờ cho ' + checkedBoxes.length + ' bản ghi chấm công đã chọn?')) {
            return;
        }

        const formData = new URLSearchParams();
        formData.append('action', 'bulkMarkOnTime');
        formData.append('ajax', 'true');
        checkedBoxes.forEach(cb => formData.append('ids', cb.value));

        fetch(window.location.pathname, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                if (window.MixiToast) {
                    MixiToast.success(data.message || 'Đã cập nhật đúng giờ thành công!');
                } else if (window.showToast) {
                    window.showToast(data.message, 'success', 'Cập nhật hàng loạt');
                }
                checkedBoxes.forEach(cb => {
                    const row = cb.closest('tr');
                    if (row) {
                        row.classList.remove('row-late', 'row-absent', 'row-wfh');
                        const statusCell = row.querySelector('td.text-center');
                        if (statusCell) {
                            statusCell.innerHTML = '<span class="status-pill ontime"><i class="bi bi-check-circle-fill"></i> Đúng giờ</span>';
                        }
                        row.style.transition = 'background-color 0.5s ease';
                        row.style.backgroundColor = 'rgba(16, 185, 129, 0.15)';
                        setTimeout(() => row.style.backgroundColor = '', 1500);
                    }
                });
                clearAttSelection();
            } else {
                if (window.MixiToast) MixiToast.error(data.message || 'Thao tác không thành công.');
                else alert(data.message || 'Thao tác không thành công.');
            }
        })
        .catch(err => {
            console.error('bulkMarkOnTime error:', err);
            if (window.MixiToast) MixiToast.error('Lỗi kết nối khi gửi yêu cầu.');
            else alert('Lỗi kết nối khi gửi yêu cầu.');
        });
    };

    window.bulkDeleteAtt = function() {
        const checkedBoxes = document.querySelectorAll('.row-check:checked');
        if (checkedBoxes.length === 0) {
            if (window.MixiToast) MixiToast.warning('Vui lòng chọn ít nhất một bản ghi chấm công.');
            else alert('Vui lòng chọn ít nhất một bản ghi chấm công.');
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
            if (window.MixiToast) MixiToast.warning('Vui lòng chọn ít nhất một bản ghi chấm công.');
            else alert('Vui lòng chọn ít nhất một bản ghi chấm công.');
            return;
        }
        if (window.MixiToast) MixiToast.info('Đang xuất ' + checkedBoxes.length + ' bản ghi chấm công...');
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

        const formatTime = function(t) {
            if (!t || t === 'null' || t === '—') return '';
            let s = t.split('.')[0].trim();
            // Xử lý định dạng AM/PM nếu có (VD: 08:04:22 AM -> 08:04:22, 04:22:22 PM -> 16:22:22)
            const m = s.match(/^(\d{1,2}):(\d{2})(?::(\d{2}))?\s*(AM|PM)$/i);
            if (m) {
                let h = parseInt(m[1], 10);
                const min = m[2];
                const sec = m[3] || '00';
                const mer = m[4].toUpperCase();
                if (mer === 'PM' && h < 12) h += 12;
                if (mer === 'AM' && h === 12) h = 0;
                s = (h < 10 ? '0' : '') + h + ':' + min + ':' + sec;
            }
            return s;
        };

        if (editId) editId.value = id || '';
        if (editDate) editDate.value = date || '';
        if (editIn) editIn.value = formatTime(checkIn);
        if (editOut) editOut.value = formatTime(checkOut);
        if (editSt) editSt.value = status || 'ON_TIME';
        if (editNt) editNt.value = notes || '';

        if (editEmp) {
            editEmp.value = empId || '';
            // Nếu option nhân viên chưa khớp, tìm và chọn chính xác
            if (empId) {
                let matched = false;
                for (let i = 0; i < editEmp.options.length; i++) {
                    if (editEmp.options[i].value === String(empId)) {
                        editEmp.selectedIndex = i;
                        matched = true;
                        break;
                    }
                }
                if (!matched) {
                    const opt = document.createElement('option');
                    opt.value = empId;
                    opt.textContent = 'Nhân viên #' + empId;
                    opt.selected = true;
                    editEmp.appendChild(opt);
                }
            }
        }

        const modalEl = document.getElementById('editAttendanceModal');
        if (modalEl) {
            const form = modalEl.querySelector('form');
            if (form) form.classList.remove('was-validated');
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        }
    };

    // 5. Approve explain (AJAX No-Reload)
    window.approveExplain = function(id, btn) {
        if (!confirm('Phê duyệt giải trình công cho nhân viên này? Dữ liệu sẽ tự động chuyển thành Đúng giờ (ON_TIME).')) {
            return;
        }

        const btnEl = (btn && btn.nodeType) ? btn : (event && event.currentTarget ? event.currentTarget : null);
        if (btnEl) {
            btnEl.disabled = true;
            btnEl.innerHTML = '<span class="spinner-border spinner-border-sm"></span>';
        }

        const formData = new URLSearchParams();
        formData.append('action', 'approveExplain');
        formData.append('id', id);
        formData.append('ajax', 'true');

        fetch(window.location.pathname, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                if (window.showToast) {
                    window.showToast(data.message || 'Đã duyệt giải trình thành công!', 'success', 'Phê duyệt thành công');
                }

                // Cập nhật DOM dòng đó mượt mà không reload
                let row = null;
                if (btnEl) row = btnEl.closest('tr');
                if (!row) row = document.querySelector(`tr[data-id="${id}"]`);

                if (row) {
                    row.classList.remove('row-late', 'row-absent', 'row-wfh');
                    row.classList.add('row-ontime');

                    // Cập nhật ô Trạng thái
                    const statusCell = row.querySelector('td.text-center');
                    if (statusCell) {
                        statusCell.innerHTML = '<span class="status-pill ontime"><i class="bi bi-check-circle-fill"></i> Đúng giờ</span>';
                    }

                    // Ẩn/xóa nút approve
                    if (btnEl) {
                        btnEl.remove();
                    }

                    // Hiệu ứng highlight màu xanh ngọc nhẹ
                    row.style.transition = 'background-color 0.6s ease';
                    row.style.backgroundColor = 'rgba(16, 185, 129, 0.18)';
                    setTimeout(() => {
                        row.style.backgroundColor = '';
                    }, 1600);
                }

                // Giảm badge pending nếu có
                const pendingCard = document.querySelector('.astat-icon.violet')?.closest('.att-stat-card')?.querySelector('.astat-value');
                if (pendingCard) {
                    let cur = parseInt(pendingCard.textContent.trim(), 10);
                    if (!isNaN(cur) && cur > 0) pendingCard.textContent = cur - 1;
                }
            } else {
                if (btnEl) {
                    btnEl.disabled = false;
                    btnEl.innerHTML = '<i class="bi bi-check-square"></i>';
                }
                if (window.MixiToast) MixiToast.error(data.message || 'Có lỗi xảy ra khi phê duyệt giải trình.');
                else alert(data.message || 'Có lỗi xảy ra khi phê duyệt giải trình.');
            }
        })
        .catch(err => {
            console.error('approveExplain error:', err);
            if (btnEl) {
                btnEl.disabled = false;
                btnEl.innerHTML = '<i class="bi bi-check-square"></i>';
            }
            if (window.MixiToast) MixiToast.error('Lỗi kết nối khi gửi yêu cầu phê duyệt.');
            else alert('Lỗi kết nối khi gửi yêu cầu phê duyệt.');
        });
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

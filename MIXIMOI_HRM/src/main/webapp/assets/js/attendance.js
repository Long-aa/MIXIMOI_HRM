/**
 * MIXIMOI HRM — ATTENDANCE MODULE SCRIPTS (attendance.js)
 */
document.addEventListener('DOMContentLoaded', function() {
    'use strict';

    // 1. Check all rows
    const checkAll = document.getElementById('checkAll');
    if (checkAll) {
        checkAll.addEventListener('change', function() {
            document.querySelectorAll('.row-check').forEach(cb => cb.checked = this.checked);
        });
    }

    // 2. Toggle anomaly filter
    const toggleAnomaly = document.getElementById('toggleAnomaly');
    if (toggleAnomaly) {
        toggleAnomaly.addEventListener('change', function() {
            const isChecked = this.checked;
            document.querySelectorAll('#attTable tbody tr').forEach(row => {
                if (isChecked) {
                    if (row.classList.contains('row-late') || row.classList.contains('row-absent') || row.classList.contains('row-wfh')) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                } else {
                    row.style.display = '';
                }
            });
        });
    }

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

    // 7. Form validation
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

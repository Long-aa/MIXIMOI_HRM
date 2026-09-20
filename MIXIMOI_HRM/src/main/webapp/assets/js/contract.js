/**
 * MIXIMOI HRM — CONTRACT MODULE SCRIPTS (contract.js)
 */
document.addEventListener('DOMContentLoaded', function() {
    'use strict';

    // 1. Check all rows checkbox
    const checkAll = document.getElementById('checkAll');
    if (checkAll) {
        checkAll.addEventListener('change', function() {
            document.querySelectorAll('.row-check').forEach(cb => cb.checked = this.checked);
        });
    }

    // 2. Toggle End Date according to Contract Type
    window.toggleEndDate = function(type, suffix = '') {
        const endDateGroup = document.getElementById('endDateGroup' + suffix);
        if (endDateGroup) {
            const input = endDateGroup.querySelector('input');
            if (type === 'INDEFINITE') {
                endDateGroup.style.opacity = '0.5';
                if (input) {
                    input.disabled = true;
                    input.value = '';
                }
            } else {
                endDateGroup.style.opacity = '1';
                if (input) input.disabled = false;
            }
        }
    };

    // Initialize toggle for new contract modal
    const typeSelect = document.getElementById('contractTypeSelect');
    if (typeSelect) {
        toggleEndDate(typeSelect.value, '');
        typeSelect.addEventListener('change', function() {
            toggleEndDate(this.value, '');
        });
    }

    // 3. Delete Contract Confirmation
    window.confirmDeleteContract = function(btn) {
        const id = btn.getAttribute('data-id');
        const code = btn.getAttribute('data-code');
        const idInput = document.getElementById('deleteContractId');
        const codeEl = document.getElementById('deleteContractCode');
        if (idInput) idInput.value = id;
        if (codeEl) codeEl.textContent = code;
        
        const modalEl = document.getElementById('deleteContractModal');
        if (modalEl) {
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        }
    };

    // 4. Open Edit Contract Modal
    window.openEditContractModal = function(btn) {
        const id = btn.getAttribute('data-id');
        const code = btn.getAttribute('data-code');
        const empId = btn.getAttribute('data-empid');
        const type = btn.getAttribute('data-type');
        const start = btn.getAttribute('data-start');
        const end = btn.getAttribute('data-end');
        const salary = btn.getAttribute('data-salary');
        const status = btn.getAttribute('data-status');
        const notes = btn.getAttribute('data-notes');

        const editId = document.getElementById('editContractId');
        const editCode = document.getElementById('editContractCode');
        const editEmp = document.getElementById('editEmployeeId');
        const editType = document.getElementById('editContractTypeSelect');
        const editStart = document.getElementById('editStartDate');
        const editEnd = document.getElementById('editEndDate');
        const editSalary = document.getElementById('editBaseSalary');
        const editStatus = document.getElementById('editStatus');
        const editNotes = document.getElementById('editNotes');

        if (editId) editId.value = id || '';
        if (editCode) editCode.value = code || '';
        if (editEmp) editEmp.value = empId || '';
        if (editType) {
            editType.value = type || 'FIXED_TERM';
            toggleEndDate(editType.value, 'Edit');
        }
        if (editStart) editStart.value = start || '';
        if (editEnd) editEnd.value = end || '';
        if (editSalary) editSalary.value = salary || '';
        if (editStatus) editStatus.value = status || 'ACTIVE';
        if (editNotes) editNotes.value = notes || '';

        const modalEl = document.getElementById('editContractModal');
        if (modalEl) {
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        }
    };

    // 5. Form Validation
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

/**
 * MIXIMOI HRM — CONTRACT MODULE SCRIPTS (contract.js)
 */
document.addEventListener('DOMContentLoaded', function() {
    'use strict';

    // 1. Check all rows checkbox & Bulk Selection
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
                // only check rows that are visible
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

    window.clearContractSelection = function() {
        document.querySelectorAll('.row-check').forEach(cb => cb.checked = false);
        if (checkAll) checkAll.checked = false;
        updateBulkToolbar();
    };

    window.bulkDelete = function() {
        const checkedBoxes = document.querySelectorAll('.row-check:checked');
        if (checkedBoxes.length === 0) {
            alert('Vui lòng chọn ít nhất một hợp đồng.');
            return;
        }
        if (!confirm('Bạn có chắc chắn muốn xóa ' + checkedBoxes.length + ' hợp đồng đã chọn không? Thao tác này không thể hoàn tác.')) {
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

    window.bulkExport = function() {
        const checkedBoxes = document.querySelectorAll('.row-check:checked');
        if (checkedBoxes.length === 0) {
            alert('Vui lòng chọn ít nhất một hợp đồng.');
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

    // 2. Realtime Search & Filter for Contracts Table
    const searchInput = document.getElementById('contractSearch');
    const filterType = document.getElementById('filterType');
    const filterStatus = document.getElementById('filterStatus');
    const filterDept = document.getElementById('filterDept');

    function filterContractTable() {
        const query = searchInput ? searchInput.value.toLowerCase().trim() : '';
        const type = filterType ? filterType.value.trim() : '';
        const status = filterStatus ? filterStatus.value.trim() : '';
        const deptText = filterDept && filterDept.selectedIndex > 0 ? filterDept.options[filterDept.selectedIndex].text.toLowerCase().trim() : '';

        const rows = document.querySelectorAll('.contract-row');
        let visibleCount = 0;

        rows.forEach(row => {
            const rowKeyword = (row.getAttribute('data-keyword') || '').toLowerCase();
            const rowType = row.getAttribute('data-type') || '';
            const rowStatus = row.getAttribute('data-status') || '';
            const rowDept = (row.getAttribute('data-dept') || '').toLowerCase();

            let matchKeyword = !query || rowKeyword.includes(query);
            let matchType = !type || rowType === type;
            let matchStatus = true;
            if (status) {
                if (status === 'EXPIRING_SOON') {
                    matchStatus = rowStatus === 'EXPIRING_SOON' || row.classList.contains('row-expiring');
                } else {
                    matchStatus = rowStatus === status;
                }
            }
            let matchDept = !deptText || rowDept.includes(deptText);

            if (matchKeyword && matchType && matchStatus && matchDept) {
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
        let emptyRow = document.getElementById('contractEmptyFilterRow');
        const tbody = document.querySelector('#contractTable tbody');
        if (tbody) {
            if (visibleCount === 0 && rows.length > 0) {
                if (!emptyRow) {
                    emptyRow = document.createElement('tr');
                    emptyRow.id = 'contractEmptyFilterRow';
                    emptyRow.innerHTML = '<td colspan="9" class="text-center py-4 text-muted">' +
                        '<i class="bi bi-inbox fs-3 d-block mb-2"></i>' +
                        'Không tìm thấy hợp đồng nào phù hợp với bộ lọc hiện tại</td>';
                    tbody.appendChild(emptyRow);
                } else {
                    emptyRow.style.display = '';
                }
            } else if (emptyRow) {
                emptyRow.style.display = 'none';
            }
        }
    }

    // Debounce realtime filter
    let debounceTimer;
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(filterContractTable, 150);
        });
    }

    if (filterType) filterType.addEventListener('change', filterContractTable);
    if (filterStatus) filterStatus.addEventListener('change', filterContractTable);
    if (filterDept) filterDept.addEventListener('change', filterContractTable);

    // 3. Toggle End Date according to Contract Type
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

    // 4. Delete Contract Confirmation
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

    // 5. Open Edit Contract Modal
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

    // 6. Open Renew Contract Modal
    window.openRenewModal = function(btn) {
        const id = btn.getAttribute('data-id');
        const code = btn.getAttribute('data-code');
        const end = btn.getAttribute('data-end');
        const salary = btn.getAttribute('data-salary');

        const renewId = document.getElementById('renewContractId');
        const renewCode = document.getElementById('renewContractCode');
        const renewEndDate = document.getElementById('renewEndDate');
        const renewSalary = document.getElementById('renewSalary');

        if (renewId) renewId.value = id || '';
        if (renewCode) renewCode.textContent = code || '';
        if (renewEndDate) {
            if (end) {
                const parts = end.split('-');
                if (parts.length === 3) {
                    const nextYear = parseInt(parts[0], 10) + 1;
                    renewEndDate.value = nextYear + '-' + parts[1] + '-' + parts[2];
                } else {
                    renewEndDate.value = end;
                }
            } else {
                renewEndDate.value = '';
            }
        }
        if (renewSalary) renewSalary.value = salary || '';

        const modalEl = document.getElementById('renewContractModal');
        if (modalEl) {
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        }
    };

    // 7. Open Terminate Contract Modal
    window.openTerminateModal = function(btn) {
        const id = btn.getAttribute('data-id');
        const code = btn.getAttribute('data-code');

        const termId = document.getElementById('terminateContractId');
        const termCode = document.getElementById('terminateContractCode');

        if (termId) termId.value = id || '';
        if (termCode) termCode.textContent = code || '';

        const modalEl = document.getElementById('terminateContractModal');
        if (modalEl) {
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        }
    };

    // 8. Form Validation
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

    // 9. Open Transition Probation Contract Modal
    window.openTransitionProbationModal = function(btn) {
        const id = btn.getAttribute('data-id');
        const code = btn.getAttribute('data-code');
        const name = btn.getAttribute('data-name');
        const salary = btn.getAttribute('data-salary');

        const transId = document.getElementById('transProbationId');
        const transCode = document.getElementById('transProbationCode');
        const transName = document.getElementById('transProbationName');
        const transSalary = document.getElementById('transProbationSalary');

        if (transId) transId.value = id || '';
        if (transCode) transCode.textContent = code || '';
        if (transName) transName.textContent = name || '';
        if (transSalary) {
            let numSalary = parseFloat(salary) || 0;
            if (numSalary > 0) {
                let fullSalary = Math.round(numSalary / 0.85);
                transSalary.value = fullSalary;
            } else {
                transSalary.value = salary || '15000000';
            }
        }

        const modalEl = document.getElementById('transitionProbationModal');
        if (modalEl) {
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        }
    };

    // 10. Dynamic feedback for Điều 20 BLLĐ 2019 in New Contract Modal
    const newEmpSelect = document.getElementById('newContractEmpSelect');
    const lawAlertBox = document.getElementById('newContractLawAlert');
    const newContractType = document.getElementById('contractTypeSelect');

    if (newEmpSelect) {
        newEmpSelect.addEventListener('change', function() {
            const opt = this.options[this.selectedIndex];
            const fixedCount = parseInt(opt ? opt.getAttribute('data-fixed-count') || '0' : '0', 10);
            
            if (lawAlertBox) {
                if (!this.value) {
                    lawAlertBox.classList.add('d-none');
                } else if (fixedCount >= 2) {
                    lawAlertBox.className = 'alert alert-danger py-2 px-3 mb-3 d-flex align-items-center gap-2';
                    lawAlertBox.innerHTML = '<i class="bi bi-exclamation-triangle-fill fs-5 text-danger flex-shrink-0"></i>' +
                        '<div><strong>Tuân thủ Điều 20 BLLĐ 2019:</strong> Nhân viên này đã ký <strong>' + fixedCount + '/2</strong> hợp đồng xác định thời hạn. ' +
                        'Theo luật định, hợp đồng tiếp theo <strong class="text-danger">bắt buộc là Không xác định thời hạn</strong> (Hệ thống đã tự động chuyển đổi).</div>';
                    if (newContractType) {
                        newContractType.value = 'INDEFINITE';
                        toggleEndDate('INDEFINITE', '');
                    }
                } else if (fixedCount === 1) {
                    lawAlertBox.className = 'alert alert-warning py-2 px-3 mb-3 d-flex align-items-center gap-2';
                    lawAlertBox.innerHTML = '<i class="bi bi-info-circle-fill fs-5 text-warning flex-shrink-0"></i>' +
                        '<div><strong>Lưu ý Điều 20 BLLĐ 2019:</strong> Nhân viên đã ký <strong>1/2</strong> hợp đồng xác định thời hạn. ' +
                        'Đây là lần ký HĐ xác định thời hạn cuối cùng cho phép trước khi bắt buộc chuyển sang Không thời hạn.</div>';
                } else {
                    lawAlertBox.className = 'alert alert-success py-2 px-3 mb-3 d-flex align-items-center gap-2';
                    lawAlertBox.innerHTML = '<i class="bi bi-check-circle-fill fs-5 text-success flex-shrink-0"></i>' +
                        '<div>Nhân viên chưa từng ký HĐ xác định thời hạn (Lần 1/2). Đủ điều kiện ký mọi loại hợp đồng theo luật định.</div>';
                }
            }
        });
    }
});

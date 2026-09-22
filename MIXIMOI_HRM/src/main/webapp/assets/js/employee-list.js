/**
 * MIXIMOI HRM — EMPLOYEE LIST SCRIPTS (employee-list.js)
 * Features: Realtime search/filter, bulk select, bulk delete/export, drag-drop CSV import
 */

// ====================== REALTIME SEARCH & FILTER ======================

(function () {
    const form = document.getElementById('empFilterForm');
    if (!form) return;

    const searchInput = form.querySelector('input[name="keyword"]');
    const selectDept  = form.querySelector('select[name="departmentId"]');
    const selectPos   = form.querySelector('select[name="positionId"]');
    const selectSt    = form.querySelector('select[name="status"]');

    let debounceTimer = null;

    // Debounce: submit form sau 350ms khi gõ
    if (searchInput) {
        searchInput.addEventListener('input', function () {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => form.submit(), 350);
        });
    }

    // Dropdown: submit ngay khi thay đổi
    [selectDept, selectPos, selectSt].forEach(el => {
        if (el) el.addEventListener('change', () => form.submit());
    });
})();

// ====================== BULK SELECT ======================

const checkAll = document.getElementById('checkAll');
const rowChecks = () => document.querySelectorAll('.row-check');

// Select-all
if (checkAll) {
    checkAll.addEventListener('change', function () {
        rowChecks().forEach(cb => cb.checked = this.checked);
        updateBulkToolbar();
    });
}

// Từng checkbox cập nhật toolbar
document.addEventListener('change', function (e) {
    if (e.target.classList.contains('row-check')) {
        const all = rowChecks();
        const checked = document.querySelectorAll('.row-check:checked');
        if (checkAll) {
            checkAll.checked = all.length > 0 && all.length === checked.length;
            checkAll.indeterminate = checked.length > 0 && checked.length < all.length;
        }
        updateBulkToolbar();
    }
});

function getCheckedIds() {
    return Array.from(document.querySelectorAll('.row-check:checked')).map(cb => cb.value);
}

function updateBulkToolbar() {
    const toolbar = document.getElementById('bulkToolbar');
    const countEl = document.getElementById('bulkCount');
    if (!toolbar) return;
    const ids = getCheckedIds();
    if (ids.length > 0) {
        toolbar.classList.remove('d-none');
        toolbar.classList.add('d-flex');
        if (countEl) countEl.textContent = ids.length;
    } else {
        toolbar.classList.add('d-none');
        toolbar.classList.remove('d-flex');
    }
}

// Bulk Delete
function bulkDelete() {
    const ids = getCheckedIds();
    if (ids.length === 0) return;
    const nameEl = document.getElementById('bulkDeleteCount');
    if (nameEl) nameEl.textContent = ids.length;
    const modal = new bootstrap.Modal(document.getElementById('bulkDeleteModal'));
    modal.show();
}

function confirmBulkDelete() {
    const ids = getCheckedIds();
    const form = document.getElementById('bulkDeleteForm');
    // Clear old inputs
    form.querySelectorAll('input[name="ids"]').forEach(el => el.remove());
    ids.forEach(id => {
        const inp = document.createElement('input');
        inp.type = 'hidden'; inp.name = 'ids'; inp.value = id;
        form.appendChild(inp);
    });
    form.submit();
}

// Bulk Export
function bulkExport() {
    const ids = getCheckedIds();
    const form = document.getElementById('bulkExportForm');
    form.querySelectorAll('input[name="ids"]').forEach(el => el.remove());
    ids.forEach(id => {
        const inp = document.createElement('input');
        inp.type = 'hidden'; inp.name = 'ids'; inp.value = id;
        form.appendChild(inp);
    });
    form.submit();
}

// ====================== SINGLE DELETE CONFIRM ======================

function confirmDelete(btn) {
    const id   = btn.getAttribute('data-id');
    const name = btn.getAttribute('data-name');
    document.getElementById('deleteEmpId').value = id;
    document.getElementById('deleteEmpName').textContent = name;
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
}

// ====================== IMPORT MODAL: DRAG/DROP & LIVE PREVIEW ======================

(function () {
    const dropArea  = document.getElementById('dropArea');
    const fileInput = document.getElementById('fileInput');
    const btnSubmitImport   = document.getElementById('btnSubmitImport');
    const previewContainer  = document.getElementById('previewContainer');
    const previewCount      = document.getElementById('previewCount');
    const previewThead      = document.getElementById('previewThead');
    const previewTbody      = document.getElementById('previewTbody');
    const btnRemoveFile     = document.getElementById('btnRemoveFile');
    const fileLabelTitle    = document.getElementById('fileLabelTitle');
    const fileLabelDesc     = document.getElementById('fileLabelDesc');

    if (!dropArea || !fileInput) return;

    dropArea.addEventListener('click', () => fileInput.click());

    ['dragenter', 'dragover'].forEach(ev => {
        dropArea.addEventListener(ev, (e) => {
            e.preventDefault(); e.stopPropagation();
            dropArea.style.borderColor = '#2563eb';
            dropArea.style.background  = '#eff6ff';
        }, false);
    });

    ['dragleave', 'drop'].forEach(ev => {
        dropArea.addEventListener(ev, (e) => {
            e.preventDefault(); e.stopPropagation();
            dropArea.style.borderColor = '#cbd5e1';
            dropArea.style.background  = '#f8fafc';
        }, false);
    });

    dropArea.addEventListener('drop', (e) => {
        const files = e.dataTransfer.files;
        if (files.length > 0) { fileInput.files = files; handleFileSelected(files[0]); }
    });

    fileInput.addEventListener('change', function () {
        if (this.files.length > 0) handleFileSelected(this.files[0]);
    });

    if (btnRemoveFile) {
        btnRemoveFile.addEventListener('click', () => {
            fileInput.value = '';
            previewContainer.classList.add('d-none');
            if (btnSubmitImport) btnSubmitImport.disabled = true;
            if (fileLabelTitle) fileLabelTitle.textContent = 'Nhấn để chọn file hoặc kéo thả vào đây';
            if (fileLabelDesc)  fileLabelDesc.textContent  = 'Hỗ trợ file định dạng CSV, TXT (UTF-8, dung lượng tối đa 10MB)';
        });
    }

    function parseLine(line, delim) {
        let result = [], cur = '', inQuotes = false;
        for (let i = 0; i < line.length; i++) {
            const c = line[i];
            if (c === '"') { inQuotes = !inQuotes; }
            else if (c === delim && !inQuotes) { result.push(cur.trim()); cur = ''; }
            else { cur += c; }
        }
        result.push(cur.trim());
        return result;
    }

    function handleFileSelected(file) {
        if (!file) return;
        if (fileLabelTitle) fileLabelTitle.textContent = file.name;
        if (fileLabelDesc)  fileLabelDesc.textContent  = (file.size / 1024).toFixed(1) + ' KB';
        if (btnSubmitImport) btnSubmitImport.disabled = false;

        const reader = new FileReader();
        reader.onload = function (e) {
            const lines = e.target.result.split(/\r?\n/).filter(l => l.trim().length > 0);
            if (lines.length > 0) {
                const delim = lines[0].includes(';') && !lines[0].includes(',') ? ';' : ',';
                const headerCols = parseLine(lines[0], delim);
                previewThead.innerHTML = '';
                headerCols.forEach(col => {
                    const th = document.createElement('th');
                    th.textContent = col.replace(/"/g, '');
                    previewThead.appendChild(th);
                });
                previewTbody.innerHTML = '';
                lines.slice(1, 6).forEach(line => {
                    const rowCols = parseLine(line, delim);
                    const tr = document.createElement('tr');
                    rowCols.forEach(col => {
                        const td = document.createElement('td');
                        td.textContent = col.replace(/"/g, '');
                        tr.appendChild(td);
                    });
                    previewTbody.appendChild(tr);
                });
                if (previewCount) previewCount.textContent = lines.length - 1;
                if (previewContainer) previewContainer.classList.remove('d-none');
            }
        };
        reader.readAsText(file, 'UTF-8');
    }
})();

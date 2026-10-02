/**
 * position-form.js — MIXIMOI HRM
 * Live preview logic for position add/edit form
 */
(function () {
    'use strict';

    /* ========== Bootstrap native validation ========== */
    document.addEventListener('DOMContentLoaded', function () {
        const forms = document.querySelectorAll('.needs-validation');
        forms.forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    });

    /* ========== Live preview update helpers ========== */
    function updatePreviewName(val) {
        document.getElementById('prevPosName').textContent = val || 'Tên chức danh vị trí';
        const codeInput = document.getElementById('posCodeInput');
        if (codeInput && !codeInput.value) {
            const code = generateAutoCode(val);
            document.getElementById('prevPosCode').textContent = code;
        }
    }

    function updatePreviewCode(val) {
        document.getElementById('prevPosCode').textContent = val || 'CV-TECH-01';
    }

    function updatePreviewLevel(val) {
        document.getElementById('prevPosLevel').innerHTML = '<i class="bi bi-award-fill me-1"></i> ' + val;
    }

    function updatePreviewDept(val) {
        document.getElementById('prevDeptName').textContent = val;
    }

    function updatePreviewSalary() {
        const min = parseInt(document.getElementById('posMinSalary').value) || 0;
        const max = parseInt(document.getElementById('posMaxSalary').value) || 0;
        if (min > 0 && max > 0) {
            document.getElementById('prevSalaryRange').textContent =
                min.toLocaleString('vi-VN') + ' – ' + max.toLocaleString('vi-VN') + ' đ';
        }
    }

    function generateAutoCode(name) {
        if (!name) return 'CV-TECH-01';
        const n = name.toLowerCase();
        if (n.includes('software') || n.includes('developer') || n.includes('tech') || n.includes('ui/ux')) return 'CV-TECH-01';
        if (n.includes('kinh doanh') || n.includes('sales') || n.includes('b2b')) return 'CV-SALES-01';
        if (n.includes('nhân sự') || n.includes('hr') || n.includes('tuyển dụng')) return 'CV-HR-01';
        if (n.includes('kế toán') || n.includes('tài chính') || n.includes('thuế')) return 'CV-ACC-01';
        return 'CV-GEN-01';
    }

    /* ========== Export to window ========== */
    window.updatePreviewName = updatePreviewName;
    window.updatePreviewCode = updatePreviewCode;
    window.updatePreviewLevel = updatePreviewLevel;
    window.updatePreviewDept = updatePreviewDept;
    window.updatePreviewSalary = updatePreviewSalary;
})();

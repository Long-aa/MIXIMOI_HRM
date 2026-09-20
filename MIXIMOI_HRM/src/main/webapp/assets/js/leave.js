/**
 * MIXIMOI HRM — LEAVE MANAGEMENT SCRIPTS (leave.js)
 */




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

// Auto calculate days in Leave Form
function calculateLeaveDays() {
    var startInput = document.querySelector('input[name="startDate"]');
    var endInput = document.querySelector('input[name="endDate"]');
    var daysInput = document.querySelector('input[name="days"]');
    if (startInput && endInput && daysInput && startInput.value && endInput.value) {
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
            daysInput.value = Math.max(1, count);
        }
    }
}
document.addEventListener('DOMContentLoaded', function() {
    var startInput = document.querySelector('input[name="startDate"]');
    var endInput = document.querySelector('input[name="endDate"]');
    if (startInput) startInput.addEventListener('change', calculateLeaveDays);
    if (endInput) endInput.addEventListener('change', calculateLeaveDays);
});


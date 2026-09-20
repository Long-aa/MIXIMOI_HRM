/**
 * MIXIMOI HRM — TIMESHEET MODULE JAVASCRIPT (timesheet.js)
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('[Timesheet] Module initialized.');
});

/**
 * Mở modal chi tiết bảng công từ data-attributes trên button
 * @param {HTMLElement} btn - Button element chứa data-* attributes
 */
function openTimesheetDetail(btn) {
    var code = btn.getAttribute('data-code') || '';
    var name = btn.getAttribute('data-name') || '';
    var position = btn.getAttribute('data-position') || '';
    var dept = btn.getAttribute('data-dept') || '';
    var days = btn.getAttribute('data-days') || '0';
    var ot = btn.getAttribute('data-ot') || '0';
    var late = btn.getAttribute('data-late') || '0';
    var leave = btn.getAttribute('data-leave') || '0';
    var status = btn.getAttribute('data-status') || '';

    var avatar = document.getElementById('tsDetailAvatar');
    if (avatar && name.length > 0) avatar.textContent = name.charAt(0).toUpperCase();
    var elName = document.getElementById('tsDetailName');
    if (elName) elName.textContent = name + ' (' + code + ')';
    var elMeta = document.getElementById('tsDetailMeta');
    if (elMeta) elMeta.textContent = position + ' \u00b7 ' + dept;
    var elDays = document.getElementById('tsDetailDays');
    if (elDays) elDays.textContent = days;
    var elOt = document.getElementById('tsDetailOt');
    if (elOt) elOt.textContent = ot + 'h';
    var elLate = document.getElementById('tsDetailLate');
    if (elLate) elLate.textContent = late + 'p';
    var elLeave = document.getElementById('tsDetailLeave');
    if (elLeave) elLeave.textContent = leave;
    var elStatus = document.getElementById('tsDetailStatus');
    if (elStatus) elStatus.textContent = status;

    var modalEl = document.getElementById('timesheetDetailModal');
    if (modalEl) {
        var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        modal.show();
    }
}

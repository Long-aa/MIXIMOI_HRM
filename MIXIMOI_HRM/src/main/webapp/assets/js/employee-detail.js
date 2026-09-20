/**
 * MIXIMOI HRM — EMPLOYEE DETAIL SCRIPTS (employee-detail.js)
 */
function confirmDeactivate() {
        new bootstrap.Modal(document.getElementById('deactivateModal')).show();
    }

    // Tab switching functionality
    function switchTab(tabId) {
        // Toggle tab buttons
        document.querySelectorAll('.profile-tab').forEach(btn => {
            if (btn.getAttribute('data-tab') === tabId) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });

        // Toggle panes
        document.querySelectorAll('.profile-tab-pane').forEach(pane => {
            if (pane.id === tabId) {
                pane.style.display = 'block';
                setTimeout(() => pane.classList.add('active'), 10);
            } else {
                pane.classList.remove('active');
                pane.style.display = 'none';
            }
        });

        if (history.replaceState) {
            history.replaceState(null, null, '#' + tabId);
        }
    }

    document.querySelectorAll('.profile-tab').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const tabId = this.getAttribute('data-tab');
            switchTab(tabId);
        });
    });

    // Check hash on load
    window.addEventListener('DOMContentLoaded', () => {
        const hash = window.location.hash ? window.location.hash.substring(1) : '';
        if (hash && document.getElementById(hash)) {
            switchTab(hash);
        }
    });

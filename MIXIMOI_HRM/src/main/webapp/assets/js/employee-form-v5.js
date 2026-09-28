/**
 * MIXIMOI HRM - Employee onboarding wizard
 * v6: robust upload + wizard event binding; unified Add/Edit flow, client validation, draft recovery,
 * file validation, salary preview and safe step navigation.
 */
(function () {
    'use strict';

    const MAX_FILE_SIZE = 10 * 1024 * 1024;
    const AVATAR_MAX_SIZE = 5 * 1024 * 1024;
    const DRAFT_PREFIX = 'miximoi.employee-form.v5.';
    let currentStep = 1;
    let maxReachedStep = 1;
    let isSubmitting = false;

    const $ = (id) => document.getElementById(id);
    const qs = (selector, root = document) => root.querySelector(selector);
    const qsa = (selector, root = document) => Array.from(root.querySelectorAll(selector));

    function form() { return $('employeeForm'); }
    function panel(step) { return $('panelStep' + step); }
    function alertBox() { return $('clientValidationAlert'); }

    function showMessage(message, type = 'danger') {
        const box = alertBox();
        if (!box) return;
        box.className = 'alert border-0 shadow-sm';
        box.classList.add(type === 'success' ? 'alert-success' : 'alert-danger');
        box.textContent = message;
        box.classList.remove('d-none');
        box.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }

    function clearMessage() {
        const box = alertBox();
        if (box) box.classList.add('d-none');
    }

    function requiredControls(root) {
        return qsa('[required]', root).filter(el => !el.disabled && el.type !== 'hidden');
    }

    function clearInvalid(root) {
        qsa('.is-invalid', root).forEach(el => el.classList.remove('is-invalid'));
    }

    function focusInvalid(el) {
        if (!el) return;
        el.classList.add('is-invalid');
        el.focus({ preventScroll: true });
        el.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    function validateControl(el) {
        if (!el) return true;

        // Radio groups need group-level validation.
        if (el.type === 'radio') {
            const group = qsa(`input[type="radio"][name="${CSS.escape(el.name)}"]`, form());
            const valid = group.some(r => r.checked);
            group.forEach(r => r.classList.toggle('is-invalid', !valid));
            return valid;
        }

        const valid = el.checkValidity();
        el.classList.toggle('is-invalid', !valid);
        return valid;
    }

    function validateStep(step, quiet = false) {
        const root = panel(step);
        if (!root) return true;

        clearInvalid(root);

        // Current-step required fields.
        for (const el of requiredControls(root)) {
            if (!validateControl(el)) {
                if (!quiet) {
                    const label = el.closest('.col-md-6, .col-md-12, .col-md-4, .col-md-3')?.querySelector('.form-label-custom');
                    const name = label ? label.textContent.replace('*', '').trim() : 'trường bắt buộc';
                    showMessage(`Vui lòng kiểm tra: ${name}.`);
                    focusInvalid(el);
                }
                return false;
            }
        }

        if (step === 1) {
            const id = $('idNumber');
            if (id && !/^\d{12}$/.test(id.value.trim())) {
                if (!quiet) {
                    showMessage('Số CCCD phải gồm đúng 12 chữ số.');
                    focusInvalid(id);
                }
                return false;
            }

            const dob = $('dateOfBirth');
            if (dob?.value && new Date(dob.value + 'T00:00:00') > new Date()) {
                if (!quiet) {
                    showMessage('Ngày sinh không được lớn hơn ngày hiện tại.');
                    focusInvalid(dob);
                }
                return false;
            }

            const phone = $('phone');
            if (phone && !/^(0\d{9,10})$/.test(phone.value.replace(/\D/g, ''))) {
                if (!quiet) {
                    showMessage('Số điện thoại phải có 10–11 chữ số và bắt đầu bằng 0.');
                    focusInvalid(phone);
                }
                return false;
            }
        }

        if (step === 3) {
            const salary = parseMoney($('baseSalary')?.value);
            if (!salary || salary <= 0) {
                if (!quiet) {
                    showMessage('Mức lương cơ bản phải lớn hơn 0.');
                    focusInvalid($('baseSalary'));
                }
                return false;
            }
        }

        if (step === 4) {
            const sign = $('contractSignDate')?.value;
            const end = $('contractEndDate')?.value;
            if (sign && end && end < sign) {
                if (!quiet) {
                    showMessage('Ngày hết hạn hợp đồng phải sau ngày ký.');
                    focusInvalid($('contractEndDate'));
                }
                return false;
            }
            if ($('confirmAccuracy') && !$('confirmAccuracy').checked) {
                if (!quiet) {
                    showMessage('Bạn cần xác nhận thông tin trước khi lưu hồ sơ.');
                    focusInvalid($('confirmAccuracy'));
                }
                return false;
            }
        }

        return true;
    }

    function validateAllSteps() {
        for (let step = 1; step <= 4; step++) {
            if (!validateStep(step, true)) {
                currentStep = step;
                renderStep();
                validateStep(step, false);
                return false;
            }
        }
        return true;
    }

    function renderStep() {
        for (let step = 1; step <= 4; step++) {
            const p = panel(step);
            const side = $('sidePanelStep' + step);
            const tab = $('stepperTab' + step);

            if (p) p.classList.toggle('active', step === currentStep);
            if (side) side.style.display = step === currentStep ? '' : 'none';

            if (tab) {
                tab.classList.toggle('active', step === currentStep);
                tab.classList.toggle('completed', step < currentStep);
                tab.classList.toggle('pending', step > currentStep);
                tab.setAttribute('aria-current', step === currentStep ? 'step' : 'false');
            }

            const badge = $('stepperBadge' + step);
            if (badge) {
                if (step === currentStep) badge.textContent = `BƯỚC ${step} • ĐANG THỰC HIỆN`;
                else if (step < currentStep) badge.textContent = `BƯỚC ${step} • ĐÃ HOÀN THÀNH`;
                else badge.textContent = `BƯỚC ${step}`;
            }
        }

        const title = $('badgeProgressText');
        if (title) title.textContent = currentStep === 4 ? 'Sẵn sàng hoàn tất hồ sơ' : 'Đang soạn thảo hồ sơ';

        updateStep1Progress();
        updateSummary();
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    window.jumpToStep = function (step) {
        step = Number(step);
        if (step < 1 || step > 4) return;

        if (step > maxReachedStep) {
            showMessage('Hãy hoàn thành bước hiện tại trước khi chuyển sang bước tiếp theo.');
            return;
        }

        currentStep = step;
        clearMessage();
        renderStep();
    };

    window.nextStep = function () {
        if (currentStep >= 4) return;
        if (!validateStep(currentStep)) return;

        maxReachedStep = Math.max(maxReachedStep, currentStep + 1);
        currentStep++;
        clearMessage();
        renderStep();
        saveDraft();
    };

    window.prevStep = function () {
        if (currentStep <= 1) return;
        currentStep--;
        clearMessage();
        renderStep();
    };

    function parseMoney(value) {
        if (value == null) return 0;
        const digits = String(value).replace(/[^\d]/g, '');
        return digits ? Number(digits) : 0;
    }

    function formatVnd(value) {
        return new Intl.NumberFormat('vi-VN').format(Math.max(0, Math.round(value))) + ' đ';
    }

    window.formatSalaryInput = function (input) {
        const amount = parseMoney(input.value);
        input.value = amount ? new Intl.NumberFormat('vi-VN').format(amount) : '';
        recalcCompensation();
        saveDraftDebounced();
    };

    window.recalcCompensation = function () {
        const base = parseMoney($('baseSalary')?.value);
        const allowance =
            (($('alLunch')?.checked ? 1000000 : 0) +
             ($('alGas')?.checked ? 1000000 : 0) +
             ($('alPhone')?.checked ? 500000 : 0));

        const gross = base + allowance;
        const insurance = Math.min(base, 36000000) * 0.105;
        const taxable = Math.max(0, gross - insurance - 11000000);
        const tax = taxable <= 0 ? 0 : taxable <= 5000000 ? taxable * 0.05 : (5000000 * 0.05) + ((taxable - 5000000) * 0.10);
        const net = Math.max(0, gross - insurance - tax);
        const pct = gross ? Math.round((net / gross) * 1000) / 10 : 0;

        if ($('calcBaseDisplay')) $('calcBaseDisplay').textContent = formatVnd(base);
        if ($('calcAllowanceDisplay')) $('calcAllowanceDisplay').textContent = '+ ' + formatVnd(allowance);
        if ($('calcGrossDisplay')) $('calcGrossDisplay').textContent = formatVnd(gross);
        if ($('calcBhxhDisplay')) $('calcBhxhDisplay').textContent = '- ' + formatVnd(insurance);
        if ($('calcTaxDisplay')) $('calcTaxDisplay').textContent = '- ' + formatVnd(tax);
        if ($('calcNetDisplay')) $('calcNetDisplay').textContent = '~ ' + formatVnd(net);
        if ($('calcNetPct')) $('calcNetPct').textContent = pct + '% Gross';
        if ($('calcDonutPct')) $('calcDonutPct').textContent = Math.round(pct) + '%';

        const probationRate = Number(qs('input[name="probationSalaryRate"]:checked')?.value || 85);
        const probation = base * probationRate / 100;
        if ($('probationSubText')) $('probationSubText').textContent = `Thử việc: ${formatVnd(probation)}/tháng`;

        if ($('finalSalary')) $('finalSalary').textContent = formatVnd(base);
    };

    window.toggleAllowanceRow = function (checkbox, amount) {
        const row = checkbox.closest('.allowance-box-item');
        if (row) row.classList.toggle('active', checkbox.checked);
        recalcCompensation();
        saveDraftDebounced();
    };

    window.addCustomAllowance = function () {
        const container = $('allowanceListContainer');
        if (!container) return;
        const id = 'customAllowance' + Date.now();
        const row = document.createElement('div');
        row.className = 'allowance-box-item active';
        row.innerHTML = `
            <div class="allowance-left">
                <input type="checkbox" class="form-check-input mt-0" id="${id}" checked>
                <div>
                    <div class="allowance-name">Phụ cấp khác</div>
                    <div class="allowance-sub">Khoản phụ cấp do HR khai báo</div>
                </div>
            </div>
            <div class="d-flex align-items-center gap-2">
                <input type="number" min="0" step="1000" class="form-control form-control-sm" style="width:150px" value="0" aria-label="Số tiền phụ cấp">
                <span class="text-muted small">đ/tháng</span>
            </div>`;
        container.appendChild(row);
        row.querySelector('input[type="checkbox"]').addEventListener('change', recalcCompensation);
        row.querySelector('input[type="number"]').addEventListener('input', recalcCompensation);
    };

    window.calculateAge = function () {
        const dob = $('dateOfBirth')?.value;
        if (!dob) return;
        const birth = new Date(dob + 'T00:00:00');
        const now = new Date();
        let age = now.getFullYear() - birth.getFullYear();
        const m = now.getMonth() - birth.getMonth();
        if (m < 0 || (m === 0 && now.getDate() < birth.getDate())) age--;
        const hint = $('ageHint');
        if (hint) hint.textContent = age >= 0 ? `Tuổi: ${age}` : '';
    };

    window.validateCccd = function (input) {
        input.value = input.value.replace(/\D/g, '').slice(0, 12);
        const valid = /^\d{12}$/.test(input.value);
        const icon = $('cccdValidIcon');
        if (icon) icon.style.display = valid ? 'block' : 'none';
        input.classList.toggle('is-valid', valid);
        input.classList.toggle('is-invalid', input.value.length > 0 && !valid);
        saveDraftDebounced();
    };

    window.updateGenderDisplay = function () {
        const checked = qs('input[name="gender"]:checked');
        const text = $('sideProfileAgeGender');
        if (text && checked) {
            text.textContent = checked.value === 'MALE' ? 'Nam' : checked.value === 'FEMALE' ? 'Nữ' : 'Khác';
        }
    };

    window.handleFullNameChange = function (value) {
        const name = value.trim() || 'Chưa nhập họ tên';
        if ($('sideProfileName')) $('sideProfileName').textContent = name;
        if ($('sideStep3Name')) $('sideStep3Name').textContent = name;
        if ($('finalPosition')) $('finalPosition').textContent = $('positionId')?.selectedOptions[0]?.textContent.trim() || 'Chưa chọn';
        updateAvatarFallback();
        saveDraftDebounced();
    };

    function updateAvatarFallback() {
        // Do not replace a real uploaded avatar.
        const img = $('avatarPreviewImg');
        if (!img || $('avatarFileInput')?.files?.length) return;
        const initials = (($('fullName')?.value || 'NV').trim().split(/\s+/).slice(-2).map(x => x[0]).join('') || 'NV').toUpperCase();
        img.alt = initials;
    }

    // ========================= FILE / DRAG-DROP HANDLERS =========================
    // Dùng cả click programmatic + drag/drop. Không phụ thuộc Bootstrap.
    window.triggerAvatarUpload = function () {
        const input = $('avatarFileInput');
        if (!input) return showMessage('Không tìm thấy ô tải ảnh chân dung.');
        input.value = '';
        input.click();
    };

    window.previewAvatar = function (input) {
        const file = input?.files?.[0];
        if (!file) return;
        const result = validateFile(file, ['.jpg','.jpeg','.png','.webp'], AVATAR_MAX_SIZE);
        if (result !== true) {
            showMessage(result);
            input.value = '';
            return;
        }
        const reader = new FileReader();
        reader.onload = e => {
            const src = e.target.result;
            if ($('avatarPreviewImg')) $('avatarPreviewImg').src = src;
            if ($('sideProfileAvatar')) $('sideProfileAvatar').src = src;
            if ($('sideStep3Avatar')) $('sideStep3Avatar').src = src;
        };
        reader.onerror = () => showMessage('Không thể đọc ảnh. Vui lòng chọn lại file.');
        reader.readAsDataURL(file);
        updateUploadedDocCount();
        saveDraftDebounced();
    };

    window.triggerDocUpload = function (id) {
        const input = $(id);
        if (!input) return showMessage('Không tìm thấy ô tải tệp: ' + id);
        input.value = '';
        input.click();
    };

    function validateFile(file, allowed, maxSize) {
        if (!file) return true;
        if (file.size > maxSize) return `Tệp "${file.name}" vượt quá ${Math.round(maxSize / 1024 / 1024)}MB.`;
        const lower = file.name.toLowerCase();
        const ok = allowed.some(ext => lower.endsWith(ext));
        return ok ? true : `Định dạng tệp "${file.name}" không được hỗ trợ.`;
    }

    window.handleDocFile = function (input, previewId, nameId) {
        const file = input?.files?.[0];
        if (!file) return;
        const result = validateFile(file, ['.jpg','.jpeg','.png','.webp','.pdf'], MAX_FILE_SIZE);
        if (result !== true) {
            showMessage(result);
            input.value = '';
            return;
        }
        const preview = $(previewId);
        const icon = $(previewId.replace('Preview', 'Icon'));
        const name = $(nameId);
        if (name) name.textContent = file.name;
        if (file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = e => {
                if (preview) {
                    preview.src = e.target.result;
                    preview.classList.remove('d-none');
                }
                if (icon) icon.classList.add('d-none');
            };
            reader.onerror = () => showMessage('Không thể đọc tệp. Vui lòng chọn lại.');
            reader.readAsDataURL(file);
        } else {
            if (preview) preview.classList.add('d-none');
            if (icon) icon.classList.remove('d-none');
        }
        const del = $(nameId.replace('Name', 'Del'));
        if (del) del.classList.remove('d-none');
        updateUploadedDocCount();
        saveDraftDebounced();
    };

    window.handleResumeFile = function (input) {
        const file = input?.files?.[0];
        if (!file) return;
        const result = validateFile(file, ['.pdf','.doc','.docx'], MAX_FILE_SIZE);
        if (result !== true) {
            showMessage(result);
            input.value = '';
            return;
        }
        if ($('resumeTitle')) $('resumeTitle').textContent = file.name;
        if ($('resumeSub')) $('resumeSub').textContent = 'Tệp mới đã chọn • sẵn sàng tải lên';
        if ($('resumeBadge')) $('resumeBadge').textContent = 'Đã chọn • ' + Math.ceil(file.size / 1024) + ' KB';
        updateUploadedDocCount();
        saveDraftDebounced();
    };

    function assignDroppedFile(inputId, file) {
        const input = $(inputId);
        if (!input || !file) return;
        try {
            const dt = new DataTransfer();
            dt.items.add(file);
            input.files = dt.files;
            input.dispatchEvent(new Event('change', { bubbles: true }));
        } catch (e) {
            showMessage('Trình duyệt không cho phép gắn file kéo-thả trực tiếp. Hãy bấm vào ô tải file.');
        }
    }

    function bindDropZone(zone, inputId) {
        if (!zone || zone.dataset.dropBound === '1') return;
        zone.dataset.dropBound = '1';
        ['dragenter','dragover'].forEach(type => zone.addEventListener(type, e => {
            e.preventDefault();
            e.stopPropagation();
            zone.classList.add('is-dragover');
        }));
        ['dragleave','drop'].forEach(type => zone.addEventListener(type, e => {
            e.preventDefault();
            e.stopPropagation();
            zone.classList.remove('is-dragover');
        }));
        zone.addEventListener('drop', e => {
            const file = e.dataTransfer?.files?.[0];
            if (file) assignDroppedFile(inputId, file);
        });
    }

    function bindFileInteractions() {
        bindDropZone($('avatarDropZone'), 'avatarFileInput');
        bindDropZone($('cccdFrontDropZone'), 'cccdFrontInput');
        bindDropZone($('cccdBackDropZone'), 'cccdBackInput');
        bindDropZone($('resumeDropZone'), 'resumeInput');
        // Bind click exactly once. Tránh gọi input.click() hai lần.
        qsa('[data-upload-input]').forEach(zone => {
            if (zone.dataset.clickBound === '1') return;
            zone.dataset.clickBound = '1';
            zone.addEventListener('click', function (e) {
                if (e.target.closest('input, a, button')) return;
                e.preventDefault();
                const id = this.getAttribute('data-upload-input');
                if (id === 'avatarFileInput') triggerAvatarUpload();
                else triggerDocUpload(id);
            });
        });
    }

    function updateUploadedDocCount() {
        const ids = ['cccdFrontInput','cccdBackInput','resumeInput'];
        const count = ids.filter(id => $(id)?.files?.length).length;
        const badge = $('uploadedDocCountBadge');
        if (badge) badge.textContent = count ? `${count}/3 tệp mới` : 'Tùy chọn tải lên';
    }

    window.clearDocUpload = function (previewId, nameId) {
        const map = {
            cccdFrontPreview: 'cccdFrontInput',
            cccdBackPreview: 'cccdBackInput'
        };
        const input = $(map[previewId]);
        if (input) input.value = '';
        const preview = $(previewId);
        if (preview) {
            preview.src = '';
            preview.classList.add('d-none');
        }
        const icon = $(previewId.replace('Preview','Icon'));
        if (icon) icon.classList.remove('d-none');
        if ($(nameId)) $(nameId).textContent = 'Bấm để tải tệp';
        const del = $(nameId.replace('Name','Del'));
        del?.classList.add('d-none');
        updateUploadedDocCount();
    };

    window.toggleSameAddress = function (checkbox) {
        const address = $('address');
        const temp = $('tempAddress');
        if (!address || !temp) return;
        if (checkbox.checked) {
            temp.value = address.value;
            temp.readOnly = true;
            temp.classList.add('bg-light');
        } else {
            temp.readOnly = false;
            temp.classList.remove('bg-light');
        }
        saveDraftDebounced();
    };

    window.toggleEditEmpCode = function () {
        const input = $('employeeCode');
        if (!input) return;
        input.readOnly = !input.readOnly;
        if (!input.readOnly) {
            input.focus();
            input.select();
        }
    };

    window.regenerateEmployeeCode = function () {
        const input = $('employeeCode');
        if (!input) return;
        // This is only a UI suggestion. The server remains authoritative.
        const current = input.value.trim();
        const match = current.match(/^NV(\d+)$/i);
        const next = match ? Number(match[1]) + 1 : Math.floor(Date.now() / 1000) % 100000;
        input.value = 'NV' + String(next).padStart(3, '0');
        saveDraftDebounced();
    };

    window.toggleEditContractCode = function () {
        const input = $('contractCode');
        if (!input) return;
        input.readOnly = !input.readOnly;
        if (!input.readOnly) {
            input.focus();
            input.select();
        }
    };

    window.regenerateContractCode = function () {
        const input = $('contractCode');
        if (!input) return;
        const current = input.value.trim();
        const match = current.match(/^HD(\d+)$/i);
        const next = match ? Number(match[1]) + 1 : Math.floor(Date.now() / 1000) % 100000;
        input.value = 'HD' + String(next).padStart(3, '0');
        saveDraftDebounced();
    };

    window.autoGenBhxh = function () {
        const input = $('bhxhCode');
        if (!input || input.value.trim()) return;
        input.value = '01' + String(Date.now()).slice(-8);
    };

    window.autoGenTaxCode = function () {
        const input = $('taxCode');
        if (!input || input.value.trim()) return;
        input.value = String(Date.now()).slice(-10);
    };

    window.handleDepartmentChange = function (departmentId) {
        const select = $('positionId');
        if (!select) return;
        const options = Array.from(select.options);
        options.forEach(option => {
            if (!option.value) return;
            const dept = option.dataset.departmentId;
            const visible = !departmentId || !dept || dept === String(departmentId);
            option.hidden = !visible;
            if (!visible && option.selected) option.selected = false;
        });
        const selected = select.selectedOptions[0];
        if (selected?.hidden) select.value = '';
        updateDepartmentQuota();
        saveDraftDebounced();
    };

    window.handlePositionChange = function (positionId) {
        const pos = $('positionId')?.selectedOptions[0];
        if ($('finalPosition')) $('finalPosition').textContent = pos ? pos.textContent.trim() : 'Chưa chọn';
        const sidePos = $('sideStep3Pos');
        if (sidePos) sidePos.textContent = (pos ? pos.textContent.trim() : 'Vị trí') + ' • ' + ($('departmentId')?.selectedOptions[0]?.textContent.trim() || 'Phòng ban');
        updateDepartmentQuota();
        saveDraftDebounced();
    };

    function updateDepartmentQuota() {
        const dept = $('departmentId')?.selectedOptions[0];
        if ($('quotaDeptName') && dept) $('quotaDeptName').textContent = '🏢 ' + dept.textContent.trim();
        if ($('deptFilterBadge')) $('deptFilterBadge').textContent = dept ? 'Đã chọn phòng ban' : 'Định biên chuẩn';
    }

    window.handleStatusChange = function (status) {
        const fields = $('terminationFields');
        if (!fields) return;
        fields.classList.toggle('d-none', status !== 'INACTIVE');
    };

    function updateStep1Progress() {
        const root = panel(1);
        if (!root) return;
        const controls = qsa('[required]', root).filter(el => el.type !== 'hidden');
        if (!controls.length) return;
        let done = 0;
        controls.forEach(el => {
            if (el.type === 'radio') {
                if (qsa(`input[type="radio"][name="${CSS.escape(el.name)}"]`, root).some(r => r.checked)) done++;
            } else if (el.value && el.checkValidity()) done++;
        });
        const pct = Math.round(done / controls.length * 100);
        if ($('step1Pct')) $('step1Pct').textContent = pct + '%';
        if ($('step1ProgressBar')) $('step1ProgressBar').style.width = pct + '%';
    }

    function updateSummary() {
        const code = $('employeeCode')?.value || window.CURRENT_EMP_CODE || '—';
        const position = $('positionId')?.selectedOptions[0]?.textContent.trim() || 'Chưa chọn';
        const salary = parseMoney($('baseSalary')?.value);

        if ($('finalEmpCode')) $('finalEmpCode').textContent = code;
        if ($('finalPosition')) $('finalPosition').textContent = position;
        if ($('finalSalary')) $('finalSalary').textContent = salary ? formatVnd(salary) : '—';
        if ($('step2CompanyEmail') && $('email')) $('step2CompanyEmail').value = $('email').value;
    }

    function draftKey() {
        const id = $('employeeForm')?.querySelector('input[name="id"]')?.value || 'new';
        return DRAFT_PREFIX + (window.IS_EDIT_MODE ? 'edit-' + id : 'new-' + (window.CURRENT_EMP_CODE || 'draft'));
    }

    function collectDraft() {
        const f = form();
        if (!f) return {};
        const data = {};
        qsa('input, select, textarea', f).forEach(el => {
            if (!el.name || el.type === 'file' || el.type === 'submit' || el.type === 'button') return;
            if (el.type === 'radio' || el.type === 'checkbox') {
                data[el.name] = data[el.name] || [];
                if (el.checked) data[el.name].push(el.value || 'on');
            } else {
                data[el.name] = el.value;
            }
        });
        data._savedAt = new Date().toISOString();
        return data;
    }

    function saveDraft() {
        try { localStorage.setItem(draftKey(), JSON.stringify(collectDraft())); } catch (_) {}
    }

    let draftTimer;
    function saveDraftDebounced() {
        clearTimeout(draftTimer);
        draftTimer = setTimeout(saveDraft, 250);
    }

    window.restoreDraftData = function () {
        try {
            const raw = localStorage.getItem(draftKey());
            if (!raw) return;
            const data = JSON.parse(raw);
            Object.entries(data).forEach(([name, value]) => {
                if (name === '_savedAt') return;
                const els = qsa(`[name="${CSS.escape(name)}"]`, form());
                els.forEach(el => {
                    if (el.type === 'radio' || el.type === 'checkbox') {
                        el.checked = Array.isArray(value) && value.includes(el.value || 'on');
                    } else if (el.type !== 'file') {
                        el.value = value ?? '';
                    }
                });
            });
            $('draftAlertBanner')?.classList.add('d-none');
            updateAll();
            showMessage('Bản nháp đã được khôi phục.', 'success');
        } catch (_) {
            showMessage('Không thể khôi phục bản nháp này.');
        }
    };

    window.confirmDiscard = function () {
        return window.confirm('Bạn có chắc muốn rời khỏi biểu mẫu? Các thay đổi chưa lưu có thể bị mất.');
    };

    window.clearDraft = function () {
        try { localStorage.removeItem(draftKey()); } catch (_) {}
        $('draftAlertBanner')?.classList.add('d-none');
    };

    window.dismissDraft = function () {
        $('draftAlertBanner')?.classList.add('d-none');
    };

    function maybeShowDraft() {
        try {
            const raw = localStorage.getItem(draftKey());
            if (!raw) return;
            const data = JSON.parse(raw);
            const savedAt = data._savedAt ? new Date(data._savedAt) : null;
            if (!savedAt || Date.now() - savedAt.getTime() > 24 * 60 * 60 * 1000) return;
            const text = $('draftAlertText');
            if (text) text.textContent = `Có bản nháp từ ${savedAt.toLocaleString('vi-VN')}.`;
            $('draftAlertBanner')?.classList.remove('d-none');
        } catch (_) {}
    }

    function updateAll() {
        calculateAge();
        updateGenderDisplay();
        updateSummary();
        updateDepartmentQuota();
        recalcCompensation();
        updateStep1Progress();
        handleStatusChange($('empStatus')?.value || 'ACTIVE');
    }

    function submitGuard() {
        const f = form();
        if (!f) return;
        f.addEventListener('submit', function (event) {
            if (isSubmitting) {
                event.preventDefault();
                return;
            }

            clearMessage();
            if (!validateAllSteps()) {
                event.preventDefault();
                return;
            }

            isSubmitting = true;
            const submitButtons = qsa('button[type="submit"]', f);
            submitButtons.forEach(btn => {
                btn.disabled = true;
                btn.dataset.originalText = btn.innerHTML;
                btn.innerHTML = '<i class="bi bi-arrow-repeat me-1"></i> Đang lưu...';
            });

            try { localStorage.removeItem(draftKey()); } catch (_) {}
        });
    }

    function bindLiveEvents() {
        const f = form();
        if (!f) return;

        qsa('input, select, textarea', f).forEach(el => {
            ['input', 'change'].forEach(eventName => {
                el.addEventListener(eventName, () => {
                    el.classList.remove('is-invalid');
                    updateStep1Progress();
                    updateSummary();
                    saveDraftDebounced();
                });
            });
        });

        $('email')?.addEventListener('input', () => {
            if ($('step2CompanyEmail')) $('step2CompanyEmail').value = $('email').value;
        });
        $('address')?.addEventListener('input', () => {
            if ($('sameAddressCheck')?.checked && $('tempAddress')) $('tempAddress').value = $('address').value;
        });

        ['cccdFrontInput','cccdBackInput','resumeInput','avatarFileInput','contractFile'].forEach(id => {
            $(id)?.addEventListener('change', updateUploadedDocCount);
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        const f = form();
        if (!f) return;

        currentStep = 1;
        maxReachedStep = 1;
        renderStep();
        bindLiveEvents();
        bindFileInteractions();

        qsa('[data-wizard-next]').forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                window.nextStep();
            });
        });
        qsa('[data-wizard-prev]').forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                window.prevStep();
            });
        });

        submitGuard();
        updateAll();
        maybeShowDraft();

        // On edit, filter positions immediately but do not force the user to step 1 data.
        if ($('departmentId')?.value) handleDepartmentChange($('departmentId').value);

        // Save only after actual edits.
        f.addEventListener('input', saveDraftDebounced);
        f.addEventListener('change', saveDraftDebounced);
    });
})();

// End of MIXIMOI HRM employee-form-v6

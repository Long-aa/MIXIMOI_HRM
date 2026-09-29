/**
 * MIXIMOI HRM — EMPLOYEE ONBOARDING & EDIT WIZARD (employee-form.js)
 * Gộp toàn bộ tính năng hoàn chỉnh: Điều hướng 4 bước, kiểm tra hợp lệ,
 * tự động sinh mã/BHXH/MST, quản trị định biên phòng ban & chức vụ,
 * tính toán lương & phúc lợi Net/Gross, upload & kéo thả tệp, lưu nháp tự động.
 */
(function () {
    'use strict';

    // =========================================================================
    // 1. DATA DICTIONARY: DEPARTMENT QUOTAS & SUITABLE POSITIONS
    // =========================================================================
    const DEPARTMENT_DATA = {
        "1": {
            name: "Ban Giám đốc",
            desc: "Lãnh đạo và điều hành toàn diện chiến lược tập đoàn",
            targetCount: 4,
            currentCount: 3,
            manager: "Nguyễn Văn An (NV001) - Tổng Giám đốc",
            positions: [
                { id: 1, name: "Giám đốc", level: "L5", defaultSalary: "50.000.000" },
                { id: 2, name: "Phó Giám đốc", level: "L5", defaultSalary: "40.000.000" },
                { id: 3, name: "Trưởng phòng (Văn phòng HĐQT)", level: "L4", defaultSalary: "30.000.000" }
            ]
        },
        "2": {
            name: "Phòng Nhân sự (HR & Tuyển dụng)",
            desc: "Quản trị nguồn nhân lực, tuyển dụng, đào tạo & C&B",
            targetCount: 5,
            currentCount: 2,
            manager: "Trần Thị Bình (NV002) - Trưởng phòng Nhân sự",
            positions: [
                { id: 3, name: "Trưởng phòng Nhân sự", level: "L4", defaultSalary: "35.000.000" },
                { id: 4, name: "Phó phòng Nhân sự", level: "L3", defaultSalary: "26.000.000" },
                { id: 8, name: "Chuyên viên HR (C&B / Tuyển dụng)", level: "L2", defaultSalary: "18.000.000" },
                { id: 5, name: "Nhân viên Nhân sự", level: "L1", defaultSalary: "12.000.000" },
                { id: 6, name: "Thực tập sinh HR", level: "L1", defaultSalary: "6.000.000" }
            ]
        },
        "3": {
            name: "Phòng Kế toán (Tài chính & Kế toán)",
            desc: "Quản trị dòng tiền, thuế, kế toán doanh nghiệp & báo cáo tài chính",
            targetCount: 6,
            currentCount: 3,
            manager: "Lê Văn Cường (NV003) - Kế toán trưởng",
            positions: [
                { id: 3, name: "Trưởng phòng Kế toán (Kế toán trưởng)", level: "L4", defaultSalary: "35.000.000" },
                { id: 4, name: "Phó phòng Kế toán", level: "L3", defaultSalary: "25.000.000" },
                { id: 9, name: "Kế toán viên (Tổng hợp / Thuế / Công nợ)", level: "L2", defaultSalary: "18.000.000" },
                { id: 5, name: "Nhân viên Kế toán kho", level: "L1", defaultSalary: "12.000.000" },
                { id: 6, name: "Thực tập sinh Kế toán", level: "L1", defaultSalary: "6.000.000" }
            ]
        },
        "4": {
            name: "Phòng Kinh doanh (Sales & Khách hàng)",
            desc: "Phát triển thị trường, bán hàng B2B/B2C và chăm sóc khách hàng",
            targetCount: 10,
            currentCount: 2,
            manager: "Phạm Thị Dung (NV004) - Giám đốc Kinh doanh",
            positions: [
                { id: 3, name: "Trưởng phòng Kinh doanh", level: "L4", defaultSalary: "32.000.000" },
                { id: 4, name: "Phó phòng Kinh doanh", level: "L3", defaultSalary: "24.000.000" },
                { id: 10, name: "Chuyên viên kinh doanh (Senior Sales)", level: "L2", defaultSalary: "18.000.000" },
                { id: 5, name: "Nhân viên Telesales / CSKH", level: "L1", defaultSalary: "12.000.000" },
                { id: 6, name: "Thực tập sinh Kinh doanh", level: "L1", defaultSalary: "6.000.000" }
            ]
        },
        "5": {
            name: "Phòng Marketing (Truyền thông & Thương hiệu)",
            desc: "Quảng bá thương hiệu, tiếp thị số, tổ chức sự kiện & Media",
            targetCount: 6,
            currentCount: 1,
            manager: "Hoàng Văn Em (NV005) - Trưởng phòng Marketing",
            positions: [
                { id: 3, name: "Trưởng phòng Marketing (CMO)", level: "L4", defaultSalary: "35.000.000" },
                { id: 4, name: "Phó phòng Marketing", level: "L3", defaultSalary: "25.000.000" },
                { id: 5, name: "Chuyên viên Digital Marketing / Content", level: "L2", defaultSalary: "18.000.000" },
                { id: 6, name: "Thực tập sinh Marketing / Design", level: "L1", defaultSalary: "6.000.000" }
            ]
        },
        "6": {
            name: "Phòng Kỹ thuật (Công nghệ thông tin & R&D)",
            desc: "Phát triển và duy trì hệ sinh thái sản phẩm công nghệ MIXIMOI",
            targetCount: 15,
            currentCount: 4,
            manager: "Lê Hoàng Nam (NV002) - Giám đốc Công nghệ (CTO)",
            positions: [
                { id: 3, name: "Trưởng phòng Kỹ thuật (Technical Lead)", level: "L4", defaultSalary: "40.000.000" },
                { id: 4, name: "Phó phòng Kỹ thuật", level: "L3", defaultSalary: "32.000.000" },
                { id: 7, name: "Kỹ sư phần mềm (Backend/Frontend/Fullstack)", level: "L3", defaultSalary: "28.500.000" },
                { id: 5, name: "Kỹ sư QA / QC Tester", level: "L2", defaultSalary: "18.000.000" },
                { id: 6, name: "Thực tập sinh Lập trình viên (Fresher/Intern)", level: "L1", defaultSalary: "8.000.000" }
            ]
        }
    };

    // =========================================================================
    // 2. CONSTANTS & SYSTEM STATE
    // =========================================================================
    const MAX_FILE_SIZE = 10 * 1024 * 1024;      // 10MB
    const AVATAR_MAX_SIZE = 5 * 1024 * 1024;    // 5MB
    const DRAFT_PREFIX = 'miximoi.employee-form.v6.';
    let currentStep = 1;
    let maxReachedStep = 1;
    let isSubmitting = false;
    let saveTimeout = null;

    const $ = (id) => document.getElementById(id);
    const qs = (selector, root = document) => root.querySelector(selector);
    const qsa = (selector, root = document) => Array.from(root.querySelectorAll(selector));

    function form() { return $('employeeForm'); }
    function panel(step) { return $('panelStep' + step); }
    function alertBox() { return $('clientValidationAlert'); }

    // =========================================================================
    // 3. TOAST & NOTIFICATION HELPERS
    // =========================================================================
    function showToast(message, type = 'success') {
        const container = $('toastContainer');
        if (!container) return;
        const toast = document.createElement('div');
        toast.className = `toast-custom ${type}`;
        let icon = 'bi-check-circle-fill text-success';
        if (type === 'warning') icon = 'bi-exclamation-triangle-fill text-warning';
        if (type === 'danger') icon = 'bi-x-circle-fill text-danger';

        toast.innerHTML = `<i class="bi ${icon} fs-5"></i><div>${message}</div>`;
        container.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateX(50px)';
            toast.style.transition = 'all 0.3s ease';
            setTimeout(() => toast.remove(), 300);
        }, 3500);
    }
    window.showToast = showToast;

    function showMessage(message, type = 'danger') {
        const box = alertBox();
        if (!box) {
            showToast(message, type);
            return;
        }
        box.className = 'alert border-0 shadow-sm';
        box.classList.add(type === 'success' ? 'alert-success' : 'alert-danger');
        box.innerHTML = `<i class="bi bi-exclamation-triangle-fill me-2"></i> ${message}`;
        box.classList.remove('d-none');
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
        const scrollTarget = (el.offsetParent === null)
            ? (el.closest('.pill-radio-group, .auto-code-wrap, .position-relative, .input-group') || el.parentElement)
            : el;
        if (scrollTarget) {
            scrollTarget.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        try {
            el.focus({ preventScroll: true });
        } catch (_) {}
    }

    function validateControl(el) {
        if (!el) return true;
        if (el.type === 'radio') {
            const group = qsa(`input[type="radio"][name="${CSS.escape(el.name)}"]`, form());
            const valid = group.some(r => r.checked);
            group.forEach(r => r.classList.toggle('is-invalid', !valid));
            const groupWrap = el.closest('.pill-radio-group');
            if (groupWrap) groupWrap.classList.toggle('is-invalid', !valid);
            return valid;
        }
        const valid = el.checkValidity();
        el.classList.toggle('is-invalid', !valid);
        return valid;
    }

    // =========================================================================
    // 4. STEP VALIDATION
    // =========================================================================
    function validateStep(step, quiet = false) {
        const root = panel(step);
        if (!root) return true;

        clearInvalid(root);

        let firstInvalid = null;
        let firstLabelName = '';

        for (const el of requiredControls(root)) {
            if (!validateControl(el)) {
                if (!firstInvalid) {
                    firstInvalid = el;
                    const label = el.closest('.col-md-6, .col-md-12, .col-md-4, .col-md-3, .col-12')?.querySelector('.form-label-custom');
                    if (label) {
                        const clone = label.cloneNode(true);
                        clone.querySelectorAll('.req, small, span.text-primary, span.text-muted, i').forEach(x => x.remove());
                        firstLabelName = clone.textContent.trim();
                    }
                    if (!firstLabelName) firstLabelName = 'trường bắt buộc';
                }
            }
        }

        if (firstInvalid) {
            if (!quiet) {
                const msg = `Bước ${step}: Vui lòng điền "${firstLabelName}" trước khi tiếp tục.`;
                showMessage(msg);
                showToast(msg, 'danger');
                focusInvalid(firstInvalid);
            }
            return false;
        }

        if (step === 1) {
            const id = $('idNumber');
            if (id && id.value.trim() && !/^\d{12}$/.test(id.value.trim())) {
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
            if (phone && phone.value.trim()) {
                const cleanPhone = phone.value.replace(/\D/g, '');
                if (!/^(0\d{9,10})$/.test(cleanPhone)) {
                    if (!quiet) {
                        showMessage('Số điện thoại phải có 10–11 chữ số và bắt đầu bằng 0.');
                        focusInvalid(phone);
                    }
                    return false;
                }
            }
        }

        if (step === 2) {
            const dept = $('departmentId');
            if (dept && (!dept.value || dept.value === '0')) {
                if (!quiet) {
                    showMessage('Vui lòng chọn phòng ban.');
                    focusInvalid(dept);
                }
                return false;
            }
            const pos = $('positionId');
            if (pos && (!pos.value || pos.value === '0')) {
                if (!quiet) {
                    showMessage('Vui lòng chọn chức vụ chuyên môn.');
                    focusInvalid(pos);
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
                    showMessage('Ngày hết hạn hợp đồng phải sau hoặc bằng ngày ký.');
                    focusInvalid($('contractEndDate'));
                }
                return false;
            }
            const confirm = $('confirmAccuracy');
            if (confirm && !confirm.checked && currentStep === 4) {
                if (!quiet) {
                    const msg = 'Bạn cần tích xác nhận thông tin trước khi hoàn tất lưu hồ sơ.';
                    showMessage(msg);
                    showToast(msg, 'danger');
                    focusInvalid(confirm);
                }
                return false;
            }
        }

        return true;
    }
    window.validateStep = validateStep;

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
    window.validateAllSteps = validateAllSteps;

    // =========================================================================
    // 5. WIZARD STEP NAVIGATION
    // =========================================================================
    function renderStep() {
        for (let step = 1; step <= 4; step++) {
            const p = panel(step);
            const side = $('sidePanelStep' + step);
            const tab = $('stepperTab' + step);

            if (p) p.classList.toggle('active', step === currentStep);
            if (side) side.style.display = step === currentStep ? '' : 'none';

            if (tab) {
                tab.classList.toggle('active', step === currentStep);
                tab.classList.toggle('done', step < currentStep);     // CSS uses .done
                tab.classList.remove('completed');                     // remove legacy class
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

        // Sticky button visibility
        const btnNext = $('btnNext');
        const btnPrev = $('btnPrev');
        const btnSubmit = $('btnSubmit');
        const btnNextText = $('btnNextText');

        if (btnPrev) {
            btnPrev.disabled = (currentStep <= 1);
        }

        if (currentStep < 4) {
            if (btnNext) btnNext.style.display = '';
            if (btnSubmit) btnSubmit.style.display = 'none';
            const nextLabels = [
                "",
                "Tiếp tục: Bước 2 (Công việc & Định biên)",
                "Tiếp tục: Bước 3 (Lương & Phúc lợi)",
                "Tiếp tục: Bước 4 (Hợp đồng & Bảo hiểm)"
            ];
            if (btnNextText) btnNextText.textContent = nextLabels[currentStep] || 'Tiếp tục';
        } else {
            if (btnNext) btnNext.style.display = 'none';
            if (btnSubmit) btnSubmit.style.display = '';
        }

        updateStep1Progress();
        updateSummary();
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    window.jumpToStep = function (step) {
        step = Number(step);
        if (step < 1 || step > 4) return;
        if (step > maxReachedStep) {
            showMessage('Vui lòng hoàn thành bước hiện tại trước khi chuyển sang bước tiếp theo.');
            return;
        }
        currentStep = step;
        clearMessage();
        renderStep();
    };

    window.nextStep = function () {
        if (currentStep >= 4) return;
        if (!form()) {
            showMessage('Không tìm thấy biểu mẫu nhân viên (#employeeForm).');
            return;
        }
        if (!panel(currentStep)) {
            showMessage('Không tìm thấy nội dung Bước ' + currentStep + '.');
            return;
        }
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

    // =========================================================================
    // 6. MONEY & SALARY CALCULATIONS
    // =========================================================================
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
        let allowance = 0;
        if ($('alLunch')?.checked) allowance += 1000000;
        if ($('alGas')?.checked) allowance += 1000000;
        if ($('alPhone')?.checked) allowance += 500000;

        // Add custom allowance rows
        qsa('.allowance-box-item', $('allowanceListContainer')).forEach(item => {
            const chk = item.querySelector('input[type="checkbox"]');
            const num = item.querySelector('input[type="number"]');
            if (chk && chk.checked && num) {
                allowance += parseMoney(num.value);
            }
        });

        const gross = base + allowance;
        const insuranceCap = 36000000; // Mức trần đóng BHXH 2024
        const insuranceBase = Math.min(base, insuranceCap);
        const insurance = insuranceBase * 0.105; // 8% BHXH + 1.5% BHYT + 1% BHTN = 10.5%
        const personalDeduction = 11000000;
        const taxable = Math.max(0, gross - insurance - personalDeduction);

        // Biểu thuế TNCN lũy tiến từng phần
        let tax = 0;
        if (taxable <= 5000000) {
            tax = taxable * 0.05;
        } else if (taxable <= 10000000) {
            tax = 5000000 * 0.05 + (taxable - 5000000) * 0.10;
        } else if (taxable <= 18000000) {
            tax = 5000000 * 0.05 + 5000000 * 0.10 + (taxable - 10000000) * 0.15;
        } else if (taxable <= 32000000) {
            tax = 5000000 * 0.05 + 5000000 * 0.10 + 8000000 * 0.15 + (taxable - 18000000) * 0.20;
        } else {
            tax = 5000000 * 0.05 + 5000000 * 0.10 + 8000000 * 0.15 + 14000000 * 0.20 + (taxable - 32000000) * 0.25;
        }

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
        if ($('sideStep3Salary')) $('sideStep3Salary').textContent = formatVnd(base);
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
        const id = 'customAllowance_' + Date.now();
        const row = document.createElement('div');
        row.className = 'allowance-box-item active';
        row.innerHTML = `
            <div class="allowance-left">
                <input type="checkbox" class="form-check-input mt-0" id="${id}" checked>
                <div>
                    <div class="allowance-name">Phụ cấp bổ sung</div>
                    <div class="allowance-sub">Khoản phụ cấp do HR/Quản lý phê duyệt</div>
                </div>
            </div>
            <div class="d-flex align-items-center gap-2">
                <input type="number" min="0" step="50000" class="form-control form-control-sm" style="width:140px" value="500000" aria-label="Số tiền phụ cấp">
                <span class="text-muted small">đ/tháng</span>
            </div>`;
        container.appendChild(row);
        row.querySelector('input[type="checkbox"]').addEventListener('change', recalcCompensation);
        row.querySelector('input[type="number"]').addEventListener('input', recalcCompensation);
        recalcCompensation();
    };

    // =========================================================================
    // 7. PERSONAL DETAILS & VALIDATION
    // =========================================================================
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
        updateGenderDisplay();
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
        const dob = $('dateOfBirth')?.value;
        let ageText = '';
        if (dob) {
            const birth = new Date(dob + 'T00:00:00');
            const now = new Date();
            let age = now.getFullYear() - birth.getFullYear();
            const m = now.getMonth() - birth.getMonth();
            if (m < 0 || (m === 0 && now.getDate() < birth.getDate())) age--;
            if (age >= 0) ageText = age + ' tuổi';
        }
        const gText = checked ? (checked.value === 'MALE' ? 'Nam' : checked.value === 'FEMALE' ? 'Nữ' : 'Khác') : 'Nam';
        if (text) {
            text.textContent = (ageText ? ageText + ' • ' : '') + gText;
        }
    };

    window.handleFullNameChange = function (value) {
        const name = value.trim() || 'Chưa nhập họ tên';
        if ($('sideProfileName')) $('sideProfileName').textContent = name;
        if ($('sideStep3Name')) $('sideStep3Name').textContent = name;
        if ($('finalFullName')) $('finalFullName').textContent = name;
        updateAvatarFallback();
        saveDraftDebounced();
    };

    function updateAvatarFallback() {
        const img = $('avatarPreviewImg');
        if (!img || $('avatarFileInput')?.files?.length) return;
        const initials = (($('fullName')?.value || 'NV').trim().split(/\s+/).slice(-2).map(x => x[0]).join('') || 'NV').toUpperCase();
        img.alt = initials;
    }

    window.toggleSameAddress = function (checkbox) {
        const temp = $('tempAddress');
        const perm = $('address');
        if (checkbox && checkbox.checked && temp && perm) {
            temp.value = perm.value;
            temp.readOnly = true;
        } else if (temp) {
            temp.readOnly = false;
        }
        saveDraftDebounced();
    };

    // =========================================================================
    // 8. CODE GENERATORS (EMPLOYEE, CONTRACT, BHXH, TAX)
    // =========================================================================
    window.toggleEditEmpCode = function () {
        const input = $('employeeCode');
        if (!input) return;
        input.readOnly = !input.readOnly;
        if (!input.readOnly) input.focus();
    };

    window.regenerateEmployeeCode = function () {
        const input = $('employeeCode');
        if (!input) return;
        const rand = Math.floor(100 + Math.random() * 900);
        input.value = 'NV' + rand;
        input.readOnly = true;
        if ($('sideProfileCode')) $('sideProfileCode').textContent = input.value;
        saveDraftDebounced();
    };

    window.toggleEditContractCode = function () {
        const input = $('contractCode');
        if (!input) return;
        input.readOnly = !input.readOnly;
        if (!input.readOnly) input.focus();
    };

    window.regenerateContractCode = function () {
        const input = $('contractCode');
        if (!input) return;
        const rand = Math.floor(100 + Math.random() * 900);
        input.value = 'HD' + rand;
        input.readOnly = true;
        saveDraftDebounced();
    };

    window.autoGenBhxh = function () {
        const input = $('bhxhCode');
        if (!input) return;
        input.value = '01' + String(Math.floor(10000000 + Math.random() * 90000000));
        saveDraftDebounced();
    };

    window.autoGenTaxCode = function () {
        const input = $('taxCode');
        if (!input) return;
        input.value = '84' + String(Math.floor(10000000 + Math.random() * 90000000));
        saveDraftDebounced();
    };

    // =========================================================================
    // 9. DEPARTMENT & POSITION MANAGEMENT
    // =========================================================================
    window.handleDepartmentChange = function (departmentId) {
        const select = $('positionId');
        if (select) {
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
        }

        updateDepartmentQuota(departmentId);
        saveDraftDebounced();
    };

    window.handlePositionChange = function (positionId) {
        const pos = $('positionId')?.selectedOptions[0];
        const dept = $('departmentId')?.selectedOptions[0];
        const posName = pos && pos.value ? pos.textContent.trim() : 'Chưa chọn';
        const deptName = dept && dept.value ? dept.textContent.trim() : 'Phòng ban';

        if ($('finalPosition')) $('finalPosition').textContent = posName;
        if ($('sideStep3Pos')) $('sideStep3Pos').textContent = posName + ' • ' + deptName;

        // Auto-fill salary if currently blank
        const deptId = $('departmentId')?.value;
        if (deptId && DEPARTMENT_DATA[deptId]) {
            const posData = DEPARTMENT_DATA[deptId].positions.find(p => String(p.id) === String(positionId));
            if (posData && (!($('baseSalary')?.value) || $('baseSalary')?.value === '0')) {
                if ($('baseSalary')) $('baseSalary').value = posData.defaultSalary;
                recalcCompensation();
            }
        }

        saveDraftDebounced();
    };

    function updateDepartmentQuota(deptId) {
        deptId = deptId || $('departmentId')?.value;
        const banner = $('deptQuotaBanner');
        const deptData = DEPARTMENT_DATA[deptId];
        const deptOpt = $('departmentId')?.selectedOptions[0];

        if (!deptId || !deptData) {
            if ($('quotaDeptName')) $('quotaDeptName').textContent = deptOpt ? ('🏢 ' + deptOpt.textContent.trim()) : '🏢 Định biên phòng ban';
            if ($('quotaDeptDesc')) $('quotaDeptDesc').textContent = 'Quy chuẩn định biên nhân sự tập đoàn MIXIMOI';
            return;
        }

        const vacantCount = Math.max(0, deptData.targetCount - deptData.currentCount);
        const pct = Math.min(100, Math.round((deptData.currentCount / deptData.targetCount) * 100));

        if ($('quotaDeptName')) $('quotaDeptName').textContent = '🏢 ' + deptData.name;
        if ($('quotaDeptDesc')) $('quotaDeptDesc').textContent = 'Nghiệp vụ: ' + deptData.desc;
        if ($('quotaVacantBadge')) {
            $('quotaVacantBadge').innerHTML = vacantCount > 0
                ? `<i class="bi bi-person-plus-fill"></i> Còn thiếu ${vacantCount} chỉ tiêu`
                : `<i class="bi bi-check-circle-fill"></i> Đã đủ định biên (${deptData.currentCount}/${deptData.targetCount})`;
        }
        if ($('quotaRatioText')) $('quotaRatioText').textContent = `Hiện có ${deptData.currentCount} / ${deptData.targetCount} nhân sự`;
        if ($('quotaPctText')) $('quotaPctText').textContent = `${pct}% định biên`;
        if ($('quotaProgressBar')) $('quotaProgressBar').style.width = pct + '%';
        if ($('quotaRecruitHint')) {
            $('quotaRecruitHint').innerHTML = `<i class="bi bi-shield-check me-1 text-primary"></i> Quản lý phụ trách: <strong>${deptData.manager}</strong>`;
        }
    }

    window.handleStatusChange = function (status) {
        const fields = $('terminationFields');
        if (!fields) return;
        fields.classList.toggle('d-none', status !== 'INACTIVE');
    };

    function updateStep1Progress() {
        const root = panel(1);
        if (!root) return;
        const textControls = qsa('[required]:not([type="radio"])', root).filter(el => !el.disabled && el.type !== 'hidden');
        const radioNames = Array.from(new Set(qsa('input[type="radio"][required]', root).map(r => r.name)));

        let total = textControls.length + radioNames.length;
        let filled = 0;

        textControls.forEach(el => {
            if (el.value && el.value.trim().length > 0) filled++;
        });

        radioNames.forEach(name => {
            const group = qsa(`input[type="radio"][name="${CSS.escape(name)}"]`, root);
            if (group.some(r => r.checked)) filled++;
        });

        const pct = total > 0 ? Math.round((filled / total) * 100) : 0;
        const bar = $('step1ProgressBar');
        if (bar) bar.style.width = pct + '%';
        const label = $('step1Pct') || $('step1ProgressText');
        if (label) label.textContent = `${pct}%`;
    }

    function updateSummary() {
        const fullName = $('fullName')?.value || '—';
        const code = $('employeeCode')?.value || '—';
        const dept = $('departmentId')?.selectedOptions[0]?.textContent.trim() || '—';
        const pos = $('positionId')?.selectedOptions[0]?.textContent.trim() || '—';

        if ($('sideProfileName')) $('sideProfileName').textContent = fullName;
        if ($('sideProfileCode')) $('sideProfileCode').textContent = code;
        if ($('sideProfileDept')) $('sideProfileDept').textContent = dept;
        if ($('sideProfilePos')) $('sideProfilePos').textContent = pos;
    }

    // =========================================================================
    // 10. FILE UPLOADS, PREVIEW & DRAG-DROP
    // =========================================================================
    window.triggerAvatarUpload = function (event) {
        if (event && event.target && event.target.tagName === 'INPUT') return;
        const input = $('avatarFileInput');
        if (!input) return showMessage('Không tìm thấy ô tải ảnh chân dung.');
        input.click();
    };

    window.previewAvatar = function (input) {
        const file = input?.files?.[0];
        if (!file) return;
        const result = validateFile(file, ['.jpg', '.jpeg', '.png', '.webp'], AVATAR_MAX_SIZE);
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
    window.handleAvatarSelected = function (e) {
        window.previewAvatar(e?.target || e);
    };

    window.triggerDocUpload = function (id, event) {
        if (event && event.target && event.target.tagName === 'INPUT') return;
        const input = $(id);
        if (!input) return showMessage('Không tìm thấy ô tải tệp: ' + id);
        input.click();
    };

    function validateFile(file, allowed, maxSize) {
        if (!file) return true;
        if (file.size > maxSize) return `Tệp "${file.name}" vượt quá dung lượng tối đa ${Math.round(maxSize / 1024 / 1024)}MB.`;
        const lower = file.name.toLowerCase();
        const ok = allowed.some(ext => lower.endsWith(ext));
        return ok ? true : `Định dạng tệp "${file.name}" không được hỗ trợ (${allowed.join(', ')}).`;
    }

    window.handleDocFile = function (input, previewId, nameId) {
        const file = input?.files?.[0];
        if (!file) return;
        const result = validateFile(file, ['.jpg', '.jpeg', '.png', '.webp', '.pdf'], MAX_FILE_SIZE);
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
        const result = validateFile(file, ['.pdf', '.doc', '.docx'], MAX_FILE_SIZE);
        if (result !== true) {
            showMessage(result);
            input.value = '';
            return;
        }
        if ($('resumeTitle')) $('resumeTitle').textContent = file.name;
        if ($('resumeSub')) $('resumeSub').textContent = 'Tệp đã chọn • sẵn sàng tải lên hệ thống';
        if ($('resumeBadge')) $('resumeBadge').textContent = 'Đã chọn • ' + Math.ceil(file.size / 1024) + ' KB';
        const del = $('resumeFileDel');
        if (del) del.classList.remove('d-none');
        updateUploadedDocCount();
        saveDraftDebounced();
    };

    window.clearDocUpload = function (previewId, nameId) {
        const preview = $(previewId);
        const icon = $(previewId.replace('Preview', 'Icon'));
        const name = $(nameId);
        const inputId = previewId.includes('Front') ? 'cccdFrontInput' : 'cccdBackInput';
        const hiddenId = previewId.includes('Front') ? 'idCardFrontUrl' : 'idCardBackUrl';
        const input = $(inputId);
        const hidden = $(hiddenId) || $(hiddenId + 'Hidden');
        if (input) input.value = '';
        if (hidden) hidden.value = '';
        if (preview) {
            preview.src = '';
            preview.classList.add('d-none');
        }
        if (icon) icon.classList.remove('d-none');
        if (name) name.textContent = 'Bấm để tải tệp';
        const del = $(nameId.replace('Name', 'Del'));
        if (del) del.classList.add('d-none');
        updateUploadedDocCount();
        saveDraftDebounced();
    };

    window.clearResumeUpload = function () {
        const input = $('resumeInput');
        const hidden = $('resumeUrlHidden') || $('resumeUrl');
        if (input) input.value = '';
        if (hidden) hidden.value = '';
        if ($('resumeTitle')) $('resumeTitle').textContent = 'Sơ yếu lí lịch / Khám SK';
        if ($('resumeSub')) $('resumeSub').textContent = 'Kéo thả tệp hoặc bấm để chọn';
        if ($('resumeBadge')) $('resumeBadge').textContent = 'PDF, DOCX <= 10MB';
        const del = $('resumeFileDel');
        if (del) del.classList.add('d-none');
        updateUploadedDocCount();
        saveDraftDebounced();
    };

    function updateUploadedDocCount() {
        const ids = ['avatarFileInput', 'cccdFrontInput', 'cccdBackInput', 'resumeInput', 'contractFile'];
        let count = 0;
        ids.forEach(id => {
            const input = $(id);
            if (input?.files?.length) count++;
        });
        const badge = $('sideProfileDocCount');
        if (badge) badge.textContent = `${count} tệp đính kèm`;
    }

    function bindFileInteractions() {
        qsa('[data-upload-input]').forEach(zone => {
            ['dragenter', 'dragover'].forEach(name => {
                zone.addEventListener(name, e => {
                    e.preventDefault();
                    zone.classList.add('drag-active');
                });
            });
            ['dragleave', 'drop'].forEach(name => {
                zone.addEventListener(name, e => {
                    e.preventDefault();
                    zone.classList.remove('drag-active');
                });
            });
            zone.addEventListener('drop', e => {
                const inputId = zone.getAttribute('data-upload-input');
                const input = $(inputId);
                if (!input || !e.dataTransfer?.files?.length) return;
                input.files = e.dataTransfer.files;
                if (inputId === 'avatarFileInput') window.previewAvatar(input);
                else if (inputId === 'resumeInput') window.handleResumeFile(input);
                else if (inputId === 'cccdFrontInput') window.handleDocFile(input, 'cccdFrontPreview', 'cccdFrontName');
                else if (inputId === 'cccdBackInput') window.handleDocFile(input, 'cccdBackPreview', 'cccdBackName');
            });
        });
    }

    // =========================================================================
    // 11. LOCAL DRAFT AUTOSAVE & RECOVERY
    // =========================================================================
    function draftKey() {
        const id = qs('input[name="id"]')?.value || 'new';
        return DRAFT_PREFIX + (window.IS_EDIT_MODE ? 'edit-' + id : 'new');
    }

    function saveDraft() {
        const f = form();
        if (!f || isSubmitting) return;
        const data = {};
        qsa('input:not([type="file"]):not([type="password"]), select, textarea', f).forEach(el => {
            if (!el.name) return;
            if (el.type === 'checkbox') data[el.name] = el.checked;
            else if (el.type === 'radio') {
                if (el.checked) data[el.name] = el.value;
            } else {
                data[el.name] = el.value;
            }
        });
        data._savedAt = new Date().toISOString();
        try {
            localStorage.setItem(draftKey(), JSON.stringify(data));
        } catch (_) {}
    }
    window.saveDraft = saveDraft;

    function saveDraftDebounced() {
        clearTimeout(saveTimeout);
        saveTimeout = setTimeout(saveDraft, 500);
    }

    window.restoreDraftData = function () {
        try {
            const raw = localStorage.getItem(draftKey());
            if (!raw) return;
            const data = JSON.parse(raw);
            const f = form();
            if (!f) return;
            Object.entries(data).forEach(([key, val]) => {
                if (key.startsWith('_')) return;
                const el = f.elements[key];
                if (!el) return;
                if (el.type === 'checkbox') el.checked = Boolean(val);
                else if (el instanceof RadioNodeList) el.value = val;
                else el.value = val;
            });
            updateAll();
            showToast('Đã khôi phục dữ liệu bản nháp thành công.', 'success');
            $('draftAlertBanner')?.classList.add('d-none');
        } catch (_) {
            showToast('Không thể khôi phục bản nháp.', 'danger');
        }
    };

    window.clearDraft = function () {
        try { localStorage.removeItem(draftKey()); } catch (_) {}
        $('draftAlertBanner')?.classList.add('d-none');
        showToast('Đã xóa bản nháp đã lưu.', 'warning');
    };

    window.dismissDraft = function () {
        $('draftAlertBanner')?.classList.add('d-none');
    };

    window.confirmDiscard = function () {
        return window.confirm('Bạn có chắc muốn rời khỏi trang? Mọi thay đổi chưa gửi sẽ được lưu tạm trong bản nháp.');
    };

    function maybeShowDraft() {
        if (window.IS_EDIT_MODE) return;
        try {
            const raw = localStorage.getItem(draftKey());
            if (!raw) return;
            const data = JSON.parse(raw);
            const savedAt = data._savedAt ? new Date(data._savedAt) : null;
            if (!savedAt || Date.now() - savedAt.getTime() > 24 * 60 * 60 * 1000) return;
            const text = $('draftAlertText');
            if (text) text.textContent = `Phát hiện bản nháp được lưu lúc ${savedAt.toLocaleTimeString('vi-VN')} ngày ${savedAt.toLocaleDateString('vi-VN')}.`;
            $('draftAlertBanner')?.classList.remove('d-none');
        } catch (_) {}
    }

    // =========================================================================
    // 12. INITIALIZATION & LIFECYCLE
    // =========================================================================
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
                btn.innerHTML = '<i class="bi bi-arrow-repeat me-1 spinner-border spinner-border-sm" role="status"></i> Đang lưu...';
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

        ['cccdFrontInput', 'cccdBackInput', 'resumeInput', 'avatarFileInput', 'contractFile'].forEach(id => {
            $(id)?.addEventListener('change', updateUploadedDocCount);
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        const f = form();
        if (!f) return;

        currentStep = 1;
        const isEditMode = !!$('employeeForm')?.querySelector('input[name="id"]') || $('employeeForm')?.querySelector('input[name="action"]')?.value === 'update';
        maxReachedStep = isEditMode ? 4 : 1;
        renderStep();
        updateStep1Progress();
        bindLiveEvents();
        bindFileInteractions();

        // Note: wizard nav buttons already use inline onclick="nextStep()" / onclick="prevStep()".
        // We bind via data-wizard-* only for buttons that do NOT have inline onclick.
        qsa('[data-wizard-next]').forEach(btn => {
            if (!btn.hasAttribute('onclick')) {
                btn.addEventListener('click', function (e) {
                    e.preventDefault();
                    window.nextStep();
                });
            }
        });
        qsa('[data-wizard-prev]').forEach(btn => {
            if (!btn.hasAttribute('onclick')) {
                btn.addEventListener('click', function (e) {
                    e.preventDefault();
                    window.prevStep();
                });
            }
        });

        submitGuard();
        updateAll();
        maybeShowDraft();

        if ($('departmentId')?.value) {
            handleDepartmentChange($('departmentId').value);
        }

        f.addEventListener('input', saveDraftDebounced);
        f.addEventListener('change', saveDraftDebounced);
    });

})();

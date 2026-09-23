/**
 * MIXIMOI HRM — EMPLOYEE ONBOARDING WIZARD SCRIPTS (employee-form.js)
 */
// =========================================================================
    // 1. DATA DICTIONARY: DEPARTMENT QUOTAS & SUITABLE POSITIONS
    // =========================================================================
    // Quota definition for each department and its matching professional positions
    const DEPARTMENT_DATA = {
        "1": { // Ban Giám đốc
            name: "Ban Giám đốc",
            desc: "Lãnh đạo và điều hành toàn diện chiến lược tập đoàn",
            targetCount: 4,
            currentCount: 3,
            manager: "Nguyễn Văn An (NV001) - Tổng Giám đốc",
            positions: [
                { id: 1, name: "Giám đốc", quota: 2, current: 1, vacant: 1, level: "L5", defaultSalary: "50.000.000", salaryRange: "45.000.000 – 70.000.000 VNĐ" },
                { id: 2, name: "Phó Giám đốc", quota: 2, current: 1, vacant: 1, level: "L5", defaultSalary: "40.000.000", salaryRange: "35.000.000 – 50.000.000 VNĐ" },
                { id: 3, name: "Trưởng phòng (Văn phòng HĐQT)", quota: 1, current: 0, vacant: 1, level: "L4", defaultSalary: "30.000.000", salaryRange: "25.000.000 – 35.000.000 VNĐ" }
            ]
        },
        "2": { // Phòng Nhân sự
            name: "Phòng Nhân sự (HR & Tuyển dụng)",
            desc: "Quản trị nguồn nhân lực, tuyển dụng, đào tạo & C&B",
            targetCount: 5,
            currentCount: 2,
            manager: "Trần Thị Bình (NV002) - Trưởng phòng Nhân sự",
            positions: [
                { id: 3, name: "Trưởng phòng Nhân sự", quota: 1, current: 1, vacant: 0, level: "L4", defaultSalary: "35.000.000", salaryRange: "30.000.000 – 40.000.000 VNĐ" },
                { id: 4, name: "Phó phòng Nhân sự", quota: 1, current: 0, vacant: 1, level: "L3", defaultSalary: "26.000.000", salaryRange: "22.000.000 – 30.000.000 VNĐ" },
                { id: 8, name: "Chuyên viên HR (C&B / Tuyển dụng)", quota: 3, current: 1, vacant: 2, level: "L2", defaultSalary: "18.000.000", salaryRange: "15.000.000 – 22.000.000 VNĐ" },
                { id: 5, name: "Nhân viên Nhân sự", quota: 2, current: 0, vacant: 2, level: "L1", defaultSalary: "12.000.000", salaryRange: "10.000.000 – 14.000.000 VNĐ" },
                { id: 6, name: "Thực tập sinh HR", quota: 2, current: 0, vacant: 2, level: "L1", defaultSalary: "6.000.000", salaryRange: "5.000.000 – 7.000.000 VNĐ" }
            ]
        },
        "3": { // Phòng Kế toán
            name: "Phòng Kế toán (Tài chính & Kế toán)",
            desc: "Quản trị dòng tiền, thuế, kế toán doanh nghiệp & báo cáo tài chính",
            targetCount: 6,
            currentCount: 3,
            manager: "Lê Văn Cường (NV003) - Kế toán trưởng",
            positions: [
                { id: 3, name: "Trưởng phòng Kế toán (Kế toán trưởng)", quota: 1, current: 1, vacant: 0, level: "L4", defaultSalary: "35.000.000", salaryRange: "30.000.000 – 45.000.000 VNĐ" },
                { id: 4, name: "Phó phòng Kế toán", quota: 1, current: 1, vacant: 0, level: "L3", defaultSalary: "25.000.000", salaryRange: "20.000.000 – 28.000.000 VNĐ" },
                { id: 9, name: "Kế toán viên (Tổng hợp / Thuế / Công nợ)", quota: 4, current: 1, vacant: 3, level: "L2", defaultSalary: "18.000.000", salaryRange: "14.000.000 – 22.000.000 VNĐ" },
                { id: 5, name: "Nhân viên Kế toán kho", quota: 2, current: 0, vacant: 2, level: "L1", defaultSalary: "12.000.000", salaryRange: "10.000.000 – 14.000.000 VNĐ" },
                { id: 6, name: "Thực tập sinh Kế toán", quota: 2, current: 0, vacant: 2, level: "L1", defaultSalary: "6.000.000", salaryRange: "5.000.000 – 7.000.000 VNĐ" }
            ]
        },
        "4": { // Phòng Kinh doanh
            name: "Phòng Kinh doanh (Sales & Khách hàng)",
            desc: "Phát triển thị trường, bán hàng B2B/B2C và chăm sóc khách hàng",
            targetCount: 10,
            currentCount: 2,
            manager: "Phạm Thị Dung (NV004) - Giám đốc Kinh doanh",
            positions: [
                { id: 3, name: "Trưởng phòng Kinh doanh", quota: 1, current: 0, vacant: 1, level: "L4", defaultSalary: "32.000.000", salaryRange: "28.000.000 – 40.000.000 VNĐ" },
                { id: 4, name: "Phó phòng Kinh doanh", quota: 1, current: 0, vacant: 1, level: "L3", defaultSalary: "24.000.000", salaryRange: "20.000.000 – 28.000.000 VNĐ" },
                { id: 10, name: "Chuyên viên kinh doanh (Senior Sales)", quota: 8, current: 1, vacant: 7, level: "L2", defaultSalary: "18.000.000", salaryRange: "15.000.000 – 25.000.000 VNĐ" },
                { id: 5, name: "Nhân viên Telesales / CSKH", quota: 4, current: 0, vacant: 4, level: "L1", defaultSalary: "12.000.000", salaryRange: "10.000.000 – 15.000.000 VNĐ" },
                { id: 6, name: "Thực tập sinh Kinh doanh", quota: 3, current: 0, vacant: 3, level: "L1", defaultSalary: "6.000.000", salaryRange: "5.000.000 – 8.000.000 VNĐ" }
            ]
        },
        "5": { // Phòng Marketing
            name: "Phòng Marketing (Truyền thông & Thương hiệu)",
            desc: "Quảng bá thương hiệu, tiếp thị số, tổ chức sự kiện & Media",
            targetCount: 6,
            currentCount: 1,
            manager: "Hoàng Văn Em (NV005) - Trưởng phòng Marketing",
            positions: [
                { id: 3, name: "Trưởng phòng Marketing (CMO)", quota: 1, current: 0, vacant: 1, level: "L4", defaultSalary: "35.000.000", salaryRange: "30.000.000 – 45.000.000 VNĐ" },
                { id: 4, name: "Phó phòng Marketing", quota: 1, current: 0, vacant: 1, level: "L3", defaultSalary: "25.000.000", salaryRange: "20.000.000 – 30.000.000 VNĐ" },
                { id: 5, name: "Chuyên viên Digital Marketing / Content", quota: 4, current: 1, vacant: 3, level: "L2", defaultSalary: "18.000.000", salaryRange: "15.000.000 – 22.000.000 VNĐ" },
                { id: 6, name: "Thực tập sinh Marketing / Design", quota: 2, current: 0, vacant: 2, level: "L1", defaultSalary: "6.000.000", salaryRange: "5.000.000 – 8.000.000 VNĐ" }
            ]
        },
        "6": { // Phòng Kỹ thuật
            name: "Phòng Kỹ thuật (Công nghệ thông tin & R&D)",
            desc: "Phát triển và duy trì hệ sinh thái sản phẩm công nghệ MIXIMOI",
            targetCount: 15,
            currentCount: 4,
            manager: "Lê Hoàng Nam (NV002) - Giám đốc Công nghệ (CTO)",
            positions: [
                { id: 3, name: "Trưởng phòng Kỹ thuật (Technical Lead)", quota: 1, current: 0, vacant: 1, level: "L4", defaultSalary: "40.000.000", salaryRange: "35.000.000 – 50.000.000 VNĐ" },
                { id: 4, name: "Phó phòng Kỹ thuật", quota: 1, current: 0, vacant: 1, level: "L3", defaultSalary: "32.000.000", salaryRange: "28.000.000 – 38.000.000 VNĐ" },
                { id: 7, name: "Kỹ sư phần mềm (Backend/Frontend/Fullstack)", quota: 10, current: 3, vacant: 7, level: "L3", defaultSalary: "28.500.000", salaryRange: "22.000.000 – 35.000.000 VNĐ" },
                { id: 5, name: "Kỹ sư QA / QC Tester", quota: 3, current: 0, vacant: 3, level: "L2", defaultSalary: "18.000.000", salaryRange: "15.000.000 – 22.000.000 VNĐ" },
                { id: 6, name: "Thực tập sinh Lập trình viên (Fresher/Intern)", quota: 3, current: 1, vacant: 2, level: "L1", defaultSalary: "8.000.000", salaryRange: "6.000.000 – 10.000.000 VNĐ" }
            ]
        }
    };

    // =========================================================================
    // 2. WIZARD ENGINE & STATE
    // =========================================================================
    let currentStep = 1;
    const TOTAL_STEPS = 4;

    const stepHeaders = [
        "",
        "Thêm nhân viên mới",
        "Thêm nhân viên - Bước 2: Công việc & Định biên",
        "Thêm nhân viên - Bước 3: Thiết lập Lương & Phúc lợi",
        "Thêm nhân viên - Bước 4: Hợp đồng & Bảo hiểm"
    ];

    const stepButtons = [
        "",
        "Tiếp tục: Bước 2 (Công việc & Vị trí)",
        "Tiếp tục: Bước 3 (Lương & Phúc lợi)",
        "Tiếp tục: Bước 4 (Hợp đồng & Bảo hiểm)",
        "Hoàn tất & Lưu hồ sơ"
    ];

    // Initialize on Load
    document.addEventListener("DOMContentLoaded", function() {
        const today = new Date();
        const formattedDate = String(today.getDate()).padStart(2, '0') + '/' +
                              String(today.getMonth() + 1).padStart(2, '0') + '/' +
                              today.getFullYear();
        const dateEl = document.getElementById("sideCreatedDate");
        if (dateEl) dateEl.innerText = formattedDate;

        // Check for saved local draft (only for new employee onboarding)
        if (!window.IS_EDIT_MODE) {
            checkSavedDraft();
        }

        // Department initialization
        const deptSelect = document.getElementById("departmentId");
        if (deptSelect && !deptSelect.value && !window.IS_EDIT_MODE) {
            deptSelect.value = "6";
        }
        if (!window.IS_EDIT_MODE) {
            handleDepartmentChange(deptSelect ? deptSelect.value : "6");
        } else {
            if (deptSelect && deptSelect.value) {
                updateDeptQuotaBannerOnly(deptSelect.value);
            }
        }

        // Calculations
        recalcCompensation();
        calculateAge();

        // Start auto-save timer
        startAutoSaveInterval();
    });

    // Toast Notification helper
    function showToast(message, type = "success") {
        const container = document.getElementById("toastContainer");
        const toast = document.createElement("div");
        toast.className = `toast-custom ${type}`;
        let icon = "bi-check-circle-fill text-success";
        if (type === "warning") icon = "bi-exclamation-triangle-fill text-warning";
        if (type === "danger") icon = "bi-x-circle-fill text-danger";

        toast.innerHTML = `<i class="bi ${icon} fs-5"></i><div>${message}</div>`;
        container.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = "0";
            toast.style.transform = "translateX(50px)";
            toast.style.transition = "all 0.3s ease";
            setTimeout(() => toast.remove(), 300);
        }, 3500);
    }

    // =========================================================================
    // 3. DEPARTMENT & POSITION FILTERING WITH HEADCOUNT LIMITS
    // =========================================================================
    function handleDepartmentChange(deptId) {
        const data = DEPARTMENT_DATA[deptId];
        const banner = document.getElementById("deptQuotaBanner");
        const posSelect = document.getElementById("positionId");

        if (!data) {
            banner.classList.remove("has-dept");
            banner.innerHTML = `<div class="text-muted" style="font-size:0.8rem;">Vui lòng chọn một phòng ban để xem chỉ tiêu định biên và các vị trí phù hợp.</div>`;
            posSelect.innerHTML = `<option value="">— Chọn chức vụ —</option>`;
            return;
        }

        banner.classList.add("has-dept");
        const vacantCount = Math.max(0, data.targetCount - data.currentCount);
        const pct = Math.min(100, Math.round((data.currentCount / data.targetCount) * 100));

        let badgeHtml = "";
        let barColor = "linear-gradient(90deg, #2563eb, #38bdf8)";
        if (vacantCount > 0) {
            badgeHtml = `<span class="quota-badge-vacant"><i class="bi bi-person-plus-fill"></i> Còn thiếu ${vacantCount} chỉ tiêu</span>`;
            barColor = "linear-gradient(90deg, #059669, #34d399)";
        } else {
            badgeHtml = `<span class="quota-badge-full"><i class="bi bi-exclamation-circle-fill"></i> Đã đủ định biên (${data.currentCount}/${data.targetCount})</span>`;
            barColor = "linear-gradient(90deg, #dc2626, #f87171)";
        }

        banner.innerHTML = `
            <div class="quota-header">
                <div>
                    <div style="font-weight:800; font-size:0.9rem; color:#0f172a;">
                        🏢 ${data.name}
                    </div>
                    <div style="font-size:0.75rem; color:#64748b;">
                        Nghiệp vụ: ${data.desc}
                    </div>
                </div>
                ${badgeHtml}
            </div>
            <div class="d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
                <span style="font-weight:700; color:#1e293b;">Hiện có ${data.currentCount} / ${data.targetCount} nhân sự</span>
                <span style="font-weight:800; color:#2563eb;">${pct}% định biên</span>
            </div>
            <div class="quota-progress">
                <div class="quota-progress-bar" style="width:${pct}%; background:${barColor};"></div>
            </div>
            <div style="font-size:0.72rem; color:#64748b; margin-top:4px;">
                <i class="bi bi-shield-check me-1 text-primary"></i> Quản lý trực tiếp phụ trách: <strong>${data.manager}</strong>
            </div>
        `;

        // Update default line manager
        const managerInput = document.getElementById("lineManager");
        if (managerInput && data.manager) {
            managerInput.value = data.manager;
        }

        // Populate positions matching this department
        posSelect.innerHTML = `<option value="">— Chọn chức vụ phù hợp (${data.positions.length} vị trí) —</option>`;
        data.positions.forEach(p => {
            const vacantNote = p.vacant > 0 ? `(Đang thiếu ${p.vacant} vị trí)` : `(Đã đủ định biên ${p.current}/${p.quota})`;
            const opt = document.createElement("option");
            opt.value = p.id;
            opt.innerText = `${p.name} ${vacantNote}`;
            opt.dataset.level = p.level;
            opt.dataset.salary = p.defaultSalary;
            opt.dataset.salaryRange = p.salaryRange;
            opt.dataset.vacant = p.vacant;
            posSelect.appendChild(opt);
        });

        // Select appropriate position
        if (window.IS_EDIT_MODE && window.CURRENT_EMP_POS_ID) {
            posSelect.value = window.CURRENT_EMP_POS_ID;
            handlePositionChange(window.CURRENT_EMP_POS_ID);
        } else if (data.positions.length > 0) {
            posSelect.selectedIndex = 1;
            handlePositionChange(data.positions[0].id);
        }

        updateStep2Summary();
    }

    function handlePositionChange(posId) {
        const posSelect = document.getElementById("positionId");
        const selectedOpt = posSelect.options[posSelect.selectedIndex];
        if (!selectedOpt || !selectedOpt.value) return;

        const level = selectedOpt.dataset.level || "L3";
        const defSalary = selectedOpt.dataset.salary || "28.500.000";
        const salaryRange = selectedOpt.dataset.salaryRange || "25.000.000 – 35.000.000 VNĐ";
        const vacant = parseInt(selectedOpt.dataset.vacant || "1");

        // Update Level dropdown
        const levelSelect = document.getElementById("employeeLevel");
        if (levelSelect) levelSelect.value = level;

        // Update Position vacant alert
        const alertBox = document.getElementById("positionVacantAlert");
        const msgSpan = document.getElementById("positionVacantMsg");
        if (alertBox && msgSpan) {
            alertBox.classList.remove("d-none");
            if (vacant > 0) {
                alertBox.className = "position-vacant-info";
                msgSpan.innerHTML = `Vị trí <strong>${selectedOpt.text.split('(')[0].trim()}</strong> đang thiếu <strong>${vacant} nhân sự</strong> so với kế hoạch định biên.`;
            } else {
                alertBox.className = "position-vacant-info bg-warning-subtle text-warning border-warning";
                msgSpan.innerHTML = `Vị trí <strong>${selectedOpt.text.split('(')[0].trim()}</strong> đã đạt đủ chỉ tiêu định biên. Vui lòng cân nhắc khi tuyển thêm.`;
            }
        }

        // Suggest salary in Step 3
        const salaryInput = document.getElementById("baseSalary");
        if (salaryInput && (!window.IS_EDIT_MODE || !salaryInput.value || salaryInput.value === '0')) {
            salaryInput.value = defSalary;
            recalcCompensation();
        }
        const salaryHint = document.getElementById("salaryRangeHint");
        if (salaryHint) {
            salaryHint.innerText = "Khung dải lương vị trí: " + salaryRange;
        }

        updateStep2Summary();
    }

    // =========================================================================
    // 4. STEPPER NAVIGATION & VALIDATION
    // =========================================================================
    function jumpToStep(target) {
        if (target === currentStep) return;
        if (!window.IS_EDIT_MODE && target > currentStep && !validateCurrentStep()) return;
        goToStep(target);
    }

    function nextStep() {
        if (!window.IS_EDIT_MODE && !validateCurrentStep()) return;
        if (currentStep < TOTAL_STEPS) {
            goToStep(currentStep + 1);
        }
    }

    function prevStep() {
        if (currentStep > 1) {
            goToStep(currentStep - 1);
        }
    }

    window.jumpToStep = jumpToStep;
    window.nextStep = nextStep;
    window.prevStep = prevStep;

    function goToStep(step) {
        currentStep = step;

        // Update header & title
        if (window.IS_EDIT_MODE) {
            const titleName = window.CURRENT_EMP_NAME || (document.getElementById("fullName") ? document.getElementById("fullName").value : "");
            const titleCode = window.CURRENT_EMP_CODE || (document.getElementById("employeeCode") ? document.getElementById("employeeCode").value : "");
            document.getElementById("pageHeaderTitle").innerText = "Chỉnh sửa: " + titleName + (titleCode ? " (" + titleCode + ")" : "") + " — Bước " + step + "/4";
        } else {
            document.getElementById("pageHeaderTitle").innerText = stepHeaders[step];
        }
        document.getElementById("badgeProgressText").innerText = "Tiến trình hồ sơ: " + (step * 25) + "% Hoàn thành";

        // Show right panel
        for (let i = 1; i <= TOTAL_STEPS; i++) {
            const panel = document.getElementById("panelStep" + i);
            if (panel) {
                if (i === step) panel.classList.add("active");
                else panel.classList.remove("active");
            }
        }

        // Show left panel
        for (let i = 1; i <= TOTAL_STEPS; i++) {
            const sidePanel = document.getElementById("sidePanelStep" + i);
            if (sidePanel) {
                sidePanel.style.display = (i === step) ? "block" : "none";
            }
        }

        // Update Steppers
        for (let i = 1; i <= TOTAL_STEPS; i++) {
            const tab = document.getElementById("stepperTab" + i);
            const badge = document.getElementById("stepperBadge" + i);
            const num = document.getElementById("stepperNum" + i);

            tab.className = "stepper-tab";
            if (i < step) {
                tab.classList.add("done");
                badge.innerText = "BƯỚC " + i + " • HOÀN TẤT";
                num.innerHTML = '<i class="bi bi-check-lg"></i>';
            } else if (i === step) {
                tab.classList.add("active");
                badge.innerText = "BƯỚC " + i + " • ĐANG THỰC HIỆN";
                num.innerText = "0" + i;
            } else {
                tab.classList.add("pending");
                badge.innerText = "BƯỚC " + i;
                num.innerText = "0" + i;
            }
        }

        // Update Buttons
        const btnPrev = document.getElementById("btnPrev");
        const btnNext = document.getElementById("btnNext");
        const btnSubmit = document.getElementById("btnSubmit");
        const btnNextText = document.getElementById("btnNextText");

        btnPrev.disabled = (step === 1);

        if (step === TOTAL_STEPS) {
            btnNext.style.display = "none";
            btnSubmit.style.display = "inline-flex";
            updateFinalSummary();
        } else {
            btnNext.style.display = "inline-flex";
            btnSubmit.style.display = "none";
            btnNextText.innerText = stepButtons[step];
        }

        // Smooth scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // Step Validation
    function validateCurrentStep() {
        const currentPanel = document.getElementById("panelStep" + currentStep);
        if (!currentPanel) return true;

        const inputs = currentPanel.querySelectorAll("input[required], select[required]");
        let valid = true;

        inputs.forEach(input => {
            if (!input.value || !input.value.trim()) {
                input.classList.add("is-invalid");
                valid = false;
            } else {
                input.classList.remove("is-invalid");
            }
        });

        if (!valid) {
            showToast("Vui lòng điền đầy đủ các thông tin bắt buộc (*) trước khi tiếp tục.", "warning");
        }
        return valid;
    }

    // =========================================================================
    // 5. AUTO GENERATION LOGIC (MÃ NV, MÃ HĐ, EMAIL, MST, BHXH)
    // =========================================================================
    function removeVietnameseTones(str) {
        str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
        str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
        str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
        str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
        str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
        str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
        str = str.replace(/đ/g, "d");
        str = str.replace(/À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ/g, "A");
        str = str.replace(/È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ/g, "E");
        str = str.replace(/Ì|Í|Ị|Ỉ|Ĩ/g, "I");
        str = str.replace(/Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ/g, "O");
        str = str.replace(/Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ/g, "U");
        str = str.replace(/Ỳ|Ý|Ỵ|Ỷ|Ỹ/g, "Y");
        str = str.replace(/Đ/g, "D");
        return str;
    }

    function handleFullNameChange(name) {
        if (!name) return;

        // Update profile summaries
        const pName = document.getElementById("sideProfileName");
        const s3Name = document.getElementById("sideStep3Name");
        if (pName) pName.innerText = name;
        if (s3Name) s3Name.innerText = name;

        // Auto-generate company email prefix: "Nguyễn Văn An" -> "an.nv"
        const clean = removeVietnameseTones(name.trim().toLowerCase());
        const parts = clean.split(/\s+/).filter(Boolean);
        if (parts.length > 0) {
            let prefix = "";
            if (parts.length === 1) {
                prefix = parts[0];
            } else {
                const firstName = parts[parts.length - 1];
                let initials = "";
                for (let i = 0; i < parts.length - 1; i++) {
                    initials += parts[i][0];
                }
                prefix = firstName + "." + initials;
            }

            const prefixInput = document.getElementById("companyEmailPrefix");
            if (prefixInput) prefixInput.value = prefix;

            const step2Email = document.getElementById("step2CompanyEmail");
            if (step2Email) step2Email.value = prefix + "@miximoi.vn";
        }
    }

    function regenerateEmployeeCode() {
        const input = document.getElementById("employeeCode");
        const current = input.value.trim();
        let nextNum = 15;
        if (current.startsWith("NV")) {
            const n = parseInt(current.substring(2));
            if (!isNaN(n)) nextNum = n + 1;
        }
        const newCode = "NV" + String(nextNum).padStart(3, '0');
        input.value = newCode;

        // Update badges
        const sideCode = document.getElementById("sideEmpCodeDisplay");
        if (sideCode) sideCode.innerText = newCode;
        const profileCode = document.getElementById("sideProfileCode");
        if (profileCode) profileCode.innerText = "MÃ NV: " + newCode;

        showToast(`Đã tự động sinh mã nhân viên mới: ${newCode}`, "success");
    }

    function toggleEditEmpCode() {
        const input = document.getElementById("employeeCode");
        if (input.hasAttribute("readonly")) {
            input.removeAttribute("readonly");
            input.focus();
            input.select();
            showToast("Đã mở khóa để nhập mã nhân viên tùy chỉnh.", "warning");
        } else {
            input.setAttribute("readonly", "true");
        }
    }

    function regenerateContractCode() {
        const input = document.getElementById("contractCode");
        const current = input.value.trim();
        let nextNum = 13;
        if (current.startsWith("HD")) {
            const n = parseInt(current.substring(2));
            if (!isNaN(n)) nextNum = n + 1;
        }
        const newCode = "HD" + String(nextNum).padStart(3, '0');
        input.value = newCode;
        showToast(`Đã sinh mã hợp đồng mới: ${newCode}`, "success");
    }

    function toggleEditContractCode() {
        const input = document.getElementById("contractCode");
        if (input.hasAttribute("readonly")) {
            input.removeAttribute("readonly");
            input.focus();
            input.select();
        } else {
            input.setAttribute("readonly", "true");
        }
    }

    function autoGenBhxh() {
        const randomDigits = Math.floor(1000000000 + Math.random() * 9000000000);
        const code = "0" + String(randomDigits).substring(1);
        document.getElementById("bhxhCode").value = code;
        showToast(`Đã gợi ý mã số BHXH: ${code}`, "success");
    }

    function autoGenTaxCode() {
        const randomDigits = Math.floor(1000000000 + Math.random() * 9000000000);
        const code = "8" + String(randomDigits).substring(1);
        document.getElementById("taxCode").value = code;
        showToast(`Đã gợi ý mã số thuế cá nhân: ${code}`, "success");
    }

    function validateCccd(input) {
        const icon = document.getElementById("cccdValidIcon");
        if (input.value.length >= 9 && input.value.length <= 12) {
            icon.style.display = "block";
        } else {
            icon.style.display = "none";
        }
    }

    function toggleSameAddress(checkbox) {
        const addr = document.getElementById("address").value;
        const tempInput = document.getElementById("tempAddress");
        if (checkbox.checked) {
            tempInput.value = addr;
            tempInput.setAttribute("readonly", "true");
            showToast("Đã đồng bộ địa chỉ thường trú sang tạm trú.", "success");
        } else {
            tempInput.removeAttribute("readonly");
        }
    }

    function calculateAge() {
        const dobVal = document.getElementById("dateOfBirth").value;
        if (!dobVal) return;
        const dob = new Date(dobVal);
        const diff = Date.now() - dob.getTime();
        const age = Math.abs(new Date(diff).getUTCFullYear() - 1970);
        const gender = document.querySelector('input[name="gender"]:checked')?.value === 'FEMALE' ? 'Nữ' : 'Nam';
        const display = document.getElementById("sideProfileAgeGender");
        if (display) display.innerText = gender + ", " + age + " tuổi";
    }

    function updateGenderDisplay() {
        calculateAge();
    }

    function updateStep2Summary() {
        const deptSelect = document.getElementById("departmentId");
        const posSelect = document.getElementById("positionId");
        const posName = posSelect.options[posSelect.selectedIndex]?.text.split('(')[0].trim() || "Kỹ sư phần mềm";
        const deptName = deptSelect.options[deptSelect.selectedIndex]?.text.trim() || "Phòng Kỹ thuật";

        const s3Pos = document.getElementById("sideStep3Pos");
        if (s3Pos) s3Pos.innerText = posName + " • " + deptName;

        const finalPos = document.getElementById("finalPosition");
        if (finalPos) finalPos.innerText = posName;
    }

    function updateFinalSummary() {
        document.getElementById("finalEmpCode").innerText = document.getElementById("employeeCode").value;
        document.getElementById("finalContractCode").innerText = document.getElementById("contractCode").value;
        const posSelect = document.getElementById("positionId");
        document.getElementById("finalPosition").innerText = posSelect.options[posSelect.selectedIndex]?.text.split('(')[0].trim() || "Kỹ sư phần mềm";
        document.getElementById("finalSalary").innerText = document.getElementById("baseSalary").value + " đ";
    }

    // =========================================================================
    // 6. PHOTO & DOCUMENT ATTACHMENTS
    // =========================================================================
    function triggerAvatarUpload() {
        document.getElementById("avatarFileInput").click();
    }

    function previewAvatar(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById("avatarPreviewImg").src = e.target.result;
                const summaries = document.querySelectorAll(".profile-summary-avatar");
                summaries.forEach(img => img.src = e.target.result);
                showToast("Đã tải ảnh chân dung xem trước thành công.", "success");
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    function triggerDocUpload(inputId) {
        document.getElementById(inputId).click();
    }

    function handleDocFile(input, imgId, nameId) {
        if (input.files && input.files[0]) {
            const file = input.files[0];
            document.getElementById(nameId).innerText = file.name;
            if (file.type.startsWith("image/")) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById(imgId).src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
            showToast(`Đã đính kèm tệp: ${file.name}`, "success");
            updateUploadedCount();
        }
    }

    function clearDocUpload(imgId, nameId) {
        document.getElementById(nameId).innerText = "Chưa có tệp";
        document.getElementById(imgId).src = "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=300&auto=format&fit=crop&q=80";
        showToast("Đã xóa tệp đính kèm.", "warning");
        updateUploadedCount();
    }

    function handleResumeFile(input) {
        if (input.files && input.files[0]) {
            const file = input.files[0];
            document.getElementById("resumeTitle").innerText = file.name;
            document.getElementById("resumeSub").innerText = (file.size / 1024 / 1024).toFixed(2) + " MB • Đã sẵn sàng";
            document.getElementById("resumeBadge").className = "badge bg-success-subtle text-success mt-2";
            document.getElementById("resumeBadge").innerText = "Tệp hợp lệ";
            showToast(`Đã tải lên hồ sơ: ${file.name}`, "success");
            updateUploadedCount();
        }
    }

    function updateUploadedCount() {
        let count = 0;
        if (document.getElementById("cccdFrontInput").files.length > 0) count++;
        if (document.getElementById("cccdBackInput").files.length > 0) count++;
        if (document.getElementById("resumeInput").files.length > 0) count++;
        document.getElementById("uploadedDocCountBadge").innerText = `Đã tải lên ${count}/3 tệp`;
    }

    // =========================================================================
    // 7. REAL-TIME SALARY & COMPENSATION CALCULATOR
    // =========================================================================
    function formatSalaryInput(input) {
        let val = input.value.replace(/\D/g, "");
        if (val) {
            input.value = Number(val).toLocaleString("vi-VN").replace(/,/g, ".");
        } else {
            input.value = "";
        }
        recalcCompensation();
    }

    function getNumericSalary() {
        const raw = document.getElementById("baseSalary").value.replace(/\./g, "").replace(/,/g, "").trim();
        return Number(raw) || 0;
    }

    let allowancesTotal = 2500000;

    function toggleAllowanceRow(checkbox, amount) {
        const parent = checkbox.closest(".allowance-box-item");
        if (checkbox.checked) {
            parent.classList.add("active");
            allowancesTotal += amount;
        } else {
            parent.classList.remove("active");
            allowancesTotal -= amount;
        }
        recalcCompensation();
    }

    function recalcCompensation() {
        const base = getNumericSalary();
        const gross = base + allowancesTotal;

        // BHXH 10.5% (NLĐ: 8% BHXH, 1.5% BHYT, 1% BHTN)
        const bhxh = Math.round(base * 0.105);

        // Thuế TNCN (tạm tính đơn giản giảm trừ 11tr)
        const taxable = Math.max(0, gross - bhxh - 11000000);
        let tax = 0;
        if (taxable > 0 && taxable <= 5000000) tax = taxable * 0.05;
        else if (taxable > 5000000 && taxable <= 10000000) tax = 250000 + (taxable - 5000000) * 0.10;
        else if (taxable > 10000000) tax = 750000 + (taxable - 10000000) * 0.15;

        const net = Math.max(0, gross - bhxh - tax);
        const netPct = gross > 0 ? Math.round((net / gross) * 100) : 88;

        // Update displays
        document.getElementById("calcBaseDisplay").innerText = base.toLocaleString("vi-VN") + " đ";
        document.getElementById("calcAllowanceDisplay").innerText = "+ " + allowancesTotal.toLocaleString("vi-VN") + " đ";
        document.getElementById("calcGrossDisplay").innerText = gross.toLocaleString("vi-VN") + " đ";
        document.getElementById("calcBhxhDisplay").innerText = "- " + bhxh.toLocaleString("vi-VN") + " đ";
        document.getElementById("calcTaxDisplay").innerText = "- " + tax.toLocaleString("vi-VN") + " đ";
        document.getElementById("calcNetDisplay").innerText = "~ " + net.toLocaleString("vi-VN") + " đ";
        document.getElementById("calcNetPct").innerText = netPct + "% Gross";
        document.getElementById("calcDonutPct").innerText = netPct + "%";

        // Update probation note
        const rate = document.getElementById("rate85").checked ? 0.85 : 1.0;
        const probSalary = Math.round(base * rate);
        document.getElementById("probationSubText").innerText =
            "Thử việc 2 tháng: " + probSalary.toLocaleString("vi-VN") + " VNĐ/tháng";
    }

    function addCustomAllowance() {
        const name = prompt("Nhập tên khoản phụ cấp mới (VD: Phụ cấp trách nhiệm dự án):");
        if (!name) return;
        const amountStr = prompt("Nhập số tiền phụ cấp (VNĐ/tháng, VD: 1500000):", "1000000");
        const amount = parseInt(amountStr) || 0;
        if (amount <= 0) return;

        const container = document.getElementById("allowanceListContainer");
        const newDiv = document.createElement("div");
        newDiv.className = "allowance-box-item active";
        newDiv.innerHTML = `
            <div class="allowance-left">
                <input type="checkbox" class="form-check-input mt-0" checked onchange="toggleAllowanceRow(this, ${amount})">
                <div>
                    <div class="allowance-name">${name} <span class="badge bg-primary-subtle text-primary ms-1" style="font-size:0.65rem;">Tùy chỉnh</span></div>
                    <div class="allowance-sub">Hỗ trợ theo quyết định phân công nhiệm vụ</div>
                </div>
            </div>
            <div class="allowance-amount">${amount.toLocaleString("vi-VN")} đ / tháng</div>
        `;
        container.appendChild(newDiv);
        allowancesTotal += amount;
        recalcCompensation();
        showToast(`Đã thêm khoản phụ cấp "${name}": ${amount.toLocaleString("vi-VN")} đ`, "success");
    }

    // =========================================================================
    // 8. DRAFT SAVING & RESTORING (LOCALSTORAGE)
    // =========================================================================
    function saveDraft() {
        const data = {
            fullName: document.getElementById("fullName").value,
            employeeCode: document.getElementById("employeeCode").value,
            dateOfBirth: document.getElementById("dateOfBirth").value,
            gender: document.querySelector('input[name="gender"]:checked')?.value || 'MALE',
            idNumber: document.getElementById("idNumber").value,
            idIssueDate: document.getElementById("idIssueDate").value,
            idIssuePlace: document.getElementById("idIssuePlace").value,
            email: document.getElementById("email").value,
            companyEmailPrefix: document.getElementById("companyEmailPrefix").value,
            phone: document.getElementById("phone").value,
            emergencyContactName: document.getElementById("emergencyContactName")?.value || '',
            emergencyContactPhone: document.getElementById("emergencyContactPhone")?.value || '',
            emergencyContactRelation: document.getElementById("emergencyContactRelation")?.value || '',
            address: document.getElementById("address").value,
            tempAddress: document.getElementById("tempAddress").value,
            departmentId: document.getElementById("departmentId").value,
            positionId: document.getElementById("positionId").value,
            employeeLevel: document.getElementById("employeeLevel").value,
            lineManager: document.getElementById("lineManager").value,
            mentorName: document.getElementById("mentorName").value,
            baseSalary: document.getElementById("baseSalary").value,
            contractCode: document.getElementById("contractCode").value,
            savedAt: new Date().toLocaleTimeString()
        };

        localStorage.setItem("miximoi_employee_draft", JSON.stringify(data));
        showToast(`Đã lưu bản nháp hồ sơ thành công (${data.savedAt})`, "success");
        document.getElementById("autoSaveTimer").innerText = "Vừa xong";
    }

    function checkSavedDraft() {
        const draftStr = localStorage.getItem("miximoi_employee_draft");
        if (draftStr) {
            try {
                const draft = JSON.parse(draftStr);
                if (draft.fullName || draft.employeeCode) {
                    const banner = document.getElementById("draftAlertBanner");
                    const text = document.getElementById("draftAlertText");
                    text.innerText = `Phát hiện bản nháp của "${draft.fullName || draft.employeeCode}" đã lưu lúc ${draft.savedAt}. Bạn có muốn khôi phục không?`;
                    banner.classList.remove("d-none");
                }
            } catch (e) {}
        }
    }

    function restoreDraftData() {
        const draftStr = localStorage.getItem("miximoi_employee_draft");
        if (!draftStr) return;
        const draft = JSON.parse(draftStr);

        if (draft.fullName) document.getElementById("fullName").value = draft.fullName;
        if (draft.employeeCode) document.getElementById("employeeCode").value = draft.employeeCode;
        if (draft.dateOfBirth) document.getElementById("dateOfBirth").value = draft.dateOfBirth;
        if (draft.idNumber) document.getElementById("idNumber").value = draft.idNumber;
        if (draft.idIssueDate) document.getElementById("idIssueDate").value = draft.idIssueDate;
        if (draft.idIssuePlace) document.getElementById("idIssuePlace").value = draft.idIssuePlace;
        if (draft.email) document.getElementById("email").value = draft.email;
        if (draft.companyEmailPrefix) document.getElementById("companyEmailPrefix").value = draft.companyEmailPrefix;
        if (draft.phone) document.getElementById("phone").value = draft.phone;
        if (draft.emergencyContactName) { const el = document.getElementById("emergencyContactName"); if (el) el.value = draft.emergencyContactName; }
        if (draft.emergencyContactPhone) { const el = document.getElementById("emergencyContactPhone"); if (el) el.value = draft.emergencyContactPhone; }
        if (draft.emergencyContactRelation) { const el = document.getElementById("emergencyContactRelation"); if (el) el.value = draft.emergencyContactRelation; }
        if (draft.address) document.getElementById("address").value = draft.address;
        if (draft.tempAddress) document.getElementById("tempAddress").value = draft.tempAddress;
        if (draft.departmentId) {
            document.getElementById("departmentId").value = draft.departmentId;
            handleDepartmentChange(draft.departmentId);
        }
        if (draft.positionId) {
            document.getElementById("positionId").value = draft.positionId;
        }
        if (draft.baseSalary) document.getElementById("baseSalary").value = draft.baseSalary;
        if (draft.contractCode) document.getElementById("contractCode").value = draft.contractCode;

        handleFullNameChange(draft.fullName);
        calculateAge();
        recalcCompensation();

        dismissDraft();
        showToast("Đã khôi phục toàn bộ dữ liệu từ bản nháp!", "success");
    }

    function dismissDraft() {
        document.getElementById("draftAlertBanner").classList.add("d-none");
    }

    function clearDraft() {
        localStorage.removeItem("miximoi_employee_draft");
        dismissDraft();
        showToast("Đã xóa bản nháp thành công.", "warning");
    }

    function startAutoSaveInterval() {
        if (window.IS_EDIT_MODE) return;
        let count = 0;
        setInterval(() => {
            count++;
            if (count % 60 === 0) {
                saveDraft();
            } else {
                const mins = Math.floor(count / 60);
                if (mins > 0) {
                    document.getElementById("autoSaveTimer").innerText = `${mins} phút trước`;
                } else {
                    document.getElementById("autoSaveTimer").innerText = `${count} giây trước`;
                }
            }
        }, 1000);
    }

    function confirmDiscard() {
        return confirm("Bạn có chắc chắn muốn hủy bỏ? Mọi thông tin chưa lưu sẽ bị hủy.");
    }

    function handleStatusChange(status) {
        const termFields = document.getElementById("terminationFields");
        if (termFields) {
            if (status === "INACTIVE") {
                termFields.classList.remove("d-none");
            } else {
                termFields.classList.add("d-none");
            }
        }
    }
    window.handleStatusChange = handleStatusChange;

    function updateDeptQuotaBannerOnly(deptId) {
        const banner = document.getElementById("deptQuotaBanner");
        const data = DEPARTMENT_DATA[deptId];
        if (!banner || !data) return;
        const pct = Math.round((data.currentCount / data.targetCount) * 100);
        const vacantCount = data.targetCount - data.currentCount;
        let badgeHtml = "";
        let barColor = "linear-gradient(90deg, #2563eb, #38bdf8)";
        if (vacantCount > 0) {
            badgeHtml = `<span class="quota-badge-vacant"><i class="bi bi-person-plus-fill"></i> Còn thiếu ${vacantCount} chỉ tiêu</span>`;
            barColor = "linear-gradient(90deg, #059669, #34d399)";
        } else {
            badgeHtml = `<span class="quota-badge-full"><i class="bi bi-exclamation-circle-fill"></i> Đã đủ định biên (${data.currentCount}/${data.targetCount})</span>`;
            barColor = "linear-gradient(90deg, #dc2626, #f87171)";
        }
        banner.innerHTML = `
            <div class="quota-header">
                <div>
                    <div style="font-weight:800; font-size:0.9rem; color:#0f172a;">🏢 ${data.name}</div>
                    <div style="font-size:0.75rem; color:#64748b;">Nghiệp vụ: ${data.desc}</div>
                </div>
                ${badgeHtml}
            </div>
            <div class="d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
                <span style="font-weight:700; color:#1e293b;">Hiện có ${data.currentCount} / ${data.targetCount} nhân sự</span>
                <span style="font-weight:800; color:#2563eb;">${pct}% định biên</span>
            </div>
            <div class="quota-progress">
                <div class="quota-progress-bar" style="width:${pct}%; background:${barColor};"></div>
            </div>
        `;
        updateStep2Summary();
    }
    window.updateDeptQuotaBannerOnly = updateDeptQuotaBannerOnly;


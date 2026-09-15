<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${empty department or empty department.id or department.id == 0 ? 'Them phong ban moi' : 'Chinh sua phong ban'} - MIXIMOI HRM</title>
    <%@ include file="/WEB-INF/views/common/head.jsp" %>
    <style>
        /* ===== Department Form Premium UI ===== */
        .dept-form-header{display:flex;flex-wrap:wrap;align-items:flex-start;justify-content:space-between;gap:16px;margin-bottom:28px}
        .dept-form-title{font-size:1.35rem;font-weight:700;color:#111827;display:flex;align-items:center;gap:10px;margin:0 0 4px}
        .dept-form-subtitle{font-size:0.83rem;color:#6b7280;margin:0}
        .btn-back{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;border:1px solid #d1d5db;border-radius:8px;background:#fff;color:#374151;font-size:0.83rem;font-weight:500;text-decoration:none;cursor:pointer;transition:all 0.15s}
        .btn-back:hover{background:#f9fafb;border-color:#9ca3af;color:#111827}

        /* Layout */
        .dept-form-layout{display:grid;grid-template-columns:280px 1fr;gap:24px;align-items:start}
        @media(max-width:900px){.dept-form-layout{grid-template-columns:1fr}}

        /* Left Panel */
        .dept-form-left-panel{display:flex;flex-direction:column;gap:16px;position:sticky;top:80px}
        .dept-identity-card{background:#fff;border:1px solid #e5e7eb;border-radius:14px;padding:24px;text-align:center;box-shadow:0 1px 4px rgba(0,0,0,0.04)}
        .dept-avatar-ring{width:96px;height:96px;border-radius:20px;background:linear-gradient(135deg,#2563eb,#7c3aed);display:flex;align-items:center;justify-content:center;margin:0 auto 16px;font-size:2.2rem;color:#fff;font-weight:800;box-shadow:0 4px 16px rgba(37,99,235,0.35)}
        .dept-id-name{font-size:1rem;font-weight:700;color:#111827;margin-bottom:4px}
        .dept-id-code{font-size:0.75rem;color:#6b7280;background:#f3f4f6;padding:3px 10px;border-radius:6px;display:inline-block;margin-bottom:12px}
        .dept-id-badge{display:inline-flex;align-items:center;gap:5px;font-size:0.75rem;font-weight:600;padding:4px 12px;border-radius:20px;background:#dcfce7;color:#15803d}
        .dept-id-badge-dot{width:6px;height:6px;border-radius:50%;background:#16a34a}

        .dept-info-card{background:#fff;border:1px solid #e5e7eb;border-radius:14px;padding:20px;box-shadow:0 1px 4px rgba(0,0,0,0.04)}
        .dept-info-card-title{font-size:0.8rem;font-weight:700;color:#6b7280;text-transform:uppercase;letter-spacing:0.06em;margin-bottom:14px;display:flex;align-items:center;gap:6px}
        .dept-info-row{display:flex;align-items:flex-start;gap:10px;padding:8px 0;border-bottom:1px solid #f3f4f6}
        .dept-info-row:last-child{border-bottom:none;padding-bottom:0}
        .dept-info-icon{width:28px;height:28px;border-radius:6px;background:#eff6ff;color:#2563eb;display:flex;align-items:center;justify-content:center;font-size:0.8rem;flex-shrink:0}
        .dept-info-label{font-size:0.72rem;color:#6b7280;margin-bottom:1px}
        .dept-info-value{font-size:0.82rem;color:#111827;font-weight:500}

        .dept-guide-card{background:linear-gradient(135deg,#eff6ff,#f0fdf4);border:1px solid #bfdbfe;border-radius:14px;padding:16px;box-shadow:0 1px 4px rgba(0,0,0,0.04)}
        .dept-guide-title{font-size:0.8rem;font-weight:700;color:#1d4ed8;margin-bottom:10px;display:flex;align-items:center;gap:6px}
        .dept-guide-item{display:flex;align-items:flex-start;gap:8px;margin-bottom:8px;font-size:0.78rem;color:#374151}
        .dept-guide-item:last-child{margin-bottom:0}
        .dept-guide-item i{color:#2563eb;flex-shrink:0;margin-top:1px}

        /* Right Panel - Form */
        .dept-form-right{display:flex;flex-direction:column;gap:0}
        .dept-form-card{background:#fff;border:1px solid #e5e7eb;border-radius:14px;overflow:hidden;box-shadow:0 1px 4px rgba(0,0,0,0.04)}
        .dept-form-section{padding:24px}
        .dept-form-section-header{display:flex;align-items:center;gap:12px;margin-bottom:20px;padding-bottom:16px;border-bottom:1px solid #f3f4f6}
        .dept-form-section-icon{width:40px;height:40px;border-radius:10px;background:#eff6ff;color:#2563eb;display:flex;align-items:center;justify-content:center;font-size:1.1rem;flex-shrink:0}
        .dept-form-section-title{font-size:0.95rem;font-weight:700;color:#111827;margin:0}
        .dept-form-section-desc{font-size:0.78rem;color:#6b7280;margin:2px 0 0}

        /* Form fields */
        .dept-form-field{margin-bottom:18px}
        .dept-form-field:last-child{margin-bottom:0}
        .dept-form-label{display:block;font-size:0.82rem;font-weight:600;color:#374151;margin-bottom:6px}
        .dept-form-label .req{color:#ef4444;margin-left:2px}
        .dept-form-label .hint{font-size:0.72rem;color:#9ca3af;font-weight:400;margin-left:6px}
        .dept-form-input,.dept-form-textarea{width:100%;padding:10px 14px;border:1.5px solid #e5e7eb;border-radius:9px;font-size:0.87rem;color:#111827;background:#fafafa;outline:none;transition:border-color 0.15s,background 0.15s,box-shadow 0.15s;box-sizing:border-box;font-family:inherit}
        .dept-form-input:focus,.dept-form-textarea:focus{border-color:#2563eb;background:#fff;box-shadow:0 0 0 3px rgba(37,99,235,0.1)}
        .dept-form-input::placeholder,.dept-form-textarea::placeholder{color:#9ca3af}
        .dept-form-input.invalid{border-color:#ef4444;background:#fff}
        .dept-form-input.invalid:focus{box-shadow:0 0 0 3px rgba(239,68,68,0.1)}
        .dept-form-textarea{resize:vertical;min-height:100px;line-height:1.6}
        .dept-input-counter{display:flex;justify-content:space-between;align-items:center;margin-top:4px}
        .dept-input-hint{font-size:0.72rem;color:#6b7280}
        .dept-char-counter{font-size:0.72rem;color:#9ca3af}
        .dept-char-counter.warn{color:#d97706}
        .dept-char-counter.over{color:#ef4444}

        /* Tag input area */
        .dept-tag-area{display:flex;flex-wrap:wrap;gap:6px;align-items:center;padding:8px 10px;border:1.5px solid #e5e7eb;border-radius:9px;background:#fafafa;min-height:44px;cursor:text}
        .dept-tag-area:focus-within{border-color:#2563eb;background:#fff;box-shadow:0 0 0 3px rgba(37,99,235,0.1)}
        .dept-tag{display:inline-flex;align-items:center;gap:4px;background:#dbeafe;color:#1d4ed8;font-size:0.75rem;font-weight:500;padding:3px 8px;border-radius:6px}
        .dept-tag button{background:none;border:none;color:#1d4ed8;cursor:pointer;padding:0;font-size:0.8rem;line-height:1;display:flex;align-items:center}

        /* Color picker */
        .dept-color-picker{display:flex;gap:8px;flex-wrap:wrap}
        .dept-color-dot{width:28px;height:28px;border-radius:8px;cursor:pointer;border:2px solid transparent;transition:all 0.15s;position:relative}
        .dept-color-dot:hover,.dept-color-dot.selected{border-color:#fff;box-shadow:0 0 0 3px rgba(37,99,235,0.4);transform:scale(1.1)}
        .dept-color-dot.selected::after{content:'';position:absolute;inset:0;display:flex;align-items:center;justify-content:center;font-size:0.85rem;color:#fff}

        /* Divider between sections */
        .dept-form-divider{border:none;border-top:1px solid #f3f4f6;margin:0}

        /* Action bar */
        .dept-form-action-bar{display:flex;justify-content:flex-end;align-items:center;gap:12px;padding:18px 24px;background:#f9fafb;border-top:1px solid #e5e7eb}
        .btn-cancel-form{display:inline-flex;align-items:center;gap:6px;padding:9px 20px;border:1px solid #d1d5db;border-radius:9px;background:#fff;color:#374151;font-size:0.85rem;font-weight:500;text-decoration:none;cursor:pointer;transition:all 0.15s}
        .btn-cancel-form:hover{background:#f9fafb;border-color:#9ca3af;color:#111827}
        .btn-submit-form{display:inline-flex;align-items:center;gap:8px;padding:10px 24px;border-radius:9px;background:linear-gradient(135deg,#2563eb,#1d4ed8);color:#fff;font-size:0.87rem;font-weight:600;border:none;cursor:pointer;box-shadow:0 2px 8px rgba(37,99,235,0.35);transition:all 0.2s}
        .btn-submit-form:hover{background:linear-gradient(135deg,#1d4ed8,#1e40af);transform:translateY(-1px);box-shadow:0 4px 14px rgba(37,99,235,0.45)}

        /* Required indicator */
        .req-note{font-size:0.75rem;color:#6b7280;margin-bottom:20px}
        .req-note span{color:#ef4444}
    </style>
</head>
<body>
<div class="app-container">
    <c:set var="activeMenu" value="departments" scope="request"/>
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
    <main class="app-main">
        <%@ include file="/WEB-INF/views/common/topbar.jsp" %>
        <div class="app-content">

            <!-- Page Header -->
            <div class="dept-form-header">
                <div>
                    <h1 class="dept-form-title">
                        <i class="bi ${empty department or empty department.id or department.id == 0 ? 'bi-building-add' : 'bi-building-gear'} text-primary"></i>
                        ${empty department or empty department.id or department.id == 0 ? 'Them phong ban moi' : 'Chinh sua thong tin phong ban'}
                    </h1>
                    <p class="dept-form-subtitle">
                        ${empty department or empty department.id or department.id == 0
                            ? 'Khai bao phong ban moi vao co cau to chuc cong ty'
                            : 'Cap nhat thong tin va cau hinh phong ban trong he thong'}
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/departments" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Quay lai danh sach
                </a>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/departments"
                  class="needs-validation" novalidate id="deptForm">
                <input type="hidden" name="action" value="${empty department or empty department.id or department.id == 0 ? 'add' : 'update'}">
                <c:if test="${not empty department and department.id > 0}">
                    <input type="hidden" name="id" value="${department.id}">
                </c:if>

                <div class="dept-form-layout">
                    <!-- Left Panel -->
                    <div class="dept-form-left-panel">
                        <!-- Identity Preview -->
                        <div class="dept-identity-card">
                            <div class="dept-avatar-ring" id="deptAvatarPreview">
                                <c:choose>
                                    <c:when test="${not empty department and not empty department.name}">
                                        ${fn:substring(department.name,0,2)}
                                    </c:when>
                                    <c:otherwise>PB</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="dept-id-name" id="deptNamePreview">
                                <c:choose>
                                    <c:when test="${not empty department and not empty department.name}"><c:out value="${department.name}"/></c:when>
                                    <c:otherwise>Ten phong ban</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="dept-id-code">
                                <c:choose>
                                    <c:when test="${not empty department and department.id > 0}">PB-${department.id < 10 ? '0' : ''}${department.id}</c:when>
                                    <c:otherwise>PB-NEW</c:otherwise>
                                </c:choose>
                            </div>
                            <div><span class="dept-id-badge"><span class="dept-id-badge-dot"></span>Hoat dong</span></div>
                        </div>

                        <!-- System Info -->
                        <div class="dept-info-card">
                            <div class="dept-info-card-title">
                                <i class="bi bi-info-circle"></i> Thong tin he thong
                            </div>
                            <div class="dept-info-row">
                                <div class="dept-info-icon"><i class="bi bi-calendar3"></i></div>
                                <div>
                                    <div class="dept-info-label">Ngay tao</div>
                                    <div class="dept-info-value">Hom nay</div>
                                </div>
                            </div>
                            <div class="dept-info-row">
                                <div class="dept-info-icon"><i class="bi bi-person-gear"></i></div>
                                <div>
                                    <div class="dept-info-label">Nguoi tao</div>
                                    <div class="dept-info-value">${sessionScope.currentUser.fullName}</div>
                                </div>
                            </div>
                            <div class="dept-info-row">
                                <div class="dept-info-icon"><i class="bi bi-shield-check"></i></div>
                                <div>
                                    <div class="dept-info-label">Trang thai mac dinh</div>
                                    <div class="dept-info-value" style="color:#16a34a;font-weight:600">Hoat dong</div>
                                </div>
                            </div>
                            <div class="dept-info-row">
                                <div class="dept-info-icon"><i class="bi bi-people"></i></div>
                                <div>
                                    <div class="dept-info-label">Nhan vien hien tai</div>
                                    <div class="dept-info-value">
                                        <c:choose>
                                            <c:when test="${not empty department and department.id > 0}">${department.employeeCount} nguoi</c:when>
                                            <c:otherwise>0 nguoi</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Guide -->
                        <div class="dept-guide-card">
                            <div class="dept-guide-title">
                                <i class="bi bi-lightbulb-fill"></i> Huong dan nhanh
                            </div>
                            <div class="dept-guide-item">
                                <i class="bi bi-check-circle-fill"></i>
                                <span>Ten phong ban phai ro rang, phan anh dung chuc nang</span>
                            </div>
                            <div class="dept-guide-item">
                                <i class="bi bi-check-circle-fill"></i>
                                <span>Mo ta nen neu ro nhiem vu va pham vi hoat dong</span>
                            </div>
                            <div class="dept-guide-item">
                                <i class="bi bi-check-circle-fill"></i>
                                <span>Co the chinh sua thong tin sau khi tao thanh cong</span>
                            </div>
                            <div class="dept-guide-item">
                                <i class="bi bi-info-circle-fill" style="color:#d97706"></i>
                                <span>Phong ban da co nhan vien se khong the xoa</span>
                            </div>
                        </div>
                    </div>

                    <!-- Right Panel -->
                    <div class="dept-form-card">
                        <!-- Section: Basic Info -->
                        <div class="dept-form-section">
                            <div class="dept-form-section-header">
                                <div class="dept-form-section-icon">
                                    <i class="bi bi-building"></i>
                                </div>
                                <div>
                                    <div class="dept-form-section-title">Thong tin phong ban</div>
                                    <div class="dept-form-section-desc">Khai bao dinh danh va chuc nang nhiem vu cua phong ban</div>
                                </div>
                            </div>

                            <p class="req-note">Cac truong co dau <span>*</span> la bat buoc</p>

                            <div class="dept-form-field">
                                <label class="dept-form-label" for="deptName">
                                    Ten phong ban <span class="req">*</span>
                                    <span class="hint">Tieng Viet co dau, ro rang</span>
                                </label>
                                <input type="text" class="dept-form-input" id="deptName" name="name"
                                       required maxlength="120"
                                       placeholder="VD: Phong Nghien cuu &amp; Phat trien"
                                       value="<c:out value='${department.name}'/>"
                                       oninput="updatePreview(this)">
                                <div class="dept-input-counter">
                                    <span class="dept-input-hint">Dat ten theo chuan: [Chuc nang chinh] hoac [Phong + Ten]</span>
                                    <span class="dept-char-counter" id="nameCounter">0 / 120</span>
                                </div>
                                <div class="invalid-feedback" style="display:none;font-size:0.75rem;color:#ef4444;margin-top:4px">
                                    Vui long nhap ten phong ban.
                                </div>
                            </div>

                            <div class="dept-form-field">
                                <label class="dept-form-label" for="deptDesc">
                                    Mo ta chuc nang &amp; nhiem vu
                                    <span class="hint">Khong bat buoc</span>
                                </label>
                                <textarea class="dept-form-textarea" id="deptDesc" name="description"
                                          rows="5" maxlength="500"
                                          placeholder="Mo ta tom tat vai tro, pham vi phu trach va chuc nang cua bo phan nay trong cong ty...&#10;&#10;VD: Phong Kinh doanh chiu trach nhiem trien khai cac hoat dong ban hang, xay dung quan he khach hang va phat trien thi truong..."
                                          oninput="updateDescCounter(this)"><c:out value="${department.description}"/></textarea>
                                <div class="dept-input-counter">
                                    <span class="dept-input-hint">Mo ta cu the giup nhan vien moi hieu ro pham vi cong viec</span>
                                    <span class="dept-char-counter" id="descCounter">0 / 500</span>
                                </div>
                            </div>
                        </div>

                        <hr class="dept-form-divider">

                        <!-- Section: Optional Settings -->
                        <div class="dept-form-section">
                            <div class="dept-form-section-header">
                                <div class="dept-form-section-icon" style="background:#f0fdf4;color:#16a34a">
                                    <i class="bi bi-gear"></i>
                                </div>
                                <div>
                                    <div class="dept-form-section-title">Cau hinh bo sung</div>
                                    <div class="dept-form-section-desc">Mau sac nhan dien va tu khoa tim kiem nhanh (khong bat buoc)</div>
                                </div>
                            </div>

                            <div class="dept-form-field">
                                <label class="dept-form-label">Mau sac nhan dien phong ban</label>
                                <div class="dept-color-picker" id="colorPicker">
                                    <div class="dept-color-dot selected" style="background:#2563eb" data-color="#2563eb" onclick="selectColor(this)" title="Xanh duong"></div>
                                    <div class="dept-color-dot" style="background:#16a34a" data-color="#16a34a" onclick="selectColor(this)" title="Xanh la"></div>
                                    <div class="dept-color-dot" style="background:#7c3aed" data-color="#7c3aed" onclick="selectColor(this)" title="Tim"></div>
                                    <div class="dept-color-dot" style="background:#d97706" data-color="#d97706" onclick="selectColor(this)" title="Cam vang"></div>
                                    <div class="dept-color-dot" style="background:#dc2626" data-color="#dc2626" onclick="selectColor(this)" title="Do"></div>
                                    <div class="dept-color-dot" style="background:#0891b2" data-color="#0891b2" onclick="selectColor(this)" title="Xanh bien"></div>
                                    <div class="dept-color-dot" style="background:#9d174d" data-color="#9d174d" onclick="selectColor(this)" title="Hong dam"></div>
                                    <div class="dept-color-dot" style="background:#374151" data-color="#374151" onclick="selectColor(this)" title="Xam toi"></div>
                                </div>
                                <div style="font-size:0.72rem;color:#6b7280;margin-top:6px">Mau sac nay se hien thi trong so do to chuc va lich</div>
                            </div>

                            <div class="dept-form-field">
                                <label class="dept-form-label" for="deptAlias">
                                    Ten viet tat / Biet danh
                                    <span class="hint">VD: R&amp;D, IT, HR, Sales</span>
                                </label>
                                <input type="text" class="dept-form-input" id="deptAlias" name="alias"
                                       maxlength="20" placeholder="VD: R&D, KINH DOANH, CSKH..."
                                       style="width:240px">
                            </div>
                        </div>

                        <!-- Action Bar -->
                        <div class="dept-form-action-bar">
                            <a href="${pageContext.request.contextPath}/departments" class="btn-cancel-form">
                                <i class="bi bi-x-lg"></i> Huy bo
                            </a>
                            <button type="submit" class="btn-submit-form" id="btnSubmitDept">
                                <i class="bi bi-check2-circle"></i>
                                ${empty department or empty department.id or department.id == 0 ? 'Tao phong ban' : 'Luu thay doi'}
                            </button>
                        </div>
                    </div>
                </div>
            </form>

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script>
    // Live preview
    function updatePreview(input) {
        const val = input.value.trim();
        document.getElementById('deptNamePreview').textContent = val || 'Ten phong ban';
        const preview = document.getElementById('deptAvatarPreview');
        preview.textContent = val.length >= 2 ? val.substring(0, 2).toUpperCase() : (val.length === 1 ? val.toUpperCase() : 'PB');
        // Counter
        const counter = document.getElementById('nameCounter');
        const len = input.value.length;
        counter.textContent = len + ' / 120';
        counter.className = 'dept-char-counter' + (len > 100 ? ' warn' : '') + (len >= 120 ? ' over' : '');
    }

    function updateDescCounter(textarea) {
        const counter = document.getElementById('descCounter');
        const len = textarea.value.length;
        counter.textContent = len + ' / 500';
        counter.className = 'dept-char-counter' + (len > 400 ? ' warn' : '') + (len >= 500 ? ' over' : '');
    }

    function selectColor(dot) {
        document.querySelectorAll('.dept-color-dot').forEach(d => d.classList.remove('selected'));
        dot.classList.add('selected');
        const color = dot.dataset.color;
        document.getElementById('deptAvatarPreview').style.background = 'linear-gradient(135deg,' + color + ',' + color + 'aa)';
    }

    // Initialize counters on load
    document.addEventListener('DOMContentLoaded', function() {
        const nameInput = document.getElementById('deptName');
        const descInput = document.getElementById('deptDesc');
        if (nameInput && nameInput.value) updatePreview(nameInput);
        if (descInput && descInput.value) updateDescCounter(descInput);

        // Form validation
        const form = document.getElementById('deptForm');
        form.addEventListener('submit', function(e) {
            const nameVal = document.getElementById('deptName').value.trim();
            if (!nameVal) {
                e.preventDefault();
                e.stopPropagation();
                document.getElementById('deptName').classList.add('invalid');
                document.querySelector('.invalid-feedback').style.display = 'block';
                document.getElementById('deptName').focus();
            } else {
                document.getElementById('btnSubmitDept').disabled = true;
                document.getElementById('btnSubmitDept').innerHTML = '<i class="bi bi-hourglass-split"></i> Dang luu...';
            }
        });

        document.getElementById('deptName').addEventListener('input', function() {
            if (this.value.trim()) {
                this.classList.remove('invalid');
                document.querySelector('.invalid-feedback').style.display = 'none';
            }
        });
    });
</script>
</body>
</html>
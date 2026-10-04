/**
 * MIXIMOI HRM & PAYROLL — Recruitment Module JavaScript
 * Modular client-side logic for ATS Kanban Pipeline, CV Soft-copy preview, and Candidate management.
 */

// 1. Tương tác chọn Card Ứng viên và cập nhật Khung Drawer bên phải
function selectCandidateCard(cardElement) {
    if (!cardElement) return;
    document.querySelectorAll('.kanban-card').forEach(c => c.classList.remove('active-card'));
    cardElement.classList.add('active-card');

    const id = cardElement.getAttribute('data-id') || '';
    const name = cardElement.getAttribute('data-name') || 'Ứng viên';
    const code = cardElement.getAttribute('data-code') || 'UV-000';
    const job = cardElement.getAttribute('data-job') || '';
    const avatar = cardElement.getAttribute('data-avatar') || '';
    const email = cardElement.getAttribute('data-email') || '';
    const phone = cardElement.getAttribute('data-phone') || '';
    const source = cardElement.getAttribute('data-source') || '';
    const rating = cardElement.getAttribute('data-rating') || '';
    const score = cardElement.getAttribute('data-score') || '85';
    const rec = cardElement.getAttribute('data-rec') || '';
    const exp = cardElement.getAttribute('data-exp') || '0';
    const salary = cardElement.getAttribute('data-salary') || 'Thỏa thuận';
    const edu = cardElement.getAttribute('data-edu') || '';
    const work = cardElement.getAttribute('data-work') || '';
    const skills = cardElement.getAttribute('data-skills') || '';

    // Cập nhật DOM
    const drawerName = document.getElementById('drawerName');
    if (drawerName) drawerName.textContent = name;

    const drawerCode = document.getElementById('drawerCode');
    if (drawerCode) drawerCode.textContent = code;

    const drawerJobTitle = document.getElementById('drawerJobTitle');
    if (drawerJobTitle) drawerJobTitle.textContent = job;

    const drawerAvatar = document.getElementById('drawerAvatarInitials');
    if (drawerAvatar) drawerAvatar.textContent = avatar ? avatar : 'UV';

    const drawerEmail = document.getElementById('drawerEmail');
    if (drawerEmail) drawerEmail.textContent = email;

    const drawerPhone = document.getElementById('drawerPhone');
    if (drawerPhone) drawerPhone.textContent = phone;

    const drawerSource = document.getElementById('drawerSource');
    if (drawerSource) drawerSource.textContent = source;

    const drawerRating = document.getElementById('drawerRating');
    if (drawerRating) drawerRating.textContent = rating;

    const drawerAiScoreText = document.getElementById('drawerAiScoreText');
    if (drawerAiScoreText) drawerAiScoreText.textContent = score + '%';

    const drawerAiScoreBadge = document.getElementById('drawerAiScoreBadge');
    if (drawerAiScoreBadge) drawerAiScoreBadge.textContent = score + '% MATCH';

    const drawerAiProgressBar = document.getElementById('drawerAiProgressBar');
    if (drawerAiProgressBar) drawerAiProgressBar.style.width = score + '%';

    const drawerAiRecommendation = document.getElementById('drawerAiRecommendation');
    if (drawerAiRecommendation) drawerAiRecommendation.innerHTML = '<strong>Đánh giá của AI:</strong> ' + rec;

    const drawerExp = document.getElementById('drawerExp');
    if (drawerExp) drawerExp.textContent = exp + ' năm';

    const drawerExpectedSalary = document.getElementById('drawerExpectedSalary');
    if (drawerExpectedSalary) drawerExpectedSalary.textContent = salary;

    const drawerOfferSalary = document.getElementById('drawerOfferSalary');
    if (drawerOfferSalary) drawerOfferSalary.textContent = salary;

    const drawerEdu = document.getElementById('drawerEdu');
    if (drawerEdu) drawerEdu.textContent = edu;

    const drawerWork = document.getElementById('drawerWork');
    if (drawerWork) drawerWork.textContent = work;

    const drawerCvFileName = document.getElementById('drawerCvFileName');
    if (drawerCvFileName) drawerCvFileName.textContent = 'CV_' + name.replace(/\s+/g, '_') + '.pdf';

    const drawerCandidateIdInput = document.getElementById('drawerCandidateIdInput');
    if (drawerCandidateIdInput) drawerCandidateIdInput.value = id;

    const modalOfferCandidateId = document.getElementById('modalOfferCandidateId');
    if (modalOfferCandidateId) modalOfferCandidateId.value = id;

    const modalOfferCandName = document.getElementById('modalOfferCandName');
    if (modalOfferCandName) modalOfferCandName.textContent = name + ' (' + code + ')';

    const modalOfferCandJob = document.getElementById('modalOfferCandJob');
    if (modalOfferCandJob) modalOfferCandJob.textContent = job;

    const modalInterviewCandId = document.getElementById('modalInterviewCandId');
    if (modalInterviewCandId) modalInterviewCandId.value = id;

    const modalInterviewCandName = document.getElementById('modalInterviewCandName');
    if (modalInterviewCandName) modalInterviewCandName.textContent = name + ' (' + code + ')';

    // Cập nhật nút 1-Click Tiếp nhận vào biên chế
    const stage = cardElement.getAttribute('data-stage');
    const drawerHireContainer = document.getElementById('drawerHireContainer');
    const drawerHireBtn = document.getElementById('drawerHireBtn');
    if (drawerHireContainer && drawerHireBtn) {
        if (stage === 'OFFER' || stage === 'ONBOARDED' || stage === 'OFFER_ACCEPTED' || stage === 'HIRED') {
            drawerHireContainer.style.display = '';
            drawerHireBtn.href = (window.APP_CONTEXT_PATH || '') + '/employees?action=new&candidateId=' + id;
        } else {
            drawerHireContainer.style.display = 'none';
        }
    }

    // Cập nhật Modal 4: Phân tích chuyên sâu AI (#aiCvAnalysisModal)
    const matched = cardElement.getAttribute('data-matched');
    const missing = cardElement.getAttribute('data-missing');

    const aiCandModalName = document.getElementById('aiCandModalName');
    if (aiCandModalName) aiCandModalName.textContent = name;

    const aiCandModalJob = document.getElementById('aiCandModalJob');
    if (aiCandModalJob) aiCandModalJob.textContent = job;

    const aiCandModalScoreBadge = document.getElementById('aiCandModalScoreBadge');
    if (aiCandModalScoreBadge) aiCandModalScoreBadge.textContent = '🥇 AI Match: ' + score + '%';

    const aiCandModalProgressBar = document.getElementById('aiCandModalProgressBar');
    if (aiCandModalProgressBar) aiCandModalProgressBar.style.width = score + '%';

    const aiCandModalMatchedSkills = document.getElementById('aiCandModalMatchedSkills');
    if (aiCandModalMatchedSkills) aiCandModalMatchedSkills.textContent = matched ? matched : 'Đang đồng bộ kỹ năng...';

    const aiCandModalMissingSkills = document.getElementById('aiCandModalMissingSkills');
    if (aiCandModalMissingSkills) aiCandModalMissingSkills.textContent = missing ? missing : 'Chưa phát hiện kỹ năng còn thiếu.';

    // Skills tags
    const drawerSkillsTags = document.getElementById('drawerSkillsTags');
    if (drawerSkillsTags && skills) {
        drawerSkillsTags.innerHTML = '';
        skills.split(',').forEach(sk => {
            if (sk.trim()) {
                const span = document.createElement('span');
                span.className = 'badge bg-light text-dark border px-2 py-1';
                span.style.fontSize = '0.78rem';
                span.textContent = sk.trim();
                drawerSkillsTags.appendChild(span);
            }
        });
    }
}

// 2. CV Soft-Copy Viewer
let currentCvZoom = 1.0;

function changeCvZoom(delta) {
    currentCvZoom = Math.min(Math.max(0.7, currentCvZoom + delta), 1.4);
    const sheet = document.getElementById('cvDocumentSheet');
    if (sheet) sheet.style.transform = 'scale(' + currentCvZoom + ')';
    const label = document.getElementById('viewerZoomLevel');
    if (label) label.textContent = Math.round(currentCvZoom * 100) + '%';
}

function printCandidateCv() {
    window.print();
}

function downloadCandidateCv() {
    const el = document.getElementById('viewerCandName');
    const name = el ? el.textContent : 'Ung_vien';
    if (window.HRM && window.HRM.toast) {
        window.HRM.toast('Tải CV', 'Đang tải xuống bản mềm CV của ứng viên ' + name + '...', 'info');
    } else {
        alert('Đang tải xuống bản mềm CV của ứng viên ' + name + '...');
    }
}

function openCandidateCvModalById(candId) {
    const card = document.querySelector('.store-cand-item[data-id="' + candId + '"]') || document.querySelector('.kanban-card[data-id="' + candId + '"]');
    let name = 'Nguyễn Hoàng Nam', code = 'UV-2026-001', job = 'Senior Fullstack Engineer';
    let email = 'nam.nv@example.com', phone = '0912.345.678', salary = '35.000.000 VNĐ';
    let exp = '4.0', score = '92', skills = 'Java, Spring Boot, Microservices, PostgreSQL, Docker';
    let cvType = 'PDF', cvText = '', summary = '', edu = 'Đại học Bách Khoa Hà Nội', work = '4 năm phát triển phần mềm';

    if (card) {
        name = card.getAttribute('data-name') || name;
        code = card.getAttribute('data-code') || code;
        job = card.getAttribute('data-job') || job;
        email = card.getAttribute('data-email') || email;
        phone = card.getAttribute('data-phone') || phone;
        salary = card.getAttribute('data-salary') || salary;
        exp = card.getAttribute('data-exp') || exp;
        score = card.getAttribute('data-score') || score;
        skills = card.getAttribute('data-skills') || skills;
        summary = card.getAttribute('data-rec') || summary;
        edu = card.getAttribute('data-edu') || edu;
        work = card.getAttribute('data-work') || work;
        cvType = card.getAttribute('data-cv-type') || 'PDF';
        cvText = card.getAttribute('data-cv-text') || '';
    }

    // Đổ dữ liệu vào Modal
    const cName = document.getElementById('viewerCandName'); if (cName) cName.textContent = name;
    const cCode = document.getElementById('viewerCandCode'); if (cCode) cCode.textContent = code;
    const cJob = document.getElementById('viewerCandJob'); if (cJob) cJob.textContent = job;
    const dName = document.getElementById('viewerDocFullName'); if (dName) dName.textContent = name.toUpperCase();
    const dJob = document.getElementById('viewerDocJobTitle'); if (dJob) dJob.textContent = job.toUpperCase();
    const dEmail = document.getElementById('viewerDocEmail'); if (dEmail) dEmail.textContent = email;
    const dPhone = document.getElementById('viewerDocPhone'); if (dPhone) dPhone.textContent = phone;
    const dSalary = document.getElementById('viewerDocSalary'); if (dSalary) dSalary.textContent = salary.includes('VNĐ') ? salary : salary + ' VNĐ';
    const dExp = document.getElementById('viewerDocExpYears'); if (dExp) dExp.textContent = exp + ' năm';
    const dScore = document.getElementById('viewerDocScoreBadge'); if (dScore) dScore.innerHTML = '<i class="bi bi-stars me-1"></i>AI MATCH: ' + score + '%';
    const dEdu = document.getElementById('viewerDocEducation'); if (dEdu) dEdu.textContent = edu;

    // Initials avatar
    const words = name.trim().split(/\s+/);
    let initials = 'UV';
    if (words.length >= 2) initials = (words[words.length - 2][0] + words[words.length - 1][0]).toUpperCase();
    else if (words.length === 1) initials = words[0].substring(0, 2).toUpperCase();
    const dAvatar = document.getElementById('viewerDocAvatar');
    if (dAvatar) dAvatar.textContent = initials;

    // Work history
    const workContainer = document.getElementById('viewerDocWorkHistory');
    if (workContainer) {
        workContainer.innerHTML = '';
        const workItems = work ? work.split('•') : ['3+ năm kinh nghiệm trong ngành'];
        workItems.forEach(item => {
            const div = document.createElement('div');
            div.className = 'mb-2';
            div.innerHTML = '<div class="fw-semibold text-dark small"><i class="bi bi-check2 text-primary me-1"></i>' + item.trim() + '</div>';
            workContainer.appendChild(div);
        });
    }

    // Summary
    const dSum = document.getElementById('viewerDocSummary');
    if (dSum) {
        dSum.textContent = summary || ('Ứng viên ' + name + ' có ' + exp + ' năm kinh nghiệm tại vị trí ' + job + '. Hồ sơ thể hiện năng lực chuyên môn vững vàng, khả năng thích ứng nhanh và tinh thần trách nhiệm cao.');
    }

    // Skills List
    const skillsContainer = document.getElementById('viewerDocSkillsList');
    if (skillsContainer) {
        skillsContainer.innerHTML = '';
        const skillArray = skills ? skills.split(',') : ['Chuyên môn', 'Làm việc nhóm', 'Tiếng Anh'];
        skillArray.forEach(s => {
            if (s.trim()) {
                const badge = document.createElement('span');
                badge.className = 'badge bg-light text-dark border px-2 py-1';
                badge.style.fontSize = '0.8rem';
                badge.textContent = s.trim();
                skillsContainer.appendChild(badge);
            }
        });
    }

    // Raw OCR text
    const dRaw = document.getElementById('viewerDocRawText');
    if (dRaw) {
        dRaw.textContent = cvText || ('TRÍCH XUẤT BẢN MỀM CV: ' + name + '\nVị trí: ' + job + '\nEmail: ' + email + ' | Điện thoại: ' + phone + '\nKỹ năng: ' + skills);
    }

    // Reset zoom
    currentCvZoom = 1.0;
    const sheet = document.getElementById('cvDocumentSheet');
    if (sheet) sheet.style.transform = 'scale(1.0)';
    const zLevel = document.getElementById('viewerZoomLevel');
    if (zLevel) zLevel.textContent = '100%';

    // Mở modal qua Bootstrap
    const modalEl = document.getElementById('viewCandidateCvModal');
    if (modalEl && window.bootstrap) {
        new bootstrap.Modal(modalEl).show();
    }
}

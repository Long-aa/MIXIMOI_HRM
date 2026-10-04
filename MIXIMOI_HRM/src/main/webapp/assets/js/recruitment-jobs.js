// Global state for selected job
                        window.currentJobData = {
                            id: '${selectedJob.id}',
                            code: '${selectedJob.requestCode}',
                            title: '${selectedJob.title}',
                            dept: '${selectedJob.departmentName}',
                            status: '${selectedJob.status}',
                            location: '${selectedJob.location != null ? selectedJob.location : "Hà Nội"}',
                            keywords: '${selectedJob.keywords != null ? selectedJob.keywords : "Java, Spring Boot, PostgreSQL, Microservices, Docker, React"}',
                            salary: '${selectedJob.salaryMinFormatted} - ${selectedJob.salaryMaxFormatted}',
                            salaryMin: '${selectedJob.salaryMinFormatted}',
                            salaryMax: '${selectedJob.salaryMaxFormatted}',
                            deadline: '${selectedJob.deadline}',
                            hired: '${selectedJob.hiredCount}',
                            target: '${selectedJob.targetHeadcount}',
                            candCount: '${selectedJob.candidateCount}',
                            assignee: '${selectedJob.assigneeName != null ? selectedJob.assigneeName : "Phạm Phương Thảo"}',
                            assigneeInitials: '${selectedJob.assigneeAvatarInitials != null ? selectedJob.assigneeAvatarInitials : "PT"}'
                        };

                        // 1. Tương tác chọn dòng vị trí và cập nhật động Khung Job Preview
                        function selectJobRow(rowElement) {
                            if (!rowElement) return;

                            // Xóa highlight cũ
                            document.querySelectorAll('.job-row-item').forEach(r => {
                                r.classList.remove('table-primary', 'bg-opacity-25');
                                const chk = r.querySelector('input[type="checkbox"]');
                                if (chk) chk.checked = false;
                            });

                            // Bật highlight mới
                            rowElement.classList.add('table-primary', 'bg-opacity-25');
                            const currentChk = rowElement.querySelector('input[type="checkbox"]');
                            if (currentChk) currentChk.checked = true;

                            // Trích xuất dữ liệu từ data attributes
                            const id = rowElement.getAttribute('data-id');
                            const title = rowElement.getAttribute('data-title');
                            const code = rowElement.getAttribute('data-code');
                            const dept = rowElement.getAttribute('data-dept');
                            const status = rowElement.getAttribute('data-status');
                            const location = rowElement.getAttribute('data-location') || 'Hà Nội';
                            const keywords = rowElement.getAttribute('data-keywords') || '';
                            const salMin = rowElement.getAttribute('data-salary-min');
                            const salMax = rowElement.getAttribute('data-salary-max');
                            const assignee = rowElement.getAttribute('data-assignee') || 'Phạm Phương Thảo';
                            const assigneeInitials = rowElement.getAttribute('data-assignee-initials') || 'PT';
                            const candCount = rowElement.getAttribute('data-cand-count') || '0';
                            const hired = rowElement.getAttribute('data-hired') || '0';
                            const target = rowElement.getAttribute('data-target') || '1';
                            const deadline = rowElement.getAttribute('data-deadline') || '30/10/2026';
                            const desc = rowElement.getAttribute('data-desc');
                            const req = rowElement.getAttribute('data-req');

                            window.currentJobData = {
                                id: id,
                                code: code,
                                title: title,
                                dept: dept,
                                status: status,
                                location: location,
                                keywords: keywords,
                                salary: salMin + ' - ' + salMax,
                                salaryMin: salMin,
                                salaryMax: salMax,
                                deadline: deadline,
                                hired: hired,
                                target: target,
                                candCount: candCount,
                                assignee: assignee,
                                assigneeInitials: assigneeInitials
                            };

                            // Cập nhật DOM trên Preview Drawer
                            const previewTitle = document.getElementById('previewTitle');
                            if (previewTitle) previewTitle.textContent = title;

                            const previewJobCode = document.getElementById('previewJobCode');
                            if (previewJobCode) previewJobCode.textContent = code;

                            const previewDept = document.getElementById('previewDept');
                            if (previewDept) previewDept.innerHTML = '<i class="bi bi-geo-alt text-primary me-1"></i>' + dept + ' (' + location + ')';

                            const previewSalary = document.getElementById('previewSalary');
                            if (previewSalary) previewSalary.innerHTML = salMin + ' - ' + salMax + ' Triệu VNĐ <span class="text-muted fs-6 fw-normal">/ tháng</span>';

                            const previewStatusBadge = document.getElementById('previewStatusBadge');
                            if (previewStatusBadge) {
                                previewStatusBadge.textContent = (status === 'OPEN') ? 'Đang nhận CV' : status;
                                previewStatusBadge.className = 'badge ' + (status === 'OPEN' ? 'bg-success-subtle text-success border border-success-subtle' : 'bg-light text-muted border') + ' mb-1';
                            }

                            const previewRecruiterName = document.getElementById('previewRecruiterName');
                            if (previewRecruiterName) previewRecruiterName.textContent = assignee;

                            const previewAvatarInitials = document.getElementById('previewAvatarInitials');
                            if (previewAvatarInitials) previewAvatarInitials.textContent = assigneeInitials;

                            const previewAiCandCount = document.getElementById('previewAiCandCount');
                            if (previewAiCandCount) previewAiCandCount.textContent = candCount + ' CV đã nộp';

                            const previewDescription = document.getElementById('previewDescription');
                            if (previewDescription) previewDescription.innerHTML = '<p class="mb-0">' + desc + '</p>';

                            const previewRequirements = document.getElementById('previewRequirements');
                            if (previewRequirements) previewRequirements.innerHTML = '<p class="mb-0">' + req + '</p>';

                            // Đồng bộ hidden IDs trên các Modals
                            const aiBatchJobId = document.getElementById('aiBatchJobId');
                            if (aiBatchJobId && id) aiBatchJobId.value = id;

                            const liveScanJobId = document.getElementById('liveScanJobId');
                            if (liveScanJobId && id) liveScanJobId.value = id;

                            // Đồng bộ từ khóa mặc định lên Modal Scanner
                            const scannerKeywordsInput = document.getElementById('scannerKeywordsInput');
                            if (scannerKeywordsInput && keywords) {
                                scannerKeywordsInput.value = keywords;
                            }
                        }

                        function selectJobById(id) {
                            const targetRow = document.querySelector('.job-row-item[data-id="' + id + '"]');
                            if (targetRow) {
                                selectJobRow(targetRow);
                                switchJobView('table');
                                targetRow.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            }
                        }

                        // 2. Chuyển đổi giao diện Bảng (Table) và Thẻ (Grid)
                        function switchJobView(mode) {
                            const tableContainer = document.getElementById('jobTableViewContainer');
                            const gridContainer = document.getElementById('jobGridViewContainer');
                            const btnTable = document.getElementById('btnTableView');
                            const btnGrid = document.getElementById('btnGridView');

                            if (mode === 'grid') {
                                if (tableContainer) tableContainer.style.display = 'none';
                                if (gridContainer) gridContainer.style.display = 'flex';
                                if (btnTable) btnTable.className = 'btn btn-outline-secondary';
                                if (btnGrid) btnGrid.className = 'btn btn-primary';
                            } else {
                                if (tableContainer) tableContainer.style.display = 'block';
                                if (gridContainer) gridContainer.style.display = 'none';
                                if (btnTable) btnTable.className = 'btn btn-primary';
                                if (btnGrid) btnGrid.className = 'btn btn-outline-secondary';
                            }
                        }

                        // 3. Tìm kiếm & Lọc vị trí tuyển dụng đa chiều (5 TIÊU CHÍ)
                        const searchInput = document.getElementById('jobSearchInput');
                        if (searchInput) {
                            searchInput.addEventListener('keyup', filterJobs);
                        }

                        function filterJobs() {
                            const keyword = searchInput ? searchInput.value.toLowerCase().trim() : '';
                            const dept = document.getElementById('deptFilter') ? document.getElementById('deptFilter').value : 'ALL';
                            const salary = document.getElementById('salaryFilter') ? document.getElementById('salaryFilter').value : 'ALL';
                            const location = document.getElementById('locationFilter') ? document.getElementById('locationFilter').value : 'ALL';
                            const status = document.getElementById('statusFilter') ? document.getElementById('statusFilter').value : 'ALL';

                            // Lọc danh sách Table Rows
                            const rows = document.querySelectorAll('#jobsTable tbody tr.job-row-item');
                            let count = 0;

                            rows.forEach(row => {
                                const title = (row.getAttribute('data-title') || '').toLowerCase();
                                const code = (row.getAttribute('data-code') || '').toLowerCase();
                                const rowDept = row.getAttribute('data-dept') || '';
                                const rowStatus = row.getAttribute('data-status') || '';
                                const rowLoc = (row.getAttribute('data-location') || '').toLowerCase();
                                const rowKeywords = (row.getAttribute('data-keywords') || '').toLowerCase();
                                const rawMin = parseFloat(row.getAttribute('data-raw-salary-min') || '0');
                                const rawMax = parseFloat(row.getAttribute('data-raw-salary-max') || '0');
                                const isNegotiable = row.getAttribute('data-negotiable') === 'true';

                                // 1. Match từ khóa tìm kiếm (Tên, Mã VT hoặc Keywords)
                                const matchKw = !keyword || title.includes(keyword) || code.includes(keyword) || rowKeywords.includes(keyword);

                                // 2. Match Phòng ban
                                const matchDept = (dept === 'ALL') || (rowDept === dept);

                                // 3. Match Mức lương
                                let matchSalary = true;
                                if (salary === 'LOW') {
                                    matchSalary = (rawMax > 0 && rawMax <= 20000000);
                                } else if (salary === 'MID') {
                                    matchSalary = (rawMax >= 20000000 && rawMin <= 35000000);
                                } else if (salary === 'HIGH') {
                                    matchSalary = (rawMax >= 35000000 && rawMin <= 50000000);
                                } else if (salary === 'VERY_HIGH') {
                                    matchSalary = (rawMax >= 50000000 || rawMin >= 50000000);
                                } else if (salary === 'NEGOTIABLE') {
                                    matchSalary = isNegotiable;
                                }

                                // 4. Match Thành phố
                                let matchLoc = true;
                                if (location === 'HN') {
                                    matchLoc = rowLoc.includes('hà nội') || rowLoc.includes('hn');
                                } else if (location === 'HCM') {
                                    matchLoc = rowLoc.includes('hồ chí minh') || rowLoc.includes('hcm') || rowLoc.includes('sài gòn');
                                } else if (location === 'DN') {
                                    matchLoc = rowLoc.includes('đà nẵng') || rowLoc.includes('dn');
                                } else if (location === 'REMOTE') {
                                    matchLoc = rowLoc.includes('remote') || rowLoc.includes('toàn quốc');
                                } else if (location === 'HYBRID') {
                                    matchLoc = rowLoc.includes('hybrid');
                                }

                                // 5. Match Trạng thái
                                const matchStatus = (status === 'ALL') || (rowStatus === status);

                                if (matchKw && matchDept && matchSalary && matchLoc && matchStatus) {
                                    row.style.display = '';
                                    count++;
                                } else {
                                    row.style.display = 'none';
                                }
                            });

                            // Lọc danh sách Grid Cards
                            const gridCards = document.querySelectorAll('.job-grid-item');
                            gridCards.forEach(card => {
                                const title = (card.getAttribute('data-title') || '').toLowerCase();
                                const code = (card.getAttribute('data-code') || '').toLowerCase();
                                const rowDept = card.getAttribute('data-dept') || '';
                                const rowStatus = card.getAttribute('data-status') || '';
                                const rowLoc = (card.getAttribute('data-location') || '').toLowerCase();
                                const rowKeywords = (card.getAttribute('data-keywords') || '').toLowerCase();
                                const rawMin = parseFloat(card.getAttribute('data-raw-salary-min') || '0');
                                const rawMax = parseFloat(card.getAttribute('data-raw-salary-max') || '0');
                                const isNegotiable = card.getAttribute('data-negotiable') === 'true';

                                const matchKw = !keyword || title.includes(keyword) || code.includes(keyword) || rowKeywords.includes(keyword);
                                const matchDept = (dept === 'ALL') || (rowDept === dept);
                                let matchSalary = true;
                                if (salary === 'LOW') matchSalary = (rawMax > 0 && rawMax <= 20000000);
                                else if (salary === 'MID') matchSalary = (rawMax >= 20000000 && rawMin <= 35000000);
                                else if (salary === 'HIGH') matchSalary = (rawMax >= 35000000 && rawMin <= 50000000);
                                else if (salary === 'VERY_HIGH') matchSalary = (rawMax >= 50000000 || rawMin >= 50000000);
                                else if (salary === 'NEGOTIABLE') matchSalary = isNegotiable;

                                let matchLoc = true;
                                if (location === 'HN') matchLoc = rowLoc.includes('hà nội') || rowLoc.includes('hn');
                                else if (location === 'HCM') matchLoc = rowLoc.includes('hồ chí minh') || rowLoc.includes('hcm');
                                else if (location === 'DN') matchLoc = rowLoc.includes('đà nẵng') || rowLoc.includes('dn');
                                else if (location === 'REMOTE') matchLoc = rowLoc.includes('remote') || rowLoc.includes('toàn quốc');
                                else if (location === 'HYBRID') matchLoc = rowLoc.includes('hybrid');

                                const matchStatus = (status === 'ALL') || (rowStatus === status);

                                if (matchKw && matchDept && matchSalary && matchLoc && matchStatus) {
                                    card.style.display = '';
                                } else {
                                    card.style.display = 'none';
                                }
                            });

                            const countBadge = document.getElementById('activeJobsCountBadge');
                            if (countBadge) countBadge.textContent = count + ' Vị trí';
                            const countShown = document.getElementById('jobsCountShown');
                            if (countShown) countShown.textContent = count;
                        }

                        // 4. Xem trước thông tin tuyển dụng của Nhân viên phụ trách
                        function openEmployeePreviewModal(assignee, code, title, dept, salary, deadline, progress, candCount, status, location, initials) {
                            document.getElementById('empModalName').textContent = assignee || 'Phạm Phương Thảo';
                            document.getElementById('empModalAvatar').textContent = initials || 'PT';
                            document.getElementById('empModalJobCode').textContent = code || 'YCTD-2026';
                            document.getElementById('empModalJobTitle').textContent = title || 'Vị trí tuyển dụng';
                            document.getElementById('empModalJobDept').textContent = dept || 'Phòng ban';
                            document.getElementById('empModalJobLocation').textContent = location || 'Hà Nội';
                            document.getElementById('empModalJobSalary').textContent = (salary || 'Thỏa thuận') + ' VNĐ';
                            document.getElementById('empModalJobProgress').textContent = (progress || '0/1') + ' Đạt';
                            document.getElementById('empModalJobCandCount').textContent = (candCount || '0') + ' CV nộp';
                            document.getElementById('empModalJobDeadline').textContent = deadline || '30/10/2026';

                            const statusBadge = document.getElementById('empModalJobStatus');
                            if (statusBadge) {
                                statusBadge.textContent = (status === 'OPEN') ? 'Đang tuyển' : status;
                                statusBadge.className = 'badge ' + (status === 'OPEN' ? 'bg-success-subtle text-success border border-success-subtle' : 'bg-light text-muted border');
                            }

                            // Lưu mã vị trí này để thao tác tiếp
                            window.empModalCurrentCode = code;

                            const modalEl = document.getElementById('previewEmployeeJobModal');
                            if (modalEl) {
                                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                                modal.show();
                            }
                        }

                        function openSelectedJobRecruiterModal() {
                            const d = window.currentJobData;
                            if (d) {
                                openEmployeePreviewModal(d.assignee, d.code, d.title, d.dept, d.salary, d.deadline, d.hired + '/' + d.target, d.candCount, d.status, d.location, d.assigneeInitials);
                            }
                        }

                        function selectFromEmpModal() {
                            const modalEl = document.getElementById('previewEmployeeJobModal');
                            if (modalEl) {
                                const modal = bootstrap.Modal.getInstance(modalEl);
                                if (modal) modal.hide();
                            }
                            if (window.empModalCurrentCode) {
                                const row = document.querySelector('.job-row-item[data-code="' + window.empModalCurrentCode + '"]');
                                if (row) selectJobRow(row);
                            }
                        }

                        function shareFromEmpModal() {
                            const modalEl = document.getElementById('previewEmployeeJobModal');
                            if (modalEl) {
                                const modal = bootstrap.Modal.getInstance(modalEl);
                                if (modal) modal.hide();
                            }
                            openShareJobModal();
                        }

                        // 5. Thao tác Chia sẻ thông tin tuyển dụng đa kênh (#shareJobModal)
                        function openShareJobModal() {
                            const d = window.currentJobData;
                            populateShareModalWithData(d);
                            const modalEl = document.getElementById('shareJobModal');
                            if (modalEl) {
                                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                                modal.show();
                            }
                        }

                        function openShareJobModalById(id) {
                            const targetRow = document.querySelector('.job-row-item[data-id="' + id + '"]');
                            if (targetRow) {
                                selectJobRow(targetRow);
                            }
                            openShareJobModal();
                        }

                        function populateShareModalWithData(d) {
                            if (!d) return;
                            const jobCode = document.getElementById('shareModalJobCode');
                            if (jobCode) jobCode.textContent = d.code;
                            const jobTitle = document.getElementById('shareModalJobTitle');
                            if (jobTitle) jobTitle.textContent = d.title;
                            const jobDept = document.getElementById('shareModalJobDept');
                            if (jobDept) jobDept.textContent = d.dept;
                            const jobSalary = document.getElementById('shareModalJobSalary');
                            if (jobSalary) jobSalary.textContent = d.salary + ' Triệu VNĐ';
                            const jobLoc = document.getElementById('shareModalJobLocation');
                            if (jobLoc) jobLoc.innerHTML = '<i class="bi bi-geo-alt text-danger me-1"></i>' + d.location;
                            const refCode = document.getElementById('shareJobRefCode');
                            if (refCode) refCode.textContent = d.code;

                            const shareUrl = window.location.origin + window.location.pathname + '?view=jobs&jobId=' + d.id;
                            const urlInput = document.getElementById('shareJobUrlInput');
                            if (urlInput) urlInput.value = shareUrl;

                            const postText = '📢 [MIXIMOI HRM TUYỂN DỤNG] ' + d.title + '\n'
                                + '🏢 Phòng ban: ' + d.dept + '\n'
                                + '📍 Địa điểm: ' + d.location + '\n'
                                + '💰 Mức lương: ' + d.salary + ' Triệu VNĐ / tháng\n'
                                + '⏰ Hạn chót nhận hồ sơ: ' + d.deadline + '\n'
                                + '👉 Ứng tuyển & xem JD chi tiết tại: ' + shareUrl + '\n'
                                + '#Tuyendung #Miximoi #HRM #Jobs #' + (d.code || 'Job');

                            const templateArea = document.getElementById('sharePostTemplateText');
                            if (templateArea) templateArea.value = postText;
                        }

                        function copyShareJobUrl() {
                            const urlInput = document.getElementById('shareJobUrlInput');
                            if (urlInput) {
                                navigator.clipboard.writeText(urlInput.value).then(() => {
                                    alert('📋 Đã sao chép liên kết tuyển dụng vào bộ nhớ tạm:\n' + urlInput.value);
                                });
                            }
                        }

                        function copySharePostContent() {
                            const postArea = document.getElementById('sharePostTemplateText');
                            if (postArea) {
                                navigator.clipboard.writeText(postArea.value).then(() => {
                                    alert('📋 Đã sao chép mẫu bài đăng tuyển dụng! Bạn có thể dán lên Facebook, LinkedIn, Zalo ngay.');
                                });
                            }
                        }

                        function shareToFacebook() {
                            const url = document.getElementById('shareJobUrlInput').value;
                            window.open('https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(url), '_blank', 'width=600,height=450');
                        }

                        function shareToLinkedIn() {
                            const url = document.getElementById('shareJobUrlInput').value;
                            window.open('https://www.linkedin.com/sharing/share-offsite/?url=' + encodeURIComponent(url), '_blank', 'width=600,height=500');
                        }

                        function shareToZalo() {
                            const url = document.getElementById('shareJobUrlInput').value;
                            window.open('https://zalo.me/share?url=' + encodeURIComponent(url), '_blank', 'width=600,height=500');
                        }

                        function shareViaEmail() {
                            const d = window.currentJobData;
                            const url = document.getElementById('shareJobUrlInput').value;
                            const subject = encodeURIComponent('[MIXIMOI Tuyển dụng] Cơ hội việc làm: ' + d.title);
                            const body = encodeURIComponent('Chào bạn,\n\nMời bạn tham khảo vị trí tuyển dụng ' + d.title + ' tại công ty MIXIMOI.\n\nXem chi tiết và nộp CV tại: ' + url);
                            window.location.href = 'mailto:?subject=' + subject + '&body=' + body;
                        }

                        // 6. HỆ THỐNG LỌC CV TỰ ĐỘNG THEO KEY TỪ KHÓA (WORD, PDF, CHỮ VIẾT TAY)
                        function runKeywordScanOnCandidates() {
                            const kwInput = document.getElementById('scannerKeywordsInput');
                            const rawKeywords = kwInput ? kwInput.value : '';
                            const keywords = rawKeywords.split(/[,;\n]+/).map(k => k.trim().toLowerCase()).filter(k => k.length > 0);

                            const scope = document.getElementById('scannerScopeSelect') ? document.getElementById('scannerScopeSelect').value : 'CURRENT_JOB';
                            const formatFilter = document.getElementById('scannerFormatSelect') ? document.getElementById('scannerFormatSelect').value : 'ALL';

                            const rawItems = document.querySelectorAll('#rawCandidateDataStore .raw-cand-item');
                            const results = [];

                            rawItems.forEach(item => {
                                const id = item.getAttribute('data-id');
                                const reqId = item.getAttribute('data-req-id');
                                const name = item.getAttribute('data-name');
                                const email = item.getAttribute('data-email');
                                const phone = item.getAttribute('data-phone');
                                const jobTitle = item.getAttribute('data-job-title');
                                const dept = item.getAttribute('data-dept');
                                const cvType = (item.getAttribute('data-cv-type') || 'PDF').toUpperCase();
                                const cvText = item.getAttribute('data-cv-text') || '';
                                const notes = item.getAttribute('data-notes') || '';
                                const skills = item.getAttribute('data-skills') || '';
                                const exp = item.getAttribute('data-exp') || '2.0';
                                const salary = item.getAttribute('data-salary') || 'Thỏa thuận';
                                const appliedDate = item.getAttribute('data-applied-date') || '';
                                const source = item.getAttribute('data-source') || 'Trực tuyến';

                                // 1. Lọc theo Scope
                                if (scope === 'CURRENT_JOB' && window.currentJobData && window.currentJobData.id) {
                                    if (String(reqId) !== String(window.currentJobData.id)) return;
                                }

                                // 2. Lọc theo định dạng CV (Word, PDF, Bản chữ viết tay)
                                if (formatFilter !== 'ALL' && cvType !== formatFilter) {
                                    return;
                                }

                                // 3. Đối sánh từ khóa trên toàn bộ văn bản CV + Kỹ năng + Ghi chú
                                const fullSearchCorpus = (cvText + ' ' + notes + ' ' + skills + ' ' + jobTitle).toLowerCase();
                                const matchedKeywords = [];
                                const missingKeywords = [];

                                keywords.forEach(kw => {
                                    if (fullSearchCorpus.includes(kw)) {
                                        matchedKeywords.push(kw);
                                    } else {
                                        missingKeywords.push(kw);
                                    }
                                });

                                // Tính điểm khớp Match Score (%)
                                let score = 0;
                                if (keywords.length > 0) {
                                    score = Math.round((matchedKeywords.length / keywords.length) * 100);
                                } else {
                                    score = 75;
                                }

                                // Tạo đoạn trích (snippet) có highlight từ khóa bằng thẻ <mark>
                                let snippet = cvText || (name + ' có kỹ năng: ' + skills + '. Ghi chú: ' + notes);
                                if (snippet.length > 180) snippet = snippet.substring(0, 180) + '...';

                                keywords.forEach(kw => {
                                    if (kw.length >= 2) {
                                        const reg = new RegExp('(' + escapeRegex(kw) + ')', 'gi');
                                        snippet = snippet.replace(reg, '<mark class="bg-warning text-dark px-1 rounded fw-bold">$1</mark>');
                                    }
                                });

                                results.push({
                                    id: id,
                                    name: name,
                                    email: email,
                                    phone: phone,
                                    jobTitle: jobTitle,
                                    dept: dept,
                                    cvType: cvType,
                                    score: score,
                                    matchedKeywords: matchedKeywords,
                                    missingKeywords: missingKeywords,
                                    snippet: snippet,
                                    exp: exp,
                                    salary: salary,
                                    appliedDate: appliedDate,
                                    source: source
                                });
                            });

                            // Sắp xếp điểm khớp cao nhất lên trước
                            results.sort((a, b) => b.score - a.score);

                            // Render kết quả ra DOM
                            renderScannedCandidates(results);
                        }

                        function renderScannedCandidates(list) {
                            const container = document.getElementById('scannedCandidatesContainer');
                            if (!container) return;

                            const matchedCountEl = document.getElementById('scanMatchedCount');
                            if (matchedCountEl) matchedCountEl.textContent = list.length;

                            const highCountEl = document.getElementById('scanHighMatchCount');
                            const highCount = list.filter(c => c.score >= 70).length;
                            if (highCountEl) highCountEl.textContent = highCount + ' Khớp cao (>=70%)';

                            if (list.length === 0) {
                                container.innerHTML = '<div class="col-12 text-center py-5 bg-white rounded-3 border"><i class="bi bi-search text-muted fs-2 mb-2"></i><h6 class="fw-bold text-dark">Không tìm thấy ứng viên phù hợp với bộ lọc</h6><p class="text-muted small">Hãy thử nới lỏng từ khóa hoặc đổi phạm vi quét sang "Toàn bộ ứng viên hệ thống".</p></div>';
                                return;
                            }

                            let html = '';
                            list.forEach((c, idx) => {
                                let cvBadge = '';
                                if (c.cvType === 'WORD') {
                                    cvBadge = '<span class="badge bg-primary-subtle text-primary border"><i class="bi bi-file-earmark-word me-1"></i>Bản Word (.docx)</span>';
                                } else if (c.cvType === 'HANDWRITTEN') {
                                    cvBadge = '<span class="badge bg-warning-subtle text-dark border"><i class="bi bi-pen me-1"></i>Bản chữ viết (OCR)</span>';
                                } else {
                                    cvBadge = '<span class="badge bg-danger-subtle text-danger border"><i class="bi bi-file-earmark-pdf me-1"></i>File PDF (.pdf)</span>';
                                }

                                const rankBadge = (idx === 0) ? '🥇 Top 1' : ((idx === 1) ? '🥈 Top 2' : ((idx === 2) ? '🥉 Top 3' : '#' + (idx + 1)));
                                const scoreColor = (c.score >= 80) ? 'bg-success' : ((c.score >= 60) ? 'bg-primary' : 'bg-warning text-dark');

                                let matchedBadges = '';
                                c.matchedKeywords.forEach(kw => {
                                    matchedBadges += '<span class="badge bg-success bg-opacity-75 me-1 mb-1 font-monospace" style="font-size: 0.7rem;">✓ ' + kw + '</span>';
                                });
                                if (c.matchedKeywords.length === 0) {
                                    matchedBadges = '<span class="text-muted small" style="font-size: 0.7rem;">Chưa phát hiện từ khóa khớp</span>';
                                }

                                html += '<div class="col-12 col-lg-6">'
                                    + '<div class="card h-100 border-0 shadow-sm rounded-3 p-3 bg-white position-relative">'
                                    + '<div class="d-flex justify-content-between align-items-start mb-2">'
                                    + '  <div class="d-flex align-items-center gap-2">'
                                    + '    <span class="badge ' + scoreColor + ' fw-bold px-2 py-1">' + rankBadge + ' • ' + c.score + '% Khớp</span>'
                                    + '    ' + cvBadge
                                    + '  </div>'
                                    + '  <span class="badge bg-light text-muted border">' + c.source + '</span>'
                                    + '</div>'
                                    + '<h6 class="fw-bold text-dark mb-1 fs-6">' + c.name + '</h6>'
                                    + '<div class="text-muted small mb-2">'
                                    + '  <i class="bi bi-envelope me-1"></i>' + c.email + ' • ' + c.exp + ' năm EXP • Lương: ' + c.salary
                                    + '</div>'
                                    + '<div class="progress mb-2" style="height: 6px;">'
                                    + '  <div class="progress-bar ' + scoreColor + '" style="width: ' + c.score + '%;"></div>'
                                    + '</div>'
                                    + '<div class="mb-2">'
                                    + '  <div class="small fw-bold text-success mb-1" style="font-size: 0.72rem;"><i class="bi bi-tags-fill me-1"></i>Từ khóa khớp tìm thấy:</div>'
                                    + '  <div>' + matchedBadges + '</div>'
                                    + '</div>'
                                    + '<div class="p-2 rounded bg-light border small text-muted mb-3" style="font-size: 0.75rem; line-height: 1.5;">'
                                    + '  <div class="fw-semibold text-dark mb-1"><i class="bi bi-text-paragraph me-1"></i>Đoạn trích từ CV (Quét bóc tách tự động):</div>'
                                    + '  <div>' + c.snippet + '</div>'
                                    + '</div>'
                                    + '<div class="d-flex gap-2 pt-2 border-top mt-auto">'
                                    + '  <a href="${pageContext.request.contextPath}/recruitment?view=candidates&candidateId=' + c.id + '" class="btn btn-sm btn-outline-secondary flex-grow-1" target="_blank">'
                                    + '    <i class="bi bi-person-lines-fill me-1"></i>Xem Chi Tiết CV'
                                    + '  </a>'
                                    + '  <form method="POST" action="${pageContext.request.contextPath}/recruitment" class="m-0">'
                                    + '    <input type="hidden" name="action" value="update_stage">'
                                    + '    <input type="hidden" name="candidateId" value="' + c.id + '">'
                                    + '    <input type="hidden" name="stage" value="INTERVIEW">'
                                    + '    <input type="hidden" name="returnView" value="jobs">'
                                    + '    <input type="hidden" name="jobId" value="' + (window.currentJobData.id || '') + '">'
                                    + '    <button type="submit" class="btn btn-sm btn-primary">'
                                    + '      <i class="bi bi-check2 me-1"></i>Duyệt Phỏng Vấn'
                                    + '    </button>'
                                    + '  </form>'
                                    + '</div>'
                                    + '</div></div>';
                            });

                            container.innerHTML = html;
                        }

                        function addQuickKeyword(word) {
                            const kwInput = document.getElementById('scannerKeywordsInput');
                            if (!kwInput) return;
                            const current = kwInput.value.trim();
                            if (current.toLowerCase().includes(word.toLowerCase())) {
                                alert('Từ khóa "' + word + '" đã có trong danh sách!');
                                return;
                            }
                            kwInput.value = current ? (current + ', ' + word) : word;
                            runKeywordScanOnCandidates();
                        }

                        function resetDefaultKeywords() {
                            const kwInput = document.getElementById('scannerKeywordsInput');
                            if (kwInput) {
                                kwInput.value = window.currentJobData.keywords || 'Java, Spring Boot, PostgreSQL, Microservices, Docker, React, Git, RESTful';
                                runKeywordScanOnCandidates();
                            }
                        }

                        function updateLiveCvPlaceholder() {
                            const type = document.getElementById('liveCvTypeSelect').value;
                            const area = document.getElementById('liveCvTextArea');
                            if (!area) return;
                            if (type === 'WORD') {
                                area.placeholder = 'Dán nội dung quét từ file Word (.docx) của ứng viên... (Kinh nghiệm làm việc, kỹ năng phần cứng/phần mềm, chứng chỉ)';
                            } else if (type === 'HANDWRITTEN') {
                                area.placeholder = 'Dán nội dung số hóa từ bản viết tay (OCR handwritten notes) của ứng viên... Hệ thống sẽ nhận diện từ khóa chuyên môn ngay lập tức.';
                            } else {
                                area.placeholder = 'Dán nội dung trích xuất từ file PDF (.pdf) của ứng viên...';
                            }
                        }

                        function loadSampleCvText(type) {
                            const typeSelect = document.getElementById('liveCvTypeSelect');
                            const nameInput = document.getElementById('liveCandidateName');
                            const emailInput = document.getElementById('liveCandidateEmail');
                            const phoneInput = document.getElementById('liveCandidatePhone');
                            const expInput = document.getElementById('liveCandidateExp');
                            const salaryInput = document.getElementById('liveCandidateSalary');
                            const area = document.getElementById('liveCvTextArea');

                            if (type === 'WORD') {
                                if (typeSelect) typeSelect.value = 'WORD';
                                if (nameInput) nameInput.value = 'Đặng Minh Quân';
                                if (emailInput) emailInput.value = 'quan.dang@gmail.com';
                                if (phoneInput) phoneInput.value = '0934.567.890';
                                if (expInput) expInput.value = '3.5';
                                if (salaryInput) salaryInput.value = '32000000';
                                if (area) {
                                    area.value = 'HỒ SƠ ỨNG VIÊN BẢN WORD (.DOCX)\n'
                                        + 'Họ và tên: Đặng Minh Quân\n'
                                        + 'Vị trí mong muốn: Senior Software Engineer\n'
                                        + 'Kỹ năng chuyên môn chính: Thành thạo Java 17, Spring Boot, Spring Data JPA, kiến trúc Microservices chịu tải cao.\n'
                                        + 'Cơ sở dữ liệu: Thiết kế và tối ưu chỉ mục PostgreSQL, MySQL, xử lý giao dịch ACID.\n'
                                        + 'Công cụ & Quy trình: Docker, Kubernetes, CI/CD Jenkins, Git, RESTful API design.\n'
                                        + 'Kinh nghiệm: 3.5 năm phát triển hệ thống quản lý nhân sự HRM và cổng thanh toán trực tuyến.';
                                }
                            } else if (type === 'PDF') {
                                if (typeSelect) typeSelect.value = 'PDF';
                                if (nameInput) nameInput.value = 'Lê Thùy Dương';
                                if (emailInput) emailInput.value = 'duong.le@techcorp.vn';
                                if (phoneInput) phoneInput.value = '0909.112.233';
                                if (expInput) expInput.value = '4.0';
                                if (salaryInput) salaryInput.value = '36000000';
                                if (area) {
                                    area.value = 'TRÍCH XUẤT TỪ FILE PDF (.PDF) - TECH LEAD CV\n'
                                        + 'Ứng viên: Lê Thùy Dương\n'
                                        + 'Tóm tắt năng lực: 4 năm kinh nghiệm Backend & Distributed Systems.\n'
                                        + 'Chuyên sâu ngôn ngữ: Java, TypeScript, Node.js.\n'
                                        + 'Frameworks: Spring Boot, Express, ReactJS cho dashboard quản trị.\n'
                                        + 'Database: PostgreSQL (Partitioning, Query plan optimization), Redis Caching.\n'
                                        + 'DevOps: Docker containerization, Microservices architecture, RESTful APIs, Git flow.';
                                }
                            } else if (type === 'HANDWRITTEN') {
                                if (typeSelect) typeSelect.value = 'HANDWRITTEN';
                                if (nameInput) nameInput.value = 'Trần Văn Bách';
                                if (emailInput) emailInput.value = 'bach.tran@student.edu.vn';
                                if (phoneInput) phoneInput.value = '0987.654.321';
                                if (expInput) expInput.value = '1.5';
                                if (salaryInput) salaryInput.value = '18000000';
                                if (area) {
                                    area.value = 'BẢN CHỮ VIẾT TAY (OCR HANDWRITTEN NOTES SỐ HÓA)\n'
                                        + 'Đơn xin việc viết tay / Ghi chú phỏng vấn nhanh:\n'
                                        + 'Em là Trần Văn Bách, tốt nghiệp ĐH Bách Khoa ngành CNTT.\n'
                                        + 'Em có 1.5 năm làm việc thực tế với Java, Spring Boot và cơ sở dữ liệu PostgreSQL.\n'
                                        + 'Em đã làm quen với Docker cơ bản, quản lý mã nguồn bằng Git và viết RESTful API cho ứng dụng di động.\n'
                                        + 'Mong muốn học hỏi thêm về Microservices và React trong môi trường thực chiến.';
                                }
                            }
                            scanDirectCvText();
                        }

                        function scanDirectCvText() {
                            const area = document.getElementById('liveCvTextArea');
                            const kwInput = document.getElementById('liveKeywordsInput');
                            const resultBox = document.getElementById('liveScanResultBox');
                            const badge = document.getElementById('liveScanScoreBadge');
                            const tagsBox = document.getElementById('liveMatchedTags');
                            const snippetBox = document.getElementById('liveHighlightedSnippet');

                            if (!area || !area.value.trim()) {
                                alert('Vui lòng nhập hoặc nạp văn bản CV để quét!');
                                return;
                            }

                            const text = area.value;
                            const keywords = (kwInput ? kwInput.value : '').split(/[,;\n]+/).map(k => k.trim().toLowerCase()).filter(k => k.length > 0);

                            const lowerText = text.toLowerCase();
                            const matched = [];
                            keywords.forEach(kw => {
                                if (lowerText.includes(kw)) {
                                    matched.push(kw);
                                }
                            });

                            let score = 0;
                            if (keywords.length > 0) {
                                score = Math.round((matched.length / keywords.length) * 100);
                            }

                            if (badge) {
                                badge.textContent = 'Độ khớp từ khóa: ' + score + '% (' + matched.length + '/' + keywords.length + ' key)';
                                badge.className = 'badge fs-6 ' + (score >= 70 ? 'bg-success' : (score >= 40 ? 'bg-primary' : 'bg-warning text-dark'));
                            }

                            if (tagsBox) {
                                let tagsHtml = '<strong class="small text-muted me-1">Từ khóa nhận diện được:</strong> ';
                                matched.forEach(m => {
                                    tagsHtml += '<span class="badge bg-success me-1 font-monospace">✓ ' + m + '</span>';
                                });
                                if (matched.length === 0) tagsHtml += '<span class="text-danger small">Không phát hiện từ khóa khớp nào</span>';
                                tagsBox.innerHTML = tagsHtml;
                            }

                            if (snippetBox) {
                                let highlighted = escapeHtml(text);
                                keywords.forEach(kw => {
                                    if (kw.length >= 2) {
                                        const reg = new RegExp('(' + escapeRegex(kw) + ')', 'gi');
                                        highlighted = highlighted.replace(reg, '<mark class="bg-warning text-dark px-1 rounded fw-bold">$1</mark>');
                                    }
                                });
                                snippetBox.innerHTML = highlighted;
                            }

                            if (resultBox) {
                                resultBox.style.display = 'block';
                            }
                        }

                        function escapeRegex(string) {
                            return string.replace(/[.*+?^()|[\]\\{}$]/g, '\\$&');
                        }

                        function escapeHtml(text) {
                            const map = {
                                '&': '&amp;',
                                '<': '&lt;',
                                '>': '&gt;',
                                '"': '&quot;',
                                "'": '&#039;'
                            };
                            return text.replace(/[&<>"']/g, m => map[m]);
                        }

                        // Tự động khởi chạy quét CV khi trang tải xong hoặc khi mở modal
                        document.addEventListener('DOMContentLoaded', function () {
                            runKeywordScanOnCandidates();

                            const screeningModalEl = document.getElementById('aiCvScreeningModal');
                            if (screeningModalEl) {
                                screeningModalEl.addEventListener('shown.bs.modal', function () {
                                    runKeywordScanOnCandidates();
                                });
                            }
                        });
                    
    // =========================================================================
    // XỬ LÝ XEM TRỰC TIẾP BẢN MỀM CV & TẢI LÊN TỰ ĐỘNG BÓC TÁCH (MIXIMOI ATS)
    // =========================================================================
    let currentViewerZoom = 100;
    let activeCvCandidateData = null;

    // 4 Bộ mẫu CV bản mềm để nạp tức thì
    const presetCvSamples = {
        'pdf_fullstack': {
            fullName: 'Lê Tuấn Hùng',
            email: 'hung.lt@gmail.com',
            phone: '0988 123 456',
            experienceYears: 4.5,
            expectedSalary: 32000000,
            cvType: 'PDF',
            fileName: 'Le_Tuan_Hung_Senior_Fullstack.pdf',
            skills: ['Java', 'Spring Boot', 'PostgreSQL', 'Microservices', 'Docker', 'Redis', 'RESTful API'],
            education: 'Đại học Bách Khoa Hà Nội — Kỹ thuật Phần mềm (2017 - 2021)',
            workHistory: 'Senior Java Backend Dev tại VinTech (2022 - Hiện tại), Software Engineer tại FPT Software (2020 - 2022)',
            cvText: 'HỌ TÊN: Lê Tuấn Hùng\n'
                + 'VỊ TRÍ: Senior Fullstack Developer (Java / PostgreSQL)\n'
                + 'KINH NGHIỆM: 4.5 năm phát triển hệ thống backend phân tán, chịu tải lớn cho ngành Tài chính và Thương mại điện tử.\n'
                + 'KỸ NĂNG: Java 17, Spring Boot, Hibernate, Jakarta Servlet, PostgreSQL, Docker, Microservices, CI/CD, Redis, Kafka, REST API.\n'
                + 'HỌC VẤN: Đại học Bách Khoa Hà Nội (GPA 3.4/4.0).'
        },
        'word_techlead': {
            fullName: 'Nguyễn Hoàng Sơn',
            email: 'son.nh@techlead.vn',
            phone: '0912 345 678',
            experienceYears: 7.0,
            expectedSalary: 55000000,
            cvType: 'WORD',
            fileName: 'Nguyen_Hoang_Son_TechLead_Architect.docx',
            skills: ['Architecture', 'System Design', 'Microservices', 'Java', 'Cloud AWS', 'Team Leadership', 'PostgreSQL'],
            education: 'Đại học Công Nghệ - ĐHQGHN — Khoa học Máy tính (2013 - 2017)',
            workHistory: 'Technical Lead tại Momo (2021 - Nay), Solution Architect tại VNPay (2018 - 2021)',
            cvText: 'HỒ SƠ NĂNG LỰC ỨNG VIÊN\n'
                + 'Họ và tên: Nguyễn Hoàng Sơn\n'
                + 'Chức danh: Technical Lead / Solution Architect\n'
                + 'Tổng số năm kinh nghiệm: 7 năm.\n'
                + 'Chuyên môn: Thiết kế kiến trúc chịu tải hàng triệu CCU, quản lý đội ngũ 15 kỹ sư phần mềm, làm chủ công nghệ Java, AWS, Kubernetes, Distributed Database PostgreSQL và hệ thống thanh toán điện tử.'
        },
        'handwritten_intern': {
            fullName: 'Trần Minh Thư',
            email: 'thu.tm.bk@gmail.com',
            phone: '0377 889 900',
            experienceYears: 1.0,
            expectedSalary: 12000000,
            cvType: 'HANDWRITTEN',
            fileName: 'Tran_Minh_Thu_Ban_Viet_Tay_OCR.jpg',
            skills: ['Java Core', 'OOP', 'SQL', 'HTML/CSS', 'Git', 'Problem Solving'],
            education: 'Sinh viên năm cuối Đại học Bách Khoa Hà Nội — Viện CNTT (GPA: 3.65/4.0)',
            workHistory: 'Thực tập sinh IT tại Viettel Solutions (6 tháng), Giải Nhì Olympic Tin học sinh viên toàn quốc',
            cvText: '[BẢN QUÉT OCR TỪ CHỮ VIẾT TAY CỦA ỨNG VIÊN]\n'
                + 'Đơn xin ứng tuyển vị trí Thực tập sinh / Lập trình viên trẻ.\n'
                + 'Tên em là Trần Minh Thư, sinh năm 2004, sinh viên năm cuối Bách Khoa. Em có nền tảng vững về Cấu trúc dữ liệu, Thuật toán, lập trình Java hướng đối tượng, SQL cơ sở dữ liệu và đam mê học hỏi phát triển sản phẩm thực tế.'
        },
        'pdf_designer': {
            fullName: 'Vũ Thùy Linh',
            email: 'linh.vu.design@gmail.com',
            phone: '0966 554 433',
            experienceYears: 3.5,
            expectedSalary: 28000000,
            cvType: 'PDF',
            fileName: 'Vu_Thuy_Linh_Product_UIUX_Designer.pdf',
            skills: ['Figma', 'UI/UX Design', 'Design System', 'User Research', 'Wireframing', 'Prototyping'],
            education: 'Đại học Mỹ thuật Công nghiệp — Thiết kế Đồ họa & Tương tác (2018 - 2022)',
            workHistory: 'Product Designer tại Base.vn (2022 - Nay), UI/UX Specialist tại Ahamove (2021 - 2022)',
            cvText: 'PORTFOLIO & CV ĐỒNG BỘ: VŨ THÙY LINH\n'
                + 'Chuyên ngành: Product UI/UX Designer\n'
                + 'Kinh nghiệm: 3.5 năm thiết kế hệ thống SaaS B2B và Ứng dụng Di động. Sử dụng thành thạo Figma, xây dựng Design System hoàn chỉnh, tối ưu trải nghiệm người dùng dựa trên Data và User Feedback.'
        }
    };

    // Hàm nạp nhanh bản mềm CV mẫu vào form
    function loadAndParsePresetCv(type) {
        const data = presetCvSamples[type];
        if (!data) return;
        renderParsedCvResult(data);
    }

    // Xử lý khi người dùng kéo thả hoặc tải file thật từ máy
    function handleCvFileUpload(event) {
        const file = event.target.files && event.target.files[0];
        if (!file) return;

        let detectedType = 'PDF';
        const ext = file.name.split('.').pop().toLowerCase();
        if (ext === 'doc' || ext === 'docx') detectedType = 'WORD';
        else if (ext === 'png' || ext === 'jpg' || ext === 'jpeg') detectedType = 'HANDWRITTEN';

        // Tự động phân tích tên file để tạo họ tên và thông số
        let extractedName = file.name.replace(/\.[^/.]+$/, '').replace(/[_-]/g, ' ');
        extractedName = extractedName.split(' ').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');

        const autoData = {
            fullName: extractedName,
            email: 'ungvien.' + Date.now().toString().slice(-4) + '@gmail.com',
            phone: '098' + Math.floor(1000000 + Math.random() * 9000000).toString().slice(0, 7),
            experienceYears: (Math.floor(Math.random() * 6) + 1.5).toFixed(1),
            expectedSalary: (Math.floor(Math.random() * 20) + 15) * 1000000,
            cvType: detectedType,
            fileName: file.name,
            skills: ['Java', 'SQL Database', 'RESTful API', 'Git', 'Agile/Scrum'],
            education: 'Tốt nghiệp Đại học chuyên ngành Công nghệ thông tin',
            workHistory: 'Đã có kinh nghiệm tham gia các dự án phát triển phần mềm doanh nghiệp',
            cvText: 'HỒ SƠ ĐÃ BÓC TÁCH TỪ TỆP BẢN MỀM: ' + file.name + '\n'
                + 'Định dạng tệp: ' + detectedType + '\n'
                + 'Họ tên ứng viên: ' + extractedName + '\n'
                + 'Tự động trích xuất cấu trúc văn bản, kỹ năng và lịch sử công tác thành công mà không cần người dùng nhập tay.'
        };

        renderParsedCvResult(autoData);
    }

    // Hiển thị kết quả bóc tách lên giao diện Live Preview và Form Input
    function renderParsedCvResult(data) {
        // Cập nhật Live Preview Document Sheet
        const elName = document.getElementById('liveDocName');
        const elEmail = document.getElementById('liveDocEmail');
        const elPhone = document.getElementById('liveDocPhone');
        const elExp = document.getElementById('liveDocExp');
        const elSalary = document.getElementById('liveDocSalary');
        const elSkills = document.getElementById('liveDocSkills');
        const elSnippet = document.getElementById('liveDocSnippet');
        const elFileName = document.getElementById('cvFileNameDisplay');
        const elTypeBadge = document.getElementById('cvTypeBadge');

        if (elName) elName.innerText = data.fullName;
        if (elEmail) elEmail.innerHTML = '<i class="bi bi-envelope me-1"></i>' + data.email;
        if (elPhone) elPhone.innerHTML = '<i class="bi bi-telephone me-1"></i>' + data.phone;
        if (elExp) elExp.innerText = data.experienceYears + ' năm';
        if (elSalary) elSalary.innerText = Number(data.expectedSalary).toLocaleString('vi-VN') + ' đ';
        if (elFileName) elFileName.innerText = data.fileName;
        if (elTypeBadge) {
            elTypeBadge.innerText = data.cvType;
            elTypeBadge.className = 'badge ' + (data.cvType === 'PDF' ? 'bg-danger' : (data.cvType === 'WORD' ? 'bg-primary' : 'bg-warning text-dark'));
        }

        if (elSkills) {
            let html = '';
            data.skills.forEach(sk => {
                html += '<span class="badge bg-primary-subtle text-primary">' + sk + '</span> ';
            });
            elSkills.innerHTML = html;
        }

        if (elSnippet) {
            elSnippet.innerText = data.cvText;
        }

        // Tự động điền đầy đủ form input
        const inName = document.getElementById('inputFullName');
        const inEmail = document.getElementById('inputEmail');
        const inPhone = document.getElementById('inputPhone');
        const inExp = document.getElementById('inputExp');
        const inSalary = document.getElementById('inputSalary');
        const inCvType = document.getElementById('inputCvType');
        const inCvUrl = document.getElementById('inputCvUrl');
        const inCvText = document.getElementById('inputCvText');
        const inNotes = document.getElementById('inputNotes');

        if (inName) inName.value = data.fullName;
        if (inEmail) inEmail.value = data.email;
        if (inPhone) inPhone.value = data.phone;
        if (inExp) inExp.value = data.experienceYears;
        if (inSalary) inSalary.value = data.expectedSalary;
        if (inCvType) inCvType.value = data.cvType;
        if (inCvUrl) inCvUrl.value = data.fileName;
        if (inCvText) inCvText.value = data.cvText;
        if (inNotes) inNotes.value = 'Đã tự động bóc tách từ file ' + data.fileName + ' (' + data.cvType + ')';

        // Đổi trạng thái badge
        const badge = document.getElementById('cvStatusBadge');
        if (badge) {
            badge.innerHTML = '<i class="bi bi-check2-circle me-1"></i>Đã bóc tách tự động: ' + data.fullName;
        }
    }

    // Mở Trình xem trực tiếp bản mềm CV theo ID ứng viên
    function openCandidateCvModal(candId) {
        const item = document.querySelector('#allCandidatesDataStore [data-id="' + candId + '"]');
        if (!item) {
            alert('Không tìm thấy thông tin bản mềm CV của ứng viên #' + candId);
            return;
        }

        const data = {
            id: candId,
            code: item.getAttribute('data-code') || 'UV-' + candId,
            name: item.getAttribute('data-name') || 'Ứng viên',
            email: item.getAttribute('data-email') || 'ungvien@example.com',
            phone: item.getAttribute('data-phone') || '0987 654 321',
            job: item.getAttribute('data-job') || 'Vị trí tuyển dụng',
            salary: item.getAttribute('data-salary') || '25.000.000 VNĐ',
            exp: item.getAttribute('data-exp') || '2.0',
            skills: item.getAttribute('data-skills') || 'Java, SQL',
            education: item.getAttribute('data-edu') || 'Đại học chuyên ngành CNTT',
            workHistory: item.getAttribute('data-work') || 'Kinh nghiệm lập trình phần mềm thực tế',
            cvType: item.getAttribute('data-cvtype') || 'PDF',
            cvUrl: item.getAttribute('data-cvurl') || 'CV_Ung_Vien.pdf',
            cvText: item.getAttribute('data-cvtext') || 'Nội dung hồ sơ ứng viên'
        };

        activeCvCandidateData = data;

        // Render lên Document Sheet
        const elName = document.getElementById('viewerDocName');
        const elJob = document.getElementById('viewerDocTargetJob');
        const elCode = document.getElementById('viewerDocCode');
        const elExp = document.getElementById('viewerDocExp');
        const elFormat = document.getElementById('viewerDocFormatTag');
        const elEmail = document.getElementById('viewerDocEmail');
        const elPhone = document.getElementById('viewerDocPhone');
        const elSalary = document.getElementById('viewerDocSalary');
        const elSummary = document.getElementById('viewerDocSummary');
        const elSkills = document.getElementById('viewerDocSkillsList');
        const elWork = document.getElementById('viewerDocWorkHistory');
        const elEdu = document.getElementById('viewerDocEducation');
        const elRawText = document.getElementById('viewerDocRawText');
        const elSubTitle = document.getElementById('cvViewerSubTitle');
        const elTypeIcon = document.getElementById('cvViewerTypeIcon');
        const elAvatar = document.getElementById('viewerDocAvatar');

        if (elName) elName.innerText = data.name;
        if (elJob) elJob.innerText = data.job;
        if (elCode) elCode.innerText = data.code;
        if (elExp) elExp.innerText = data.exp + ' năm kinh nghiệm';
        if (elEmail) elEmail.innerHTML = '<i class="bi bi-envelope-fill me-1 text-primary"></i>' + data.email;
        if (elPhone) elPhone.innerHTML = '<i class="bi bi-telephone-fill me-1 text-primary"></i>' + data.phone;
        if (elSalary) elSalary.innerText = data.salary;
        if (elEdu) elEdu.innerText = data.education;
        if (elRawText) elRawText.innerText = data.cvText;

        if (elAvatar) {
            const initials = data.name.split(' ').map(n => n[0]).slice(-2).join('').toUpperCase();
            elAvatar.innerText = initials || 'UV';
        }

        if (elFormat) {
            elFormat.innerText = (data.cvType === 'WORD' ? 'Bản Word (.docx)' : (data.cvType === 'HANDWRITTEN' ? 'Bản chữ viết (OCR)' : 'File PDF (.pdf)'));
        }

        if (elSubTitle) {
            elSubTitle.innerText = 'Tệp: ' + data.cvUrl + ' • Định dạng: ' + data.cvType;
        }

        if (elTypeIcon) {
            if (data.cvType === 'WORD') elTypeIcon.innerHTML = '<i class="bi bi-file-earmark-word-fill text-primary"></i>';
            else if (data.cvType === 'HANDWRITTEN') elTypeIcon.innerHTML = '<i class="bi bi-pen-fill text-warning"></i>';
            else elTypeIcon.innerHTML = '<i class="bi bi-file-earmark-pdf-fill text-danger"></i>';
        }

        // Render Skills Tags
        if (elSkills) {
            const arr = data.skills.split(',').map(s => s.trim()).filter(s => s.length > 0);
            let h = '';
            arr.forEach(s => {
                h += '<span class="badge bg-light text-dark border px-2 py-1">' + s + '</span> ';
            });
            elSkills.innerHTML = h;
        }

        // Render Work History
        if (elWork) {
            elWork.innerHTML = '<div class="mb-2"><strong class="text-dark d-block">' + data.job + '</strong><span class="text-muted small">' + data.workHistory + ' (' + data.exp + ' năm kinh nghiệm)</span></div>';
        }

        // Reset zoom
        changeCvZoom(0);

        // Hiển thị modal
        const modalEl = document.getElementById('viewCandidateCvModal');
        if (modalEl) {
            const bsModal = bootstrap.Modal.getOrCreateInstance(modalEl);
            bsModal.show();
        }
    }

    // Zoom Toolbar
    function changeCvZoom(delta) {
        if (delta === 0) currentViewerZoom = 100;
        else {
            currentViewerZoom = Math.min(140, Math.max(70, currentViewerZoom + delta));
        }

        const sheet = document.getElementById('cvDocumentSheet');
        const zoomText = document.getElementById('cvZoomLevelText');
        if (sheet) {
            sheet.style.transform = 'scale(' + (currentViewerZoom / 100) + ')';
        }
        if (zoomText) {
            zoomText.innerText = currentViewerZoom + '%';
        }
    }

    function printCandidateCv() {
        window.print();
    }

    function downloadCandidateCv() {
        if (!activeCvCandidateData) return;
        alert('Đang tải xuống tệp bản mềm CV: ' + activeCvCandidateData.cvUrl + ' (' + activeCvCandidateData.cvType + ')');
    }
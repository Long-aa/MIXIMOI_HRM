/**
 * MIXIMOI HRM — EMPLOYEE LIST SCRIPTS (employee-list.js)
 */
// Check all rows
    document.getElementById('checkAll').addEventListener('change', function() {
        document.querySelectorAll('.row-check').forEach(cb => cb.checked = this.checked);
    });

    function confirmDelete(btn) {
        const id   = btn.getAttribute('data-id');
        const name = btn.getAttribute('data-name');
        document.getElementById('deleteEmpId').value = id;
        document.getElementById('deleteEmpName').textContent = name;
        new bootstrap.Modal(document.getElementById('deleteModal')).show();
    }

    // Import Modal: drag/drop & live preview
    (function() {
        const dropArea = document.getElementById('dropArea');
        const fileInput = document.getElementById('fileInput');
        const btnSubmitImport = document.getElementById('btnSubmitImport');
        const previewContainer = document.getElementById('previewContainer');
        const previewCount = document.getElementById('previewCount');
        const previewThead = document.getElementById('previewThead');
        const previewTbody = document.getElementById('previewTbody');
        const btnRemoveFile = document.getElementById('btnRemoveFile');
        const fileLabelTitle = document.getElementById('fileLabelTitle');
        const fileLabelDesc = document.getElementById('fileLabelDesc');

        if (!dropArea || !fileInput) return;

        dropArea.addEventListener('click', () => fileInput.click());

        ['dragenter', 'dragover'].forEach(eventName => {
            dropArea.addEventListener(eventName, (e) => {
                e.preventDefault();
                e.stopPropagation();
                dropArea.style.borderColor = '#2563eb';
                dropArea.style.background = '#eff6ff';
            }, false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, (e) => {
                e.preventDefault();
                e.stopPropagation();
                dropArea.style.borderColor = '#cbd5e1';
                dropArea.style.background = '#f8fafc';
            }, false);
        });

        dropArea.addEventListener('drop', (e) => {
            const dt = e.dataTransfer;
            const files = dt.files;
            if (files.length > 0) {
                fileInput.files = files;
                handleFileSelected(files[0]);
            }
        });

        fileInput.addEventListener('change', function() {
            if (this.files.length > 0) {
                handleFileSelected(this.files[0]);
            }
        });

        if (btnRemoveFile) {
            btnRemoveFile.addEventListener('click', () => {
                fileInput.value = '';
                previewContainer.classList.add('d-none');
                btnSubmitImport.disabled = true;
                fileLabelTitle.textContent = 'Nhấn để chọn file hoặc kéo thả vào đây';
                fileLabelDesc.textContent = 'Hỗ trợ file định dạng CSV, TXT (UTF-8, dung lượng tối đa 10MB)';
            });
        }

        function parseLine(line, delim) {
            let result = [];
            let cur = '';
            let inQuotes = false;
            for (let i = 0; i < line.length; i++) {
                let c = line[i];
                if (c === '"') {
                    inQuotes = !inQuotes;
                } else if (c === delim && !inQuotes) {
                    result.push(cur.trim());
                    cur = '';
                } else {
                    cur += c;
                }
            }
            result.push(cur.trim());
            return result;
        }

        function handleFileSelected(file) {
            if (!file) return;
            fileLabelTitle.textContent = file.name;
            fileLabelDesc.textContent = (file.size / 1024).toFixed(1) + ' KB';
            btnSubmitImport.disabled = false;

            const reader = new FileReader();
            reader.onload = function(e) {
                const text = e.target.result;
                const lines = text.split(/\r?\n/).filter(l => l.trim().length > 0);
                if (lines.length > 0) {
                    const delim = lines[0].includes(';') && !lines[0].includes(',') ? ';' : ',';
                    const headerCols = parseLine(lines[0], delim);
                    
                    previewThead.innerHTML = '';
                    headerCols.forEach(col => {
                        const th = document.createElement('th');
                        th.textContent = col.replace(/"/g, '');
                        previewThead.appendChild(th);
                    });

                    previewTbody.innerHTML = '';
                    const sampleLines = lines.slice(1, 6);
                    sampleLines.forEach(line => {
                        const rowCols = parseLine(line, delim);
                        const tr = document.createElement('tr');
                        rowCols.forEach(col => {
                            const td = document.createElement('td');
                            td.textContent = col.replace(/"/g, '');
                            tr.appendChild(td);
                        });
                        previewTbody.appendChild(tr);
                    });

                    previewCount.textContent = (lines.length - 1);
                    previewContainer.classList.remove('d-none');
                }
            };
            reader.readAsText(file, 'UTF-8');
        }
    })();

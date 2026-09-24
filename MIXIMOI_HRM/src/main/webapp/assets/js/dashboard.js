/**
 * MIXIMOI HRM & PAYROLL — Master Dashboard Controller Scripts
 * Chart.js configurations, custom canvas rendering plugins & interactive dashboard controls.
 */

document.addEventListener('DOMContentLoaded', () => {
    initPersonnelChart();
    initDepartmentDonutChart();
    initRefreshButtons();
    initActionButtons();
    initPersonnelStructureTabs();
});

let personnelChartInstance = null;
let departmentChartInstance = null;

/**
 * 1. Biến động nhân sự (Area Spline Chart with Custom Top Badges)
 * Đọc dữ liệu thực tế từ window.dashboardChartData.growthTrend
 */
function initPersonnelChart() {
    const ctx = document.getElementById('personnelGrowthChart');
    if (!ctx) return;

    const chartCtx = ctx.getContext('2d');

    // Smooth gradient under spline curve
    const gradient = chartCtx.createLinearGradient(0, 0, 0, 270);
    gradient.addColorStop(0, 'rgba(37, 99, 235, 0.28)');
    gradient.addColorStop(0.7, 'rgba(37, 99, 235, 0.08)');
    gradient.addColorStop(1, 'rgba(37, 99, 235, 0.00)');

    let chartLabels = ['Tháng 04', 'Tháng 05', 'Tháng 06', 'Tháng 07', 'Tháng 08', 'Tháng 09 (Hiện tại)'];
    let chartData = [10, 11, 12, 13, 14, 15];

    if (window.dashboardChartData && window.dashboardChartData.growthTrend && window.dashboardChartData.growthTrend.labels.length > 0) {
        chartLabels = window.dashboardChartData.growthTrend.labels;
        chartData = window.dashboardChartData.growthTrend.data;
    }

    const minVal = chartData.length > 0 ? Math.min(...chartData) : 0;
    const maxVal = chartData.length > 0 ? Math.max(...chartData) : 10;
    const yMin = Math.max(0, minVal - 3);
    const yMax = maxVal + 4;

    // Custom Chart.js Plugin to draw numbers & the special badge above points
    const pointAnnotationPlugin = {
        id: 'pointAnnotationPlugin',
        afterDatasetsDraw(chart) {
            const { ctx } = chart;
            const meta = chart.getDatasetMeta(0);
            const dataset = chart.data.datasets[0];
            const lastIndex = dataset.data.length - 1;

            meta.data.forEach((element, index) => {
                const val = dataset.data[index];
                const x = element.x;
                const y = element.y;

                if (index === lastIndex) {
                    // Draw highlighted badge pill: "X NS"
                    ctx.save();
                    const badgeText = `${val} NS`;
                    ctx.font = 'bold 11px Plus Jakarta Sans, sans-serif';
                    const textWidth = ctx.measureText(badgeText).width;
                    const pillWidth = textWidth + 16;
                    const pillHeight = 22;
                    const pillX = x - pillWidth / 2;
                    const pillY = y - 32;
                    const radius = 6;

                    // Draw pill background
                    ctx.fillStyle = '#2563eb';
                    ctx.beginPath();
                    ctx.roundRect(pillX, pillY, pillWidth, pillHeight, radius);
                    ctx.fill();

                    // Draw little bottom caret
                    ctx.beginPath();
                    ctx.moveTo(x - 4, pillY + pillHeight);
                    ctx.lineTo(x + 4, pillY + pillHeight);
                    ctx.lineTo(x, pillY + pillHeight + 4);
                    ctx.closePath();
                    ctx.fillStyle = '#2563eb';
                    ctx.fill();

                    // Draw text inside badge
                    ctx.fillStyle = '#ffffff';
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';
                    ctx.fillText(badgeText, x, pillY + pillHeight / 2);
                    ctx.restore();
                } else {
                    // Standard numerical labels above previous points
                    ctx.save();
                    ctx.fillStyle = '#334155';
                    ctx.font = '600 11px Plus Jakarta Sans, sans-serif';
                    ctx.textAlign = 'center';
                    ctx.fillText(val, x, y - 10);
                    ctx.restore();
                }
            });
        }
    };

    personnelChartInstance = new Chart(chartCtx, {
        type: 'line',
        data: {
            labels: chartLabels,
            datasets: [{
                label: 'Quy mô nhân sự',
                data: chartData,
                borderColor: '#2563eb',
                borderWidth: 2.8,
                backgroundColor: gradient,
                fill: true,
                tension: 0.38,
                pointBackgroundColor: '#ffffff',
                pointBorderColor: '#2563eb',
                pointBorderWidth: 2.5,
                pointRadius: 5.5,
                pointHoverRadius: 7.5,
                pointHoverBackgroundColor: '#2563eb',
                pointHoverBorderColor: '#ffffff',
                pointHoverBorderWidth: 2.5
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            layout: {
                padding: { top: 38, bottom: 8, left: 15, right: 25 }
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#0f172a',
                    titleFont: { family: 'Plus Jakarta Sans', size: 12, weight: 'bold' },
                    bodyFont: { family: 'Plus Jakarta Sans', size: 12 },
                    padding: 10,
                    cornerRadius: 8,
                    displayColors: false,
                    callbacks: {
                        label: (context) => ` Quy mô: ${context.parsed.y} nhân sự`
                    }
                }
            },
            scales: {
                x: {
                    grid: { display: false },
                    border: { display: false },
                    ticks: {
                        color: (context) => context.index === chartLabels.length - 1 ? '#2563eb' : '#64748b',
                        font: (context) => ({
                            family: 'Plus Jakarta Sans',
                            size: 11,
                            weight: context.index === chartLabels.length - 1 ? '700' : '500'
                        })
                    }
                },
                y: {
                    display: false,
                    min: yMin,
                    max: yMax
                }
            }
        },
        plugins: [pointAnnotationPlugin]
    });
}

/**
 * 2. Cơ cấu nhân sự (Donut Chart with Center Total & Multi-View Tabs)
 * Đọc dữ liệu thực tế từ window.dashboardChartData.donut
 */
function initDepartmentDonutChart() {
    const ctx = document.getElementById('departmentDonutChart');
    if (!ctx) return;

    let donutDataSets = {
        dept: {
            labels: ['Ban Giám đốc', 'Nhân sự', 'Kế toán', 'Kinh doanh', 'Marketing', 'Kỹ thuật'],
            data: [1, 4, 3, 1, 2, 4],
            colors: ['#2563eb', '#0ea5e9', '#f97316', '#10b981', '#8b5cf6', '#64748b']
        },
        gender: {
            labels: ['Nam', 'Nữ'],
            data: [8, 7],
            colors: ['#2563eb', '#ec4899']
        },
        age: {
            labels: ['18 - 25 tuổi', '25 - 35 tuổi', '35 - 45 tuổi', '45 - 55 tuổi', 'Trên 55'],
            data: [1, 10, 4, 0, 0],
            colors: ['#38bdf8', '#2563eb', '#6366f1', '#f59e0b', '#94a3b8']
        }
    };

    if (window.dashboardChartData && window.dashboardChartData.donut) {
        if (window.dashboardChartData.donut.dept && window.dashboardChartData.donut.dept.labels && window.dashboardChartData.donut.dept.labels.length > 0) {
            donutDataSets.dept = window.dashboardChartData.donut.dept;
        }
        if (window.dashboardChartData.donut.gender) {
            donutDataSets.gender = window.dashboardChartData.donut.gender;
        }
        if (window.dashboardChartData.donut.age) {
            donutDataSets.age = window.dashboardChartData.donut.age;
        }
    }

    departmentChartInstance = new Chart(ctx.getContext('2d'), {
        type: 'doughnut',
        data: {
            labels: donutDataSets.dept.labels,
            datasets: [{
                data: donutDataSets.dept.data,
                backgroundColor: donutDataSets.dept.colors,
                borderWidth: 3,
                borderColor: '#ffffff',
                hoverOffset: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            cutout: '72%',
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#0f172a',
                    titleFont: { family: 'Plus Jakarta Sans', size: 12 },
                    bodyFont: { family: 'Plus Jakarta Sans', size: 12, weight: 'bold' },
                    padding: 10,
                    cornerRadius: 8,
                    callbacks: {
                        label: (context) => ` ${context.label}: ${context.parsed} nhân sự`
                    }
                }
            }
        }
    });

    // Handle Donut Tabs (Phòng ban / Giới tính / Độ tuổi)
    const donutTabs = document.querySelectorAll('[data-donut-tab]');
    const donutLegendEl = document.getElementById('donutDynamicLegend');

    donutTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            donutTabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            const tabKey = tab.getAttribute('data-donut-tab');
            if (donutDataSets[tabKey] && departmentChartInstance) {
                departmentChartInstance.data.labels = donutDataSets[tabKey].labels;
                departmentChartInstance.data.datasets[0].data = donutDataSets[tabKey].data;
                departmentChartInstance.data.datasets[0].backgroundColor = donutDataSets[tabKey].colors;
                departmentChartInstance.update();

                // Update Legend
                if (donutLegendEl && donutDataSets[tabKey].labels) {
                    const total = donutDataSets[tabKey].data.reduce((a, b) => a + b, 0);
                    let html = '';
                    donutDataSets[tabKey].labels.forEach((label, idx) => {
                        const val = donutDataSets[tabKey].data[idx] || 0;
                        const pct = total > 0 ? Math.round((val * 100 / total) * 10) / 10 : 0;
                        const col = donutDataSets[tabKey].colors[idx] || '#2563eb';
                        html += `
                            <div class="donut-legend-item">
                                <span class="legend-label">
                                    <span class="color-square" style="background-color: ${col};"></span>
                                    ${label}
                                </span>
                                <span class="legend-val">${pct}% <span class="text-muted fw-normal">(${val})</span></span>
                            </div>
                        `;
                    });
                    donutLegendEl.innerHTML = html;
                }
            }
        });
    });
}

/**
 * 3. Refresh Buttons Micro-animation & Feedback
 */
function initRefreshButtons() {
    const refreshButtons = document.querySelectorAll('.btn-activity-refresh');
    refreshButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            const icon = btn.querySelector('i');
            if (icon) {
                icon.classList.add('spin-animation');
                setTimeout(() => {
                    icon.classList.remove('spin-animation');
                }, 700);
            }
        });
    });
}

/**
 * 5. Quick Export & Action Buttons Feedback
 */
function initActionButtons() {
    const btnExport = document.getElementById('btnExportReport');
    const btnComposite = document.getElementById('btnGenerateComposite');

    if (btnExport) {
        btnExport.addEventListener('click', () => {
            btnExport.classList.add('disabled');
            const originalHtml = btnExport.innerHTML;
            btnExport.innerHTML = '<i class="bi bi-hourglass-split"></i> <span>Đang kết xuất...</span>';
            setTimeout(() => {
                btnExport.classList.remove('disabled');
                btnExport.innerHTML = originalHtml;
                alert('Đã xuất báo cáo tổng quan Dashboard T09/2026 dạng Excel thành công!');
            }, 600);
        });
    }

    if (btnComposite) {
        btnComposite.addEventListener('click', () => {
            alert('Hệ thống đang tổng hợp dữ liệu toàn diện các phòng ban T09/2026.');
        });
    }
}

/**
 * 6. Phân tích cơ cấu nhân sự (Độ tuổi, Giới tính, Thâm niên, Trình độ)
 */
function initPersonnelStructureTabs() {
    const tabs = document.querySelectorAll('#structureFilterTabs [data-structure-tab]');
    const subtitleEl = document.getElementById('structureCardSubtitle');
    const sub1Title = document.getElementById('structureSub1Title');
    const sub1Val = document.getElementById('structureSub1Val');
    const sub2Title = document.getElementById('structureSub2Title');
    const sub2Val = document.getElementById('structureSub2Val');

    if (!tabs || tabs.length === 0) return;

    const tabConfig = {
        age: {
            subtitle: 'Phân bổ theo tuổi và cơ cấu nhân sự chi tiết toàn hệ thống',
            sub1Title: 'Tỷ lệ giới tính',
            sub1Val: '<i class="bi bi-gender-male"></i> Nam: 55% &nbsp;|&nbsp; <i class="bi bi-gender-female text-danger"></i> Nữ: 45%',
            sub1Class: 'text-primary',
            sub2Title: 'Thâm niên trung bình',
            sub2Val: '2.8 năm <span class="text-muted fw-normal">(38% từ 1-3 năm)</span>',
            sub2Class: 'text-success'
        },
        gender: {
            subtitle: 'Cơ cấu giới tính và phân bổ cân bằng nhân sự theo từng khối phòng ban',
            sub1Title: 'Tỷ lệ toàn công ty',
            sub1Val: '<i class="bi bi-gender-male"></i> Nam: 55% (135) &nbsp;|&nbsp; <i class="bi bi-gender-female text-danger"></i> Nữ: 45% (110)',
            sub1Class: 'text-primary',
            sub2Title: 'Cân bằng giới cấp quản lý',
            sub2Val: '<span class="text-primary fw-bold">♂ 58%</span> &nbsp;|&nbsp; <span class="text-danger fw-bold">♀ 42%</span> <span class="text-muted fw-normal">(Đạt chuẩn ESG)</span>',
            sub2Class: 'text-dark'
        },
        seniority: {
            subtitle: 'Phân bổ thời gian công tác và mức độ gắn kết nhân sự tại MIXIMOI',
            sub1Title: 'Thâm niên trung bình',
            sub1Val: '2.8 năm <span class="text-muted fw-normal">(Tăng +0.4 năm so với 2025)</span>',
            sub1Class: 'text-success',
            sub2Title: 'Tỷ lệ gắn bó (> 1 năm)',
            sub2Val: '<span class="text-success fw-bold">76.0%</span> <span class="text-muted fw-normal">(186/245 nhân sự)</span>',
            sub2Class: 'text-success'
        },
        education: {
            subtitle: 'Phân bổ theo trình độ học vấn, bằng cấp chuyên môn và chứng chỉ nghề',
            sub1Title: 'Đại học & Sau Đại học',
            sub1Val: '<span class="text-primary fw-bold">76.3%</span> <span class="text-muted fw-normal">(187/245 nhân sự chính quy)</span>',
            sub1Class: 'text-primary',
            sub2Title: 'Chứng chỉ quốc tế',
            sub2Val: '<span class="fw-bold text-purple">42 chứng chỉ</span> <span class="text-muted fw-normal">(PMP, AWS, CFA, CPA)</span>',
            sub2Class: 'text-dark'
        }
    };

    tabs.forEach(tab => {
        tab.addEventListener('click', (e) => {
            e.preventDefault();
            const targetKey = tab.getAttribute('data-structure-tab');
            if (!targetKey) return;

            // 1. Update active tab pill
            tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            // 2. Switch tab pane
            const allPanes = document.querySelectorAll('.structure-tab-pane');
            allPanes.forEach(pane => pane.classList.remove('active'));

            const targetPane = document.getElementById('structure-pane-' + targetKey);
            if (targetPane) {
                targetPane.classList.add('active');

                // Animate progress bars from 0 to original width
                const bars = targetPane.querySelectorAll('.age-dist-bar-fill, .gender-bar-male, .gender-bar-female');
                bars.forEach(bar => {
                    const originalWidth = bar.style.width;
                    bar.style.transition = 'none';
                    bar.style.width = '0%';
                    requestAnimationFrame(() => {
                        requestAnimationFrame(() => {
                            bar.style.transition = 'width 0.5s cubic-bezier(0.16, 1, 0.3, 1)';
                            bar.style.width = originalWidth;
                        });
                    });
                });
            }

            // 3. Smoothly update subtitle
            const cfg = tabConfig[targetKey];
            if (cfg && subtitleEl) {
                subtitleEl.style.opacity = '0';
                setTimeout(() => {
                    subtitleEl.textContent = cfg.subtitle;
                    subtitleEl.style.opacity = '1';
                }, 120);
            }

            // 4. Update demographic subcards
            if (cfg) {
                if (sub1Title) sub1Title.textContent = cfg.sub1Title;
                if (sub1Val) {
                    sub1Val.className = 'demo-subcard-val ' + (cfg.sub1Class || '');
                    sub1Val.innerHTML = cfg.sub1Val;
                }
                if (sub2Title) sub2Title.textContent = cfg.sub2Title;
                if (sub2Val) {
                    sub2Val.className = 'demo-subcard-val ' + (cfg.sub2Class || '');
                    sub2Val.innerHTML = cfg.sub2Val;
                }
            }
        });
    });
}

// Fallback initialization if DOMContentLoaded already fired
if (document.readyState !== 'loading') {
    initPersonnelStructureTabs();
}

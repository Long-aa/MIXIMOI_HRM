/**
 * MIXIMOI HRM & PAYROLL — Master Dashboard Controller Scripts
 * Chart.js configurations, custom canvas rendering plugins & interactive dashboard controls.
 */

document.addEventListener('DOMContentLoaded', () => {
    initPersonnelChart();
    initDepartmentDonutChart();
    initPeriodFilterTabs();
    initRefreshButtons();
    initActionButtons();
});

let personnelChartInstance = null;
let departmentChartInstance = null;

/**
 * 1. Biến động nhân sự (Area Spline Chart with Custom Top Badges)
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

    // Data points matching the 6-month progression in mockup
    const periodData = {
        '6m': {
            labels: ['tháng 04', 'tháng 05', 'tháng 06', 'tháng 07', 'tháng 08', 'Tháng 09 (Hiện tại)'],
            data: [210, 218, 225, 232, 238, 245]
        },
        '1y': {
            labels: ['T10/25', 'T11/25', 'T12/25', 'T01/26', 'T02/26', 'T03/26', 'T04/26', 'T05/26', 'T06/26', 'T07/26', 'T08/26', 'T09/26'],
            data: [178, 185, 192, 198, 204, 208, 210, 218, 225, 232, 238, 245]
        }
    };

    // Custom Chart.js Plugin to draw numbers & the special "245 NS" badge above points
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
                    // Draw highlighted badge pill: "245 NS"
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
            labels: periodData['6m'].labels,
            datasets: [{
                label: 'Quy mô nhân sự',
                data: periodData['6m'].data,
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
                        color: (context) => context.index === periodData['6m'].labels.length - 1 ? '#2563eb' : '#64748b',
                        font: (context) => ({
                            family: 'Plus Jakarta Sans',
                            size: 11,
                            weight: context.index === periodData['6m'].labels.length - 1 ? '700' : '500'
                        })
                    }
                },
                y: {
                    display: false,
                    min: 190,
                    max: 265
                }
            }
        },
        plugins: [pointAnnotationPlugin]
    });
}

/**
 * 2. Cơ cấu nhân sự (Donut Chart with Center Total & Multi-View Tabs)
 */
function initDepartmentDonutChart() {
    const ctx = document.getElementById('departmentDonutChart');
    if (!ctx) return;

    const donutDataSets = {
        dept: {
            labels: ['Kinh doanh', 'CNTT & R&D', 'Marketing', 'Kế toán', 'Nhân sự', 'Khác'],
            data: [28, 22, 18, 15, 10, 7],
            colors: ['#2563eb', '#0ea5e9', '#f97316', '#10b981', '#8b5cf6', '#64748b']
        },
        gender: {
            labels: ['Nam', 'Nữ'],
            data: [55, 45],
            colors: ['#2563eb', '#ec4899']
        },
        age: {
            labels: ['18 - 25 tuổi', '25 - 35 tuổi', '35 - 45 tuổi', '45 - 55 tuổi', 'Trên 55'],
            data: [18, 52, 18, 12, 5],
            colors: ['#38bdf8', '#2563eb', '#6366f1', '#f59e0b', '#94a3b8']
        }
    };

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
                        label: (context) => ` ${context.label}: ${context.parsed}%`
                    }
                }
            }
        }
    });

    // Handle Donut Tabs (Phòng ban / Giới tính / Độ tuổi)
    const donutTabs = document.querySelectorAll('[data-donut-tab]');
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
            }
        });
    });
}

/**
 * 3. Period Filter Segmented Tabs Switching
 */
function initPeriodFilterTabs() {
    const periodButtons = document.querySelectorAll('.period-tab-btn');
    periodButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            periodButtons.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            const range = btn.getAttribute('data-range');
            if (personnelChartInstance && (range === 'year' || range === 'quarter')) {
                personnelChartInstance.data.labels = ['Q1', 'Q2', 'Q3', 'Q4 (Dự kiến)'];
                personnelChartInstance.data.datasets[0].data = [215, 230, 245, 260];
                personnelChartInstance.update();
            } else if (personnelChartInstance && range === 'month') {
                personnelChartInstance.data.labels = ['tháng 04', 'tháng 05', 'tháng 06', 'tháng 07', 'tháng 08', 'Tháng 09 (Hiện tại)'];
                personnelChartInstance.data.datasets[0].data = [210, 218, 225, 232, 238, 245];
                personnelChartInstance.update();
            }
        });
    });
}

/**
 * 4. Refresh Buttons Micro-animation & Feedback
 */
function initRefreshButtons() {
    const refreshButtons = document.querySelectorAll('#btnRefreshFilters, .btn-activity-refresh');
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

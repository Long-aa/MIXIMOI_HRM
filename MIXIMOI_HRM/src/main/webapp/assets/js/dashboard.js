/**
 * MIXIMOI HRM & PAYROLL — Dashboard Scripts
 * Chart.js configurations & dynamic dashboard widgets matching UI specifications
 */

document.addEventListener('DOMContentLoaded', () => {
  initPersonnelChart();
  initDepartmentChart();
  initRecentActivityRefresh();
});

let personnelChartInstance = null;

/**
 * 1. Biến động nhân sự (Area Spline Chart)
 */
function initPersonnelChart() {
  const ctx = document.getElementById('personnelGrowthChart');
  if (!ctx) return;

  const chartCtx = ctx.getContext('2d');

  // Create subtle vertical gradient for area fill
  const gradient = chartCtx.createLinearGradient(0, 0, 0, 300);
  gradient.addColorStop(0, 'rgba(37, 99, 235, 0.25)');
  gradient.addColorStop(1, 'rgba(37, 99, 235, 0.00)');

  const dataSets = {
    '6m': {
      labels: ['Tháng 04', 'Tháng 05', 'Tháng 06', 'Tháng 07', 'Tháng 08', 'Tháng 09 (Hiện tại)'],
      data: [210, 218, 223, 230, 238, 245]
    },
    '1y': {
      labels: ['T10', 'T11', 'T12', 'T01', 'T02', 'T03', 'T04', 'T05', 'T06', 'T07', 'T08', 'T09'],
      data: [180, 185, 192, 198, 202, 207, 210, 218, 223, 230, 238, 245]
    },
    'all': {
      labels: ['2023', 'Q1/24', 'Q2/24', 'Q3/24', 'Q4/24', 'Q1/25', 'Q2/25', 'Q3/25', 'Hiện tại'],
      data: [120, 145, 160, 175, 185, 198, 215, 230, 245]
    }
  };

  // Custom Chart.js plugin to draw values directly above data points
  const dataLabelsPlugin = {
    id: 'topDataLabels',
    afterDatasetsDraw(chart) {
      const { ctx } = chart;
      chart.data.datasets.forEach((dataset, i) => {
        const meta = chart.getDatasetMeta(i);
        meta.data.forEach((element, index) => {
          const val = dataset.data[index];
          ctx.save();
          ctx.fillStyle = '#1e293b';
          ctx.font = '600 11px Plus Jakarta Sans, sans-serif';
          ctx.textAlign = 'center';
          ctx.fillText(val, element.x, element.y - 12);
          ctx.restore();
        });
      });
    }
  };

  personnelChartInstance = new Chart(chartCtx, {
    type: 'line',
    data: {
      labels: dataSets['6m'].labels,
      datasets: [{
        label: 'Quy mô nhân sự',
        data: dataSets['6m'].data,
        borderColor: '#2563eb',
        borderWidth: 2.5,
        backgroundColor: gradient,
        fill: true,
        tension: 0.35,
        pointBackgroundColor: '#ffffff',
        pointBorderColor: '#2563eb',
        pointBorderWidth: 2.5,
        pointRadius: 5,
        pointHoverRadius: 7,
        pointHoverBackgroundColor: '#2563eb',
        pointHoverBorderColor: '#ffffff',
        pointHoverBorderWidth: 2
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      layout: {
        padding: { top: 25, bottom: 5, left: 10, right: 15 }
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
            label: function(context) {
              return ' ' + context.parsed.y + ' nhân sự';
            }
          }
        }
      },
      scales: {
        x: {
          grid: { display: false },
          ticks: {
            color: '#64748b',
            font: { family: 'Plus Jakarta Sans', size: 11, weight: '500' }
          }
        },
        y: {
          display: false,
          min: 190,
          max: 260
        }
      }
    },
    plugins: [dataLabelsPlugin]
  });

  // Handle Tab Switch (6 Tháng / Năm nay / Tất cả)
  const filterPills = document.querySelectorAll('.filter-pill[data-period]');
  filterPills.forEach(pill => {
    pill.addEventListener('click', () => {
      filterPills.forEach(p => p.classList.remove('active'));
      pill.classList.add('active');

      const period = pill.getAttribute('data-period');
      if (dataSets[period]) {
        personnelChartInstance.data.labels = dataSets[period].labels;
        personnelChartInstance.data.datasets[0].data = dataSets[period].data;

        // adjust y scale min
        const minVal = Math.min(...dataSets[period].data);
        const maxVal = Math.max(...dataSets[period].data);
        personnelChartInstance.options.scales.y.min = Math.floor(minVal * 0.85);
        personnelChartInstance.options.scales.y.max = Math.ceil(maxVal * 1.1);

        personnelChartInstance.update();
      }
    });
  });
}

/**
 * 2. Cơ cấu phòng ban (Donut Chart with Center Total)
 */
function initDepartmentChart() {
  const ctx = document.getElementById('departmentDonutChart');
  if (!ctx) return;

  new Chart(ctx.getContext('2d'), {
    type: 'doughnut',
    data: {
      labels: ['Kinh doanh', 'Công nghệ (IT)', 'Marketing', 'Kế toán', 'Nhân sự & Vận hành'],
      datasets: [{
        data: [35, 25, 18, 12, 10],
        backgroundColor: [
          '#2563eb', // Kinh doanh
          '#0ea5e9', // Công nghệ (IT)
          '#6366f1', // Marketing
          '#38bdf8', // Kế toán
          '#93c5fd'  // Nhân sự & Vận hành
        ],
        borderWidth: 3,
        borderColor: '#ffffff',
        hoverOffset: 4
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
            label: function(context) {
              return ` ${context.label}: ${context.parsed}%`;
            }
          }
        }
      }
    }
  });
}

/**
 * 3. Recent Activity Refresh Interaction
 */
function initRecentActivityRefresh() {
  const refreshBtn = document.querySelector('.btn-activity-refresh');
  if (!refreshBtn) return;

  refreshBtn.addEventListener('click', (e) => {
    e.preventDefault();
    const icon = refreshBtn.querySelector('i');
    if (icon) {
      icon.classList.add('spin-animation');
      setTimeout(() => {
        icon.classList.remove('spin-animation');
      }, 700);
    }
  });
}

// ── CHART DEFAULTS ──
Chart.defaults.color = '#9099b5';
Chart.defaults.font.family = "'Plus Jakarta Sans', sans-serif";

const GRID_COLOR = 'rgba(0,0,0,0.05)';
const TICK_COLOR = '#9099b5';

// ════════════════════════════════════════════
//  APP DATA — single source of truth
//  Add data for new sections/pages here
// ════════════════════════════════════════════
const AppData = {

    months: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],

    // ── Monthly total violations per year ──
    monthlyViolations: {
        2024: [22, 18, 30, 27, 14, 19, 35, 40, 28, 33, 25, 21],
        2023: [15, 12, 20, 18, 11, 16, 28, 31, 22, 26, 18, 14],
        2022: [10,  9, 14, 12,  8, 10, 18, 22, 15, 20, 13, 10],
    },

    // ── Per-department monthly violations per year ──
    deptLines: {
        2024: {
            SOT: [12,  9, 14, 13,  7, 10, 16, 19, 13, 15, 12, 10],
            SOB: [ 7,  6,  9,  8,  4,  6, 11, 12,  9, 11,  8,  7],
            SOE: [ 3,  3,  7,  6,  3,  3,  8,  9,  6,  7,  5,  4],
        },
        2023: {
            SOT: [ 8,  7, 10,  9,  5,  8, 13, 15, 10, 12,  9,  7],
            SOB: [ 5,  4,  7,  6,  4,  5,  9, 10,  7,  9,  6,  5],
            SOE: [ 2,  1,  3,  3,  2,  3,  6,  6,  5,  5,  3,  2],
        },
        2022: {
            SOT: [ 5,  4,  7,  6,  3,  5,  9, 10,  7,  9,  6,  5],
            SOB: [ 3,  3,  5,  4,  3,  3,  6,  8,  5,  7,  5,  3],
            SOE: [ 2,  2,  2,  2,  2,  2,  3,  4,  3,  4,  2,  2],
        },
    },

    // ── Dept bar/filter data (course × year level × school) ──
    deptFilter: {
        all:  { all: { 1:42, 2:38, 3:47 }, 1:{ 1:12, 2:10, 3:14 }, 2:{ 1:10, 2:9, 3:11 }, 3:{ 1:11, 2:10, 3:12 }, 4:{ 1:9, 2:9, 3:10 } },
        bsit: { all: { 1:22, 2:0,  3:0  }, 1:{ 1:8,  2:0,  3:0  }, 2:{ 1:6,  2:0, 3:0  }, 3:{ 1:5,  2:0,  3:0  }, 4:{ 1:3, 2:0, 3:0 } },
        bscs: { all: { 1:18, 2:0,  3:0  }, 1:{ 1:6,  2:0,  3:0  }, 2:{ 1:5,  2:0, 3:0  }, 3:{ 1:4,  2:0,  3:0  }, 4:{ 1:3, 2:0, 3:0 } },
        bsba: { all: { 1:0,  2:36, 3:0  }, 1:{ 1:0,  2:10, 3:0  }, 2:{ 1:0,  2:9, 3:0  }, 3:{ 1:0,  2:10, 3:0  }, 4:{ 1:0, 2:7, 3:0 } },
        bsed: { all: { 1:0,  2:0,  3:28 }, 1:{ 1:0,  2:0,  3:8  }, 2:{ 1:0,  2:0, 3:7  }, 3:{ 1:0,  2:0,  3:7  }, 4:{ 1:0, 2:0, 3:6 } },
        beed: { all: { 1:0,  2:0,  3:19 }, 1:{ 1:0,  2:0,  3:6  }, 2:{ 1:0,  2:0, 3:5  }, 3:{ 1:0,  2:0,  3:4  }, 4:{ 1:0, 2:0, 3:4 } },
    },

    // ── Major offense breakdown ──
    majorOffenses: [
        { label: 'Physical Assault',      count: 28, color: '#ef4444' },
        { label: 'Possession of Weapons', count: 15, color: '#f87171' },
        { label: 'Drug-related Offenses', count: 19, color: '#fca5a5' },
        { label: 'Vandalism',             count: 22, color: '#fb923c' },
        { label: 'Academic Dishonesty',   count: 34, color: '#f97316' },
    ],

    // ── Minor offense breakdown ──
    minorOffenses: [
        { label: 'Tardiness',              count: 72, color: '#f59e0b' },
        { label: 'Improper Uniform',       count: 58, color: '#fbbf24' },
        { label: 'Excessive Absences',     count: 44, color: '#fcd34d' },
        { label: 'Unauthorized Phone Use', count: 37, color: '#a3e635' },
        { label: 'Littering',              count: 21, color: '#86efac' },
    ],

    // ── Recent violations table ──
    recentViolations: [
        { name:'Juan dela Cruz',   id:'2021-00142', dept:'SOT', year:'3rd', violation:'Academic Dishonesty',    type:'Major', date:'Mar 12, 2024', status:'Pending'  },
        { name:'Maria Santos',     id:'2022-00391', dept:'SOB', year:'2nd', violation:'Tardiness',              type:'Minor', date:'Mar 12, 2024', status:'Resolved' },
        { name:'Carlos Reyes',     id:'2020-00077', dept:'SOE', year:'4th', violation:'Vandalism',              type:'Major', date:'Mar 11, 2024', status:'Ongoing'  },
        { name:'Ana Lim',          id:'2023-00214', dept:'SOT', year:'1st', violation:'Improper Uniform',       type:'Minor', date:'Mar 11, 2024', status:'Resolved' },
        { name:'Mark Villanueva',  id:'2021-00503', dept:'SOB', year:'3rd', violation:'Physical Assault',       type:'Major', date:'Mar 10, 2024', status:'Pending'  },
        { name:'Sophia Torres',    id:'2022-00188', dept:'SOE', year:'2nd', violation:'Excessive Absences',     type:'Minor', date:'Mar 10, 2024', status:'Pending'  },
        { name:'Luis Garcia',      id:'2020-00099', dept:'SOT', year:'4th', violation:'Unauthorized Phone Use', type:'Minor', date:'Mar 09, 2024', status:'Resolved' },
        { name:'Patricia Flores',  id:'2023-00312', dept:'SOB', year:'1st', violation:'Drug-related Offense',   type:'Major', date:'Mar 09, 2024', status:'Ongoing'  },
        { name:'Jerome Aquino',    id:'2021-00456', dept:'SOE', year:'3rd', violation:'Littering',              type:'Minor', date:'Mar 08, 2024', status:'Resolved' },
        { name:'Kristine Mendoza', id:'2022-00089', dept:'SOT', year:'2nd', violation:'Possession of Weapons',  type:'Major', date:'Mar 07, 2024', status:'Pending'  },
    ],
};


// ════════════════════════════════════════════
//  MONTHLY VIOLATIONS BAR CHART
// ════════════════════════════════════════════
const monthlyCtx = document.getElementById('monthlyChart').getContext('2d');
let monthlyChart = new Chart(monthlyCtx, {
    type: 'bar',
    data: {
        labels: AppData.months,
        datasets: [{
            label: 'Violations',
            data: AppData.monthlyViolations[2024],
            backgroundColor: 'rgba(79,110,247,0.25)',
            borderColor: '#4f6ef7',
            borderWidth: 2,
            borderRadius: 5,
            borderSkipped: false,
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: {
            x: { grid: { color: GRID_COLOR }, ticks: { color: TICK_COLOR, font: { size: 10 } } },
            y: { grid: { color: GRID_COLOR }, ticks: { color: TICK_COLOR, font: { size: 10 } }, beginAtZero: true },
        }
    }
});

function updateMonthlyChart() {
    const yr = document.getElementById('yearFilter1').value;
    monthlyChart.data.datasets[0].data = AppData.monthlyViolations[yr];
    monthlyChart.update();
}


// ════════════════════════════════════════════
//  MINOR VS MAJOR LINE CHART
// ════════════════════════════════════════════
const mmCtx = document.getElementById('minorMajorChart').getContext('2d');
new Chart(mmCtx, {
    type: 'line',
    data: {
        labels: AppData.months,
        datasets: [
            {
                label: 'Minor',
                data: [14, 11, 19, 16, 9, 12, 22, 25, 17, 20, 15, 13],
                backgroundColor: 'rgba(245,158,11,0.4)',
                borderColor: '#f59e0b',
                borderWidth: 2,
                cubicInterpolationMode: 'monotone',
            },
            {
                label: 'Major',
                data: [8, 7, 11, 11, 5, 7, 13, 15, 11, 13, 10, 8],
                backgroundColor: 'rgba(239,68,68,0.35)',
                borderColor: '#ef4444',
                borderWidth: 2,
                cubicInterpolationMode: 'monotone',
            }
        ]
    },
    options: {
        responsive: true,
        plugins: {
            legend: {
                labels: { color: '#8b90a7', font: { size: 11 }, boxWidth: 10, padding: 12 }
            }
        },
        scales: {
            x: { grid: { color: GRID_COLOR }, ticks: { color: TICK_COLOR, font: { size: 9 } } },
            y: { grid: { color: GRID_COLOR }, ticks: { color: TICK_COLOR, font: { size: 10 } }, beginAtZero: true },
        }
    }
});


// ════════════════════════════════════════════
//  VIOLATIONS PER DEPARTMENT LINE CHART
// ════════════════════════════════════════════
const deptLineCtx = document.getElementById('deptLineChart').getContext('2d');
let deptLineChart = new Chart(deptLineCtx, {
    type: 'line',
    data: {
        labels: AppData.months,
        datasets: [
            {
                label: 'SOT – School of Technology',
                data: AppData.deptLines[2024].SOT,
                borderColor: '#4f6ef7',
                backgroundColor: 'rgba(79,110,247,0.08)',
                borderWidth: 2,
                pointRadius: 4,
                pointHoverRadius: 6,
                fill: true,
                tension: 0.4,
            },
            {
                label: 'SOB – School of Business',
                data: AppData.deptLines[2024].SOB,
                borderColor: '#7c3aed',
                backgroundColor: 'rgba(124,58,237,0.08)',
                borderWidth: 2,
                pointRadius: 4,
                pointHoverRadius: 6,
                fill: true,
                tension: 0.4,
                borderDash: [5, 3],
            },
            {
                label: 'SOE – School of Education',
                data: AppData.deptLines[2024].SOE,
                borderColor: '#f59e0b',
                backgroundColor: 'rgba(245,158,11,0.08)',
                borderWidth: 2,
                pointRadius: 4,
                pointHoverRadius: 6,
                fill: true,
                tension: 0.4,
                borderDash: [2, 2],
            }
        ]
    },
    options: {
        responsive: true,
        plugins: {
            legend: {
                labels: { color: '#8b90a7', font: { size: 11 }, boxWidth: 10, padding: 12 }
            }
        },
        scales: {
            x: { grid: { color: GRID_COLOR }, ticks: { color: TICK_COLOR, font: { size: 9 } } },
            y: { grid: { color: GRID_COLOR }, ticks: { color: TICK_COLOR, font: { size: 10 } }, beginAtZero: true },
        }
    }
});

function updateDeptLineChart() {
    const yr = document.getElementById('deptLineYear').value;
    deptLineChart.data.datasets[0].data = AppData.deptLines[yr].SOT;
    deptLineChart.data.datasets[1].data = AppData.deptLines[yr].SOB;
    deptLineChart.data.datasets[2].data = AppData.deptLines[yr].SOE;
    deptLineChart.update();
}


// ════════════════════════════════════════════
//  DEPT FILTER BARS
// ════════════════════════════════════════════
function updateDeptBars() {
    const course    = document.getElementById('deptCourseFilter').value;
    const yrLevel   = document.getElementById('deptYearLevelFilter').value;

    const courseObj = AppData.deptFilter[course] || AppData.deptFilter['all'];
    const vals      = courseObj[yrLevel]          || courseObj['all'];

    const sot = vals[1], sob = vals[2], soe = vals[3];
    const max = Math.max(sot, sob, soe) || 1;

    document.getElementById('deptBars').innerHTML = `
        <div class="dept-item">
            <div class="dept-item-header">
                <div class="dept-name">SOT <span>School of Technology</span></div>
                <div class="dept-count">${sot} cases</div>
            </div>
            <div class="dept-bar-track"><div class="dept-bar-fill sot-fill" style="width:${(sot/max*100).toFixed(1)}%"></div></div>
        </div>
        <div class="dept-item">
            <div class="dept-item-header">
                <div class="dept-name">SOB <span>School of Business</span></div>
                <div class="dept-count">${sob} cases</div>
            </div>
            <div class="dept-bar-track"><div class="dept-bar-fill sob-fill" style="width:${(sob/max*100).toFixed(1)}%"></div></div>
        </div>
        <div class="dept-item">
            <div class="dept-item-header">
                <div class="dept-name">SOE <span>School of Education</span></div>
                <div class="dept-count">${soe} cases</div>
            </div>
            <div class="dept-bar-track"><div class="dept-bar-fill soe-fill" style="width:${(soe/max*100).toFixed(1)}%"></div></div>
        </div>
    `;

    if (window.deptBarChart) {
        deptBarChart.data.datasets[0].data = [sot, sob, soe];
        deptBarChart.update();
    }
}
updateDeptBars();


// ════════════════════════════════════════════
//  DEPT BAR CHART
// ════════════════════════════════════════════
const deptCtx = document.getElementById('deptChart').getContext('2d');
window.deptBarChart = new Chart(deptCtx, {
    type: 'bar',
    data: {
        labels: ['SOT', 'SOB', 'SOE'],
        datasets: [{
            label: 'Violations',
            data: [42, 38, 47],
            backgroundColor: [
                'rgba(79,110,247,0.45)',
                'rgba(124,58,237,0.45)',
                'rgba(245,158,11,0.45)',
            ],
            borderColor: ['#4f6ef7', '#7c3aed', '#f59e0b'],
            borderWidth: 2,
            borderRadius: 6,
            borderSkipped: false,
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: {
            x: { grid: { color: GRID_COLOR }, ticks: { color: TICK_COLOR, font: { size: 11, weight: '600' } } },
            y: { grid: { color: GRID_COLOR }, ticks: { color: TICK_COLOR, font: { size: 10 } }, beginAtZero: true },
        }
    }
});


// ════════════════════════════════════════════
//  DONUT CHARTS  (major & minor offenses)
// ════════════════════════════════════════════
function buildDonut(canvasId, offenses, legendId, totalId) {
    const total = offenses.reduce((s, o) => s + o.count, 0);
    document.getElementById(totalId).textContent = total;

    const ctx = document.getElementById(canvasId).getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: offenses.map(o => o.label),
            datasets: [{
                data: offenses.map(o => o.count),
                backgroundColor: offenses.map(o => o.color + 'cc'),
                borderColor: offenses.map(o => o.color),
                borderWidth: 2,
                hoverOffset: 6,
            }]
        },
        options: {
            responsive: true,
            cutout: '68%',
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: ctx => ` ${ctx.label}: ${ctx.raw} (${((ctx.raw / total) * 100).toFixed(1)}%)`
                    }
                }
            }
        }
    });

    document.getElementById(legendId).innerHTML = offenses.map(o => `
        <div class="legend-item">
            <div class="legend-dot" style="background:${o.color}"></div>
            <div class="legend-text">${o.label}</div>
            <div class="legend-val">${o.count}</div>
        </div>
    `).join('');
}

buildDonut('majorDonut', AppData.majorOffenses, 'majorLegend', 'majorTotal');
buildDonut('minorDonut', AppData.minorOffenses, 'minorLegend', 'minorTotal');


// ════════════════════════════════════════════
//  RECENT VIOLATIONS TABLE
// ════════════════════════════════════════════
function filterTable() {
    const dept   = document.getElementById('recentDeptFilter').value;
    const type   = document.getElementById('recentTypeFilter').value;
    const status = document.getElementById('recentStatusFilter').value;

    const filtered = AppData.recentViolations.filter(r =>
        (dept   === 'all' || r.dept   === dept)   &&
        (type   === 'all' || r.type   === type)   &&
        (status === 'all' || r.status === status)
    );

    const tbody = document.getElementById('recentTableBody');

    if (!filtered.length) {
        tbody.innerHTML = `<tr><td colspan="8" style="text-align:center;padding:28px">No records match the selected filters.</td></tr>`;
        return;
    }

    tbody.innerHTML = filtered.map(r => {
        const typeBadge   = r.type   === 'Major'    ? 'badge-major'    : 'badge-minor';
        const statusBadge = r.status === 'Pending'  ? 'badge-pending'  :
                            r.status === 'Resolved' ? 'badge-resolved' : 'badge-ongoing';
        const deptTag     = `tag-${r.dept.toLowerCase()}`;
        return `
            <tr>
                <td>${r.name}</td>
                <td class="student-id">${r.id}</td>
                <td><span class="dept-tag ${deptTag}">${r.dept}</span></td>
                <td>${r.year}</td>
                <td>${r.violation}</td>
                <td><span class="badge ${typeBadge}">${r.type}</span></td>
                <td>${r.date}</td>
                <td><span class="badge ${statusBadge}">${r.status}</span></td>
            </tr>
        `;
    }).join('');
}
filterTable();
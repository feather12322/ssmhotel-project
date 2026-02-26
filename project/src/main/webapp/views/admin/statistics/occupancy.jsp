<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>入住统计 - 酒店管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <style>
        body {
            background: #f2f2f2;
        }

        .main-content {
            margin: 20px;
        }

        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .filter-form {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: flex-end;
        }

        .filter-form .layui-form-item {
            margin-bottom: 0;
        }

        .filter-actions {
            display: flex;
            gap: 10px;
        }

        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }

        .stat-card .stat-icon {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.8;
        }

        .stat-card .stat-title {
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .stat-card .stat-value {
            color: #333;
            font-size: 32px;
            font-weight: 700;
            margin: 0;
        }

        .stat-card.room .stat-icon { color: #009688; }
        .stat-card.occupied .stat-icon { color: #52c41a; }
        .stat-card.rate .stat-icon { color: #1890ff; }
        .stat-card.revenue .stat-icon { color: #faad14; }

        .chart-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }

        .chart-header {
            padding: 20px;
            border-bottom: 1px solid #e6e6e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .trend-info {
            font-size: 14px;
            color: #666;
        }

        .info-text {
            font-style: italic;
        }

        .chart-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin: 0;
        }

        .chart-content {
            padding: 20px;
        }

        .chart-container {
            height: 400px;
            width: 100%;
        }

        .table-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .table-container {
            padding: 0;
        }

        .layui-table {
            margin: 0;
        }

        .layui-table th {
            background: #f8f8f8;
            color: #333;
            font-weight: 600;
        }

        .rate-cell {
            font-weight: bold;
            padding: 4px 8px;
            border-radius: 4px;
            background: rgba(0,0,0,0.05);
        }

        .rate-high { color: #52c41a; background: rgba(82, 196, 26, 0.1); }
        .rate-medium { color: #faad14; background: rgba(250, 173, 20, 0.1); }
        .rate-normal { color: #1890ff; background: rgba(24, 144, 255, 0.1); }
        .rate-low { color: #ff4d4f; background: rgba(255, 77, 79, 0.1); }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .main-content {
                margin: 10px;
            }

            .filter-form {
                flex-direction: column;
                align-items: stretch;
            }

            .filter-form .layui-input,
            .filter-form .layui-select {
                width: 100%;
            }

            .stats-section {
                grid-template-columns: 1fr;
            }

            .chart-container {
                height: 300px;
            }
        }
    </style>
</head>
<body>
    <!-- 筛选条件 -->
    <div class="main-content">
        <div class="filter-section">
            <form class="layui-form filter-form" lay-filter="occupancyFilterForm">
                <div class="layui-form-item">
                    <label class="layui-form-label">统计周期</label>
                    <div class="layui-input-block">
                        <select name="period">
                            <option value="day">按日统计</option>
                            <option value="week" selected>按周统计</option>
                            <option value="month">按月统计</option>
                            <option value="year">按年统计</option>
                        </select>
                    </div>
                </div>

                <div class="filter-actions">
                    <button class="layui-btn layui-btn-normal" lay-submit lay-filter="searchBtn">
                        <i class="fas fa-search"></i> 生成统计
                    </button>
                </div>
            </form>
        </div>

        <!-- 统计概览 -->
        <div class="stats-section">
            <div class="stat-card room">
                <div class="stat-icon">
                    <i class="fas fa-bed"></i>
                </div>
                <div class="stat-title">总房间数</div>
                <div class="stat-value" id="totalRooms">0</div>
            </div>

            <div class="stat-card occupied">
                <div class="stat-icon">
                    <i class="fas fa-user-check"></i>
                </div>
                <div class="stat-title">入住房间</div>
                <div class="stat-value" id="totalOccupied">0</div>
            </div>

            <div class="stat-card rate">
                <div class="stat-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-title">平均入住率</div>
                <div class="stat-value" id="avgOccupancyRate">0%</div>
            </div>

            <div class="stat-card revenue">
                <div class="stat-icon">
                    <i class="fas fa-yen-sign"></i>
                </div>
                <div class="stat-title">总收入</div>
                <div class="stat-value" id="totalRevenue">¥0</div>
            </div>
        </div>

        <!-- 入住率图表 -->
        <div class="chart-section">
            <div class="chart-header">
                <h2 class="chart-title">
                    <i class="fas fa-chart-bar" style="margin-right: 8px;"></i>
                    各房间类型入住统计
                </h2>
                <div>
                    <button class="layui-btn layui-btn-sm" onclick="switchChart('bar')">
                        <i class="fas fa-chart-bar"></i> 柱状图
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-primary" onclick="switchChart('pie')">
                        <i class="fas fa-chart-pie"></i> 饼图
                    </button>
                </div>
            </div>
            <div class="chart-content">
                <div id="occupancyChart" class="chart-container"></div>
            </div>
        </div>

        <!-- 入住率趋势图表 -->
        <div class="chart-section">
            <div class="chart-header">
                <h2 class="chart-title">
                    <i class="fas fa-chart-line" style="margin-right: 8px;"></i>
                    入住率趋势分析
                </h2>
                <div class="trend-info">
                    <span class="info-text">显示所选周期内的入住率变化趋势</span>
                </div>
            </div>
            <div class="chart-content">
                <div id="occupancyTrendChart" class="chart-container"></div>
            </div>
        </div>

        <!-- 详细数据表格 -->
        <div class="table-section">
            <div class="chart-header">
                <h2 class="chart-title">
                    <i class="fas fa-table" style="margin-right: 8px;"></i>
                    详细统计数据
                </h2>
            </div>
            <div class="table-container">
                <table class="layui-table" lay-skin="line">
                    <thead>
                    <tr>
                        <th>房间类型</th>
                        <th>房间数量</th>
                        <th>入住数量</th>
                        <th>入住率</th>
                        <th>订单数量</th>
                        <th>收入贡献</th>
                    </tr>
                    </thead>
                    <tbody id="occupancyTableBody">
                        <tr>
                            <td colspan="5" style="text-align: center; color: #999;">暂无数据</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <script>
        layui.use(['layer', 'form', 'laydate'], function(){
            var layer = layui.layer;
            var form = layui.form;
            var laydate = layui.laydate;


            // 初始化图表
            var occupancyChart = echarts.init(document.getElementById('occupancyChart'));
            var trendChart = echarts.init(document.getElementById('occupancyTrendChart'));
            var currentChartType = 'bar';

            // 搜索
            form.on('submit(searchBtn)', function(data){
                var field = data.field;
                loadOccupancyData(field.period);
                return false;
            });

            // 默认加载数据
            loadOccupancyData('week');

            // 加载入住统计数据
            function loadOccupancyData(period) {
                var params = 'period=' + period;

                fetch('${pageContext.request.contextPath}/admin/statistics/occupancy/data?' + params)
                    .then(r => r.json())
                    .then(res => {
                        if(res.success) {
                            console.log('入住统计数据:', res.data);
                            updateStats(res.data);
                            updateChart(res.data, currentChartType);
                            updateTable(res.data);

                            // 如果有趋势数据，显示趋势图
                            var trendData = res.data.find(function(item) {
                                return item.trend;
                            });
                            if (trendData && trendData.trend) {
                                updateTrendChart(trendData.trend);
                            }
                        } else {
                            layer.msg(res.message || '加载数据失败', {icon: 2});
                        }
                    })
                    .catch(() => {
                        layer.msg('网络异常，请重试', {icon: 2});
                    });
            }

            // 更新趋势图表
            function updateTrendChart(trendData) {
                if (!trendChart) return;

                var option = {
                    tooltip: {
                        trigger: 'axis',
                        formatter: function(params) {
                            var item = params[0];
                            var dataItem = trendData[item.dataIndex];
                            return item.name + '<br/>' +
                                   '入住率: ' + item.value + '%<br/>' +
                                   '总房间数: ' + (dataItem.totalRooms || 0) + '<br/>' +
                                   '入住订单数: ' + (dataItem.occupiedOrders || 0);
                        }
                    },
                    grid: {
                        left: '3%',
                        right: '4%',
                        bottom: '15%',
                        containLabel: true
                    },
                    xAxis: {
                        type: 'category',
                        data: trendData.map(item => item.period || ''),
                        axisLabel: {
                            rotate: 45,
                            interval: 0
                        }
                    },
                    yAxis: {
                        type: 'value',
                        name: '入住率 (%)',
                        axisLabel: {
                            formatter: '{value}%'
                        }
                    },
                    series: [{
                        name: '入住率趋势',
                        type: 'line',
                        data: trendData.map(item => item.occupancyRate || 0),
                        smooth: true,
                        itemStyle: {
                            color: '#1890ff'
                        },
                        areaStyle: {
                            color: 'rgba(24, 144, 255, 0.1)'
                        },
                        markPoint: {
                            data: [
                                {type: 'max', name: '最大值'},
                                {type: 'min', name: '最小值'}
                            ]
                        }
                    }]
                };

                trendChart.setOption(option, true);
            }

            // 更新统计概览
            function updateStats(data) {
                // 查找汇总数据（categoryId为summary的项目）
                var summaryData = null;
                var categoryData = [];

                data.forEach(function(item) {
                    if (item.categoryId === 'summary') {
                        summaryData = item;
                    } else if (item.categoryName && item.categoryName !== '总体统计') {
                        categoryData.push(item);
                    }
                });

                if (summaryData) {
                    document.getElementById('totalRooms').textContent = summaryData.totalRooms || 0;
                    document.getElementById('totalOccupied').textContent = Math.round((summaryData.occupancyRate / 100) * summaryData.totalRooms) || 0;
                    document.getElementById('avgOccupancyRate').textContent = (summaryData.occupancyRate || 0) + '%';
                    document.getElementById('totalRevenue').textContent = '¥' + (parseFloat(summaryData.totalRevenue || 0)).toFixed(2);
                } else {
                    // 如果没有汇总数据，则计算各分类的总和
                    var totalRooms = 0;
                    var totalRevenue = 0;
                    var weightedRate = 0;

                    categoryData.forEach(function(item) {
                        totalRooms += item.totalRooms || 0;
                        totalRevenue += parseFloat(item.totalRevenue || 0);
                        weightedRate += (item.occupancyRate || 0) * (item.totalRooms || 0);
                    });

                    var avgRate = totalRooms > 0 ? (weightedRate / totalRooms).toFixed(1) : 0;

                    document.getElementById('totalRooms').textContent = totalRooms;
                    document.getElementById('totalOccupied').textContent = Math.round(avgRate / 100 * totalRooms);
                    document.getElementById('avgOccupancyRate').textContent = avgRate + '%';
                    document.getElementById('totalRevenue').textContent = '¥' + totalRevenue.toFixed(2);
                }
            }

            // 更新图表
            function updateChart(data, chartType) {
                // 过滤掉汇总数据和趋势数据，只显示各分类数据
                var chartData = data.filter(function(item) {
                    return item.categoryId !== 'summary' && !item.trend;
                });

                var option = {};

                if(chartType === 'bar') {
                    option = {
                        tooltip: {
                            trigger: 'axis',
                            axisPointer: {
                                type: 'shadow'
                            },
                            formatter: function(params) {
                                var item = params[0];
                                var dataItem = chartData[item.dataIndex];
                                return item.name + '<br/>' +
                                       '入住率: ' + item.value + '%<br/>' +
                                       '房间数: ' + (dataItem.totalRooms || 0) + '<br/>' +
                                       '订单数: ' + (dataItem.orderCount || 0) + '<br/>' +
                                       '收入: ¥' + (parseFloat(dataItem.totalRevenue || 0)).toFixed(2);
                            }
                        },
                        grid: {
                            left: '3%',
                            right: '4%',
                            bottom: '15%',
                            containLabel: true
                        },
                        xAxis: {
                            type: 'category',
                            data: chartData.map(item => item.categoryName || '未命名'),
                            axisLabel: {
                                rotate: 45,
                                interval: 0
                            }
                        },
                        yAxis: {
                            type: 'value',
                            name: '入住率 (%)',
                            axisLabel: {
                                formatter: '{value}%'
                            }
                        },
                        series: [{
                            name: '入住率',
                            type: 'bar',
                            data: chartData.map(item => item.occupancyRate || 0),
                            itemStyle: {
                                color: function(params) {
                                    var rate = chartData[params.dataIndex].occupancyRate || 0;
                                    if(rate >= 80) return '#52c41a';
                                    if(rate >= 60) return '#faad14';
                                    if(rate >= 30) return '#1890ff';
                                    return '#ff4d4f';
                                }
                            },
                            label: {
                                show: true,
                                position: 'top',
                                formatter: '{c}%'
                            }
                        }]
                    };
                } else {
                    option = {
                        tooltip: {
                            trigger: 'item',
                            formatter: function(params) {
                                var dataItem = chartData[params.dataIndex];
                                return params.name + '<br/>' +
                                       '入住率: ' + params.value + '%<br/>' +
                                       '房间数: ' + (dataItem.totalRooms || 0) + '<br/>' +
                                       '订单数: ' + (dataItem.orderCount || 0);
                            }
                        },
                        legend: {
                            orient: 'vertical',
                            left: 'left',
                            top: 'middle'
                        },
                        series: [{
                            name: '入住率',
                            type: 'pie',
                            radius: ['30%', '70%'],
                            center: ['60%', '50%'],
                            data: chartData.map(item => ({
                                value: item.occupancyRate || 0,
                                name: item.categoryName || '未命名'
                            })),
                            emphasis: {
                                itemStyle: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }
                            },
                            label: {
                                formatter: '{b}: {d}%'
                            }
                        }]
                    };
                }

                occupancyChart.setOption(option, true);
            }

            // 更新表格
            function updateTable(data) {
                // 过滤掉汇总数据和趋势数据，只显示各分类数据
                var tableData = data.filter(function(item) {
                    return item.categoryId !== 'summary' && !item.trend;
                });

                var html = '';
                if(tableData.length > 0) {
                    tableData.forEach(function(item) {
                        var rateClass = '';
                        var rate = item.occupancyRate || 0;
                        if(rate >= 80) rateClass = 'rate-high';
                        else if(rate >= 60) rateClass = 'rate-medium';
                        else if(rate >= 30) rateClass = 'rate-normal';
                        else rateClass = 'rate-low';

                        var occupiedCount = Math.round((rate / 100) * (item.totalRooms || 0));

                        html += '<tr>' +
                                '<td>' + (item.categoryName || '未命名') + '</td>' +
                                '<td>' + (item.totalRooms || 0) + '</td>' +
                                '<td>' + occupiedCount + '</td>' +
                                '<td><span class="rate-cell ' + rateClass + '">' + rate.toFixed(1) + '%</span></td>' +
                                '<td>' + (item.orderCount || 0) + '</td>' +
                                '<td>¥' + (parseFloat(item.totalRevenue || 0)).toFixed(2) + '</td>' +
                                '</tr>';
                    });
                } else {
                    html = '<tr><td colspan="6" style="text-align: center; color: #999;">暂无数据</td></tr>';
                }

                document.getElementById('occupancyTableBody').innerHTML = html;
            }

            // 切换图表类型
            window.switchChart = function(type) {
                currentChartType = type;
                // 获取当前选中的周期
                var currentPeriod = document.querySelector('[name=period]').value;
                loadOccupancyData(currentPeriod); // 重新加载当前数据
            };

            // 导出数据
            window.exportData = function() {
                layer.msg('导出功能开发中...', {icon: 0});
            };

            // 响应式调整
            window.addEventListener('resize', function() {
                occupancyChart.resize();
                if (trendChart) {
                    trendChart.resize();
                }
            });
        });
    </script>
</body>
</html>
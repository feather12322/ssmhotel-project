<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>收入统计 - 酒店管理系统</title>
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

        .summary-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .summary-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            text-align: center;
        }

        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }

        .summary-card .stat-icon {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.8;
        }

        .summary-card .stat-title {
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .summary-card .stat-value {
            color: #333;
            font-size: 28px;
            font-weight: 700;
            margin: 0;
        }

        .summary-card.revenue .stat-icon { color: #ff5722; }
        .summary-card.orders .stat-icon { color: #009688; }
        .summary-card.avg .stat-icon { color: #1890ff; }
        .summary-card.growth .stat-icon { color: #52c41a; }

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

        .charts-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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

        .revenue-cell {
            font-weight: bold;
            color: #ff5722;
        }

        .percentage-cell {
            font-weight: bold;
        }

        .percentage-high { color: #52c41a; }
        .percentage-medium { color: #faad14; }
        .percentage-low { color: #ff4d4f; }

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

            .summary-section {
                grid-template-columns: 1fr;
            }

            .charts-row {
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
            <form class="layui-form filter-form" lay-filter="revenueFilterForm">
                <div class="layui-form-item">
                    <label class="layui-form-label">统计周期</label>
                    <div class="layui-input-block">
                        <select name="period">
                            <option value="day">按日统计</option>
                            <option value="week">按周统计</option>
                            <option value="month" selected>按月统计</option>
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

        <!-- 收入概览 -->
        <div class="summary-section">
            <div class="summary-card revenue">
                <div class="stat-icon">
                    <i class="fas fa-yen-sign"></i>
                </div>
                <div class="stat-title">总收入</div>
                <div class="stat-value" id="totalRevenue">¥0.00</div>
            </div>

            <div class="summary-card orders">
                <div class="stat-icon">
                    <i class="fas fa-receipt"></i>
                </div>
                <div class="stat-title">订单数量</div>
                <div class="stat-value" id="totalOrders">0</div>
            </div>

            <div class="summary-card avg">
                <div class="stat-icon">
                    <i class="fas fa-calculator"></i>
                </div>
                <div class="stat-title">平均订单金额</div>
                <div class="stat-value" id="avgOrderValue">¥0.00</div>
            </div>

            <div class="summary-card growth">
                <div class="stat-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-title">收入增长率</div>
                <div class="stat-value" id="growthRate">+0.0%</div>
            </div>
        </div>

        <!-- 图表区域 -->
        <div class="chart-section">
            <div class="chart-header">
                <h2 class="chart-title">
                    <i class="fas fa-chart-area" style="margin-right: 8px;"></i>
                    收入统计图表
                </h2>
            </div>
            <div class="chart-content">
                <div class="charts-row">
                    <div class="chart-container" id="revenueTrendChart"></div>
                    <div class="chart-container" id="categoryRevenueChart"></div>
                </div>
            </div>
        </div>

        <!-- 详细数据表格 -->
        <div class="table-section">
            <div class="chart-header">
                <h2 class="chart-title">
                    <i class="fas fa-table" style="margin-right: 8px;"></i>
                    各房间类型收入统计
                </h2>
            </div>
            <div class="table-container">
                <table class="layui-table" lay-skin="line">
                    <thead>
                    <tr>
                        <th>房间类型</th>
                        <th>订单数量</th>
                        <th>收入金额</th>
                        <th>收入占比</th>
                        <th>平均单价</th>
                    </tr>
                    </thead>
                    <tbody id="revenueTableBody">
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
            var trendChart = echarts.init(document.getElementById('revenueTrendChart'));
            var categoryChart = echarts.init(document.getElementById('categoryRevenueChart'));

            // 搜索
            form.on('submit(searchBtn)', function(data){
                var field = data.field;
                loadRevenueData(field.period);
                return false;
            });

            // 默认加载数据
            loadRevenueData('month');

            // 加载收入统计数据
            function loadRevenueData(period) {
                var params = 'period=' + period;

                fetch('${pageContext.request.contextPath}/admin/statistics/revenue/data?' + params)
                    .then(r => r.json())
                    .then(res => {
                        if(res.success) {
                            updateSummary(res.data);
                            updateCharts(res.data);
                            updateTable(res.data);
                        } else {
                            layer.msg(res.message || '加载数据失败', {icon: 2});
                        }
                    })
                    .catch(() => {
                        layer.msg('网络异常，请重试', {icon: 2});
                    });
            }

            // 更新收入概览
            function updateSummary(data) {
                if(data.length > 0) {
                    var summary = data[0]; // 第一项是汇总数据
                    var totalRevenue = parseFloat(summary.totalRevenue || 0);
                    var totalOrders = parseInt(summary.totalOrders || 0);
                    var avgValue = totalOrders > 0 ? (totalRevenue / totalOrders) : 0;

                    document.getElementById('totalRevenue').textContent = '¥' + totalRevenue.toFixed(2);
                    document.getElementById('totalOrders').textContent = totalOrders;
                    document.getElementById('avgOrderValue').textContent = '¥' + avgValue.toFixed(2);
                    document.getElementById('growthRate').textContent = '+0.0%'; // 这里可以计算增长率
                }
            }

            // 更新图表
            function updateCharts(data) {
                if(data.length > 0) {
                    var summary = data[0];
                    var categories = data.slice(1); // 除第一项外的其他项是分类数据

                    // 收入趋势图
                    var trendOption = {
                        title: {
                            text: '收入趋势',
                            left: 'center'
                        },
                        tooltip: {
                            trigger: 'axis',
                            formatter: function(params) {
                                var item = params[0];
                                return item.name + '<br/>收入: ¥' + item.value;
                            }
                        },
                        grid: {
                            left: '3%',
                            right: '4%',
                            bottom: '3%',
                            containLabel: true
                        },
                        xAxis: {
                            type: 'category',
                            data: summary.trend ? summary.trend.map(item => item.date || item.period) : []
                        },
                        yAxis: {
                            type: 'value',
                            name: '收入 (元)',
                            axisLabel: {
                                formatter: '¥{value}'
                            }
                        },
                        series: [{
                            name: '收入',
                            type: 'line',
                            data: summary.trend ? summary.trend.map(item => parseFloat(item.revenue || 0)) : [],
                            smooth: true,
                            areaStyle: {
                                opacity: 0.3
                            },
                            itemStyle: {
                                color: '#009688'
                            }
                        }]
                    };

                    // 分类收入饼图
                    var categoryOption = {
                        title: {
                            text: '各类型收入占比',
                            left: 'center'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: '{a} <br/>{b}: ¥{c} ({d}%)'
                        },
                        legend: {
                            orient: 'vertical',
                            left: 'left'
                        },
                        series: [{
                            name: '收入',
                            type: 'pie',
                            radius: '50%',
                            data: categories.map(item => ({
                                value: parseFloat(item.revenue || 0),
                                name: item.categoryName || '未命名'
                            })),
                            emphasis: {
                                itemStyle: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }
                            }
                        }]
                    };

                    trendChart.setOption(trendOption, true);
                    categoryChart.setOption(categoryOption, true);
                }
            }

            // 更新表格
            function updateTable(data) {
                var html = '';
                if(data.length > 1) {
                    var categories = data.slice(1); // 除第一项外的其他项是分类数据

                    categories.forEach(function(item) {
                        var percentage = parseFloat(item.percentage || 0);
                        var percentageClass = '';
                        if(percentage >= 30) percentageClass = 'percentage-high';
                        else if(percentage >= 15) percentageClass = 'percentage-medium';
                        else percentageClass = 'percentage-low';

                        var orderCount = parseInt(item.orderCount || 0);
                        var revenue = parseFloat(item.revenue || 0);
                        var avgPrice = orderCount > 0 ? (revenue / orderCount).toFixed(2) : '0.00';

                        html += '<tr>' +
                                '<td>' + (item.categoryName || '未命名') + '</td>' +
                                '<td>' + orderCount + '</td>' +
                                '<td><span class="revenue-cell">¥' + revenue.toFixed(2) + '</span></td>' +
                                '<td><span class="percentage-cell ' + percentageClass + '">' + percentage.toFixed(1) + '%</span></td>' +
                                '<td>¥' + avgPrice + '</td>' +
                                '</tr>';
                    });
                } else {
                    html = '<tr><td colspan="5" style="text-align: center; color: #999;">暂无数据</td></tr>';
                }

                document.getElementById('revenueTableBody').innerHTML = html;
            }

            // 导出数据
            window.exportData = function() {
                layer.msg('导出功能开发中...', {icon: 0});
            };

            // 响应式调整
            window.addEventListener('resize', function() {
                trendChart.resize();
                categoryChart.resize();
            });
        });
    </script>
</body>
</html>
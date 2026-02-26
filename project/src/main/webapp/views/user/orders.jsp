<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>酒店预订系统 - 我的订单</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- 统一头部导航 -->
    <%@ include file="header.jsp" %>

    <!-- 主内容区域 -->
    <div class="main-content">
        <!-- 面包屑导航 -->
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/user/index">首页</a> >
            <span>我的订单</span>
        </div>

        <!-- 订单状态筛选选项卡 -->
        <div class="filter-tabs-section">
            <div class="layui-tab layui-tab-brief" lay-filter="orderTabs">
                <ul class="layui-tab-title">
                    <li class="layui-this" data-status="">
                        <i class="fas fa-list-ul"></i> 全部订单
                    </li>
                    <li data-status="0">
                        <i class="fas fa-clock"></i> 待确认
                    </li>
                    <li data-status="1">
                        <i class="fas fa-check-circle"></i> 已确认
                    </li>
                    <li data-status="2">
                        <i class="fas fa-user-check"></i> 已入住
                    </li>
                    <li data-status="3">
                        <i class="fas fa-check-double"></i> 已完成
                    </li>
                    <li data-status="4">
                        <i class="fas fa-times-circle"></i> 已取消
                    </li>
                </ul>
            </div>
        </div>

        <!-- 订单列表 -->
        <div class="orders-section">
            <div class="section-header">
                <h2><i class="fas fa-list-ul" style="margin-right: 10px;"></i>订单列表</h2>
            </div>

            <c:if test="${empty orders}">
                <div class="no-orders">
                    <i class="fas fa-shopping-cart"></i>
                    <h3>暂无订单</h3>
                    <p>您还没有任何订单记录</p>
                    <a href="${pageContext.request.contextPath}/user/rooms" class="book-now-btn">
                        <i class="fas fa-plus"></i> 立即预订
                    </a>
                </div>
            </c:if>

            <c:if test="${not empty orders}">
                <div class="orders-grid">
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card">
                            <div class="order-header">
                                <div class="order-info">
                                    <div class="order-no">订单号：${order.orderNo}</div>
                                    <div class="order-time">
                                        <i class="fas fa-calendar-alt"></i>
                                        下单时间：<fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                                    </div>
                                </div>
                                <div class="order-status">
                                    <span class="status-badge status-${order.orderStatus}">
                                        <c:choose>
                                            <c:when test="${order.orderStatus == 0}">待确认</c:when>
                                            <c:when test="${order.orderStatus == 1}">已确认</c:when>
                                            <c:when test="${order.orderStatus == 2}">已入住</c:when>
                                            <c:when test="${order.orderStatus == 3}">已完成</c:when>
                                            <c:when test="${order.orderStatus == 4}">已取消</c:when>
                                            <c:otherwise>未知状态</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <div class="order-content">
                                <div class="room-info">
                                    <div class="room-image">
                                        <c:forEach var="room" items="${rooms}">
                                            <c:if test="${room.roomId == order.roomId}">
                                                <c:if test="${not empty room.coverImg}">
                                                    <img src="${room.coverImg}" alt="${room.roomNo}">
                                                </c:if>
                                                <c:if test="${empty room.coverImg}">
                                                    <div class="no-image">
                                                        <i class="fas fa-image"></i>
                                                    </div>
                                                </c:if>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <div class="room-details">
                                        <c:forEach var="room" items="${rooms}">
                                            <c:if test="${room.roomId == order.roomId}">
                                                <h4>${room.roomNo} - ${room.bedType}</h4>
                                                <p><i class="fas fa-expand-arrows-alt"></i> ${room.area}m²</p>
                                                <p><i class="fas fa-concierge-bell"></i> ${room.facilities}</p>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="booking-info">
                                    <div class="info-item">
                                        <label>入住人：</label>
                                        <span>${order.guestName}</span>
                                    </div>
                                    <div class="info-item">
                                        <label>联系电话：</label>
                                        <span>${order.phone}</span>
                                    </div>
                                    <div class="info-item">
                                        <label>入住日期：</label>
                                        <span><fmt:formatDate value="${order.checkInDate}" pattern="yyyy-MM-dd"/></span>
                                    </div>
                                    <div class="info-item">
                                        <label>退房日期：</label>
                                        <span><fmt:formatDate value="${order.checkOutDate}" pattern="yyyy-MM-dd"/></span>
                                    </div>
                                    <div class="info-item">
                                        <label>入住天数：</label>
                                        <span>${order.stayDays}晚</span>
                                    </div>
                                </div>

                                <div class="price-info">
                                    <div class="price-breakdown">
                                        <div class="price-row">
                                            <span>房间价格：</span>
                                            <span>¥${order.roomPrice}/晚</span>
                                        </div>
                                        <div class="price-row">
                                            <span>入住天数：</span>
                                            <span>${order.stayDays}晚</span>
                                        </div>
                                        <div class="price-row total">
                                            <span>订单总价：</span>
                                            <span>¥${order.totalPrice}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${not empty order.remark}">
                                <div class="order-remark">
                                    <label>特殊要求：</label>
                                    <span>${order.remark}</span>
                                </div>
                            </c:if>

                            <div class="order-actions">
                                <c:if test="${order.orderStatus == 0}">
                                    <button class="action-btn cancel-btn" onclick="cancelOrder(${order.orderId})">
                                        <i class="fas fa-times"></i> 取消订单
                                    </button>
                                </c:if>
                                <c:if test="${order.orderStatus == 4 && not empty order.cancelReason}">
                                    <div class="cancel-reason">
                                        <label>取消原因：</label>
                                        <span>${order.cancelReason}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- 分页 -->
            <c:if test="${total > 0}">
                <div class="pagination" id="pagination"></div>
            </c:if>
        </div>
    </div>

    <style>
        /* 主内容区域 */
        .main-content {
            padding: 30px;
            max-width: 1400px;
            margin: 0 auto;
        }

        /* 面包屑导航 */
        .breadcrumb {
            margin-bottom: 20px;
            color: #666;
        }

        .breadcrumb a {
            color: #009688;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        /* 筛选选项卡区域 */
        .filter-tabs-section {
            margin-bottom: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 20px;
        }

        .layui-tab-brief .layui-tab-title li {
            margin: 0 30px 0 0;
            padding: 0;
            font-size: 16px;
            font-weight: 500;
        }

        .layui-tab-brief .layui-tab-title li i {
            margin-right: 8px;
            font-size: 14px;
        }

        .layui-tab-brief .layui-tab-title .layui-this {
            color: #009688;
            border-bottom: 2px solid #009688;
        }

        .layui-tab-brief .layui-tab-title .layui-this i {
            color: #009688;
        }

        /* 订单区域 */
        .orders-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 30px;
        }

        /* 分页样式 */
        .pagination {
            margin-top: 30px;
            padding: 20px 0;
            text-align: center;
        }

        .section-header {
            margin-bottom: 25px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 15px;
        }

        .section-header h2 {
            color: #333;
            margin: 0;
            font-size: 20px;
        }

        /* 无订单状态 */
        .no-orders {
            text-align: center;
            padding: 80px 20px;
            color: #999;
        }

        .no-orders i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .no-orders h3 {
            color: #666;
            margin-bottom: 10px;
        }

        .book-now-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 24px;
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .book-now-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,150,136,0.3);
        }

        /* 订单网格 */
        .orders-grid {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .order-card {
            border: 1px solid #e8f4f8;
            border-radius: 12px;
            padding: 25px;
            background: #fafafa;
            transition: all 0.3s ease;
        }

        .order-card:hover {
            box-shadow: 0 6px 25px rgba(0,0,0,0.1);
            border-color: #009688;
        }

        /* 订单头部 */
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e8f4f8;
        }

        .order-info {
            flex: 1;
        }

        .order-no {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }

        .order-time {
            color: #666;
            font-size: 14px;
        }

        .order-time i {
            margin-right: 5px;
        }

        .order-status {
            text-align: right;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            text-align: center;
        }

        .status-0 { background: #fff3cd; color: #856404; } /* 待确认 */
        .status-1 { background: #d1ecf1; color: #0c5460; } /* 已确认 */
        .status-2 { background: #d4edda; color: #155724; } /* 已入住 */
        .status-3 { background: #009688; color: white; } /* 已完成 */
        .status-4 { background: #f8d7da; color: #721c24; } /* 已取消 */

        /* 订单内容 */
        .order-content {
            display: grid;
            grid-template-columns: 200px 1fr 200px;
            gap: 20px;
            margin-bottom: 20px;
        }

        .room-info {
            display: flex;
            gap: 15px;
        }

        .room-image {
            width: 80px;
            height: 60px;
            border-radius: 6px;
            overflow: hidden;
            flex-shrink: 0;
        }

        .room-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .room-image .no-image {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: #adb5bd;
        }

        .room-details h4 {
            color: #333;
            margin: 0 0 8px 0;
            font-size: 16px;
        }

        .room-details p {
            color: #666;
            margin: 4px 0;
            font-size: 13px;
        }

        .room-details i {
            width: 14px;
            margin-right: 5px;
            color: #009688;
        }

        .booking-info {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .info-item {
            display: flex;
            align-items: center;
        }

        .info-item label {
            width: 80px;
            color: #666;
            font-size: 14px;
            font-weight: 500;
        }

        .info-item span {
            color: #333;
            font-size: 14px;
        }

        .price-info {
            text-align: right;
        }

        .price-breakdown {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: #666;
        }

        .price-row.total {
            border-top: 2px solid #009688;
            padding-top: 8px;
            font-size: 16px;
            font-weight: 600;
            color: #ff5722;
        }

        /* 特殊要求 */
        .order-remark {
            background: #fff8e1;
            border: 1px solid #ffe082;
            border-radius: 6px;
            padding: 12px;
            margin-bottom: 15px;
        }

        .order-remark label {
            color: #f57c00;
            font-weight: 500;
        }

        .order-remark span {
            color: #333;
        }

        /* 订单操作 */
        .order-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .cancel-btn {
            background: #ff5722;
            color: white;
        }

        .cancel-btn:hover {
            background: #d84315;
            transform: translateY(-1px);
        }

        .cancel-reason {
            background: #ffebee;
            border: 1px solid #ffcdd2;
            border-radius: 6px;
            padding: 12px;
            margin-top: 10px;
        }

        .cancel-reason label {
            color: #c62828;
            font-weight: 500;
        }

        .cancel-reason span {
            color: #333;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .main-content {
                padding: 20px 15px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }

            .stat-card {
                padding: 15px;
            }

            .order-content {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .order-header {
                flex-direction: column;
                gap: 10px;
            }

            .order-status {
                text-align: left;
            }

            .price-info {
                text-align: left;
            }

            .order-actions {
                justify-content: center;
            }
        }
    </style>

    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <script>
        // 页面加载调试
        console.log('页面开始加载');

        layui.use(['layer', 'element', 'laypage'], function(){
            var layer = layui.layer;
            var element = layui.element;
            var laypage = layui.laypage;

            console.log('Layui模块加载完成');

            // 存储当前页面参数
            var currentPage = parseInt('${page}') || 1;
            var currentLimit = parseInt('${limit}') || 5;
            var currentStatus = '${currentStatus}' || '';

            console.log('初始化参数:', {
                currentPage: currentPage,
                currentLimit: currentLimit,
                currentStatus: currentStatus,
                total: '${total}',
                hasOrders: '${not empty orders}'
            });

            // 确保DOM加载完成后初始化
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initComponents);
            } else {
                initComponents();
            }

            function initComponents() {
                console.log('开始初始化组件');
                // 初始化选项卡状态
                initTabStatus();

                // 初始化分页
                initPagination();

                // 重新渲染元素
                element.render();
                console.log('元素渲染完成');
            }

            function initTabStatus() {
                var currentStatus = '${currentStatus}';
                console.log('初始化选项卡状态:', currentStatus);

                // 先移除所有active状态
                var tabItems = document.querySelectorAll('.layui-tab-title li');
                for (var i = 0; i < tabItems.length; i++) {
                    tabItems[i].classList.remove('layui-this');
                }

                // 设置当前状态的选项卡为active
                var targetTab;
                if(currentStatus === '' || currentStatus === null || currentStatus === undefined) {
                    // 默认选择"全部订单"
                    targetTab = document.querySelector('.layui-tab-title li[data-status=""]');
                } else {
                    targetTab = document.querySelector('.layui-tab-title li[data-status="' + currentStatus + '"]');
                }

                if(targetTab) {
                    targetTab.classList.add('layui-this');
                    console.log('激活选项卡:', targetTab.textContent.trim());
                } else {
                    console.log('未找到对应的选项卡');
                }
            }

            function initPagination() {
                var totalCount = parseInt('${total}') || 0;
                var paginationElem = document.getElementById('pagination');

                console.log('分页初始化检查:');
                console.log('- totalCount:', totalCount);
                console.log('- currentPage:', currentPage);
                console.log('- currentLimit:', currentLimit);
                console.log('- currentStatus:', currentStatus);
                console.log('- pagination元素存在:', !!paginationElem);

                if(totalCount > 0 && paginationElem) {
                    console.log('开始渲染分页，参数:', {
                        elem: 'pagination',
                        count: totalCount,
                        curr: currentPage,
                        limit: currentLimit
                    });
                    laypage.render({
                        elem: 'pagination',
                        count: totalCount,
                        curr: currentPage,
                        limit: currentLimit,
                        limits: [5, 10, 15],
                        layout: ['count', 'prev', 'page', 'next', 'limit', 'skip'],
                        jump: function(obj, first){
                            if(!first){
                                console.log('分页跳转:', obj.curr, obj.limit);
                                var url = '${pageContext.request.contextPath}/user/orders?page=' + obj.curr + '&limit=' + obj.limit;
                                var currentActiveStatus = getCurrentStatus();
                                if(currentActiveStatus && currentActiveStatus !== '') {
                                    url += '&status=' + currentActiveStatus;
                                }
                                console.log('分页跳转URL:', url);
                                window.location.href = url;
                            }
                        }
                    });
                }
            }

            function getCurrentStatus() {
                var activeTab = document.querySelector('.layui-tab-title li.layui-this');
                return activeTab ? activeTab.getAttribute('data-status') || '' : '';
            }

            // 选项卡切换 - 使用原生事件监听
            console.log('绑定选项卡切换事件');
            var tabItems = document.querySelectorAll('.layui-tab-title li');
            console.log('找到选项卡数量:', tabItems.length);

            for (var i = 0; i < tabItems.length; i++) {
                var tab = tabItems[i];
                var status = tab.getAttribute('data-status');
                console.log('选项卡 ' + i + ' 状态:', status, '文本:', tab.textContent.trim());

                tab.addEventListener('click', function() {
                    var clickedStatus = this.getAttribute('data-status') || '';
                    console.log('点击选项卡，状态:', clickedStatus);

                    var url = '${pageContext.request.contextPath}/user/orders?page=1&limit=' + currentLimit;
                    if(clickedStatus !== '') {
                        url += '&status=' + clickedStatus;
                    }
                    console.log('选项卡跳转URL:', url);
                    window.location.href = url;
                });
            }

            // 同时保留Layui的事件监听（以防万一）
            element.on('tab(orderTabs)', function(data){
                console.log('Layui选项卡事件触发');
            });
            console.log('选项卡切换事件绑定完成');
        });

        // 取消订单
        function cancelOrder(orderId) {
            var contentHtml = '<div style="padding: 20px;">';
            contentHtml += '<p>请填写取消原因（选填）：</p>';
            contentHtml += '<textarea id="cancelReason" placeholder="请输入取消原因..." ';
            contentHtml += 'style="width: 100%; height: 80px; border: 1px solid #ddd; border-radius: 4px; padding: 8px; resize: none;"></textarea>';
            contentHtml += '</div>';

            layer.prompt({
                formType: 2,
                value: '',
                title: '取消订单',
                area: ['400px', '200px'],
                content: contentHtml
            }, function(value, index, elem){
                var cancelReason = document.getElementById('cancelReason').value;

                fetch('${pageContext.request.contextPath}/user/cancelOrder', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'orderId=' + orderId + '&cancelReason=' + encodeURIComponent(cancelReason)
                }).then(function(r) { return r.json(); }).then(function(res) {
                    if(res.success){
                        layer.msg('订单取消成功', {icon: 1});
                        setTimeout(function() {
                            var currentStatus = getCurrentStatus();
                            var url = '${pageContext.request.contextPath}/user/orders?page=' + currentPage + '&limit=' + currentLimit;
                            if(currentStatus !== '') {
                                url += '&status=' + currentStatus;
                            }
                            window.location.href = url;
                        }, 1000);
                    } else {
                        layer.msg(res.message || '取消失败', {icon: 2});
                    }
                }).catch(function() {
                    layer.msg('网络异常，请重试', {icon: 2});
                });

                layer.close(index);
            });
        }
    </script>
</body>
</html>
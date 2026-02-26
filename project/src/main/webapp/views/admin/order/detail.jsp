<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单详情 - 酒店管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: #f2f2f2;
        }

        .main-content {
            margin: 20px;
            max-width: 1200px;
        }

        .detail-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .card-header {
            padding: 20px;
            border-bottom: 1px solid #e6e6e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin: 0;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }

        .status-0 { background: #fff3cd; color: #856404; } /* 待确认 */
        .status-1 { background: #d1ecf1; color: #0c5460; } /* 已确认 */
        .status-2 { background: #d4edda; color: #155724; } /* 已入住 */
        .status-3 { background: #009688; color: white; }   /* 已完成 */
        .status-4 { background: #f8d7da; color: #721c24; } /* 已取消 */

        .card-content {
            padding: 20px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .info-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
        }

        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 8px;
            color: #009688;
        }

        .info-item {
            display: flex;
            margin-bottom: 12px;
        }

        .info-item:last-child {
            margin-bottom: 0;
        }

        .info-label {
            width: 100px;
            color: #666;
            font-weight: 500;
            flex-shrink: 0;
        }

        .info-value {
            color: #333;
            flex: 1;
        }

        .price-breakdown {
            background: white;
            border-radius: 6px;
            padding: 15px;
            margin-top: 15px;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .price-row:last-child {
            border-bottom: none;
            border-top: 2px solid #009688;
            font-weight: bold;
            color: #ff5722;
        }

        .special-requests {
            background: #fff8e1;
            border: 1px solid #ffe082;
            border-radius: 6px;
            padding: 15px;
            margin-top: 15px;
        }

        .special-requests .section-title {
            color: #f57c00;
        }

        .cancel-reason {
            background: #ffebee;
            border: 1px solid #ffcdd2;
            border-radius: 6px;
            padding: 15px;
            margin-top: 15px;
        }

        .cancel-reason .section-title {
            color: #c62828;
        }

        .action-buttons {
            text-align: center;
            padding: 20px;
            background: white;
            border-top: 1px solid #e6e6e6;
        }

        .action-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            margin: 0 5px;
            transition: all 0.3s ease;
        }

        .btn-back { background: #f5f5f5; color: #666; }
        .btn-confirm { background: #1890ff; color: white; }
        .btn-cancel { background: #faad14; color: white; }
        .btn-complete { background: #52c41a; color: white; }
        .btn-delete { background: #ff4d4f; color: white; }

        .btn-back:hover { background: #e9ecef; }
        .btn-confirm:hover { background: #40a9ff; }
        .btn-cancel:hover { background: #ffc069; }
        .btn-complete:hover { background: #73d13d; }
        .btn-delete:hover { background: #ff7875; }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .main-content {
                margin: 10px;
            }

            .info-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .card-header {
                flex-direction: column;
                gap: 10px;
                text-align: center;
            }

            .action-buttons {
                padding: 15px;
            }

            .action-btn {
                display: block;
                width: 100%;
                margin: 5px 0;
            }
        }
    </style>
</head>
<body>
    <div class="main-content">
        <!-- 订单基本信息 -->
        <div class="detail-card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-file-invoice-dollar" style="margin-right: 8px;"></i>
                    订单详情 - ${order.orderNo}
                </h2>
                <span class="status-badge status-${order.orderStatus}">
                    <c:choose>
                        <c:when test="${order.orderStatus == 0}">待确认</c:when>
                        <c:when test="${order.orderStatus == 1}">已确认</c:when>
                        <c:when test="${order.orderStatus == 2}">已入住</c:when>
                        <c:when test="${order.orderStatus == 3}">已完成</c:when>
                        <c:otherwise>已取消</c:otherwise>
                    </c:choose>
                </span>
            </div>

            <div class="card-content">
                <div class="info-grid">
                    <!-- 订单信息 -->
                    <div class="info-section">
                        <h3 class="section-title">
                            <i class="fas fa-shopping-cart"></i>
                            订单信息
                        </h3>
                        <div class="info-item">
                            <span class="info-label">订单号：</span>
                            <span class="info-value">${order.orderNo}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">下单时间：</span>
                            <span class="info-value">
                                <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">最后更新：</span>
                            <span class="info-value">
                                <fmt:formatDate value="${order.updateTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </span>
                        </div>
                    </div>

                    <!-- 入住人信息 -->
                    <div class="info-section">
                        <h3 class="section-title">
                            <i class="fas fa-user"></i>
                            入住人信息
                        </h3>
                        <div class="info-item">
                            <span class="info-label">入住人：</span>
                            <span class="info-value">${order.guestName}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">联系电话：</span>
                            <span class="info-value">${order.phone}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">用户名：</span>
                            <span class="info-value">${user.userName}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">用户姓名：</span>
                            <span class="info-value">${user.realName}</span>
                        </div>
                    </div>

                    <!-- 房间信息 -->
                    <div class="info-section">
                        <h3 class="section-title">
                            <i class="fas fa-bed"></i>
                            房间信息
                        </h3>
                        <div class="info-item">
                            <span class="info-label">房间号：</span>
                            <span class="info-value">${room.roomNo}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">床型：</span>
                            <span class="info-value">${room.bedType}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">面积：</span>
                            <span class="info-value">${room.area}m²</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">设施：</span>
                            <span class="info-value">${room.facilities}</span>
                        </div>
                    </div>

                    <!-- 入住信息 -->
                    <div class="info-section">
                        <h3 class="section-title">
                            <i class="fas fa-calendar-alt"></i>
                            入住信息
                        </h3>
                        <div class="info-item">
                            <span class="info-label">入住日期：</span>
                            <span class="info-value">
                                <fmt:formatDate value="${order.checkInDate}" pattern="yyyy-MM-dd"/>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">退房日期：</span>
                            <span class="info-value">
                                <fmt:formatDate value="${order.checkOutDate}" pattern="yyyy-MM-dd"/>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">入住天数：</span>
                            <span class="info-value">${order.stayDays}晚</span>
                        </div>
                    </div>
                </div>

                <!-- 价格明细 -->
                <div class="price-breakdown">
                    <h3 class="section-title" style="margin-bottom: 15px;">
                        <i class="fas fa-yen-sign"></i>
                        价格明细
                    </h3>
                    <div class="price-row">
                        <span>房间单价：</span>
                        <span>¥${order.roomPrice}/晚</span>
                    </div>
                    <div class="price-row">
                        <span>入住天数：</span>
                        <span>${order.stayDays}晚</span>
                    </div>
                    <div class="price-row">
                        <span>订单总价：</span>
                        <span>¥${order.totalPrice}</span>
                    </div>
                </div>

                <!-- 特殊要求 -->
                <c:if test="${not empty order.remark}">
                    <div class="special-requests">
                        <h3 class="section-title">
                            <i class="fas fa-sticky-note"></i>
                            特殊要求
                        </h3>
                        <p style="margin: 0; color: #333;">${order.remark}</p>
                    </div>
                </c:if>

                <!-- 取消原因 -->
                <c:if test="${order.orderStatus == 4 && not empty order.cancelReason}">
                    <div class="cancel-reason">
                        <h3 class="section-title">
                            <i class="fas fa-exclamation-triangle"></i>
                            取消原因
                        </h3>
                        <p style="margin: 0; color: #333;">${order.cancelReason}</p>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- 操作按钮 -->
        <div class="detail-card">
            <div class="action-buttons">
                <button class="action-btn btn-back" onclick="goBack()">
                    <i class="fas fa-arrow-left"></i> 返回列表
                </button>

                <c:if test="${order.orderStatus == 0}">
                    <button class="action-btn btn-confirm" onclick="confirmOrder()">
                        <i class="fas fa-check"></i> 确认订单
                    </button>
                    <button class="action-btn btn-cancel" onclick="cancelOrder()">
                        <i class="fas fa-times"></i> 取消订单
                    </button>
                </c:if>

                <c:if test="${order.orderStatus == 1}">
                    <button class="action-btn btn-cancel" onclick="cancelOrder()">
                        <i class="fas fa-times"></i> 取消订单
                    </button>
                </c:if>

                <c:if test="${order.orderStatus == 2}">
                    <button class="action-btn btn-complete" onclick="completeOrder()">
                        <i class="fas fa-check-double"></i> 完成订单
                    </button>
                </c:if>

                <c:if test="${order.orderStatus == 3 || order.orderStatus == 4}">
                    <button class="action-btn btn-delete" onclick="deleteOrder()">
                        <i class="fas fa-trash"></i> 删除订单
                    </button>
                </c:if>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <script>
        layui.use(['layer'], function(){
            var layer = layui.layer;
        });

        // 返回列表
        function goBack() {
            window.location.href = '${pageContext.request.contextPath}/admin/order/list';
        }

        // 确认订单
        function confirmOrder() {
            layer.confirm('确定要确认这个订单吗？', {
                icon: 3,
                title: '确认订单'
            }, function(index){
                fetch('${pageContext.request.contextPath}/admin/order/confirm/${order.orderId}', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'}
                }).then(r => r.json()).then(res => {
                    if(res.success){
                        layer.msg(res.message, {icon: 1});
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        layer.msg(res.message, {icon: 2});
                    }
                }).catch(() => {
                    layer.msg('操作失败', {icon: 2});
                });
                layer.close(index);
            });
        }

        // 取消订单
        function cancelOrder() {
            layer.prompt({
                formType: 2,
                value: '',
                title: '取消订单',
                area: ['400px', '200px'],
                content: '<div style="padding: 20px;"><p>请输入取消原因：</p><textarea id="cancelReason" placeholder="请输入取消原因..." style="width: 100%; height: 80px; border: 1px solid #ddd; border-radius: 4px; padding: 8px; resize: none;"></textarea></div>'
            }, function(value, index, elem){
                var cancelReason = document.getElementById('cancelReason').value;

                fetch('${pageContext.request.contextPath}/admin/order/cancel/${order.orderId}', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'cancelReason=' + encodeURIComponent(cancelReason)
                }).then(r => r.json()).then(res => {
                    if(res.success){
                        layer.msg(res.message, {icon: 1});
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        layer.msg(res.message, {icon: 2});
                    }
                }).catch(() => {
                    layer.msg('操作失败', {icon: 2});
                });

                layer.close(index);
            });
        }

        // 完成订单
        function completeOrder() {
            layer.confirm('确定要完成这个订单吗？', {
                icon: 3,
                title: '完成订单'
            }, function(index){
                fetch('${pageContext.request.contextPath}/admin/order/complete/${order.orderId}', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'}
                }).then(r => r.json()).then(res => {
                    if(res.success){
                        layer.msg(res.message, {icon: 1});
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        layer.msg(res.message, {icon: 2});
                    }
                }).catch(() => {
                    layer.msg('操作失败', {icon: 2});
                });
                layer.close(index);
            });
        }

        // 删除订单
        function deleteOrder() {
            layer.confirm('确定要删除这个订单吗？删除后无法恢复！', {
                icon: 0,
                title: '删除订单'
            }, function(index){
                fetch('${pageContext.request.contextPath}/admin/order/delete/${order.orderId}', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'}
                }).then(r => r.json()).then(res => {
                    if(res.success){
                        layer.msg(res.message, {icon: 1});
                        setTimeout(() => window.location.href = '${pageContext.request.contextPath}/admin/order/list', 1000);
                    } else {
                        layer.msg(res.message, {icon: 2});
                    }
                }).catch(() => {
                    layer.msg('操作失败', {icon: 2});
                });
                layer.close(index);
            });
        }
    </script>
</body>
</html>
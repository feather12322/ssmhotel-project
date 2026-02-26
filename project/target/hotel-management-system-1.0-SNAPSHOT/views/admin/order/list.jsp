<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单管理 - 酒店管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: #f2f2f2;
        }

        .main-content {
            margin: 20px;
        }

        .search-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .search-form {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: flex-end;
        }

        .search-form .layui-form-item {
            margin-bottom: 0;
        }

        .search-form .layui-input,
        .search-form .layui-select {
            width: 150px;
        }

        .search-actions {
            display: flex;
            gap: 10px;
        }

        .content-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .section-header {
            padding: 20px;
            border-bottom: 1px solid #e6e6e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin: 0;
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

        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            text-align: center;
            display: inline-block;
        }

        .status-0 { background: #fff3cd; color: #856404; } /* 待确认 */
        .status-1 { background: #d1ecf1; color: #0c5460; } /* 已确认 */
        .status-2 { background: #d4edda; color: #155724; } /* 已入住 */
        .status-3 { background: #009688; color: white; }   /* 已完成 */
        .status-4 { background: #f8d7da; color: #721c24; } /* 已取消 */

        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            margin-right: 5px;
        }

        .btn-confirm { background: #1890ff; color: white; }
        .btn-checkin { background: #722ed1; color: white; }
        .btn-complete { background: #52c41a; color: white; }
        .btn-cancel { background: #faad14; color: white; }
        .btn-delete { background: #ff4d4f; color: white; }
        .btn-detail { background: #009688; color: white; }

        .pagination {
            padding: 20px;
            text-align: center;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .main-content {
                margin: 10px;
            }

            .search-form {
                flex-direction: column;
                align-items: stretch;
            }

            .search-form .layui-input,
            .search-form .layui-select {
                width: 100%;
            }

        }
    </style>
</head>
<body>
    <!-- 搜索区域 -->
    <div class="main-content">
        <div class="search-section">
            <form class="layui-form search-form" lay-filter="orderSearchForm">
                <div class="layui-form-item">
                    <label class="layui-form-label">订单号</label>
                    <div class="layui-input-block">
                        <input type="text" name="orderNo" placeholder="输入订单号" autocomplete="off" class="layui-input" value="${searchOrderNo}">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">入住人</label>
                    <div class="layui-input-block">
                        <input type="text" name="guestName" placeholder="输入入住人姓名" autocomplete="off" class="layui-input" value="${searchGuestName}">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">联系电话</label>
                    <div class="layui-input-block">
                        <input type="text" name="phone" placeholder="输入联系电话" autocomplete="off" class="layui-input" value="${searchPhone}">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">用户名</label>
                    <div class="layui-input-block">
                        <input type="text" name="userName" placeholder="输入用户名" autocomplete="off" class="layui-input" value="${searchUserName}">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">订单状态</label>
                    <div class="layui-input-block">
                        <select name="orderStatus">
                            <option value="">全部状态</option>
                            <option value="0" <c:if test="${searchOrderStatus == 0}">selected</c:if>>待确认</option>
                            <option value="1" <c:if test="${searchOrderStatus == 1}">selected</c:if>>已确认</option>
                            <option value="2" <c:if test="${searchOrderStatus == 2}">selected</c:if>>已入住</option>
                            <option value="3" <c:if test="${searchOrderStatus == 3}">selected</c:if>>已完成</option>
                            <option value="4" <c:if test="${searchOrderStatus == 4}">selected</c:if>>已取消</option>
                        </select>
                    </div>
                </div>

                <div class="search-actions">
                    <button class="layui-btn layui-btn-normal" lay-submit lay-filter="searchBtn">
                        <i class="fas fa-search"></i> 搜索
                    </button>
                    <button type="reset" class="layui-btn layui-btn-primary" id="resetBtn">
                        <i class="fas fa-undo"></i> 重置
                    </button>
                </div>
            </form>
        </div>

        <!-- 订单列表 -->
        <div class="content-section">
            <div class="section-header">
                <h2 class="section-title">
                    <i class="fas fa-list-ul" style="margin-right: 8px;"></i>
                    订单列表
                </h2>
            </div>

            <div class="table-container">
                <table class="layui-table" lay-skin="line">
                    <thead>
                    <tr>
                        <th>订单号</th>
                        <th>入住人</th>
                        <th>联系电话</th>
                        <th>用户名</th>
                        <th>房间信息</th>
                        <th>入住日期</th>
                        <th>退房日期</th>
                        <th>订单金额</th>
                        <th>订单状态</th>
                        <th>下单时间</th>
                        <th width="350">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>${order.orderNo}</td>
                            <td>${order.guestName}</td>
                            <td>${order.phone}</td>
                            <td>${order.userName}</td>
                            <td>${order.remark}</td>
                            <td><fmt:formatDate value="${order.checkInDate}" pattern="yyyy-MM-dd"/></td>
                            <td><fmt:formatDate value="${order.checkOutDate}" pattern="yyyy-MM-dd"/></td>
                            <td>¥${order.totalPrice}</td>
                            <td>
                                <span class="status-badge status-${order.orderStatus}">
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 0}">待确认</c:when>
                                        <c:when test="${order.orderStatus == 1}">已确认</c:when>
                                        <c:when test="${order.orderStatus == 2}">已入住</c:when>
                                        <c:when test="${order.orderStatus == 3}">已完成</c:when>
                                        <c:otherwise>已取消</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td>
                                <button class="action-btn btn-detail" onclick="viewDetail(${order.orderId})">
                                    <i class="fas fa-eye"></i> 详情
                                </button>
                                <c:if test="${order.orderStatus == 0}">
                                    <button class="action-btn btn-confirm" onclick="confirmOrder(${order.orderId})">
                                        <i class="fas fa-check"></i> 确认订单
                                    </button>
                                    <button class="action-btn btn-cancel" onclick="cancelOrder(${order.orderId})">
                                        <i class="fas fa-times"></i> 取消
                                    </button>
                                </c:if>
                                <c:if test="${order.orderStatus == 1}">
                                    <button class="action-btn btn-checkin" onclick="checkInOrder(${order.orderId})">
                                        <i class="fas fa-sign-in-alt"></i> 确认入住
                                    </button>
                                    <button class="action-btn btn-cancel" onclick="cancelOrder(${order.orderId})">
                                        <i class="fas fa-times"></i> 取消
                                    </button>
                                </c:if>
                                <c:if test="${order.orderStatus == 2}">
                                    <button class="action-btn btn-complete" onclick="completeOrder(${order.orderId})">
                                        <i class="fas fa-check-double"></i> 确认完成
                                    </button>
                                </c:if>
                                <button class="action-btn btn-delete" onclick="deleteOrder(${order.orderId})">
                                    <i class="fas fa-trash"></i> 删除
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty orders}">
                    <div style="text-align: center; padding: 50px; color: #999;">
                        <i class="fas fa-shopping-cart" style="font-size: 48px; margin-bottom: 15px; opacity: 0.5;"></i>
                        <p>暂无订单数据</p>
                    </div>
                </c:if>
            </div>

            <!-- 分页 -->
            <c:if test="${total > 0}">
                <div class="pagination" id="pagination"></div>
            </c:if>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <script>
        layui.use(['layer', 'form', 'laypage'], function(){
            var layer = layui.layer;
            var form = layui.form;
            var laypage = layui.laypage;

            // 初始化表单
            form.render();

            // 分页
            laypage.render({
                elem: 'pagination',
                count: ${total},
                curr: ${page},
                limit: ${limit},
                limits: [5, 10, 20, 50],
                layout: ['count', 'prev', 'page', 'next', 'limit', 'skip'],
                jump: function(obj, first){
                    if(!first){
                        var params = new URLSearchParams(window.location.search);
                        params.set('page', obj.curr);
                        params.set('limit', obj.limit);
                        window.location.href = '${pageContext.request.contextPath}/admin/order/list?' + params.toString();
                    }
                }
            });


            // 搜索
            form.on('submit(searchBtn)', function(data){
                var field = data.field;
                var params = new URLSearchParams();

                if(field.orderNo) params.append('orderNo', field.orderNo);
                if(field.guestName) params.append('guestName', field.guestName);
                if(field.phone) params.append('phone', field.phone);
                if(field.userName) params.append('userName', field.userName);
                if(field.orderStatus) params.append('orderStatus', field.orderStatus);

                var url = '${pageContext.request.contextPath}/admin/order/list';
                if(params.toString()) url += '?' + params.toString();

                window.location.href = url;
                return false;
            });

            // 重置搜索
            document.getElementById('resetBtn').addEventListener('click', function(){
                document.querySelector('[name=orderNo]').value = '';
                document.querySelector('[name=guestName]').value = '';
                document.querySelector('[name=phone]').value = '';
                document.querySelector('[name=userName]').value = '';
                document.querySelector('[name=orderStatus]').value = '';
                form.render('select');
                layer.msg('已重置搜索条件', {icon: 1, time: 1000});
            });
        });

        // 查看订单详情
        function viewDetail(orderId) {
            window.location.href = '${pageContext.request.contextPath}/admin/order/detail/' + orderId;
        }

        // 确认订单
        function confirmOrder(orderId) {
            layer.confirm('确定要确认这个订单吗？', {
                icon: 3,
                title: '确认订单'
            }, function(index){
                fetch('${pageContext.request.contextPath}/admin/order/confirm/' + orderId, {
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

        // 确认入住
        function checkInOrder(orderId) {
            layer.confirm('确定要确认这个订单入住吗？', {
                icon: 3,
                title: '确认入住'
            }, function(index){
                fetch('${pageContext.request.contextPath}/admin/order/checkin/' + orderId, {
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
        function cancelOrder(orderId) {
            layer.prompt({
                formType: 2,
                value: '',
                title: '取消订单',
                area: ['400px', '200px'],
                content: '<div style="padding: 20px;"><p>请输入取消原因：</p><textarea id="cancelReason" placeholder="请输入取消原因..." style="width: 100%; height: 80px; border: 1px solid #ddd; border-radius: 4px; padding: 8px; resize: none;"></textarea></div>'
            }, function(value, index, elem){
                var cancelReason = document.getElementById('cancelReason').value;

                fetch('${pageContext.request.contextPath}/admin/order/cancel/' + orderId, {
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

        // 确认完成
        function completeOrder(orderId) {
            layer.confirm('确定要确认这个订单已完成吗？', {
                icon: 3,
                title: '确认完成'
            }, function(index){
                fetch('${pageContext.request.contextPath}/admin/order/complete/' + orderId, {
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
        function deleteOrder(orderId) {
            layer.confirm('确定要删除这个订单吗？删除后无法恢复！', {
                icon: 0,
                title: '删除订单'
            }, function(index){
                fetch('${pageContext.request.contextPath}/admin/order/delete/' + orderId, {
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


    </script>
</body>
</html>
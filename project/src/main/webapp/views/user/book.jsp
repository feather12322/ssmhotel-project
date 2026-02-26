<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>酒店预订系统 - 房间预订</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', 'Helvetica Neue', Helvetica, Arial, sans-serif;
            background: linear-gradient(135deg, #f8f9fa 0%, #e8f4f8 100%);
            margin: 0;
            padding: 0;
        }


        /* 主内容区域 */
        .main-content {
            padding: 30px;
            max-width: 1200px;
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

        /* 预订容器 */
        .booking-container {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 30px;
        }

        /* 房间信息 */
        .room-info-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 30px;
        }

        .room-header {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
        }

        .room-image {
            width: 200px;
            height: 150px;
            border-radius: 8px;
            overflow: hidden;
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
            font-size: 48px;
            color: #adb5bd;
        }

        .room-basic {
            flex: 1;
        }

        .room-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 10px;
        }

        .room-meta {
            color: #666;
            margin-bottom: 10px;
        }

        .room-price {
            font-size: 28px;
            font-weight: bold;
            color: #ff5722;
        }

        .room-details {
            margin-top: 25px;
        }

        .detail-row {
            display: flex;
            margin-bottom: 15px;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .detail-label {
            width: 120px;
            font-weight: 500;
            color: #666;
        }

        .detail-value {
            flex: 1;
            color: #333;
        }

        /* 预订表单 */
        .booking-form-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 30px;
            height: fit-content;
        }

        .form-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 25px;
            text-align: center;
            border-bottom: 2px solid #009688;
            padding-bottom: 15px;
        }

        .layui-form-item {
            margin-bottom: 20px;
        }

        .layui-input {
            height: 45px;
            border-radius: 22px;
            border: 2px solid #e8f4f8;
            padding: 0 20px;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .layui-input:focus {
            border-color: #009688;
            box-shadow: 0 0 0 3px rgba(0,150,136,0.1);
        }

        .order-summary {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .summary-row.total {
            border-top: 2px solid #009688;
            padding-top: 10px;
            font-size: 16px;
            font-weight: bold;
            color: #ff5722;
        }

        .book-btn {
            width: 100%;
            height: 50px;
            border-radius: 25px;
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            border: none;
            color: white;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .book-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,150,136,0.3);
        }

        .book-btn:active {
            transform: translateY(0);
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .user-header {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
            }

            .header-left .nav-links {
                gap: 15px;
            }

            .main-content {
                padding: 20px 15px;
            }

            .booking-container {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .room-header {
                flex-direction: column;
                gap: 15px;
            }

            .room-image {
                width: 100%;
                height: 200px;
            }
        }
    </style>
</head>
<body>
    <!-- 统一头部导航 -->
    <%@ include file="header.jsp" %>

    <!-- 主内容区域 -->
    <div class="main-content">
        <!-- 面包屑导航 -->
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/user/index">首页</a> >
            <a href="${pageContext.request.contextPath}/user/rooms">房间查询</a> >
            <span>房间预订</span>
        </div>

        <!-- 预订容器 -->
        <div class="booking-container">
            <!-- 房间信息 -->
            <div class="room-info-section">
                <h2 style="color: #333; margin-bottom: 25px; border-bottom: 2px solid #009688; padding-bottom: 15px;">
                    <i class="fas fa-bed" style="margin-right: 10px;"></i>房间信息
                </h2>

                <div class="room-header">
                    <div class="room-image">
                        <c:if test="${not empty room.coverImg}">
                            <img src="${room.coverImg}" alt="${room.roomNo}">
                        </c:if>
                        <c:if test="${empty room.coverImg}">
                            <div class="no-image">
                                <i class="fas fa-image"></i>
                            </div>
                        </c:if>
                    </div>
                    <div class="room-basic">
                        <div class="room-title">${room.roomNo} - ${room.bedType}</div>
                        <div class="room-meta">
                            <span class="category-tag">${categoryName}</span>
                        </div>
                        <div class="room-price">¥${room.price} <span style="font-size: 14px; color: #999;">/晚</span></div>
                    </div>
                </div>

                <div class="room-details">
                    <div class="detail-row">
                        <div class="detail-label">房间面积：</div>
                        <div class="detail-value">${room.area}m²</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">配套设施：</div>
                        <div class="detail-value">${room.facilities}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">房间状态：</div>
                        <div class="detail-value">
                            <span class="layui-badge layui-bg-green">可预订</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 预订表单 -->
            <div class="booking-form-section">
                <div class="form-title">
                    <i class="fas fa-calendar-check" style="margin-right: 10px;"></i>填写预订信息
                </div>

                <form class="layui-form" lay-filter="bookingForm">
                    <input type="hidden" name="roomId" value="${room.roomId}" />

                    <div class="layui-form-item">
                        <label class="layui-form-label">入住人</label>
                        <div class="layui-input-block">
                            <input type="text" name="guestName" required lay-verify="required" placeholder="请输入入住人姓名" autocomplete="off" class="layui-input" value="${user.realName}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">联系电话</label>
                        <div class="layui-input-block">
                            <input type="text" name="phone" required lay-verify="required|phone" placeholder="请输入联系电话" autocomplete="off" class="layui-input" value="${user.phone}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">入住日期</label>
                        <div class="layui-input-block">
                            <input type="text" name="checkInDate" id="checkInDate" required lay-verify="required" placeholder="请选择入住日期" autocomplete="off" class="layui-input">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">退房日期</label>
                        <div class="layui-input-block">
                            <input type="text" name="checkOutDate" id="checkOutDate" required lay-verify="required" placeholder="请选择退房日期" autocomplete="off" class="layui-input">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">入住人数</label>
                        <div class="layui-input-block">
                            <input type="number" name="guestCount" required lay-verify="required|number" placeholder="请输入入住人数" autocomplete="off" class="layui-input" min="1" value="1">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">特殊要求</label>
                        <div class="layui-input-block">
                            <textarea name="specialRequests" placeholder="如有特殊要求，请在此填写（选填）" class="layui-textarea" style="min-height: 80px;"></textarea>
                        </div>
                    </div>

                    <!-- 订单摘要 -->
                    <div class="order-summary">
                        <div class="summary-row">
                            <span>房间价格：</span>
                            <span>¥${room.price}/晚</span>
                        </div>
                        <div class="summary-row">
                            <span>入住天数：</span>
                            <span id="stayDays">0晚</span>
                        </div>
                        <div class="summary-row total">
                            <span>订单总价：</span>
                            <span id="totalPrice">¥0</span>
                        </div>
                    </div>

                    <button class="book-btn" lay-submit lay-filter="submitBooking">
                        <i class="fas fa-calendar-check" style="margin-right: 8px;"></i>确认预订
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <script>
        layui.use(['form', 'layer', 'laydate'], function(){
            var form = layui.form, layer = layui.layer, laydate = layui.laydate;

            // 获取今天的日期字符串
            var today = new Date();
            var todayStr = today.getFullYear() + '-' +
                          String(today.getMonth() + 1).padStart(2, '0') + '-' +
                          String(today.getDate()).padStart(2, '0');

            // 获取明天的日期字符串
            var tomorrow = new Date();
            tomorrow.setDate(today.getDate() + 1);
            var tomorrowStr = tomorrow.getFullYear() + '-' +
                             String(tomorrow.getMonth() + 1).padStart(2, '0') + '-' +
                             String(tomorrow.getDate()).padStart(2, '0');

            // 初始化日期选择器
            var checkInDate = laydate.render({
                elem: '#checkInDate',
                min: todayStr,
                theme: 'molv',
                done: function(value, date){
                    // 设置退房日期的最小值为入住日期的下一天
                    var nextDay = new Date(date.year, date.month - 1, date.date + 1);
                    var nextDayStr = nextDay.getFullYear() + '-' +
                                   String(nextDay.getMonth() + 1).padStart(2, '0') + '-' +
                                   String(nextDay.getDate()).padStart(2, '0');

                    checkOutDate.config.min = nextDayStr;
                    // 如果当前退房日期早于或等于入住日期，清空退房日期
                    var currentCheckOut = document.getElementById('checkOutDate').value;
                    if (currentCheckOut && currentCheckOut <= value) {
                        document.getElementById('checkOutDate').value = '';
                        document.getElementById('stayDays').textContent = '0晚';
                        document.getElementById('totalPrice').textContent = '¥0';
                    }
                    calculatePrice();
                }
            });

            var checkOutDate = laydate.render({
                elem: '#checkOutDate',
                min: tomorrowStr,
                theme: 'molv',
                done: function(){
                    calculatePrice();
                }
            });

            // 计算价格
            function calculatePrice() {
                var checkIn = document.getElementById('checkInDate').value;
                var checkOut = document.getElementById('checkOutDate').value;
                var pricePerNight = ${room.price};

                if (checkIn && checkOut) {
                    var startDate = new Date(checkIn);
                    var endDate = new Date(checkOut);

                    // 计算天数差（包含入住当天，不包含退房当天）
                    var timeDiff = endDate.getTime() - startDate.getTime();
                    var days = Math.ceil(timeDiff / (1000 * 3600 * 24));

                    if (days > 0) {
                        var totalPrice = days * pricePerNight;
                        document.getElementById('stayDays').textContent = days + '晚';
                        document.getElementById('totalPrice').textContent = '¥' + totalPrice.toFixed(2);
                    } else {
                        document.getElementById('stayDays').textContent = '0晚';
                        document.getElementById('totalPrice').textContent = '¥0';
                    }
                } else {
                    document.getElementById('stayDays').textContent = '0晚';
                    document.getElementById('totalPrice').textContent = '¥0';
                }
            }

            // 自定义验证规则
            form.verify({
                phone: function(value){
                    var reg = /^1[3|4|5|6|7|8|9][0-9]{9}$/;
                    if(!reg.test(value)){
                        return '请输入正确的手机号码';
                    }
                }
            });

            // 表单提交
            form.on('submit(submitBooking)', function(data){
                var field = data.field;

                // 检查日期
                if (!field.checkInDate || !field.checkOutDate) {
                    layer.msg('请选择入住和退房日期', {icon: 2});
                    return false;
                }

                var checkIn = new Date(field.checkInDate);
                var checkOut = new Date(field.checkOutDate);
                if (checkIn >= checkOut) {
                    layer.msg('退房日期必须晚于入住日期', {icon: 2});
                    return false;
                }

                // 显示加载状态
                var btn = document.querySelector('.book-btn');
                var originalText = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin" style="margin-right: 8px;"></i>提交中...';
                btn.disabled = true;

                fetch('${pageContext.request.contextPath}/user/submitBooking', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: Object.keys(field).map(k => encodeURIComponent(k) + '=' + encodeURIComponent(field[k] || '')).join('&')
                }).then(r => r.json()).then(res => {
                    if(res.success){
                        layer.msg('预订成功！', {icon: 1, time: 2000});
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/user/orders';
                        }, 2000);
                    } else {
                        layer.msg(res.message || '预订失败', {icon: 2});
                        btn.innerHTML = originalText;
                        btn.disabled = false;
                    }
                }).catch(() => {
                    layer.msg('网络异常，请重试', {icon: 2});
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                });

                return false;
            });
        });
    </script>
</body>
</html>
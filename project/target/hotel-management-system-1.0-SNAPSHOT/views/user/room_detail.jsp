<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>酒店预订系统 - 房间详情</title>
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

        /* 房间详情容器 */
        .room-detail-container {
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

        .room-gallery {
            margin-bottom: 30px;
        }

        .main-image {
            width: 100%;
            height: 400px;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 15px;
        }

        .main-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .main-image .no-image {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 64px;
            color: #adb5bd;
        }

        .room-title {
            font-size: 32px;
            color: #333;
            margin-bottom: 15px;
        }

        .room-meta {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
            color: #666;
        }

        .category-tag {
            display: inline-block;
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }

        .room-price {
            font-size: 36px;
            font-weight: bold;
            color: #ff5722;
            margin-bottom: 25px;
        }

        .room-description {
            line-height: 1.8;
            color: #666;
            margin-bottom: 30px;
        }

        .room-features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            color: #666;
        }

        .feature-item i {
            color: #009688;
            width: 20px;
        }

        /* 预订卡片 */
        .booking-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 30px;
            height: fit-content;
        }

        .booking-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 25px;
            text-align: center;
            border-bottom: 2px solid #009688;
            padding-bottom: 15px;
        }

        .status-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
            text-align: center;
            margin-bottom: 20px;
        }

        .status-available { background: #52c41a; color: white; }
        .status-booked { background: #faad14; color: white; }
        .status-occupied { background: #1890ff; color: white; }
        .status-maintenance { background: #ff4d4f; color: white; }

        .quick-book-form {
            margin-bottom: 20px;
        }

        .quick-book-btn {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .quick-book-btn.available {
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            color: white;
        }

        .quick-book-btn.available:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,150,136,0.3);
        }

        .quick-book-btn.unavailable {
            background: #f5f5f5;
            color: #999;
            cursor: not-allowed;
        }

        .room-actions {
            display: flex;
            gap: 10px;
        }

        .action-btn {
            flex: 1;
            padding: 12px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            border: 2px solid #009688;
            background: transparent;
            color: #009688;
        }

        .action-btn:hover {
            background: #009688;
            color: white;
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

            .room-detail-container {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .room-title {
                font-size: 24px;
            }

            .room-price {
                font-size: 28px;
            }

            .main-image {
                height: 250px;
            }

            .room-features {
                grid-template-columns: 1fr;
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
            <span>房间详情</span>
        </div>

        <!-- 房间详情容器 -->
        <div class="room-detail-container">
            <!-- 房间信息 -->
            <div class="room-info-section">
                <!-- 房间图片 -->
                <div class="room-gallery">
                    <div class="main-image">
                        <c:if test="${not empty room.coverImg}">
                            <img src="${room.coverImg}" alt="${room.roomNo}">
                        </c:if>
                        <c:if test="${empty room.coverImg}">
                            <div class="no-image">
                                <i class="fas fa-image"></i>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- 房间标题和基本信息 -->
                <div class="room-title">${room.roomNo} - ${room.bedType}</div>

                <div class="room-meta">
                    <div class="meta-item">
                        <i class="fas fa-expand-arrows-alt"></i>
                        ${room.area}m²
                    </div>
                    <div class="meta-item">
                        <i class="fas fa-users"></i>
                        适合${room.area > 30 ? '2-4' : '1-2'}人入住
                    </div>
                    <div class="category-tag">${categoryName}</div>
                </div>

                <div class="room-price">¥${room.price} <span style="font-size: 16px; color: #999;">/晚</span></div>

                <!-- 房间描述 -->
                <div class="room-description">
                    <p>这是一间舒适的${categoryName}，配备了完善的设施，为您的入住提供优质体验。</p>
                </div>

                <!-- 房间设施 -->
                <div class="room-features">
                    <c:forEach var="facility" items="${room.facilities != null ? room.facilities.split(',') : []}" varStatus="status">
                        <div class="feature-item">
                            <i class="fas fa-check-circle"></i>
                            <span>${facility}</span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty room.facilities}">
                        <div class="feature-item">
                            <i class="fas fa-concierge-bell"></i>
                            <span>标准酒店设施</span>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-wifi"></i>
                            <span>免费WiFi</span>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-shower"></i>
                            <span>独立卫生间</span>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- 预订卡片 -->
            <div class="booking-card">
                <div class="booking-title">
                    <i class="fas fa-calendar-check" style="margin-right: 10px;"></i>快速预订
                </div>

                <!-- 房间状态 -->
                <div class="status-badge
                    <c:choose>
                        <c:when test="${room.roomStatus == 1}">status-available</c:when>
                        <c:when test="${room.roomStatus == 2}">status-booked</c:when>
                        <c:when test="${room.roomStatus == 3}">status-occupied</c:when>
                        <c:otherwise>status-maintenance</c:otherwise>
                    </c:choose>">
                    <c:choose>
                        <c:when test="${room.roomStatus == 1}">可预订</c:when>
                        <c:when test="${room.roomStatus == 2}">已预订</c:when>
                        <c:when test="${room.roomStatus == 3}">已入住</c:when>
                        <c:otherwise>维修中</c:otherwise>
                    </c:choose>
                </div>

                <!-- 快速预订按钮 -->
                <div class="quick-book-form">
                    <c:if test="${room.roomStatus == 1}">
                        <button class="quick-book-btn available" onclick="bookRoom(${room.roomId})">
                            <i class="fas fa-calendar-check" style="margin-right: 8px;"></i>立即预订
                        </button>
                    </c:if>
                    <c:if test="${room.roomStatus != 1}">
                        <button class="quick-book-btn unavailable" disabled>
                            <c:choose>
                                <c:when test="${room.roomStatus == 2}">
                                    <i class="fas fa-clock" style="margin-right: 8px;"></i>已预订
                                </c:when>
                                <c:when test="${room.roomStatus == 3}">
                                    <i class="fas fa-user-check" style="margin-right: 8px;"></i>已入住
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-tools" style="margin-right: 8px;"></i>维修中
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </c:if>
                </div>

                <!-- 房间操作 -->
                <div class="room-actions">
                    <a href="${pageContext.request.contextPath}/user/rooms" class="action-btn">
                        <i class="fas fa-arrow-left" style="margin-right: 5px;"></i>返回列表
                    </a>
                    <button class="action-btn" onclick="shareRoom()">
                        <i class="fas fa-share" style="margin-right: 5px;"></i>分享
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <script>
        layui.use(['layer'], function(){
            var layer = layui.layer;
        });

        // 预订房间
        function bookRoom(roomId) {
            window.location.href = '${pageContext.request.contextPath}/user/book/' + roomId;
        }

        // 分享房间
        function shareRoom() {
            if (navigator.share) {
                navigator.share({
                    title: '${room.roomNo} - ${room.bedType}',
                    text: '查看这个房间：${room.roomNo}',
                    url: window.location.href
                });
            } else {
                // 复制链接到剪贴板
                navigator.clipboard.writeText(window.location.href).then(function() {
                    layer.msg('链接已复制到剪贴板', {icon: 1});
                });
            }
        }
    </script>
</body>
</html>
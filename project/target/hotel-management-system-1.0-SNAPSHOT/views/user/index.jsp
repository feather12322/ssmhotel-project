<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>酒店预订系统 - 用户中心</title>
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
            max-width: 1400px;
            margin: 0 auto;
        }

        /* 欢迎区域 */
        .welcome-section {
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            color: white;
            padding: 50px 40px;
            border-radius: 16px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0,150,136,0.2);
        }

        .welcome-section h1 {
            font-size: 36px;
            margin-bottom: 15px;
            font-weight: 300;
        }

        .welcome-section p {
            font-size: 18px;
            opacity: 0.9;
            margin: 0;
        }

        /* 功能卡片 */
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .feature-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            text-align: center;
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.05);
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.12);
        }

        .feature-icon {
            font-size: 48px;
            color: #009688;
            margin-bottom: 20px;
            opacity: 0.8;
        }

        .feature-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 10px;
            font-weight: 500;
        }

        .feature-desc {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }

        .feature-action {
            display: inline-block;
            margin-top: 15px;
            padding: 8px 20px;
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            color: white;
            text-decoration: none;
            border-radius: 20px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .feature-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,150,136,0.3);
            color: white;
        }

        /* 房间分类样式 */
        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .category-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.05);
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.15);
        }

        .category-image {
            height: 180px;
            overflow: hidden;
            position: relative;
        }

        .category-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .category-card:hover .category-image img {
            transform: scale(1.05);
        }

        .no-image {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: rgba(255,255,255,0.8);
            position: relative;
        }

        .no-image::before {
            content: '';
            position: absolute;
            top: -10px;
            left: -10px;
            right: -10px;
            bottom: -10px;
            background: linear-gradient(45deg, #009688, #5FB878, #009688);
            opacity: 0.1;
            border-radius: 12px;
        }

        .category-info {
            padding: 20px;
        }

        .category-info h3 {
            color: #333;
            margin-bottom: 10px;
            font-size: 18px;
        }

        .category-desc {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 15px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .category-price {
            color: #009688;
            font-size: 16px;
            font-weight: bold;
        }

        /* 搜索区域样式 */
        .search-section {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0,150,136,0.15);
            padding: 35px;
            margin-bottom: 40px;
            border: 1px solid rgba(0,150,136,0.1);
            position: relative;
            overflow: hidden;
        }

        .search-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #009688 0%, #5FB878 50%, #009688 100%);
        }

        .search-title {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
            font-size: 24px;
            font-weight: 500;
        }

        .search-title i {
            color: #009688;
            margin-right: 10px;
        }

        .search-filters {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .filter-group {
            background: rgba(255,255,255,0.8);
            border-radius: 12px;
            padding: 20px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .filter-group:hover {
            border-color: rgba(0,150,136,0.3);
            box-shadow: 0 4px 20px rgba(0,150,136,0.1);
            transform: translateY(-2px);
        }

        .filter-group label {
            display: block;
            color: #666;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .filter-group .layui-input,
        .filter-group .layui-select {
            border-radius: 8px;
            border: 2px solid rgba(0,150,136,0.2);
            height: 45px;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .filter-group .layui-input:focus,
        .filter-group .layui-select:focus {
            border-color: #009688;
            box-shadow: 0 0 0 3px rgba(0,150,136,0.1);
        }

        .price-range {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            gap: 10px;
            align-items: center;
        }

        .price-range .layui-form-mid {
            color: #666;
            font-weight: bold;
        }

        .search-actions {
            text-align: center;
        }

        .search-actions .layui-btn {
            height: 50px;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 500;
            padding: 0 40px;
            margin: 0 10px;
            transition: all 0.3s ease;
        }

        .search-actions .layui-btn-primary {
            background: rgba(255,255,255,0.9);
            border: 2px solid rgba(0,150,136,0.3);
            color: #009688;
        }

        .search-actions .layui-btn-primary:hover {
            background: #009688;
            border-color: #009688;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,150,136,0.3);
        }

        .search-actions .layui-btn-normal {
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            border: none;
            box-shadow: 0 4px 15px rgba(0,150,136,0.3);
        }

        .search-actions .layui-btn-normal:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,150,136,0.4);
        }

        /* 房间列表样式 */
        .room-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
        }

        .room-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.05);
        }

        .room-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.15);
        }

        .room-image {
            height: 200px;
            overflow: hidden;
            position: relative;
        }

        .room-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .room-status {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
            color: white;
        }

        .status-1 { background: #52c41a; } /* 可预订 - 绿色 */
        .status-2 { background: #faad14; } /* 已预订 - 橙色 */
        .status-3 { background: #1890ff; } /* 已入住 - 蓝色 */
        .status-0 { background: #ff4d4f; } /* 维修中 - 红色 */

        .room-info {
            padding: 20px;
        }

        .room-info h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .room-details {
            margin-bottom: 15px;
        }

        .room-details p {
            color: #666;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .room-details p i {
            width: 16px;
            margin-right: 8px;
            color: #009688;
        }

        .category-tag {
            display: inline-block;
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            color: white;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            margin-top: 5px;
        }

        .category-card {
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.15);
        }

        .room-price {
            display: flex;
            align-items: baseline;
            margin-bottom: 15px;
        }

        .price {
            font-size: 24px;
            font-weight: bold;
            color: #ff5722;
        }

        .unit {
            color: #999;
            font-size: 14px;
            margin-left: 5px;
        }

        .book-btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .book-btn:not(.disabled) {
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            color: white;
        }

        .book-btn:not(.disabled):hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,150,136,0.3);
        }

        .book-btn.disabled {
            background: #f5f5f5;
            color: #999;
            cursor: not-allowed;
        }

        .no-rooms {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .no-rooms i {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        .section {
            margin-bottom: 50px;
        }

        /* 个人中心样式 */
        .avatar-upload-section {
            text-align: center;
            padding: 30px 20px;
        }

        .current-avatar {
            margin-bottom: 20px;
        }

        .upload-tips {
            color: #666;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .upload-tips i {
            color: #009688;
            margin-right: 5px;
        }

        .upload-btn {
            margin-bottom: 20px;
        }

        .profile-form .layui-form-item {
            margin-bottom: 20px;
        }

        .profile-form .layui-form-label {
            width: 100px;
        }

        .profile-form .layui-input-block {
            margin-left: 130px;
        }

        .password-form .layui-form-item {
            margin-bottom: 20px;
        }

        .password-form .layui-form-label {
            width: 100px;
        }

        .password-form .layui-input-block {
            margin-left: 130px;
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

            .welcome-section {
                padding: 30px 20px;
            }

            .welcome-section h1 {
                font-size: 28px;
            }

            .category-grid, .room-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .search-section {
                padding: 25px;
            }

            .search-filters {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .search-title {
                font-size: 20px;
                margin-bottom: 20px;
            }

            .price-range {
                grid-template-columns: 1fr;
                gap: 5px;
            }

            .price-range .layui-form-mid {
                text-align: center;
                margin: 5px 0;
            }

            .avatar-upload-section {
                padding: 20px 10px;
            }

            .current-avatar img {
                width: 100px !important;
                height: 100px !important;
            }

            .profile-form .layui-form-label,
            .password-form .layui-form-label {
                width: 80px;
            }

            .profile-form .layui-input-block,
            .password-form .layui-input-block {
                margin-left: 90px;
            }
        }
    </style>
</head>
<body>
    <!-- 统一头部导航 -->
    <%@ include file="header.jsp" %>

    <!-- 主内容区域 -->
    <div class="main-content">
        <!-- 欢迎区域 -->
        <div class="welcome-section">
            <h1><i class="fas fa-hotel" style="margin-right: 15px;"></i>欢迎使用酒店预订系统</h1>
            <p>发现优质酒店，预订心仪房间，开启您的舒适旅程</p>
        </div>

        <!-- 功能卡片 -->
        <div class="feature-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-search"></i>
                </div>
                <div class="feature-title">房间查询</div>
                <div class="feature-desc">快速搜索符合条件的房间，查看详情信息</div>
                <a href="${pageContext.request.contextPath}/user/rooms" class="feature-action">
                    <i class="fas fa-arrow-right"></i> 开始查询
                </a>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div class="feature-title">我的订单</div>
                <div class="feature-desc">查看和管理您的所有预订订单</div>
                <a href="${pageContext.request.contextPath}/user/orders" class="feature-action">
                    <i class="fas fa-arrow-right"></i> 查看订单
                </a>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-user-cog"></i>
                </div>
                <div class="feature-title">个人中心</div>
                <div class="feature-desc">修改个人资料、上传头像、更改密码</div>
                <button onclick="openProfileModal()" class="feature-action">
                    <i class="fas fa-arrow-right"></i> 进入中心
                </button>
            </div>
        </div>

        <!-- 房间分类浏览 -->
        <div class="section">
            <h2 style="color: #333; margin-bottom: 25px; text-align: center;">
                <i class="fas fa-th-large" style="margin-right: 10px;"></i>房间分类
            </h2>
            <div class="category-grid">
                <c:forEach var="category" items="${categories}">
                    <div class="category-card" onclick="filterByCategory(${category.categoryId})">
                        <div class="category-image">
                            <c:if test="${not empty category.coverImg}">
                                <img src="${category.coverImg}" alt="${category.categoryName}">
                            </c:if>
                            <c:if test="${empty category.coverImg}">
                                <div class="no-image">
                                    <i class="fas fa-image"></i>
                                </div>
                            </c:if>
                        </div>
                        <div class="category-info">
                            <h3>${category.categoryName}</h3>
                            <p class="category-desc">${category.description}</p>
                            <p class="category-price">
                                <i class="fas fa-yen-sign"></i>
                                ¥${category.priceMin} - ¥${category.priceMax}
                            </p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 房间查询条件 -->
        <div class="section">
            <div class="search-section">
                <div class="search-title">
                    <i class="fas fa-search"></i>查找心仪房间
                </div>
                <form class="layui-form search-form" lay-filter="roomSearchForm">
                    <div class="search-filters">
                        <div class="filter-group">
                            <label><i class="fas fa-hashtag" style="margin-right: 5px; color: #009688;"></i>房间号</label>
                            <input type="text" name="roomNo" placeholder="输入房间号" autocomplete="off" class="layui-input">
                        </div>
                        <div class="filter-group">
                            <label><i class="fas fa-th-large" style="margin-right: 5px; color: #009688;"></i>房间类型</label>
                            <select name="categoryId">
                                <option value="">全部类型</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryId}">${category.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label><i class="fas fa-yen-sign" style="margin-right: 5px; color: #009688;"></i>价格范围</label>
                            <div class="price-range">
                                <input type="number" name="priceMin" placeholder="最低价" autocomplete="off" class="layui-input">
                                <div class="layui-form-mid">-</div>
                                <input type="number" name="priceMax" placeholder="最高价" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                    </div>
                    <div class="search-actions">
                        <button class="layui-btn layui-btn-normal" lay-submit lay-filter="searchBtn">
                            <i class="fas fa-search" style="margin-right: 8px;"></i>开始查找
                        </button>
                        <button type="reset" class="layui-btn layui-btn-primary" id="resetBtn">
                            <i class="fas fa-undo" style="margin-right: 8px;"></i>清空条件
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 房间列表 -->
        <div class="section">
            <h2 style="color: #333; margin-bottom: 25px; text-align: center;">
                <i class="fas fa-bed" style="margin-right: 10px;"></i>可预订房间
            </h2>
            <div class="room-grid">
                <c:forEach var="room" items="${rooms}">
                    <div class="room-card">
                        <div class="room-image">
                            <c:if test="${not empty room.coverImg}">
                                <img src="${room.coverImg}" alt="${room.roomNo}">
                            </c:if>
                            <c:if test="${empty room.coverImg}">
                                <div class="no-image">
                                    <i class="fas fa-image"></i>
                                </div>
                            </c:if>
                            <div class="room-status status-${room.roomStatus}">
                                <c:choose>
                                    <c:when test="${room.roomStatus == 1}">可预订</c:when>
                                    <c:when test="${room.roomStatus == 2}">已预订</c:when>
                                    <c:when test="${room.roomStatus == 3}">已入住</c:when>
                                    <c:otherwise>维修中</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="room-info">
                            <h3>${room.roomNo} - ${room.bedType}</h3>
                            <div class="room-details">
                                <p><i class="fas fa-expand-arrows-alt"></i> ${room.area}m²</p>
                                <p><i class="fas fa-concierge-bell"></i> ${room.facilities}</p>
                                <div class="room-category">
                                    <c:forEach var="category" items="${categories}">
                                        <c:if test="${category.categoryId == room.categoryId}">
                                            <span class="category-tag">${category.categoryName}</span>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="room-price">
                                <span class="price">¥${room.price}</span>
                                <span class="unit">/晚</span>
                            </div>
                            <c:if test="${room.roomStatus == 1}">
                                <button class="book-btn" onclick="bookRoom(${room.roomId})">
                                    <i class="fas fa-calendar-check"></i> 立即预订
                                </button>
                            </c:if>
                            <c:if test="${room.roomStatus != 1}">
                                <button class="book-btn disabled" disabled>
                                    <i class="fas fa-clock"></i>
                                    <c:choose>
                                        <c:when test="${room.roomStatus == 2}">已预订</c:when>
                                        <c:when test="${room.roomStatus == 3}">已入住</c:when>
                                        <c:otherwise>维修中</c:otherwise>
                                    </c:choose>
                                </button>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty rooms}">
                <div class="no-rooms">
                    <i class="fas fa-search"></i>
                    <p>暂无符合条件的房间</p>
                </div>
            </c:if>
        </div>
    </div>

    <!-- 个人中心模态框 -->
    <div id="profileModal" style="display: none;">
        <div class="layui-tab layui-tab-brief" lay-filter="profileTab">
            <ul class="layui-tab-title">
                <li class="layui-this">
                    <i class="fas fa-user-edit"></i> 基本资料
                </li>
                <li>
                    <i class="fas fa-camera"></i> 头像设置
                </li>
                <li>
                    <i class="fas fa-lock"></i> 修改密码
                </li>
            </ul>
            <div class="layui-tab-content">
                <!-- 基本资料 -->
                <div class="layui-tab-item layui-show">
                    <form class="layui-form profile-form" lay-filter="profileForm">
                        <div class="layui-form-item">
                            <label class="layui-form-label">用户名</label>
                            <div class="layui-input-block">
                                <input type="text" name="userName" readonly class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">真实姓名</label>
                            <div class="layui-input-block">
                                <input type="text" name="realName" required lay-verify="required" placeholder="请输入真实姓名" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">手机号</label>
                            <div class="layui-input-block">
                                <input type="text" name="phone" required lay-verify="phone" placeholder="请输入手机号" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">邮箱</label>
                            <div class="layui-input-block">
                                <input type="email" name="email" lay-verify="email" placeholder="请输入邮箱地址" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-input-block">
                                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="updateProfile">
                                    <i class="fas fa-save"></i> 保存修改
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- 头像设置 -->
                <div class="layui-tab-item">
                    <div class="avatar-upload-section">
                        <div class="current-avatar">
                            <img id="currentAvatar" src="" alt="当前头像" style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 3px solid #009688;">
                        </div>
                        <div class="upload-tips">
                            <p><i class="fas fa-info-circle"></i> 支持jpg、jpeg、png、gif格式，文件大小不超过2MB</p>
                        </div>
                        <div class="upload-btn">
                            <button type="button" class="layui-btn layui-btn-normal" id="uploadAvatarBtn">
                                <i class="fas fa-upload"></i> 选择头像
                            </button>
                        </div>
                        <div class="upload-progress" style="display: none;">
                            <div class="layui-progress layui-progress-big" lay-showpercent="true" lay-filter="uploadProgress">
                                <div class="layui-progress-bar layui-bg-blue" lay-percent="0%"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 修改密码 -->
                <div class="layui-tab-item">
                    <form class="layui-form password-form" lay-filter="passwordForm">
                        <div class="layui-form-item">
                            <label class="layui-form-label">原密码</label>
                            <div class="layui-input-block">
                                <input type="password" name="oldPassword" required lay-verify="required" placeholder="请输入原密码" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">新密码</label>
                            <div class="layui-input-block">
                                <input type="password" name="newPassword" required lay-verify="required|password" placeholder="请输入新密码" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">确认密码</label>
                            <div class="layui-input-block">
                                <input type="password" name="confirmPassword" required lay-verify="required|confirmPassword" placeholder="请再次输入新密码" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-input-block">
                                <button class="layui-btn layui-btn-danger" lay-submit lay-filter="changePassword">
                                    <i class="fas fa-key"></i> 修改密码
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <script>
        // 全局函数定义
        // 按分类筛选
        function filterByCategory(categoryId) {
            window.location.href = '${pageContext.request.contextPath}/user/rooms?categoryId=' + categoryId;
        }

        // 预订房间
        function bookRoom(roomId) {
            window.location.href = '${pageContext.request.contextPath}/user/book/' + roomId;
        }

        // 打开个人中心模态框
        function openProfileModal() {
            layui.use(['layer', 'form', 'upload'], function(){
                var layer = layui.layer;
                var form = layui.form;
                var upload = layui.upload;

                layer.open({
                    type: 1,
                    title: '<i class="fas fa-user-cog"></i> 个人中心',
                    content: $('#profileModal'),
                    area: ['600px', '500px'],
                    btn: false,
                    success: function() {
                        // 加载用户信息
                        loadUserProfile();
                        // 初始化头像上传
                        initAvatarUpload();
                        // 渲染表单
                        form.render();
                    }
                });

                // 加载用户信息
                function loadUserProfile() {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/user/profile',
                        type: 'GET',
                        success: function(res) {
                            if (res.success) {
                                var user = res.data;
                                // 填充表单
                                form.val('profileForm', {
                                    userName: user.userName || '',
                                    realName: user.realName || '',
                                    phone: user.phone || '',
                                    email: user.email || '',
                                    createTime: user.createTime ? new Date(user.createTime).toLocaleString() : ''
                                });

                                // 设置头像
                                if (user.avatar) {
                                    $('#currentAvatar').attr('src', user.avatar);
                                } else {
                                    $('#currentAvatar').attr('src', 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIwIiBoZWlnaHQ9IjEyMCIgdmlld0JveD0iMCAwIDEyMCAxMjAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxjaXJjbGUgY3g9IjYwIiBjeT0iNjAiIHI9IjYwIiBmaWxsPSIjRjlGQUZBIi8+CjxjaXJjbGUgY3g9IjYwIiBjeT0iNDUiIHI9IjIwIiBmaWxsPSIjQzRDNEM0Ii8+CjxwYXRoIGQ9Ik0yMCA4NWMwLTE1IDEyLjUzNi0yNyAyOC0yN3MxNCAxMiAzMiAyOGgyNGMxNS40NjQgMCAyOCAxMi41MzYgMjggMjhzLTEyLjUzNiAyNy0yOCAyN0g0NGMtMTUuNDY0IDAtMjgtMTIuNTM2LTI4LTI3eiIgZmlsbD0iI0M0QzREM0Ii8+Cjwvc3ZnPg==');
                                }
                            } else {
                                layer.msg(res.message || '加载用户信息失败', {icon: 2});
                            }
                        },
                        error: function() {
                            layer.msg('网络异常，请重试', {icon: 2});
                        }
                    });
                }

                // 初始化头像上传
                function initAvatarUpload() {
                    upload.render({
                        elem: '#uploadAvatarBtn',
                        url: '${pageContext.request.contextPath}/user/uploadAvatar',
                        accept: 'images',
                        acceptMime: 'image/*',
                        exts: 'jpg|jpeg|png|gif',
                        size: 2048, // 2MB
                        before: function() {
                            $('.upload-progress').show();
                            layer.load(1);
                        },
                        done: function(res) {
                            layer.closeAll('loading');
                            $('.upload-progress').hide();

                            if (res.success) {
                                layer.msg('头像上传成功', {icon: 1});
                                $('#currentAvatar').attr('src', res.avatarUrl);
                            } else {
                                layer.msg(res.message || '头像上传失败', {icon: 2});
                            }
                        },
                        error: function() {
                            layer.closeAll('loading');
                            $('.upload-progress').hide();
                            layer.msg('网络异常，请重试', {icon: 2});
                        }
                    });
                }
            });
        }

        // 页面加载完成后初始化
        $(document).ready(function() {
            layui.use(['layer', 'form', 'upload', 'element'], function(){
                var layer = layui.layer;
                var form = layui.form;
                var upload = layui.upload;
                var element = layui.element;

                // 初始化表单
                form.render('select');

                // 房间查询
                form.on('submit(searchBtn)', function(data){
                    var field = data.field;
                    var params = new URLSearchParams();

                    if(field.roomNo) params.append('roomNo', field.roomNo);
                    if(field.categoryId) params.append('categoryId', field.categoryId);
                    if(field.priceMin) params.append('priceMin', field.priceMin);
                    if(field.priceMax) params.append('priceMax', field.priceMax);

                    var url = '${pageContext.request.contextPath}/user/rooms';
                    if(params.toString()) url += '?' + params.toString();

                    window.location.href = url;
                    return false;
                });

                // 重置查询
                $('#resetBtn').on('click', function(){
                    // 清空表单
                    $('[name=roomNo]').val('');
                    $('[name=categoryId]').val('');
                    $('[name=priceMin]').val('');
                    $('[name=priceMax]').val('');
                    form.render('select');
                    layer.msg('已清空搜索条件', {icon: 1, time: 1000});
                });

                // 表单验证规则
                form.verify({
                    password: function(value) {
                        if (value.length < 6) {
                            return '密码长度不能少于6位';
                        }
                    },
                    confirmPassword: function(value) {
                        var newPassword = $('input[name=newPassword]').val();
                        if (value !== newPassword) {
                            return '两次输入的密码不一致';
                        }
                    }
                });

                // 更新个人资料
                form.on('submit(updateProfile)', function(data){
                    var field = data.field;
                    layer.load(1);
                    $.ajax({
                        url: '${pageContext.request.contextPath}/user/updateProfile',
                        type: 'POST',
                        data: {
                            realName: field.realName,
                            phone: field.phone,
                            email: field.email
                        },
                        success: function(res) {
                            layer.closeAll('loading');
                            if (res.success) {
                                layer.msg('个人资料更新成功', {icon: 1});
                            } else {
                                layer.msg(res.message || '更新失败', {icon: 2});
                            }
                        },
                        error: function() {
                            layer.closeAll('loading');
                            layer.msg('网络异常，请重试', {icon: 2});
                        }
                    });
                    return false;
                });

                // 修改密码
                form.on('submit(changePassword)', function(data){
                    var field = data.field;
                    layer.load(1);
                    $.ajax({
                        url: '${pageContext.request.contextPath}/user/changePassword',
                        type: 'POST',
                        data: {
                            oldPassword: field.oldPassword,
                            newPassword: field.newPassword
                        },
                        success: function(res) {
                            layer.closeAll('loading');
                            if (res.success) {
                                layer.msg('密码修改成功，请重新登录', {icon: 1});
                                setTimeout(function() {
                                    window.location.href = '${pageContext.request.contextPath}/user/login';
                                }, 1500);
                            } else {
                                layer.msg(res.message || '密码修改失败', {icon: 2});
                            }
                        },
                        error: function() {
                            layer.closeAll('loading');
                            layer.msg('网络异常，请重试', {icon: 2});
                        }
                    });
                    return false;
                });

                // 页面加载完成提示
                console.log('用户中心页面加载完成');
            });
        });
    </script>
</body>
</html>
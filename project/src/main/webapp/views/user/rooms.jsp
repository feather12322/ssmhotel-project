<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>酒店预订系统 - 房间列表</title>
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
            grid-template-columns: repeat(auto-fill, minmax(350px, 350px));
            gap: 25px;
            justify-content: flex-start;
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

        .room-actions {
            display: flex;
            gap: 10px;
        }

        .detail-btn {
            flex: 1;
            padding: 10px;
            border: 2px solid #009688;
            background: transparent;
            color: #009688;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
        }

        .detail-btn:hover {
            background: #009688;
            color: white;
        }

        .book-btn {
            flex: 1;
            padding: 10px;
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

            .room-grid {
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

            .room-actions {
                flex-direction: column;
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
            <span>房间查询</span>
        </div>

        <!-- 搜索条件 -->
        <div class="search-section">
            <div class="search-title">
                <i class="fas fa-search"></i>查找心仪房间
            </div>
            <form class="layui-form search-form" lay-filter="roomSearchForm">
                <div class="search-filters">
                    <div class="filter-group">
                        <label><i class="fas fa-hashtag" style="margin-right: 5px; color: #009688;"></i>房间号</label>
                        <input type="text" name="roomNo" placeholder="输入房间号" autocomplete="off" class="layui-input" value="${searchRoomNo}">
                    </div>
                    <div class="filter-group">
                        <label><i class="fas fa-th-large" style="margin-right: 5px; color: #009688;"></i>房间类型</label>
                        <select name="categoryId">
                            <option value="">全部类型</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}" <c:if test="${searchCategoryId == category.categoryId}">selected</c:if>>${category.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label><i class="fas fa-yen-sign" style="margin-right: 5px; color: #009688;"></i>价格范围</label>
                        <div class="price-range">
                            <input type="number" name="priceMin" placeholder="最低价" autocomplete="off" class="layui-input" value="${searchPriceMin}">
                            <div class="layui-form-mid">-</div>
                            <input type="number" name="priceMax" placeholder="最高价" autocomplete="off" class="layui-input" value="${searchPriceMax}">
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

        <!-- 房间列表 -->
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
                        <div class="room-actions">
                            <a href="${pageContext.request.contextPath}/user/room/${room.roomId}" class="detail-btn">查看详情</a>
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
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty rooms}">
            <div class="no-rooms">
                <i class="fas fa-search"></i>
                <p>暂无符合条件的房间</p>
                <p style="font-size: 14px; margin-top: 10px;">请尝试调整搜索条件</p>
            </div>
        </c:if>
    </div>

    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <script>
        layui.use(['layer', 'form'], function(){
            var layer = layui.layer;
            var form = layui.form;

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
            document.getElementById('resetBtn').addEventListener('click', function(){
                // 清空表单
                document.querySelector('[name=roomNo]').value = '';
                document.querySelector('[name=categoryId]').value = '';
                document.querySelector('[name=priceMin]').value = '';
                document.querySelector('[name=priceMax]').value = '';
                form.render('select');
                layer.msg('已清空搜索条件', {icon: 1, time: 1000});
            });
        });

        // 预订房间
        function bookRoom(roomId) {
            window.location.href = '${pageContext.request.contextPath}/user/book/' + roomId;
        }
    </script>
</body>
</html>
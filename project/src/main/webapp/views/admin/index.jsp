<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>酒店管理系统 - 后台管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 全局样式优化 */
        * {
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #f8f9fa 0%, #e8f4f8 100%);
            font-family: 'Microsoft YaHei', 'Helvetica Neue', Helvetica, Arial, sans-serif;
        }

        /* 头部区域优化 */
        .layui-layout-admin .layui-header {
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%) !important;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1) !important;
            border-bottom: none !important;
            display: flex !important;
            justify-content: space-between !important;
            align-items: center !important;
        }

        .layui-layout-admin .layui-logo {
            background: rgba(255, 255, 255, 0.1) !important;
            color: #fff !important;
            font-weight: 600 !important;
            font-size: 18px !important;
            border-radius: 0 20px 20px 0 !important;
            backdrop-filter: blur(10px) !important;
            border-right: 1px solid rgba(255, 255, 255, 0.2) !important;
            flex-shrink: 0 !important; /* 防止logo被压缩 */
        }

        .layui-layout-admin .layui-logo i {
            margin-right: 8px;
            color: #fff;
        }

        /* 用户信息区域 */
        .user-info {
            position: relative !important;
            cursor: pointer !important;
            padding: 0 20px !important;
            height: 60px !important;
            display: flex !important;
            align-items: center !important;
            margin-left: auto !important; /* 确保用户信息在右侧 */
        }

        .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .user-details {
            color: white;
            line-height: 1.2;
        }

        .user-name {
            font-size: 14px;
            font-weight: 500;
        }

        .user-role {
            font-size: 12px;
            opacity: 0.8;
        }

        .user-dropdown-icon {
            margin-left: 8px;
            transition: transform 0.3s ease;
        }

        .user-info:hover .user-dropdown-icon {
            transform: rotate(180deg);
        }

        /* 下拉菜单 */
        .user-dropdown {
            position: absolute;
            top: 100%;
            right: 20px;
            background: white;
            min-width: 180px;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s ease;
            z-index: 1000;
            border: 1px solid rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .user-info:hover .user-dropdown {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-item {
            display: block;
            padding: 12px 16px;
            color: #333;
            text-decoration: none;
            transition: all 0.3s ease;
            border-bottom: 1px solid #f0f0f0;
        }

        .dropdown-item:last-child {
            border-bottom: none;
        }

        .dropdown-item:hover {
            background: #f8f9fa;
            color: #009688;
        }

        .dropdown-item i {
            margin-right: 8px;
            width: 16px;
        }

        .dropdown-item:hover i {
            color: #009688;
        }

        /* 个人中心链接的特殊样式 */
        .dropdown-item[href*="profile"]:hover {
            padding-left: 16px;
        }

        /* 侧边栏优化（与全局主题统一） */
        .layui-side {
            background: linear-gradient(180deg, #00695c 0%, #004d40 100%);
            box-shadow: 2px 0 10px rgba(0,0,0,0.06);
        }

        /* 菜单项 - 默认/悬停/激活样式与全局翠绿主题一致 */
        .layui-nav-tree .layui-nav-item a {
            color: rgba(255, 255, 255, 0.95);
            border-radius: 8px;
            margin: 6px 10px;
            transition: all 0.18s ease;
            padding: 10px 14px;
            display: flex;
            align-items: center;
        }

        .layui-nav-tree .layui-nav-item a i {
            width: 22px;
            text-align: center;
            margin-right: 10px;
            color: rgba(255,255,255,0.9);
        }

        .layui-nav-tree .layui-nav-item a:hover {
            background: rgba(255, 255, 255, 0.06);
            color: #fff;
            transform: translateX(6px);
        }

        .layui-nav-tree .layui-this a {
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            color: #fff;
            box-shadow: 0 6px 18px rgba(0,150,136,0.18);
        }

        .layui-nav-tree .layui-nav-child dd a {
            padding-left: 44px;
            font-size: 13px;
            color: rgba(255,255,255,0.9);
        }

        .layui-nav-tree .layui-nav-child dd a:hover {
            background: rgba(255, 255, 255, 0.04);
        }

        /* 主内容区域优化：自适应高度，不固定高度，随内容撑开 */
        .layui-body {
            background: #f8f9fa;
            border-radius: 10px 0 0 0;
            margin: 10px 10px 10px 0;
            box-shadow: inset 0 0 10px rgba(0,0,0,0.05);
            min-height: 0 !important;
            height: auto !important;
            overflow: visible !important;
        }

        /* 主区域内主体自适应，确保内部容器随内容高度伸缩 */
        .layui-main, .layui-tab-content, .layui-tab-item {
            height: auto !important;
            min-height: 0 !important;
        }
        .layui-tab {
            margin: 0 0;
        }

        /* 选项卡优化 */
        .layui-tab-brief .layui-tab-title {
            background: #fff;
            border-radius: 8px 8px 0 0;
            padding: 0 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border-bottom: none;
        }

        .layui-tab-brief .layui-tab-title li {
            background: transparent;
            border-radius: 6px 6px 0 0;
            margin-right: 4px;
        }

        .layui-tab-brief .layui-tab-title li a {
            color: #666;
            padding: 12px 35px 12px 20px;
        }

        .layui-tab-brief .layui-tab-title .layui-this a {
            color: #009688;
            font-weight: 500;
        }

        .layui-tab-brief .layui-tab-title .layui-this {
            background: #f8f9fa;
            border-bottom: 2px solid #009688;
        }

        /* 选项卡关闭按钮样式 */
        .layui-tab-title li .layui-tab-close {
            position: absolute;
            top: 8px;
            right: 8px;
            color: #999;
            cursor: pointer;
            transition: all .2s;
            -webkit-transition: all .2s;
            font-size: 14px;
            opacity: 0.7;
            background: rgba(255,255,255,0.8);
            border-radius: 50%;
            width: 18px;
            height: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            line-height: 1;
        }

        .layui-tab-title li .layui-tab-close:hover {
            color: #FF5722;
            opacity: 1;
            background: rgba(255,87,34,0.1);
            transform: scale(1.1);
        }

        /* 首页tab不可关闭 */
        .layui-tab-title li:first-child .layui-tab-close {
            display: none !important;
        }

        .layui-tab-content {
            background: #fff;
            border-radius: 0 0 8px 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        /* 欢迎区域优化 */
        .welcome-section {
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            color: white;
            padding: 40px;
            border-radius: 12px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .welcome-section h1 {
            font-size: 32px;
            margin-bottom: 10px;
            font-weight: 300;
        }

        .welcome-section p {
            font-size: 16px;
            opacity: 0.9;
            margin: 0;
        }

        /* 统计卡片优化 */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
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

        /* 统计卡片颜色区分 */
        .stat-card.room .stat-icon { color: #009688; }
        .stat-card.checkin .stat-icon { color: #5FB878; }
        .stat-card.order .stat-icon { color: #FFB800; }
        .stat-card.revenue .stat-icon { color: #FF5722; }

        /* 底部优化 */
        .layui-footer {
            background: #fff;
            color: #666;
            border-top: 1px solid #e8f4f8;
            text-align: center;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.05);
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .layui-layout-admin .layui-side {
                width: 200px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .user-details {
                display: none;
            }

            .user-avatar {
                margin-right: 0;
            }
        }

        /* 滚动条美化 */
        ::-webkit-scrollbar {
            width: 6px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }

        ::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            border-radius: 3px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #5FB878 0%, #009688 100%);
        }
    </style>
</head>
<body class="layui-layout-body">
    <div class="layui-layout layui-layout-admin">
        <!-- 头部区域 -->
        <div class="layui-header">
            <div class="layui-logo">
                <i class="fas fa-hotel"></i> 酒店管理系统
            </div>

            <!-- 右侧用户信息 -->
            <div class="user-info">
                <div class="user-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="user-details">
                    <div class="user-name">${adminUser.realName}</div>
                    <div class="user-role">管理员</div>
                </div>
                <i class="fas fa-chevron-down user-dropdown-icon"></i>

                <!-- 下拉菜单 -->
                <div class="user-dropdown">
                    <a href="javascript:;" onclick="quickAction('profile')" class="dropdown-item" style="display: flex; align-items: center;">
                        <i class="fas fa-user-circle" style="margin-right: 8px;"></i> 个人中心
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/logout" class="dropdown-item">
                        <i class="fas fa-sign-out-alt"></i> 退出登录
                    </a>
                </div>
            </div>
        </div>

        <!-- 左侧菜单 -->
           <div class="layui-side layui-bg-black">
            <div class="layui-side-scroll">
                <ul class="layui-nav layui-nav-tree" lay-filter="adminNav">
                    <li class="layui-nav-item layui-nav-itemed">
                        <a href="javascript:;">
                            <i class="fas fa-home"></i> 首页
                        </a>
                        <dl class="layui-nav-child">
                            <dd><a href="javascript:;" data-url="${pageContext.request.contextPath}/admin/welcome" data-title="系统首页">系统首页</a></dd>
                        </dl>
                    </li>
                    <li class="layui-nav-item">
                        <a href="javascript:;">
                            <i class="fas fa-bed"></i> 房间管理
                        </a>
                        <dl class="layui-nav-child">
                            <dd><a href="javascript:;" data-url="${pageContext.request.contextPath}/admin/room/category/list" data-title="房间分类管理">房间分类管理</a></dd>
                            <dd><a href="javascript:;" data-url="${pageContext.request.contextPath}/admin/room/list" data-title="房间信息管理">房间信息管理</a></dd>
                        </dl>
                    </li>
                    <li class="layui-nav-item">
                        <a href="javascript:;">
                            <i class="fas fa-clipboard-list"></i> 订单管理
                        </a>
                        <dl class="layui-nav-child">
                            <dd><a href="javascript:;" data-url="${pageContext.request.contextPath}/admin/order/list" data-title="订单列表">订单列表</a></dd>
                        </dl>
                    </li>
                    <li class="layui-nav-item">
                        <a href="javascript:;">
                            <i class="fas fa-chart-bar"></i> 统计报表
                        </a>
                        <dl class="layui-nav-child">
                            <dd><a href="javascript:;" data-url="${pageContext.request.contextPath}/admin/statistics/occupancy" data-title="入住统计">入住统计</a></dd>
                            <dd><a href="javascript:;" data-url="${pageContext.request.contextPath}/admin/statistics/revenue" data-title="收入统计">收入统计</a></dd>
                        </dl>
                    </li>
                    <li class="layui-nav-item">
                        <a href="javascript:;">
                            <i class="fas fa-users"></i> 用户管理
                        </a>
                        <dl class="layui-nav-child">
                            <dd><a href="javascript:;" data-url="${pageContext.request.contextPath}/admin/user/list" data-title="会员管理">会员管理</a></dd>
                        </dl>
                    </li>
                    <li class="layui-nav-item">
                        <a href="javascript:;">
                            <i class="fas fa-cogs"></i> 系统管理
                        </a>
                        <dl class="layui-nav-child">
                            <dd><a href="javascript:;" data-url="${pageContext.request.contextPath}/admin/system/admin/list" data-title="管理员管理">管理员管理</a></dd>
                        </dl>
                    </li>
                </ul>
            </div>
        </div>

        <!-- 内容主体区域 -->
        <div class="layui-body">
            <!-- 选项卡 -->
            <div class="layui-tab layui-tab-brief" lay-filter="adminTab" lay-allowClose="true">
                <ul class="layui-tab-title">
                    <li class="layui-this">系统首页</li>
                </ul>
                <div class="layui-tab-content">
                    <div class="layui-tab-item layui-show">
                        <!-- 欢迎区域 -->
                        <div class="welcome-section">
                            <h1><i class="fas fa-hotel"></i> 欢迎使用酒店管理系统</h1>
                            <p>选择左侧菜单开始管理您的酒店业务，享受智能化的酒店管理体验</p>
                        </div>

                        <!-- 统计卡片 -->
                        <div class="stats-grid">
                            <div class="stat-card room">
                                <div class="stat-icon">
                                    <i class="fas fa-bed"></i>
                                </div>
                                <div class="stat-title">总房间数</div>
                                <div class="stat-value" id="totalRooms">--</div>
                            </div>

                            <div class="stat-card checkin">
                                <div class="stat-icon">
                                    <i class="fas fa-user-check"></i>
                                </div>
                                <div class="stat-title">今日入住</div>
                                <div class="stat-value" id="todayCheckIns">--</div>
                            </div>

                            <div class="stat-card order">
                                <div class="stat-icon">
                                    <i class="fas fa-clipboard-check"></i>
                                </div>
                                <div class="stat-title">待审核订单</div>
                                <div class="stat-value" id="pendingOrders">--</div>
                            </div>

                            <div class="stat-card revenue">
                                <div class="stat-icon">
                                    <i class="fas fa-dollar-sign"></i>
                                </div>
                                <div class="stat-title">今日收入</div>
                                <div class="stat-value" id="todayRevenue">--</div>
                            </div>
                        </div>

                        <!-- 快捷操作区域 -->
                        <div class="layui-row" style="margin-top: 30px;">
                            <div class="layui-col-md12">
                                <div style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);">
                                    <h3 style="color: #333; margin-bottom: 20px; display: flex; align-items: center;">
                                        <i class="fas fa-bolt" style="color: #009688; margin-right: 10px;"></i>
                                        快捷操作
                                    </h3>
                                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px;">
                                        <a href="javascript:;" onclick="quickAction('room')" style="display: flex; align-items: center; padding: 15px; background: linear-gradient(135deg, #e8f4f8 0%, #b2dfdb 100%); border-radius: 8px; text-decoration: none; color: #009688; transition: all 0.3s ease;">
                                            <i class="fas fa-plus-circle" style="margin-right: 10px; font-size: 20px;"></i>
                                            <span>添加房间</span>
                                        </a>
                                        <a href="javascript:;" onclick="quickAction('order')" style="display: flex; align-items: center; padding: 15px; background: linear-gradient(135deg, #f1f8e9 0%, #dcedc8 100%); border-radius: 8px; text-decoration: none; color: #4caf50; transition: all 0.3s ease;">
                                            <i class="fas fa-list-ul" style="margin-right: 10px; font-size: 20px;"></i>
                                            <span>查看订单</span>
                                        </a>
                                        <a href="javascript:;" onclick="quickAction('user')" style="display: flex; align-items: center; padding: 15px; background: linear-gradient(135deg, #fff8e1 0%, #ffecb3 100%); border-radius: 8px; text-decoration: none; color: #ff9800; transition: all 0.3s ease;">
                                            <i class="fas fa-users-cog" style="margin-right: 10px; font-size: 20px;"></i>
                                            <span>用户管理</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 底部固定区域 -->
        <div class="layui-footer">
            © 2024 酒店管理系统. All Rights Reserved.
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <script>
        // 页面加载时的调试信息
        console.log('后台管理页面加载完成');

        // 加载首页统计数据函数
        function loadDashboardStatistics() {
            fetch('${pageContext.request.contextPath}/admin/statistics/dashboard')
                .then(r => r.json())
                .then(res => {
                    if(res.success && res.data) {
                        document.getElementById('totalRooms').textContent = res.data.totalRooms;
                        document.getElementById('todayCheckIns').textContent = res.data.todayCheckIns;
                        document.getElementById('pendingOrders').textContent = res.data.pendingOrders;
                        document.getElementById('todayRevenue').textContent = '¥' + parseFloat(res.data.todayRevenue).toFixed(2);
                    } else {
                        console.error('获取统计数据失败:', res.message);
                        // 设置默认值
                        document.getElementById('totalRooms').textContent = '0';
                        document.getElementById('todayCheckIns').textContent = '0';
                        document.getElementById('pendingOrders').textContent = '0';
                        document.getElementById('todayRevenue').textContent = '¥0.00';
                    }
                })
                .catch(error => {
                    console.error('网络错误，无法获取统计数据:', error);
                    // 设置默认值
                    document.getElementById('totalRooms').textContent = '0';
                    document.getElementById('todayCheckIns').textContent = '0';
                    document.getElementById('pendingOrders').textContent = '0';
                    document.getElementById('todayRevenue').textContent = '¥0.00';
                });
        }

        layui.use(['element', 'layer'], function(){
            var element = layui.element;
            var layer = layui.layer;
            var $ = layui.$;

            // 监听导航点击
            $('.layui-nav-tree a[data-url]').on('click', function(){
                var url = $(this).data('url');
                var title = $(this).data('title');

                // 检查标签是否已存在
                var exist = false;
                $('.layui-tab-title li').each(function(){
                    if($(this).text() === title){
                        exist = true;
                        // 切换到该标签
                        $(this).addClass('layui-this').siblings().removeClass('layui-this');
                        $('.layui-tab-content .layui-tab-item').eq($(this).index()).addClass('layui-show').siblings().removeClass('layui-show');
                        return false;
                    }
                });

                if(!exist){
                    // 添加新标签
                    var tabIndex = $('.layui-tab-title li').length;
                $('.layui-tab-title').append('<li>' + title + '<i class="fas fa-times layui-tab-close" style="display:none;"></i></li>');
                    // 创建iframe并在加载完成后自适应高度（仅同源页面可完美自适应）
                    var $iframe = $('<iframe>', {
                        src: url,
                        frameborder: 0,
                        style: 'width:100%; border:0; display:block; min-height: 600px;'
                    });

                    // 智能高度自适应函数
                    var adjustIframeHeight = function() {
                        try {
                            var doc = $iframe[0].contentWindow.document;
                            var body = doc.body;
                            var html = doc.documentElement;

                            // 获取内容实际高度
                            var height = Math.max(
                                body.scrollHeight,
                                body.offsetHeight,
                                html.clientHeight,
                                html.scrollHeight,
                                html.offsetHeight,
                                600 // 最小高度
                            );

                            // 添加一些缓冲空间，避免滚动条
                            height += 20;

                            // 限制最大高度，避免过度拉伸
                            height = Math.min(height, window.innerHeight - 200);

                            $iframe.height(height);
                        } catch(e){
                            // cross-origin or other access error; fallback to auto height
                            $iframe.css('height','600px');
                        }
                    };

                    $iframe.on('load', function(){
                        // 页面加载完成后调整高度
                        setTimeout(adjustIframeHeight, 100);

                        // 监听内容变化，重新调整高度
                        try {
                            var doc = this.contentWindow.document;
                            // 监听DOM变化
                            var observer = new MutationObserver(function(mutations) {
                                setTimeout(adjustIframeHeight, 50);
                            });

                            observer.observe(doc.body, {
                                childList: true,
                                subtree: true,
                                attributes: true,
                                characterData: true
                            });

                            // 监听窗口大小变化
                            $(window).on('resize', adjustIframeHeight);

                        } catch(e) {
                            // 如果不支持MutationObserver，使用定时器检查
                            setInterval(adjustIframeHeight, 1000);
                        }
                    });
                    $('.layui-tab-content').append($('<div class=\"layui-tab-item\"></div>').append($iframe));

                    // 切换到新标签
                    $('.layui-tab-title li').removeClass('layui-this');
                    $('.layui-tab-title li').eq(tabIndex).addClass('layui-this');
                    $('.layui-tab-content .layui-tab-item').removeClass('layui-show');
                    $('.layui-tab-content .layui-tab-item').eq(tabIndex).addClass('layui-show');
                }

                // 重新渲染选项卡
                element.render('tab');
            });

            // 监听选项卡切换
            element.on('tab(adminTab)', function(data){
                // 显示关闭按钮
                $('.layui-tab-title li .layui-tab-close').hide();
                // 只有当前激活的tab且不是首页时才显示关闭按钮
                var $currentTab = $('.layui-tab-title li.layui-this');
                if($currentTab.index() > 0){ // 首页index为0，不显示删除按钮
                    $currentTab.find('.layui-tab-close').show();
                }

                // 如果切换到首页，重新加载统计数据
                if($currentTab.index() === 0) {
                    loadDashboardStatistics();
                }
            });

            // 鼠标悬停显示关闭按钮
            $(document).on('mouseenter', '.layui-tab-title li', function(){
                if(!$(this).hasClass('layui-this') && $('.layui-tab-title li').length > 1 && $(this).index() > 0){
                    $(this).find('.layui-tab-close').show();
                }
            });

            $(document).on('mouseleave', '.layui-tab-title li', function(){
                $(this).find('.layui-tab-close').hide();
            });

            // 删除tab
            $(document).on('click', '.layui-tab-close', function(e){
                e.stopPropagation(); // 阻止事件冒泡
                var $tab = $(this).closest('li');
                var index = $tab.index();

                // 不允许删除首页（第一个tab）
                if(index === 0){
                    layer.msg('首页不能删除', {icon: 0});
                    return false;
                }

                // 确认删除
                layer.confirm('确定要关闭此页面吗？', {
                    icon: 3,
                    title: '提示'
                }, function(layerIndex){
                    // 移除tab和对应的content
                    $tab.remove();
                    $('.layui-tab-content .layui-tab-item').eq(index).remove();

                    // 如果删除的是当前激活的tab，激活前一个tab
                    if($tab.hasClass('layui-this')){
                        var newActiveIndex = Math.max(0, index - 1);
                        $('.layui-tab-title li').eq(newActiveIndex).addClass('layui-this').siblings().removeClass('layui-this');
                        $('.layui-tab-content .layui-tab-item').eq(newActiveIndex).addClass('layui-show').siblings().removeClass('layui-show');

                        // 重新显示当前激活tab的删除按钮（如果不是首页）
                        if(newActiveIndex > 0){
                            $('.layui-tab-title li.layui-this .layui-tab-close').show();
                        }
                    }

                    // 重新渲染tab
                    element.render('tab');
                    layer.close(layerIndex);
                });

                return false;
            });

            // 退出登录确认
            $('.user-dropdown .dropdown-item[href*="logout"]').on('click', function(e){
                e.preventDefault();
                var href = $(this).attr('href');
                layer.confirm('确定要退出登录吗？', {
                    icon: 3,
                    title: '提示',
                    btn: ['确定', '取消']
                }, function(index){
                    window.location.href = href;
                    layer.close(index);
                });
            });

            // 快捷操作功能
            window.quickAction = function(action) {
                var title = '';
                var url = '';

                switch(action) {
                    case 'room':
                        title = '添加房间';
                        url = '${pageContext.request.contextPath}/admin/room/add';
                        break;
                    case 'order':
                        title = '订单管理';
                        url = '${pageContext.request.contextPath}/admin/order/list';
                        break;
                    case 'user':
                        title = '用户管理';
                        url = '${pageContext.request.contextPath}/admin/user/list';
                        break;
                    case 'profile':
                        title = '个人中心';
                        url = '${pageContext.request.contextPath}/admin/profile';
                        break;
                    case 'report':
                        title = '数据报表';
                        url = '${pageContext.request.contextPath}/admin/statistics/revenue';
                        break;
                    default:
                        layer.msg('功能开发中...', {icon: 0});
                        return;
                }

                // 检查标签是否已存在
                var exist = false;
                $('.layui-tab-title li').each(function(){
                    if($(this).text() === title){
                        exist = true;
                        // 切换到该标签
                        $(this).addClass('layui-this').siblings().removeClass('layui-this');
                        $('.layui-tab-content .layui-tab-item').eq($(this).index()).addClass('layui-show').siblings().removeClass('layui-show');
                        return false;
                    }
                });

                if(!exist){
                    // 添加新标签
                    var tabIndex = $('.layui-tab-title li').length;
                    $('.layui-tab-title').append('<li>' + title + '<i class="fas fa-times layui-tab-close" style="display:none;"></i></li>');
                    var $iframe = $('<iframe>', {
                        src: url,
                        frameborder: 0,
                        style: 'width:100%; border:0; display:block; min-height: 600px;'
                    });

                    // 智能高度自适应函数
                    var adjustIframeHeight = function() {
                        try {
                            var doc = $iframe[0].contentWindow.document;
                            var body = doc.body;
                            var html = doc.documentElement;

                            // 获取内容实际高度
                            var height = Math.max(
                                body.scrollHeight,
                                body.offsetHeight,
                                html.clientHeight,
                                html.scrollHeight,
                                html.offsetHeight,
                                600 // 最小高度
                            );

                            // 添加一些缓冲空间，避免滚动条
                            height += 20;

                            // 限制最大高度，避免过度拉伸
                            height = Math.min(height, window.innerHeight - 200);

                            $iframe.height(height);
                        } catch(e){
                            // cross-origin or other access error; fallback to auto height
                            $iframe.css('height','600px');
                        }
                    };

                    $iframe.on('load', function(){
                        // 页面加载完成后调整高度
                        setTimeout(adjustIframeHeight, 100);

                        // 监听内容变化，重新调整高度
                        try {
                            var doc = this.contentWindow.document;
                            // 监听DOM变化
                            var observer = new MutationObserver(function(mutations) {
                                setTimeout(adjustIframeHeight, 50);
                            });

                            observer.observe(doc.body, {
                                childList: true,
                                subtree: true,
                                attributes: true,
                                characterData: true
                            });

                            // 监听窗口大小变化
                            $(window).on('resize', adjustIframeHeight);

                        } catch(e) {
                            // 如果不支持MutationObserver，使用定时器检查
                            setInterval(adjustIframeHeight, 1000);
                        }
                    });
                    $('.layui-tab-content').append($('<div class="layui-tab-item"></div>').append($iframe));

                    // 切换到新标签
                    $('.layui-tab-title li').removeClass('layui-this');
                    $('.layui-tab-title li').eq(tabIndex).addClass('layui-this');
                    $('.layui-tab-content .layui-tab-item').removeClass('layui-show');
                    $('.layui-tab-content .layui-tab-item').eq(tabIndex).addClass('layui-show');

                    // 重新渲染选项卡
                    element.render('tab');
                }

                layer.msg('正在打开' + title + '...', {icon: 1, time: 1000});
            };

            // 页面加载完成后获取统计数据
            loadDashboardStatistics();
        });
    </script>
</body>
</html>
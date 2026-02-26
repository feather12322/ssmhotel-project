<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 用户端统一头部导航 -->
<div class="user-header">
    <div class="header-left">
        <a href="${pageContext.request.contextPath}/user/index" class="logo">
            <i class="fas fa-hotel" style="margin-right: 8px;"></i>
            酒店预订系统
        </a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/user/index">首页</a>
            <a href="${pageContext.request.contextPath}/user/rooms">房间查询</a>
            <a href="${pageContext.request.contextPath}/user/orders">我的订单</a>
        </div>
    </div>

    <div class="header-right">
        <div class="user-info">
            <div class="user-avatar">
                <c:choose>
                    <c:when test="${not empty user.avatar}">
                        <img src="${user.avatar}" alt="头像" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                    </c:when>
                    <c:otherwise>
                        <i class="fas fa-user"></i>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="user-details">
                <div class="user-name">${user.realName}</div>
                <div class="user-role">会员用户</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/user/logout" class="logout-btn">
            <i class="fas fa-sign-out-alt" style="margin-right: 5px;"></i>退出
        </a>
    </div>
</div>

<!-- 统一的头部样式 -->
<style>
    /* 头部导航 */
    .user-header {
        background: white;
        color: #333;
        padding: 15px 30px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 2px solid #f0f0f0;
        position: sticky;
        top: 0;
        z-index: 1000;
    }

    .header-left {
        display: flex;
        align-items: center;
    }

    .header-left .logo {
        font-size: 24px;
        font-weight: 600;
        margin-right: 30px;
        color: #333;
        text-decoration: none;
        display: flex;
        align-items: center;
    }

    .header-left .nav-links {
        display: flex;
        gap: 20px;
    }

    .nav-links a {
        color: #666;
        text-decoration: none;
        padding: 8px 16px;
        border-radius: 6px;
        transition: all 0.3s ease;
        font-weight: 500;
    }

    .nav-links a:hover,
    .nav-links a.active {
        background: #009688;
        color: white;
    }

    .header-right {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .user-info {
        display: flex;
        align-items: center;
        gap: 10px;
        cursor: pointer;
    }

    .user-avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: white;
        box-shadow: 0 2px 8px rgba(0,150,136,0.2);
        position: relative;
        overflow: hidden;
    }

    .user-avatar img {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        object-fit: cover;
    }

    .user-details {
        line-height: 1.2;
        color: #333;
    }

    .user-name {
        font-size: 14px;
        font-weight: 500;
    }

    .user-role {
        font-size: 12px;
        opacity: 0.8;
    }

    .logout-btn {
        color: #666;
        text-decoration: none;
        padding: 6px 12px;
        border-radius: 4px;
        transition: all 0.3s ease;
        font-weight: 500;
    }

    .logout-btn:hover {
        background: #f8f9fa;
        color: #009688;
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

        .header-left .logo {
            font-size: 20px;
            margin-right: 20px;
        }

        .nav-links a {
            padding: 6px 12px;
            font-size: 14px;
        }

    .user-details {
        display: none;
    }

    .user-avatar {
        margin-right: 0;
    }
}
</style>

<!-- 统一导航高亮逻辑 -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const navLinks = document.querySelectorAll('.nav-links a');
    const currentPath = window.location.pathname;

    navLinks.forEach(link => {
        const linkHref = link.getAttribute('href');

        // 跳过个人中心链接（#profile）
        if (!linkHref || linkHref === '#profile') {
            return;
        }

        // 根据当前路径匹配对应的导航项
        if (linkHref.includes('/user/index') && currentPath === '/user/index') {
            link.classList.add('active');
        } else if (linkHref.includes('/user/rooms') && (currentPath === '/user/rooms' || currentPath.includes('/user/room/'))) {
            link.classList.add('active');
        } else if (linkHref.includes('/user/orders') && currentPath === '/user/orders') {
            link.classList.add('active');
        }
    });
});
</script>
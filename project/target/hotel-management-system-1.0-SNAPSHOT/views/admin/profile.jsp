<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <style>
        .container { padding: 20px; }
        .profile-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 20px;
        }
        .avatar-section {
            text-align: center;
            margin-bottom: 30px;
        }
        .avatar-circle {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 40px;
            color: white;
            box-shadow: 0 4px 15px rgba(0,150,136,0.3);
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-item {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            border: 1px solid rgba(0,0,0,0.05);
        }
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #009688;
            margin-bottom: 5px;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        .info-section h3 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #009688;
        }
        .info-row {
            display: flex;
            margin-bottom: 15px;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .info-label {
            width: 120px;
            font-weight: 500;
            color: #666;
        }
        .info-value {
            flex: 1;
            color: #333;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 个人信息 -->
    <div class="profile-card">
        <div class="info-section">
            <h3><i class="fas fa-user-circle" style="margin-right: 10px;"></i>个人信息</h3>

            <div class="info-row">
                <div class="info-label">用户名：</div>
                <div class="info-value">${adminUser.userName}</div>
            </div>

            <div class="info-row">
                <div class="info-label">真实姓名：</div>
                <div class="info-value">${adminUser.realName}</div>
            </div>

            <div class="info-row">
                <div class="info-label">手机号：</div>
                <div class="info-value">
                    <c:if test="${not empty adminUser.phone}">${adminUser.phone}</c:if>
                    <c:if test="${empty adminUser.phone}"><span style="color: #999;">未填写</span></c:if>
                </div>
            </div>

            <div class="info-row">
                <div class="info-label">邮箱：</div>
                <div class="info-value">
                    <c:if test="${not empty adminUser.email}">${adminUser.email}</c:if>
                    <c:if test="${empty adminUser.email}"><span style="color: #999;">未填写</span></c:if>
                </div>
            </div>

            <div class="info-row">
                <div class="info-label">用户类型：</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${adminUser.userType == 1}">
                            <span class="layui-badge layui-bg-blue">管理员</span>
                        </c:when>
                        <c:otherwise>
                            <span class="layui-badge layui-bg-green">普通用户</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="info-row">
                <div class="info-label">账户状态：</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${adminUser.status == 1}">
                            <span class="layui-badge layui-bg-green">正常</span>
                        </c:when>
                        <c:when test="${adminUser.status == 0}">
                            <span class="layui-badge layui-bg-gray">禁用</span>
                        </c:when>
                        <c:otherwise>
                            <span class="layui-badge">未知</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="info-row">
                <div class="info-label">注册时间：</div>
                <div class="info-value">
                    <c:if test="${not empty adminUser.createTime}">
                        <fmt:formatDate value="${adminUser.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </c:if>
                    <c:if test="${empty adminUser.createTime}">
                        <span style="color: #999;">未知</span>
                    </c:if>
                </div>
            </div>

            <div class="info-row" style="border-bottom: none;">
                <div class="info-label">最后登录：</div>
                <div class="info-value">
                    <c:if test="${not empty adminUser.updateTime}">
                        <fmt:formatDate value="${adminUser.updateTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </c:if>
                    <c:if test="${empty adminUser.updateTime}">
                        <span style="color: #999;">未知</span>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- 操作按钮 -->
    <div class="profile-card">
        <div style="text-align: center;">
            <button class="layui-btn layui-btn-normal" onclick="editProfile()">
                <i class="fas fa-edit"></i> 编辑信息
            </button>
            <button class="layui-btn layui-btn-warm" onclick="changePassword()">
                <i class="fas fa-key"></i> 修改密码
            </button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
<script>
    layui.use(['layer'], function(){
        var layer = layui.layer;

        // 编辑个人信息
        window.editProfile = function(){
            layer.open({
                type: 2,
                title: '编辑个人信息',
                area: ['700px', '650px'],
                content: '${pageContext.request.contextPath}/admin/profile/edit',
                end: function(){
                    // 刷新页面
                    location.reload();
                }
            });
        };

        // 修改密码
        window.changePassword = function(){
            layer.open({
                type: 2,
                title: '修改密码',
                area: ['700px', '650px'],
                content: '${pageContext.request.contextPath}/admin/profile/changePassword'
            });
        };

    });
</script>
</body>
</html>
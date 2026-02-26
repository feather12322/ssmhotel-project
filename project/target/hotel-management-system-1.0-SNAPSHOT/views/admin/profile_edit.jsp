<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑个人信息</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <style>
        .container { padding: 20px; max-width: 600px; margin: 0 auto; }
        .form-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 30px;
        }
        .form-section h3 {
            color: #333;
            margin-bottom: 30px;
            text-align: center;
            border-bottom: 2px solid #009688;
            padding-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="form-section">
        <h3><i class="fas fa-user-edit" style="margin-right: 10px;"></i>编辑个人信息</h3>

        <form class="layui-form" lay-filter="profileForm">
            <input type="hidden" name="userId" value="${user.userId}" />

            <div class="layui-form-item">
                <label class="layui-form-label">用户名</label>
                <div class="layui-input-block">
                    <input type="text" name="userName" required lay-verify="required" placeholder="用户名" autocomplete="off" class="layui-input" value="${user.userName}" readonly style="background: #f8f9fa;">
                    <div class="layui-form-mid layui-word-aux">用户名不可修改</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">真实姓名</label>
                <div class="layui-input-block">
                    <input type="text" name="realName" required lay-verify="required" placeholder="请输入真实姓名" autocomplete="off" class="layui-input" value="${user.realName}">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">手机号</label>
                <div class="layui-input-block">
                    <input type="text" name="phone" placeholder="请输入手机号" autocomplete="off" class="layui-input" value="${user.phone}">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">邮箱</label>
                <div class="layui-input-block">
                    <input type="email" name="email" placeholder="请输入邮箱" autocomplete="off" class="layui-input" value="${user.email}">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">用户类型</label>
                <div class="layui-input-block">
                    <c:choose>
                        <c:when test="${user.userType == 1}">
                            <input type="text" class="layui-input" value="管理员" readonly style="background: #f8f9fa;">
                        </c:when>
                        <c:otherwise>
                            <input type="text" class="layui-input" value="普通用户" readonly style="background: #f8f9fa;">
                        </c:otherwise>
                    </c:choose>
                    <div class="layui-form-mid layui-word-aux">用户类型不可修改</div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-normal" lay-submit lay-filter="saveProfile">保存修改</button>
                    <button type="button" class="layui-btn layui-btn-primary" onclick="parent.layer.closeAll()">取消</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
<script>
    layui.use(['form', 'layer'], function(){
        var form = layui.form, layer = layui.layer;

        // 表单提交
        form.on('submit(saveProfile)', function(data){
            var field = data.field;

            fetch('${pageContext.request.contextPath}/admin/profile/update', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: Object.keys(field).map(k => encodeURIComponent(k) + '=' + encodeURIComponent(field[k] || '')).join('&')
            }).then(r => r.json()).then(res => {
                if(res.success){
                    layer.msg('保存成功', {icon: 1});
                    setTimeout(() => {
                        parent.layer.closeAll();
                        parent.location.reload();
                    }, 1000);
                } else {
                    layer.msg('保存失败：' + (res.message || ''), {icon: 2});
                }
            }).catch(() => {
                layer.msg('网络异常', {icon: 2});
            });

            return false;
        });
    });
</script>
</body>
</html>
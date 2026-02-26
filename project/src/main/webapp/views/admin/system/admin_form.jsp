<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员表单</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <style>.container{padding:20px;}</style>
</head>
<body>
<div class="container">
    <form class="layui-form" lay-filter="adminForm">
        <input type="hidden" name="userId" value="${user.userId}" />
        <div class="layui-form-item">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-block">
                <input type="text" name="userName" required lay-verify="required" placeholder="用户名" autocomplete="off" class="layui-input" value="${user.userName}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">密码</label>
            <div class="layui-input-block">
                <input type="password" name="password" required lay-verify="required" placeholder="密码" autocomplete="off" class="layui-input" value="${user.password}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">真实姓名</label>
            <div class="layui-input-block">
                <input type="text" name="realName" class="layui-input" value="${user.realName}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">手机号</label>
            <div class="layui-input-block">
                <input type="text" name="phone" class="layui-input" value="${user.phone}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">邮箱</label>
            <div class="layui-input-block">
                <input type="email" name="email" class="layui-input" value="${user.email}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">状态</label>
            <div class="layui-input-block">
                <select name="status">
                    <option value="1" <c:if test="${user.status == 1}">selected</c:if>>正常</option>
                    <option value="0" <c:if test="${user.status == 0}">selected</c:if>>禁用</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="saveAdmin">保存</button>
                <a class="layui-btn layui-btn-primary" href="${pageContext.request.contextPath}/admin/system/admin/list">返回</a>
            </div>
        </div>
    </form>
</div>
<script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
<script>
    layui.use(['form','layer'], function(){
        var form = layui.form, layer = layui.layer;
        form.render('select'); // 渲染select组件
        form.on('submit(saveAdmin)', function(data){
            var vals = data.field;
            var url = vals.userId ? '${pageContext.request.contextPath}/admin/system/admin/update' : '${pageContext.request.contextPath}/admin/system/admin/save';
            fetch(url, {
                method:'POST',
                headers:{'Content-Type':'application/x-www-form-urlencoded'},
                body: Object.keys(vals).map(k=>encodeURIComponent(k)+'='+encodeURIComponent(vals[k]||'')).join('&')
            }).then(r=>r.json()).then(res=>{
                if(res.success){ layer.msg('保存成功',{icon:1}); setTimeout(()=>location.href='${pageContext.request.contextPath}/admin/system/admin/list',800); }
                else layer.msg('保存失败',{icon:2});
            }).catch(()=>layer.msg('网络异常',{icon:2}));
            return false;
        });
    });
</script>
</body>
</html>


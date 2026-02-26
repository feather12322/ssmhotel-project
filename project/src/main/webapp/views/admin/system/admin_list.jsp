<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <style>.actions{margin-bottom:16px;}</style>
</head>
<body>
<div class="layui-container" style="padding:20px;">
    <div class="actions">
        <a class="layui-btn layui-btn-normal" href="${pageContext.request.contextPath}/admin/system/admin/add">新增管理员</a>
    </div>

    <!-- 查询条件 -->
    <form class="layui-form layui-card" lay-filter="searchForm" style="margin-bottom:20px; padding:15px;">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">用户名</label>
                <div class="layui-input-inline">
                    <input type="text" name="userName" placeholder="请输入用户名" autocomplete="off" class="layui-input" value="${searchUserName}">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">真实姓名</label>
                <div class="layui-input-inline">
                    <input type="text" name="realName" placeholder="请输入真实姓名" autocomplete="off" class="layui-input" value="${searchRealName}">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">手机号</label>
                <div class="layui-input-inline">
                    <input type="text" name="phone" placeholder="请输入手机号" autocomplete="off" class="layui-input" value="${searchPhone}">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">状态</label>
                <div class="layui-input-inline">
                    <select name="status">
                        <option value="">全部状态</option>
                        <option value="1" <c:if test="${searchStatus == 1}">selected</c:if>>正常</option>
                        <option value="0" <c:if test="${searchStatus == 0}">selected</c:if>>禁用</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="searchBtn">查询</button>
                <button type="reset" class="layui-btn layui-btn-primary" id="resetBtn">重置</button>
            </div>
        </div>
    </form>

    <table class="layui-table" lay-size="sm">
        <colgroup>
            <col width="60">
            <col width="120">
            <col width="100">
            <col width="120">
            <col width="150">
            <col width="80">
            <col width="120">
            <col width="200">
        </colgroup>
        <thead>
        <tr>
            <th>ID</th>
            <th>用户名</th>
            <th>真实姓名</th>
            <th>手机号</th>
            <th>邮箱</th>
            <th>状态</th>
            <th>注册时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${users}">
            <tr>
                <td>${u.userId}</td>
                <td>
                    <div style="font-weight:600">${u.userName}</div>
                </td>
                <td>${u.realName}</td>
                <td>
                    <c:if test="${not empty u.phone}">${u.phone}</c:if>
                    <c:if test="${empty u.phone}"><span style="color:#999">未填写</span></c:if>
                </td>
                <td>
                    <c:if test="${not empty u.email}">${u.email}</c:if>
                    <c:if test="${empty u.email}"><span style="color:#999">未填写</span></c:if>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${u.status == 1}">
                            <span class="layui-badge layui-bg-green">正常</span>
                        </c:when>
                        <c:when test="${u.status == 0}">
                            <span class="layui-badge layui-bg-gray">禁用</span>
                        </c:when>
                        <c:otherwise>
                            <span class="layui-badge">未知</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:if test="${not empty u.createTime}">
                        <fmt:formatDate value="${u.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                    </c:if>
                    <c:if test="${empty u.createTime}">
                        <span style="color:#999">未知</span>
                    </c:if>
                </td>
                <td>
                    <a class="layui-btn layui-btn-xs" href="${pageContext.request.contextPath}/admin/system/admin/edit/${u.userId}">编辑</a>
                    <button class="layui-btn layui-btn-danger layui-btn-xs" onclick="deleteAdmin(${u.userId})">删除</button>
                    <button class="layui-btn layui-btn-warm layui-btn-xs" onclick="resetPwd(${u.userId})">重置密码</button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <!-- 分页 -->
    <div id="pageDemo" style="text-align: center; margin-top: 20px;"></div>
</div>

<script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
<script>
    layui.use(['layer', 'form', 'laypage'], function(){
        var layer = layui.layer;
        var form = layui.form;
        var laypage = layui.laypage;

        // 查询功能
        form.on('submit(searchBtn)', function(data){
            var field = data.field;
            var params = new URLSearchParams();
            if(field.userName) params.append('userName', field.userName);
            if(field.realName) params.append('realName', field.realName);
            if(field.phone) params.append('phone', field.phone);
            if(field.status) params.append('status', field.status);

            var url = '${pageContext.request.contextPath}/admin/system/admin/list';
            if(params.toString()) url += '?' + params.toString();

            window.location.href = url;
            return false;
        });

        // 重置查询
        document.getElementById('resetBtn').addEventListener('click', function(){
            window.location.href = '${pageContext.request.contextPath}/admin/system/admin/list';
        });

        // 分页
        laypage.render({
            elem: 'pageDemo',
            count: ${total},
            curr: ${page},
            limit: ${limit},
            limits: [5, 10, 20, 50],
            layout: ['count', 'prev', 'page', 'next', 'limit', 'skip'],
            jump: function(obj, first){
                if(!first){
                    var params = new URLSearchParams();
                    if('${searchUserName}' !== '') params.append('userName', '${searchUserName}');
                    if('${searchRealName}' !== '') params.append('realName', '${searchRealName}');
                    if('${searchPhone}' !== '') params.append('phone', '${searchPhone}');
                    if('${searchStatus}' !== '') params.append('status', '${searchStatus}');
                    params.append('page', obj.curr);
                    params.append('limit', obj.limit);

                    var url = '${pageContext.request.contextPath}/admin/system/admin/list';
                    if(params.toString()) url += '?' + params.toString();
                    window.location.href = url;
                }
            }
        });

        window.deleteAdmin = function(id){
            layer.confirm('确定删除该管理员吗？', function(index){
                fetch('${pageContext.request.contextPath}/admin/system/admin/delete', {
                    method:'POST',
                    headers:{'Content-Type':'application/x-www-form-urlencoded'},
                    body:'userId=' + id
                }).then(r=>r.json()).then(res=>{
                    if(res.success) location.reload();
                    else layer.msg('删除失败',{icon:2});
                }).catch(()=>layer.msg('网络错误',{icon:2}));
                layer.close(index);
            });
        };
        window.resetPwd = function(id){
            layer.confirm('确定将密码重置为 123456 吗？', function(index){
                fetch('${pageContext.request.contextPath}/admin/system/admin/resetPassword', {
                    method:'POST',
                    headers:{'Content-Type':'application/x-www-form-urlencoded'},
                    body:'userId=' + id
                }).then(r=>r.json()).then(res=>{
                    if(res.success) layer.msg('重置成功，默认密码 123456',{icon:1});
                    else layer.msg('重置失败',{icon:2});
                }).catch(()=>layer.msg('网络错误',{icon:2}));
                layer.close(index);
            });
        };
    });
</script>
</body>
</html>


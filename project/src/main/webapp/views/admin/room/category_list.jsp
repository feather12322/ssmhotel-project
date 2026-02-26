<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>房间分类管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <style>
        .actions { margin-bottom: 16px; }
        /* 表格内容左对齐 */
        .layui-table th, .layui-table td {
            text-align: left;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<div class="layui-container" style="padding:20px;">
    <div class="actions">
        <a class="layui-btn layui-btn-normal" href="${pageContext.request.contextPath}/admin/room/category/add">新增分类</a>
    </div>

    <!-- 查询条件 -->
    <form class="layui-form layui-card" lay-filter="searchForm" style="margin-bottom:20px; padding:15px;">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">分类名称</label>
                <div class="layui-input-inline">
                    <input type="text" name="categoryName" placeholder="请输入分类名称" autocomplete="off" class="layui-input" value="${searchCategoryName}">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">价格区间</label>
                <div class="layui-input-inline">
                    <input type="number" name="priceMin" placeholder="最低价" autocomplete="off" class="layui-input" value="${searchPriceMin}">
                </div>
                <div class="layui-form-mid">-</div>
                <div class="layui-input-inline">
                    <input type="number" name="priceMax" placeholder="最高价" autocomplete="off" class="layui-input" value="${searchPriceMax}">
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
            <col width="80">
            <col width="100">
            <col>
            <col width="120">
            <col width="120">
        </colgroup>
        <thead>
        <tr>
            <th>编号</th>
            <th>封面图片</th>
            <th>名称 / 描述</th>
            <th>价格区间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="c" items="${categories}">
            <tr>
                <td>${c.categoryId}</td>
                <td>
                    <c:if test="${not empty c.coverImg}">
                        <img src="${c.coverImg}" style="width: 60px; height: 40px; object-fit: cover; border-radius: 4px;" alt="封面图片">
                    </c:if>
                    <c:if test="${empty c.coverImg}">
                        <div style="width: 60px; height: 40px; background: #f5f5f5; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: #999; font-size: 12px;">无图片</div>
                    </c:if>
                </td>
                <td>
                    <div style="font-weight:600">${c.categoryName}</div>
                    <div style="color:#888">${c.description}</div>
                </td>
                <td>¥${c.priceMin} - ¥${c.priceMax}</td>
                <td>
                    <a class="layui-btn layui-btn-xs" href="${pageContext.request.contextPath}/admin/room/category/edit/${c.categoryId}">编辑</a>
                    <button class="layui-btn layui-btn-danger layui-btn-xs" onclick="deleteCategory(${c.categoryId})">删除</button>
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
            if(field.categoryName) params.append('categoryName', field.categoryName);
            if(field.priceMin) params.append('priceMin', field.priceMin);
            if(field.priceMax) params.append('priceMax', field.priceMax);

            var url = '${pageContext.request.contextPath}/admin/room/category/list';
            if(params.toString()) url += '?' + params.toString();

            window.location.href = url;
            return false;
        });

        // 重置查询
        document.getElementById('resetBtn').addEventListener('click', function(){
            window.location.href = '${pageContext.request.contextPath}/admin/room/category/list';
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
                    if('${searchCategoryName}' !== '') params.append('categoryName', '${searchCategoryName}');
                    if('${searchPriceMin}' !== '') params.append('priceMin', '${searchPriceMin}');
                    if('${searchPriceMax}' !== '') params.append('priceMax', '${searchPriceMax}');
                    params.append('page', obj.curr);
                    params.append('limit', obj.limit);

                    var url = '${pageContext.request.contextPath}/admin/room/category/list';
                    if(params.toString()) url += '?' + params.toString();
                    window.location.href = url;
                }
            }
        });

        window.deleteCategory = function(id){
            layer.confirm('确定删除该分类吗？', function(index){
                fetch('${pageContext.request.contextPath}/admin/room/category/delete', {
                    method: 'POST',
                    headers: {'Content-Type':'application/x-www-form-urlencoded'},
                    body: 'categoryId=' + id
                }).then(res=>res.json()).then(data=>{
                    if(data.success) location.reload();
                    else layer.msg('删除失败',{icon:2});
                }).catch(()=>layer.msg('网络错误',{icon:2}));
                layer.close(index);
            });
        };
    });
</script>
</body>
</html>


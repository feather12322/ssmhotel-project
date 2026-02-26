<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>房间信息管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <style>
        .actions{margin-bottom:16px;}
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
        <a class="layui-btn layui-btn-normal" href="${pageContext.request.contextPath}/admin/room/add">新增房间</a>
    </div>

    <!-- 查询条件 -->
    <form class="layui-form layui-card" lay-filter="searchForm" style="margin-bottom:20px; padding:15px;">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">房间号</label>
                <div class="layui-input-inline">
                    <input type="text" name="roomNo" placeholder="请输入房间号" autocomplete="off" class="layui-input" value="${searchRoomNo}">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">房间分类</label>
                <div class="layui-input-inline">
                    <select name="categoryId">
                        <option value="">全部分类</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" <c:if test="${searchCategoryId == c.categoryId}">selected</c:if>>${c.categoryName}</option>
                        </c:forEach>
                    </select>
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
                <label class="layui-form-label">房间状态</label>
                <div class="layui-input-inline">
                    <select name="roomStatus">
                        <option value="">全部状态</option>
                        <option value="0" <c:if test="${searchRoomStatus == 0}">selected</c:if>>维修中</option>
                        <option value="1" <c:if test="${searchRoomStatus == 1}">selected</c:if>>可预订</option>
                        <option value="2" <c:if test="${searchRoomStatus == 2}">selected</c:if>>已预订</option>
                        <option value="3" <c:if test="${searchRoomStatus == 3}">selected</c:if>>已入住</option>
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
            <col width="80">
            <col>
            <col width="120">
            <col width="120">
        </colgroup>
        <thead>
        <tr>
            <th>ID</th>
            <th>封面</th>
            <th>房间信息</th>
            <th>价格</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="r" items="${rooms}">
            <tr>
                <td>${r.roomId}</td>
                <td>
                    <c:if test="${not empty r.coverImg}">
                        <img src="${r.coverImg}" style="max-width:100px; max-height:60px; border-radius:6px;">
                    </c:if>
                </td>
                <td>
                    <div style="font-weight:600">${r.roomNo} - ${r.bedType}</div>
                    <div style="color:#888">分类:
                        <c:forEach var="c" items="${categories}">
                            <c:if test="${c.categoryId == r.categoryId}">${c.categoryName}</c:if>
                        </c:forEach>
                    </div>
                    <c:if test="${not empty r.detailImgs}">
                        <div style="margin-top:8px; display:flex; gap:6px; flex-wrap:wrap;">
                            <c:forEach var="img" items="${fn:split(r.detailImgs, ',')}">
                                <img src="${img}" style="max-width:80px; max-height:48px; border-radius:4px;">
                            </c:forEach>
                        </div>
                    </c:if>
                </td>
                <td>¥${r.price}</td>
                <td>
                    <c:choose>
                        <c:when test="${r.roomStatus == 0}">维修中</c:when>
                        <c:when test="${r.roomStatus == 1}">可预订</c:when>
                        <c:when test="${r.roomStatus == 2}">已预订</c:when>
                        <c:when test="${r.roomStatus == 3}">已入住</c:when>
                        <c:otherwise>未知</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <a class="layui-btn layui-btn-xs" href="${pageContext.request.contextPath}/admin/room/edit/${r.roomId}">编辑</a>
                    <button class="layui-btn layui-btn-danger layui-btn-xs" onclick="deleteRoom(${r.roomId})">删除</button>
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

        // 初始化表单
        form.render('select');

        // 查询功能
        form.on('submit(searchBtn)', function(data){
            var field = data.field;
            var params = new URLSearchParams();
            if(field.roomNo) params.append('roomNo', field.roomNo);
            if(field.categoryId) params.append('categoryId', field.categoryId);
            if(field.priceMin) params.append('priceMin', field.priceMin);
            if(field.priceMax) params.append('priceMax', field.priceMax);
            if(field.roomStatus) params.append('roomStatus', field.roomStatus);

            var url = '${pageContext.request.contextPath}/admin/room/list';
            if(params.toString()) url += '?' + params.toString();

            window.location.href = url;
            return false;
        });

        // 重置查询
        document.getElementById('resetBtn').addEventListener('click', function(){
            window.location.href = '${pageContext.request.contextPath}/admin/room/list';
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
                    if('${searchRoomNo}' !== '') params.append('roomNo', '${searchRoomNo}');
                    if('${searchCategoryId}' !== '') params.append('categoryId', '${searchCategoryId}');
                    if('${searchPriceMin}' !== '') params.append('priceMin', '${searchPriceMin}');
                    if('${searchPriceMax}' !== '') params.append('priceMax', '${searchPriceMax}');
                    if('${searchRoomStatus}' !== '') params.append('roomStatus', '${searchRoomStatus}');
                    params.append('page', obj.curr);
                    params.append('limit', obj.limit);

                    var url = '${pageContext.request.contextPath}/admin/room/list';
                    if(params.toString()) url += '?' + params.toString();
                    window.location.href = url;
                }
            }
        });

        window.deleteRoom = function(id){
            layer.confirm('确定删除该房间吗？', function(index){
                fetch('${pageContext.request.contextPath}/admin/room/delete', {
                    method:'POST',
                    headers:{'Content-Type':'application/x-www-form-urlencoded'},
                    body:'roomId='+id
                }).then(r=>r.json()).then(res=>{
                    if(res.success) location.reload();
                    else layer.msg('删除失败',{icon:2});
                }).catch(()=>layer.msg('网络错误',{icon:2}));
                layer.close(index);
            });
        };
    });
</script>
</body>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>分类表单</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <style>
        .container { padding: 20px; }
        .image-upload {
            border: 2px dashed #d2d2d2;
            border-radius: 8px;
            width: 200px;
            height: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            background: #fafafa;
            position: relative;
            overflow: hidden;
        }
        .image-upload:hover { border-color: #009688; }
        .image-upload img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .image-upload .placeholder {
            color: #999;
            text-align: center;
        }
        .image-upload .placeholder i { font-size: 32px; display: block; margin-bottom: 8px; }
        .image-upload .delete-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background: rgba(0,0,0,0.5);
            color: white;
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            cursor: pointer;
            display: none;
        }
        .image-upload:hover .delete-btn { display: block; }
    </style>
</head>
<body>
<div class="container">
    <form class="layui-form" lay-filter="categoryForm">
        <input type="hidden" name="categoryId" value="${category.categoryId}" />
        <div class="layui-form-item">
            <label class="layui-form-label">名称</label>
            <div class="layui-input-block">
                <input type="text" name="categoryName" required lay-verify="required" placeholder="分类名称" autocomplete="off" class="layui-input" value="${category.categoryName}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">描述</label>
            <div class="layui-input-block">
                <textarea name="description" class="layui-textarea">${category.description}</textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">最低价</label>
            <div class="layui-input-block">
                <input type="number" name="priceMin" class="layui-input" value="${category.priceMin}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">最高价</label>
            <div class="layui-input-block">
                <input type="number" name="priceMax" class="layui-input" value="${category.priceMax}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">封面图片</label>
            <div class="layui-input-block">
                <input type="hidden" name="coverImg" id="coverImgInput" value="${category.coverImg}" />
                <div class="image-upload" id="coverImgUpload">
                    <c:if test="${not empty category.coverImg}">
                        <img src="${category.coverImg}" alt="封面图片" />
                        <button type="button" class="delete-btn" onclick="deleteImage('${category.coverImg}')">×</button>
                    </c:if>
                    <c:if test="${empty category.coverImg}">
                        <div class="placeholder">
                            <i class="layui-icon layui-icon-picture"></i>
                            点击上传
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="saveCategory">保存</button>
                <a class="layui-btn layui-btn-primary" href="${pageContext.request.contextPath}/admin/room/category/list">返回</a>
            </div>
        </div>
    </form>
</div>
<script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
<script>
    layui.use(['form','layer','upload'], function(){
        var form = layui.form, layer = layui.layer, upload = layui.upload;

        // 封面图片上传
        upload.render({
            elem: '#coverImgUpload',
            url: '${pageContext.request.contextPath}/admin/room/category/uploadImage',
            accept: 'images',
            size: 51200, // 50MB
            before: function(){
                layer.load(1);
            },
            done: function(res){
                layer.closeAll('loading');
                if(res.success){
                    document.getElementById('coverImgInput').value = res.url;
                    document.getElementById('coverImgUpload').innerHTML =
                        '<img src="' + res.url + '" alt="封面图片" />' +
                        '<button type="button" class="delete-btn" onclick="deleteImage(\'' + res.url + '\')">×</button>';
                    layer.msg('上传成功', {icon: 1});
                } else {
                    layer.msg('上传失败', {icon: 2});
                }
            },
            error: function(){
                layer.closeAll('loading');
                layer.msg('上传失败', {icon: 2});
            }
        });

        form.on('submit(saveCategory)', function(data){
            var vals = data.field;
            var url = vals.categoryId ? '${pageContext.request.contextPath}/admin/room/category/update' : '${pageContext.request.contextPath}/admin/room/category/save';
            fetch(url, {
                method:'POST',
                headers:{'Content-Type':'application/x-www-form-urlencoded'},
                body: Object.keys(vals).map(k=>encodeURIComponent(k)+'='+encodeURIComponent(vals[k]||'')).join('&')
            }).then(r=>r.json()).then(res=>{
                if(res.success){ layer.msg('保存成功',{icon:1}); setTimeout(()=>location.href='${pageContext.request.contextPath}/admin/room/category/list',800); }
                else layer.msg('保存失败',{icon:2});
            }).catch(()=>layer.msg('网络异常',{icon:2}));
            return false;
        });
    });

    // 删除图片
    function deleteImage(imageUrl) {
        layer.confirm('确定删除这张图片吗？', function(index){
            fetch('${pageContext.request.contextPath}/admin/room/category/deleteImage', {
                method: 'POST',
                headers: {'Content-Type':'application/x-www-form-urlencoded'},
                body: 'imageUrl=' + encodeURIComponent(imageUrl)
            }).then(r=>r.json()).then(res=>{
                if(res.success){
                    document.getElementById('coverImgInput').value = '';
                    document.getElementById('coverImgUpload').innerHTML =
                        '<div class="placeholder">' +
                        '<i class="layui-icon layui-icon-picture"></i>' +
                        '点击上传' +
                        '</div>';
                    layer.msg('删除成功', {icon: 1});
                } else {
                    layer.msg('删除失败', {icon: 2});
                }
                layer.close(index);
            }).catch(()=>{
                layer.msg('网络异常', {icon: 2});
                layer.close(index);
            });
        });
    }
</script>
</body>
</html>


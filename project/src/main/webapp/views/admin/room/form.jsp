<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>房间表单</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <style>
        .container{padding:20px;}
        .upload-area{
            width:140px;
            height:100px;
            border:2px dashed #d9eedd;
            border-radius:8px;
            display:flex;
            align-items:center;
            justify-content:center;
            cursor:pointer;
            background: #f7fff9;
        }
        .upload-area .plus{
            font-size:28px;
            color:#009688;
        }
        .thumb-wrap{display:flex;gap:8px;flex-wrap:wrap;margin-top:8px;}
        .thumb-wrap .thumb{width:120px;height:80px;overflow:hidden;border-radius:6px;border:1px solid #eee;display:flex;align-items:center;justify-content:center;background:#fff;position:relative;}
        .thumb img{max-width:100%;max-height:100%;}
        .thumb .thumb-remove{position:absolute; top:4px; right:4px; background:rgba(0,0,0,0.6); color:#fff; border:none; border-radius:50%; width:20px; height:20px; line-height:18px; text-align:center; cursor:pointer;}
    </style>
</head>
<body>
<div class="container">
    <form class="layui-form" lay-filter="roomForm">
        <input type="hidden" name="roomId" value="${room.roomId}" />
        <div class="layui-form-item">
            <label class="layui-form-label">房间号</label>
            <div class="layui-input-block">
                <input type="text" name="roomNo" required lay-verify="required" placeholder="房间号" autocomplete="off" class="layui-input" value="${room.roomNo}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">房间分类</label>
            <div class="layui-input-block">
                <select name="categoryId">
                    <option value="">请选择分类</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.categoryId}" <c:if test="${room.categoryId == c.categoryId}">selected</c:if>>${c.categoryName}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">面积(m²)</label>
            <div class="layui-input-block">
                <input type="number" name="area" class="layui-input" value="${room.area}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">床型</label>
            <div class="layui-input-block">
                <input type="text" name="bedType" class="layui-input" value="${room.bedType}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">价格</label>
            <div class="layui-input-block">
                <input type="number" name="price" class="layui-input" value="${room.price}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">封面图片</label>
            <div class="layui-input-block">
                <div id="coverUploadArea" class="upload-area" title="点击上传封面">
                    <div class="plus">＋</div>
                </div>
                <input type="hidden" name="coverImg" id="coverImg" value="${room.coverImg}">
                <div id="coverPreview" style="margin-top:10px;">
                    <c:if test="${not empty room.coverImg}">
                        <div style="position:relative; display:inline-block;">
                            <img id="coverThumb" src="${room.coverImg}" style="max-width:200px; max-height:120px; border-radius:6px;">
                            <button type="button" id="coverRemoveBtn" style="position:absolute; top:6px; right:6px; background:rgba(0,0,0,0.5); color:#fff; border:none; border-radius:50%; width:24px; height:24px; cursor:pointer;">×</button>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">详情图片</label>
            <div class="layui-input-block">
                <div id="detailsUploadArea" class="upload-area" title="点击上传多张详情图片">
                    <div class="plus">＋</div>
                </div>
                <input type="hidden" name="detailImgs" id="detailImgs" value="${room.detailImgs}">
                <div id="detailPreview" style="margin-top:10px;">
                    <div class="thumb-wrap" id="detailThumbs">
                        <c:if test="${not empty room.detailImgs}">
                            <c:forEach var="img" items="${fn:split(room.detailImgs, ',')}">
                                <div class="thumb" data-url="${img}">
                                    <img src="${img}"/>
                                    <button type="button" class="thumb-remove" style="position:absolute; top:6px; right:6px; background:rgba(0,0,0,0.5); color:#fff; border:none; border-radius:50%; width:20px; height:20px; cursor:pointer;">×</button>
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">房间状态</label>
            <div class="layui-input-block">
                <select name="roomStatus">
                    <option value="0" <c:if test="${room.roomStatus == 0}">selected</c:if>>维修中</option>
                    <option value="1" <c:if test="${room.roomStatus == 1}">selected</c:if>>可预订</option>
                    <option value="2" <c:if test="${room.roomStatus == 2}">selected</c:if>>已预订</option>
                    <option value="3" <c:if test="${room.roomStatus == 3}">selected</c:if>>已入住</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">设施</label>
            <div class="layui-input-block">
                <input type="text" name="facilities" class="layui-input" value="${room.facilities}">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="saveRoom">保存</button>
                <a class="layui-btn layui-btn-primary" href="${pageContext.request.contextPath}/admin/room/list">返回</a>
            </div>
        </div>
    </form>
</div>
<script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
<script>
    layui.use(['form','layer'], function(){
        var form = layui.form, layer = layui.layer;
        form.render('select');
        form.on('submit(saveRoom)', function(data){
            var vals = data.field;
            var url = vals.roomId ? '${pageContext.request.contextPath}/admin/room/update' : '${pageContext.request.contextPath}/admin/room/save';
            fetch(url, {
                method:'POST',
                headers:{'Content-Type':'application/x-www-form-urlencoded'},
                body: Object.keys(vals).map(k=>encodeURIComponent(k)+'='+encodeURIComponent(vals[k]||'')).join('&')
            }).then(r=>r.json()).then(res=>{
                if(res.success){ layer.msg('保存成功',{icon:1}); setTimeout(()=>location.href='${pageContext.request.contextPath}/admin/room/list',800); }
                else layer.msg('保存失败',{icon:2});
            }).catch(()=>layer.msg('网络异常',{icon:2}));
            return false;
        });
    });
</script>
<script>
    layui.use(['upload','layer'], function(){
        var upload = layui.upload;
        var layer = layui.layer;

        // cover upload (single)
        upload.render({
            elem: '#coverUploadArea',
            url: '${pageContext.request.contextPath}/admin/room/uploadImage',
            accept: 'images',
            size: 51200, // 50MB limit
            done: function(res){
                if(res && res.success){
                    document.getElementById('coverImg').value = res.url;
                    document.getElementById('coverPreview').innerHTML = '<div style=\"position:relative; display:inline-block;\"><img id=\"coverThumb\" src=\"'+res.url+'\" style=\"max-width:200px; max-height:120px; border-radius:6px;\"><button type=\"button\" id=\"coverRemoveBtn\" style=\"position:absolute; top:6px; right:6px; background:rgba(0,0,0,0.5); color:#fff; border:none; border-radius:50%; width:24px; height:24px; cursor:pointer;\">×</button></div>';
                    bindCoverRemove();
                } else {
                    layer.msg('封面上传失败',{icon:2});
                }
            },
            error: function(){
                layer.msg('封面上传异常',{icon:2});
            }
        });

        // details upload (multiple)
        upload.render({
            elem: '#detailsUploadArea',
            url: '${pageContext.request.contextPath}/admin/room/uploadImage',
            accept: 'images',
            multiple: true,
            size: 51200, // 50MB per file
            done: function(res){
                if(res && res.success){
                    var thumbs = document.getElementById('detailThumbs');
                    var d = document.createElement('div');
                    d.className = 'thumb';
                    d.setAttribute('data-url', res.url);
                    d.innerHTML = '<img src=\"'+res.url+'\"/><button type=\"button\" class=\"thumb-remove\" style=\"position:absolute; top:6px; right:6px; background:rgba(0,0,0,0.5); color:#fff; border:none; border-radius:50%; width:20px; height:20px; cursor:pointer;\">×</button>';
                    thumbs.appendChild(d);
                    bindThumbRemove(d);
                    var existing = document.getElementById('detailImgs').value;
                    var arr = existing ? existing.split(',') : [];
                    arr.push(res.url);
                    document.getElementById('detailImgs').value = arr.join(',');
                } else {
                    layer.msg('图片上传失败',{icon:2});
                }
            },
            error: function(){
                layer.msg('图片上传异常',{icon:2});
            }
        });
    });
</script>
<script>
    // bind remove handlers
    function bindCoverRemove(){
        var btn = document.getElementById('coverRemoveBtn');
        if(!btn) return;
        btn.onclick = function(){
            var url = document.getElementById('coverImg').value;
            if(url){
                fetch('${pageContext.request.contextPath}/admin/room/deleteImage', {
                    method:'POST',
                    headers:{'Content-Type':'application/x-www-form-urlencoded'},
                    body: 'url=' + encodeURIComponent(url)
                }).then(r=>r.json()).then(res=>{
                    // ignore result, remove UI
                    document.getElementById('coverImg').value = '';
                    document.getElementById('coverPreview').innerHTML = '';
                }).catch(()=>{
                    document.getElementById('coverImg').value = '';
                    document.getElementById('coverPreview').innerHTML = '';
                });
            } else {
                document.getElementById('coverPreview').innerHTML = '';
            }
        };
    }

    function bindThumbRemove(el){
        var btn = el.querySelector('.thumb-remove');
        if(!btn) return;
        btn.onclick = function(){
            var url = el.getAttribute('data-url');
            var existing = document.getElementById('detailImgs').value;
            var arr = existing ? existing.split(',') : [];
            var idx = arr.indexOf(url);
            if(idx>-1) arr.splice(idx,1);
            document.getElementById('detailImgs').value = arr.join(',');
            // remove element from DOM
            el.parentNode.removeChild(el);
            // delete file from server
            fetch('${pageContext.request.contextPath}/admin/room/deleteImage', {
                method:'POST',
                headers:{'Content-Type':'application/x-www-form-urlencoded'},
                body: 'url=' + encodeURIComponent(url)
            }).then(()=>{}).catch(()=>{});
        };
    }

    // bind existing thumbs' remove buttons on load
    document.addEventListener('DOMContentLoaded', function(){
        var thumbs = document.querySelectorAll('#detailThumbs .thumb');
        thumbs.forEach(function(t){ bindThumbRemove(t); });
        bindCoverRemove();
    });
</script>
</body>
</html>


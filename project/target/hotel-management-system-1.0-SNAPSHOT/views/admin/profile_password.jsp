<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改密码</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <style>
        .container { padding: 20px; max-width: 500px; margin: 0 auto; }
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
        <h3><i class="fas fa-key" style="margin-right: 10px;"></i>修改密码</h3>

        <form class="layui-form" lay-filter="passwordForm">
            <div class="layui-form-item">
                <label class="layui-form-label">当前密码</label>
                <div class="layui-input-block">
                    <input type="password" name="oldPassword" required lay-verify="required" placeholder="请输入当前密码" autocomplete="off" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">新密码</label>
                <div class="layui-input-block">
                    <input type="password" name="newPassword" required lay-verify="required|password" placeholder="请输入新密码" autocomplete="off" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">确认密码</label>
                <div class="layui-input-block">
                    <input type="password" name="confirmPassword" required lay-verify="required|confirmPassword" placeholder="请再次输入新密码" autocomplete="off" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-warm" lay-submit lay-filter="changePassword">修改密码</button>
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

        // 自定义验证规则
        form.verify({
            password: function(value){
                if(value.length < 6){
                    return '密码长度不能少于6位';
                }
            },
            confirmPassword: function(value){
                var newPassword = document.querySelector('[name=newPassword]').value;
                if(value !== newPassword){
                    return '两次输入的密码不一致';
                }
            }
        });

        // 表单提交
        form.on('submit(changePassword)', function(data){
            var field = data.field;

            fetch('${pageContext.request.contextPath}/admin/profile/updatePassword', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'oldPassword=' + encodeURIComponent(field.oldPassword) +
                      '&newPassword=' + encodeURIComponent(field.newPassword)
            }).then(r => r.json()).then(res => {
                if(res.success){
                    layer.msg('密码修改成功，请重新登录', {icon: 1});
                    setTimeout(() => {
                        parent.location.href = '${pageContext.request.contextPath}/admin/logout';
                    }, 2000);
                } else {
                    layer.msg('密码修改失败：' + (res.message || ''), {icon: 2});
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
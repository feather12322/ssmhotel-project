<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>酒店管理系统 - 管理员登录</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', 'Helvetica Neue', Helvetica, Arial, sans-serif;
            background: url('${pageContext.request.contextPath}/images/login-bg.jpg') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        /* 背景遮罩层 */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 150, 136, 0.1);
            backdrop-filter: blur(1px);
        }

        /* 登录容器 */
        .login-wrapper {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 600px;
            margin: 20px;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.3);
            position: relative;
            z-index: 10;
        }

        /* 头部 */
        .login-header {
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            color: #fff;
            padding: 40px 30px 35px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .login-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="2" fill="rgba(255,255,255,0.1)"/></svg>');
            animation: sparkle 15s infinite linear;
        }

        @keyframes sparkle {
            0% { transform: translate(0, 0); }
            100% { transform: translate(-20px, -20px); }
        }

        .login-header .logo {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(10px);
            border: 2px solid rgba(255, 255, 255, 0.3);
        }

        .login-header .logo i {
            font-size: 36px;
            color: #fff;
        }

        .login-header h2 {
            margin: 0;
            font-size: 28px;
            font-weight: 300;
            letter-spacing: 1px;
        }

        .login-header p {
            margin: 8px 0 0 0;
            opacity: 0.9;
            font-size: 16px;
        }

        /* 主体 */
        .login-body {
            padding: 50px 40px 40px;
        }

        .layui-form-item {
            margin-bottom: 30px;
            position: relative;
        }

        .layui-form-item .layui-input-block {
            margin-left: 0;
        }

        .layui-form-label {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            color: #009688;
            font-size: 18px;
            transition: all 0.3s ease;
            pointer-events: none;
        }

        .layui-input {
            height: 55px;
            font-size: 16px;
            border-radius: 12px;
            border: 2px solid #e8f4f8;
            padding: 0 20px 0 50px;
            background: #f8fffe;
            transition: all 0.3s ease;
            font-weight: 400;
        }

        .layui-input:focus {
            border-color: #009688;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(0, 150, 136, 0.1);
            transform: translateY(-2px);
        }

        .layui-input:focus + .layui-form-label,
        .layui-input:not(:placeholder-shown) + .layui-form-label {
            top: -10px;
            left: 10px;
            font-size: 12px;
            background: #fff;
            padding: 0 8px;
            color: #009688;
        }

        /* 记住密码 */
        .remember-me {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }

        .remember-me input[type="checkbox"] {
            width: 18px;
            height: 18px;
            margin-right: 10px;
            accent-color: #009688;
        }

        .remember-me label {
            font-size: 14px;
            color: #666;
            cursor: pointer;
        }

        /* 登录按钮 */
        .layui-btn {
            width: 100%;
            height: 55px;
            font-size: 18px;
            font-weight: 500;
            border-radius: 12px;
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            border: none;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 150, 136, 0.3);
        }

        .layui-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 150, 136, 0.4);
        }

        .layui-btn:active {
            transform: translateY(0);
        }

        .layui-btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .layui-btn:active::before {
            width: 300px;
            height: 300px;
        }

        /* 底部链接 */
        .login-footer {
            text-align: center;
            padding: 25px 40px;
            background: #f8fffe;
            border-top: 1px solid #e8f4f8;
        }

        .login-footer p {
            color: #999;
            font-size: 14px;
            margin: 0;
        }

        .login-footer a {
            color: #009688;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .login-footer a:hover {
            color: #5FB878;
            text-decoration: underline;
        }

        /* 切换登录按钮样式 */
        .switch-login-btn {
            display: inline-block;
            padding: 10px 20px;
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white !important;
            text-decoration: none !important;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(76, 175, 80, 0.3);
        }

        .switch-login-btn:hover {
            background: linear-gradient(135deg, #45a049 0%, #4CAF50 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.4);
            color: white !important;
            text-decoration: none !important;
        }

        .switch-login-btn i {
            margin-right: 8px;
        }

        /* 响应式 */
        @media (max-width: 480px) {
            .login-wrapper {
                margin: 10px;
            }

            .login-header {
                padding: 30px 20px 25px;
            }

            .login-header h2 {
                font-size: 24px;
            }

            .login-body {
                padding: 40px 30px 30px;
            }

            .layui-input {
                height: 50px;
                font-size: 16px;
            }

            .layui-btn {
                height: 50px;
                font-size: 16px;
            }
        }

        /* 加载动画 */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(8px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 10000;
        }

        .loading-content {
            text-align: center;
            color: #009688;
            padding: 30px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 3px solid #e8f4f8;
            border-top: 3px solid #009688;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 15px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* 入场动画 */
        .login-container {
            animation: slideInUp 0.8s ease-out;
            transform: translateY(0);
        }

        @keyframes slideInUp {
            0% {
                opacity: 0;
                transform: translateY(50px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 输入框焦点状态 */
        .layui-form-item.focused .layui-input {
            border-color: #009688;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(0, 150, 136, 0.1);
        }

        /* 按钮悬停效果增强 */
        .layui-btn:not(:disabled):hover {
            background: linear-gradient(135deg, #5FB878 0%, #009688 100%);
        }

        /* 错误提示样式 */
        .error-message {
            color: #ff5722;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        /* 成功提示样式 */
        .success-message {
            color: #009688;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
    </style>
</head>
<body>
    <!-- 加载动画 -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-content">
            <div class="loading-spinner"></div>
            <p>登录中...</p>
        </div>
    </div>
    <div class="login-wrapper">
        <div class="login-container">
            <div class="login-header">
                <div class="logo">
                    <i class="fas fa-hotel"></i>
                </div>
                <h2>酒店管理系统</h2>
                <p>Administrator Login Portal</p>
            </div>
            <div class="login-body">
                <form class="layui-form" action="" lay-filter="loginForm">
                    <div class="layui-form-item">
                        <input type="text" name="userName" lay-verify="required" placeholder=" " class="layui-input" autocomplete="off">
                        <label class="layui-form-label"><i class="fas fa-user"></i></label>
                    </div>
                    <div class="layui-form-item">
                        <input type="password" name="password" lay-verify="required" placeholder=" " class="layui-input" autocomplete="off">
                        <label class="layui-form-label"><i class="fas fa-lock"></i></label>
                    </div>
                    <div class="remember-me">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">记住我</label>
                    </div>
                    <div class="layui-form-item">
                        <button class="layui-btn" lay-submit lay-filter="loginSubmit">
                            <i class="fas fa-sign-in-alt"></i> 登录系统
                        </button>
                    </div>
                </form>
            </div>
                <div class="login-footer">
                    <div style="margin-bottom: 15px;">
                        <a href="${pageContext.request.contextPath}/user/login" class="switch-login-btn">
                            <i class="fas fa-user"></i> 用户登录
                        </a>
                    </div>
                    <p>
                        <!-- <a href="#" onclick="showForgotPassword()">忘记密码？</a> | -->
                        <!-- <a href="#" onclick="showDemoAccount()">演示账号</a>  -->
                    </p>
                    <p style="margin-top: 10px; font-size: 12px; color: #bbb;">
                        © 2026 酒店管理系统. All Rights Reserved.
                    </p>
                </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <script>
        layui.use(['form', 'layer'], function(){
            var form = layui.form;
            var layer = layui.layer;
            var $ = layui.$;

            // 表单提交
            form.on('submit(loginSubmit)', function(data){
                var field = data.field;

                // 显示自定义加载动画
                $('#loadingOverlay').fadeIn(200);

                console.log('发送登录请求:', field); // 调试信息

                // 发送登录请求
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/doLogin',
                    type: 'POST',
                    data: {
                        userName: field.userName,
                        password: field.password
                    },
                    dataType: 'json',
                    timeout: 10000, // 10秒超时
                    success: function(res){
                        console.log('登录响应:', res); // 调试信息
                        $('#loadingOverlay').fadeOut(200);

                        if(res.success){
                            layer.msg(res.message, {
                                icon: 1,
                                time: 1500,
                                shade: 0.1
                            }, function(){
                                // 使用后端返回的跳转URL
                                var redirectUrl = res.redirectUrl || '${pageContext.request.contextPath}/admin/index';
                                console.log('跳转到:', redirectUrl); // 调试信息
                                window.location.href = redirectUrl;
                            });
                        } else {
                            // 登录失败的提示
                            layer.msg(res.message || '登录失败，请检查用户名和密码', {
                                icon: 2,
                                time: 3000,
                                anim: 6
                            });

                            // 清空密码框
                            $('input[name="password"]').val('').focus();
                        }
                    },
                    error: function(xhr, status, error){
                        console.error('登录请求失败:', xhr, status, error); // 调试信息
                        $('#loadingOverlay').fadeOut(200);

                        var errorMsg = '网络异常，请稍后重试';
                        if(status === 'timeout'){
                            errorMsg = '请求超时，请检查网络连接';
                        } else if(xhr.status === 404){
                            errorMsg = '登录接口不存在，请检查服务是否启动';
                        } else if(xhr.status === 500){
                            errorMsg = '服务器内部错误，请联系管理员';
                        }

                        layer.msg(errorMsg, {
                            icon: 2,
                            time: 3000,
                            anim: 6
                        });
                    }
                });

                return false;
            });

            // 回车键提交
            $(document).keydown(function(event){
                if(event.keyCode == 13){
                    $('button[lay-submit]').click();
                }
            });

            // 输入框焦点效果
            $('input').on('focus', function(){
                $(this).parent().addClass('focused');
            }).on('blur', function(){
                $(this).parent().removeClass('focused');
            });

            // 记住密码功能
            var rememberUsername = localStorage.getItem('rememberUsername');
            if(rememberUsername){
                $('input[name="userName"]').val(rememberUsername);
                $('#remember').prop('checked', true);
            }

            form.on('checkbox(remember)', function(data){
                if(data.elem.checked){
                    localStorage.setItem('rememberUsername', $('input[name="userName"]').val());
                } else {
                    localStorage.removeItem('rememberUsername');
                }
            });
            // 页面加载完成后的初始化
            $(document).ready(function(){
                // 自动聚焦到用户名输入框
                $('input[name="userName"]').focus();

                // 添加一些动画效果
                setTimeout(function(){
                    $('.login-container').addClass('animate-in');
                }, 100);
            });
        });

        // 显示忘记密码提示
        function showForgotPassword(){
            if(typeof layui !== 'undefined' && layui.layer){
                layui.layer.msg('请联系系统管理员重置密码', {icon: 0, time: 3000});
            } else {
                alert('请联系系统管理员重置密码');
            }
        }

        // 显示演示账号
        function showDemoAccount(){
            var message = '演示账号：\n用户名：admin\n密码：123456';

            if(typeof layui !== 'undefined' && layui.layer){
                layui.layer.alert(
                    '<div style="text-align: left; line-height: 2;">' +
                    '<strong>演示账号：</strong><br>' +
                    '用户名：admin<br>' +
                    '密码：123456<br><br>' +
                    '</div>', {
                    title: '演示账号信息',
                    skin: 'layui-layer-molv',
                    closeBtn: 1,
                    anim: 4,
                    area: ['300px', 'auto']
                });
            } else {
                alert(message);
            }
        }
    </script>
</body>
</html>
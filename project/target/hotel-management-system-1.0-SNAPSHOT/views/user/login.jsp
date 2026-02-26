<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>酒店预订系统 - 用户登录</title>
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
            max-width: 450px;
            margin: 20px;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            transform: translateY(0);
            transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }

        .login-container.animate-in {
            animation: slideIn 0.8s ease-out;
        }

        @keyframes slideIn {
            0% {
                opacity: 0;
                transform: translateY(50px) scale(0.9);
            }
            100% {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* 头部 */
        .login-header {
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            padding: 40px 30px 30px;
            text-align: center;
            color: white;
        }

        .login-header .logo {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.9;
        }

        .login-header h1 {
            font-size: 24px;
            margin-bottom: 8px;
            font-weight: 300;
        }

        .login-header p {
            font-size: 14px;
            opacity: 0.9;
            margin: 0;
        }

        /* 表单区域 */
        .login-form {
            padding: 40px 30px 30px;
        }

        .layui-form-item {
            margin-bottom: 25px;
        }

        .layui-input {
            height: 50px;
            border-radius: 25px;
            border: 2px solid #e8f4f8;
            padding: 0 25px;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .layui-input:focus {
            border-color: #009688;
            box-shadow: 0 0 0 3px rgba(0, 150, 136, 0.1);
        }

        .layui-form-item .layui-icon {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #009688;
            font-size: 18px;
        }

        /* 按钮 */
        .login-btn {
            width: 100%;
            height: 50px;
            border-radius: 25px;
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            border: none;
            color: white;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 150, 136, 0.3);
        }

        .login-btn:active {
            transform: translateY(0);
        }

        /* 链接区域 */
        .login-links {
            text-align: center;
            margin-top: 20px;
        }

        .login-links a {
            color: #009688;
            text-decoration: none;
            font-size: 14px;
            margin: 0 15px;
            transition: color 0.3s ease;
        }

        .login-links a:hover {
            color: #5FB878;
            text-decoration: underline;
        }

        /* 响应式设计 */
        @media (max-width: 480px) {
            .login-wrapper {
                margin: 10px;
                max-width: none;
            }

            .login-header {
                padding: 30px 20px 20px;
            }

            .login-form {
                padding: 30px 20px 20px;
            }
        }

        /* 动画效果 */
        .form-group {
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.6s ease-out forwards;
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 切换登录按钮样式 */
        .switch-login-btn {
            display: inline-block;
            padding: 10px 20px;
            background: linear-gradient(135deg, #FF9800 0%, #F57C00 100%);
            color: white !important;
            text-decoration: none !important;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(255, 152, 0, 0.3);
        }

        .switch-login-btn:hover {
            background: linear-gradient(135deg, #F57C00 0%, #FF9800 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.4);
            color: white !important;
            text-decoration: none !important;
        }

        .switch-login-btn i {
            margin-right: 8px;
        }
    </style>
</head>
<body>
    <div class="login-wrapper">
        <div class="login-container">
            <!-- 头部 -->
            <div class="login-header">
                <div class="logo">
                    <i class="fas fa-hotel"></i>
                </div>
                <h1>欢迎使用酒店预订系统</h1>
                <p>请登录您的账号开始预订之旅</p>
            </div>

            <!-- 表单 -->
            <div class="login-form">
                <form class="layui-form" lay-filter="loginForm">
                    <div class="form-group">
                        <div class="layui-form-item">
                            <div class="layui-input-wrap">
                                <input type="text" name="userName" required lay-verify="required" placeholder="请输入用户名" autocomplete="off" class="layui-input">
                                <i class="fas fa-user layui-icon"></i>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="layui-form-item">
                            <div class="layui-input-wrap">
                                <input type="password" name="password" required lay-verify="required" placeholder="请输入密码" autocomplete="off" class="layui-input">
                                <i class="fas fa-lock layui-icon"></i>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <button class="login-btn" lay-submit lay-filter="loginBtn">
                            <i class="fas fa-sign-in-alt" style="margin-right: 8px;"></i>登录
                        </button>
                    </div>
                </form>

                <!-- 链接 -->
                <div class="login-links">
                    <div style="margin-bottom: 15px;">
                        <a href="${pageContext.request.contextPath}/admin/login" class="switch-login-btn">
                            <i class="fas fa-user-shield"></i> 管理员登录
                        </a>
                    </div>
                    <a href="${pageContext.request.contextPath}/user/register">
                        <i class="fas fa-user-plus" style="margin-right: 5px;"></i>还没有账号？立即注册
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <script>
        layui.use(['form', 'layer'], function(){
            var form = layui.form, layer = layui.layer;

            // 页面加载动画
            setTimeout(function(){
                document.querySelector('.login-container').classList.add('animate-in');
            }, 100);

            // 表单提交
            form.on('submit(loginBtn)', function(data){
                var field = data.field;

                // 显示加载状态
                var btn = document.querySelector('.login-btn');
                var originalText = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin" style="margin-right: 8px;"></i>登录中...';
                btn.disabled = true;

                fetch('${pageContext.request.contextPath}/user/doLogin', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'userName=' + encodeURIComponent(field.userName) + '&password=' + encodeURIComponent(field.password)
                }).then(r => r.json()).then(res => {
                    if(res.success){
                        layer.msg('登录成功，正在跳转...', {icon: 1, time: 1500});
                        setTimeout(() => {
                            window.location.href = res.redirectUrl;
                        }, 1500);
                    } else {
                        layer.msg(res.message || '登录失败', {icon: 2});
                        btn.innerHTML = originalText;
                        btn.disabled = false;
                    }
                }).catch(() => {
                    layer.msg('网络异常，请重试', {icon: 2});
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                });

                return false;
            });
        });
    </script>
</body>
</html>
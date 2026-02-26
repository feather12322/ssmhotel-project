<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>酒店预订系统 - 用户注册</title>
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

        /* 注册容器 */
        .register-wrapper {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 500px;
            margin: 20px;
        }

        .register-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            transform: translateY(0);
            transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }

        .register-container.animate-in {
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
        .register-header {
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            padding: 35px 30px 25px;
            text-align: center;
            color: white;
        }

        .register-header .logo {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.9;
        }

        .register-header h1 {
            font-size: 24px;
            margin-bottom: 8px;
            font-weight: 300;
        }

        .register-header p {
            font-size: 14px;
            opacity: 0.9;
            margin: 0;
        }

        /* 表单区域 */
        .register-form {
            padding: 35px 30px 25px;
        }

        .layui-form-item {
            margin-bottom: 20px;
        }

        .layui-input {
            height: 48px;
            border-radius: 24px;
            border: 2px solid #e8f4f8;
            padding: 0 20px;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .layui-input:focus {
            border-color: #009688;
            box-shadow: 0 0 0 3px rgba(0, 150, 136, 0.1);
        }

        .layui-textarea {
            border-radius: 12px;
            border: 2px solid #e8f4f8;
            transition: all 0.3s ease;
        }

        .layui-textarea:focus {
            border-color: #009688;
            box-shadow: 0 0 0 3px rgba(0, 150, 136, 0.1);
        }

        /* 按钮 */
        .register-btn {
            width: 100%;
            height: 48px;
            border-radius: 24px;
            background: linear-gradient(135deg, #009688 0%, #5FB878 100%);
            border: none;
            color: white;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 15px;
        }

        .register-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 150, 136, 0.3);
        }

        .register-btn:active {
            transform: translateY(0);
        }

        /* 链接区域 */
        .register-links {
            text-align: center;
            margin-top: 15px;
        }

        .register-links a {
            color: #009688;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s ease;
        }

        .register-links a:hover {
            color: #5FB878;
            text-decoration: underline;
        }

        /* 响应式设计 */
        @media (max-width: 480px) {
            .register-wrapper {
                margin: 10px;
                max-width: none;
            }

            .register-header {
                padding: 25px 20px 15px;
            }

            .register-form {
                padding: 25px 20px 15px;
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
        .form-group:nth-child(4) { animation-delay: 0.4s; }
        .form-group:nth-child(5) { animation-delay: 0.5s; }
        .form-group:nth-child(6) { animation-delay: 0.6s; }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="register-wrapper">
        <div class="register-container">
            <!-- 头部 -->
            <div class="register-header">
                <div class="logo">
                    <i class="fas fa-hotel"></i>
                </div>
                <h1>加入酒店预订系统</h1>
                <p>创建您的账号，开启预订之旅</p>
            </div>

            <!-- 表单 -->
            <div class="register-form">
                <form class="layui-form" lay-filter="registerForm">
                    <div class="form-group">
                        <div class="layui-form-item">
                            <input type="text" name="userName" required lay-verify="required|username" placeholder="请输入用户名（3-20位字母数字）" autocomplete="off" class="layui-input">
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="layui-form-item">
                            <input type="text" name="realName" required lay-verify="required" placeholder="请输入真实姓名" autocomplete="off" class="layui-input">
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="layui-form-item">
                            <input type="password" name="password" required lay-verify="required|password" placeholder="请输入密码（至少6位）" autocomplete="off" class="layui-input">
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="layui-form-item">
                            <input type="password" name="confirmPassword" required lay-verify="required|confirmPassword" placeholder="请再次输入密码" autocomplete="off" class="layui-input">
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="layui-form-item">
                            <input type="text" name="phone" placeholder="请输入手机号（选填）" autocomplete="off" class="layui-input">
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="layui-form-item">
                            <input type="email" name="email" placeholder="请输入邮箱地址（选填）" autocomplete="off" class="layui-input">
                        </div>
                    </div>

                    <div class="form-group">
                        <button class="register-btn" lay-submit lay-filter="registerBtn">
                            <i class="fas fa-user-plus" style="margin-right: 8px;"></i>立即注册
                        </button>
                    </div>
                </form>

                <!-- 链接 -->
                <div class="register-links">
                    <a href="${pageContext.request.contextPath}/user/login">
                        <i class="fas fa-sign-in-alt" style="margin-right: 5px;"></i>已有账号？立即登录
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
                document.querySelector('.register-container').classList.add('animate-in');
            }, 100);

            // 自定义验证规则
            form.verify({
                username: function(value){
                    if(value.length < 3 || value.length > 20){
                        return '用户名长度必须在3-20位之间';
                    }
                    if(!/^[a-zA-Z0-9]+$/.test(value)){
                        return '用户名只能包含字母和数字';
                    }
                },
                password: function(value){
                    if(value.length < 6){
                        return '密码长度不能少于6位';
                    }
                },
                confirmPassword: function(value){
                    var password = document.querySelector('[name=password]').value;
                    if(value !== password){
                        return '两次输入的密码不一致';
                    }
                }
            });

            // 表单提交
            form.on('submit(registerBtn)', function(data){
                var field = data.field;

                // 显示加载状态
                var btn = document.querySelector('.register-btn');
                var originalText = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin" style="margin-right: 8px;"></i>注册中...';
                btn.disabled = true;

                fetch('${pageContext.request.contextPath}/user/doRegister', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: Object.keys(field).map(k => encodeURIComponent(k) + '=' + encodeURIComponent(field[k] || '')).join('&')
                }).then(r => r.json()).then(res => {
                    if(res.success){
                        layer.msg('注册成功！请登录您的账号', {icon: 1, time: 2000});
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/user/login';
                        }, 2000);
                    } else {
                        layer.msg(res.message || '注册失败', {icon: 2});
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
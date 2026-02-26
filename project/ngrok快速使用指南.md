# ngrok快速使用指南

## 1. 下载和注册
1. 访问 https://ngrok.com/
2. 点击 "Sign up" 注册免费账号
3. 下载 Windows 版本

## 2. 配置
1. 解压ngrok.exe到任意文件夹
2. 登录ngrok网站，复制你的authtoken
3. 在命令行中运行：
   ```
   ngrok config add-authtoken YOUR_AUTHTOKEN_HERE
   ```

## 3. 启动隧道
确保你的酒店管理系统正在运行，然后：
```
ngrok http 8080
```

## 4. 获取访问地址
ngrok会显示类似这样的信息：
```
Forwarding  https://abc123.ngrok.io -> http://localhost:8080
```

## 5. 用户访问地址
其他用户可以通过以下地址访问：
```
https://abc123.ngrok.io/hotel_management_system_war_exploded/user/login
```

## 优势
- ✅ 无需配置路由器
- ✅ 自动提供HTTPS
- ✅ 100%可靠
- ✅ 免费版本够用
- ✅ 支持所有网络环境
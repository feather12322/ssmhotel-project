# ngrok内网穿透使用指南

## 1. 注册和下载
1. 访问 https://ngrok.com/
2. 注册免费账号
3. 下载Windows版本

## 2. 安装配置
1. 解压到任意目录
2. 获取authtoken（登录后在dashboard中找到）
3. 运行命令配置token：
   ```
   ngrok authtoken YOUR_AUTHTOKEN
   ```

## 3. 启动隧道
在项目运行的情况下，打开新的命令行窗口：
```
ngrok http 8080
```

## 4. 获取公网地址
ngrok会显示类似这样的信息：
```
Forwarding  https://abc123.ngrok.io -> http://localhost:8080
```

## 5. 用户访问地址
其他用户可以通过以下地址访问：
```
https://abc123.ngrok.io/hotel_management_system_war_exploded/user/login
```

## 注意事项
- 免费版每次重启会生成新的随机域名
- 免费版有连接数和流量限制
- 付费版可以使用固定域名
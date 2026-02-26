# 酒店管理系统

基于SSM框架（Spring + Spring MVC + MyBatis）的酒店管理系统，支持用户端和管理员端功能。

## 项目结构

```
hotel-management-system/
├── pom.xml                          # Maven配置文件
├── sql.sql                          # 数据库SQL脚本
├── start.bat                        # Windows启动脚本
├── init-data.sql                    # 测试数据脚本
├── STARTUP.md                       # 详细启动指南
├── src/
│   └── main/
│       ├── java/com/hotel/          # Java源码
│       │   ├── config/              # 配置类
│       │   ├── controller/          # 控制器
│       │   ├── dao/                 # 数据访问层
│       │   ├── entity/              # 实体类
│       │   └── service/             # 业务逻辑层
│       ├── resources/               # 配置文件
│       │   ├── applicationContext.xml
│       │   ├── db.properties
│       │   ├── mybatis-config.xml
│       │   └── spring-mvc.xml
│       └── webapp/
│           ├── WEB-INF/web.xml       # Web应用配置
│           ├── static/               # 静态资源
│           │   └── layui/            # Layui框架
│           └── views/                # JSP视图
│               └── admin/            # 管理员页面
└── README.md
```

## 技术栈

- **后端框架**: Spring + Spring MVC + MyBatis
- **前端框架**: Layui + FontAwesome 6.4.0
- **数据库**: MySQL
- **服务器**: Tomcat
- **构建工具**: Maven

## 环境要求

- JDK 1.8+
- MySQL 5.7+
- Maven 3.6+
- Tomcat 8.5+

## 快速开始

### 1. 数据库准备

#### 方法一：自动初始化（推荐）
```bash
# 1. 启动MySQL服务
# 2. 执行数据库初始化脚本
mysql -u root -p < db_init.sql
# 3. 导入测试数据
mysql -u root -p 260112ssmhotel < init-data.sql
```

#### 方法二：手动创建
1. 创建数据库：
```sql
CREATE DATABASE 260112ssmhotel CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. 执行建表脚本：
```bash
mysql -u root -p 260112ssmhotel < sql.sql
```

3. 导入测试数据：
```bash
mysql -u root -p 260112ssmhotel < init-data.sql
```

3. 修改数据库连接配置：
编辑 `src/main/resources/db.properties` 文件中的数据库连接信息

### 2. 项目构建

```bash
# 编译项目
mvn clean compile

# 打包项目
mvn clean package
```

### 3. 部署运行

#### 方式一：IDEA中运行（开发推荐）
1. 下载Tomcat 8.5+：https://tomcat.apache.org/download-80.cgi
2. IDEA配置Tomcat Server（详见 `IDEA_RUN_CONFIG.md`）
3. 运行项目，访问：`http://localhost:8080/admin/login`

#### 方式二：外部Tomcat部署
1. 将生成的 `target/hotel-management-system.war` 文件部署到Tomcat的webapps目录
2. 启动Tomcat服务器
3. 访问管理端：`http://localhost:8080/hotel-management-system/admin/login`

#### 方式三：使用启动脚本
```bash
# Windows系统
./start.bat
# 然后手动将war包部署到Tomcat
```

## 功能特性

### 管理员端功能
- ✅ 用户登录认证
- ✅ 后台管理界面（左侧菜单 + 选项卡）
- ⏳ 房间分类管理
- ⏳ 房间信息管理
- ⏳ 订单管理
- ⏳ 统计报表
- ⏳ 会员管理
- ⏳ 系统管理

### 用户端功能（待开发）
- ⏳ 房间浏览
- ⏳ 订单预订
- ⏳ 个人中心

## 默认管理员账号

用户名：admin
密码：123456

## 项目特点

1. **美观的界面**: 使用Layui + FontAwesome 6.4.0框架，采用统一的翠绿色主题，提供现代化的用户界面和2000+精美图标
2. **响应式设计**: 支持PC和移动端访问
3. **模块化架构**: 清晰的分层架构，便于维护和扩展
4. **权限控制**: 基于Session的用户权限管理
5. **选项卡导航**: 支持多标签页管理，提高操作效率
6. **现代化界面**: 使用渐变背景、阴影效果、动画过渡，提供卓越的视觉体验
7. **智能导航**: 下拉菜单式用户信息管理，快捷操作面板，提升操作便捷性

## 开发计划

- [x] 项目基础架构搭建
- [x] 管理员登录功能
- [x] 后台管理界面
- [ ] 用户注册登录
- [ ] 房间分类管理
- [ ] 房间信息管理
- [ ] 订单管理功能
- [ ] 统计报表功能
- [ ] 文件上传功能
- [ ] 系统设置功能

## 注意事项

1. 首次运行前请确保数据库已正确创建并导入数据
2. 修改数据库连接配置时，请同时更新 `db.properties` 文件
3. 项目使用了Layui框架，请确保静态资源路径正确
4. 建议在开发环境中使用UTF-8编码

## 联系方式

如有问题或建议，请联系开发团队。
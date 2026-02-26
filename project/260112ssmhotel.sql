/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50728
 Source Host           : localhost:3306
 Source Schema         : 260112ssmhotel

 Target Server Type    : MySQL
 Target Server Version : 50728
 File Encoding         : 65001

 Date: 13/01/2026 10:20:49
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for order_info
-- ----------------------------
DROP TABLE IF EXISTS `order_info`;
CREATE TABLE `order_info`  (
  `order_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '订单ID（自增主键）',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单编号（业务唯一标识，用于查询）',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '关联用户ID（下单用户/住客）',
  `room_id` bigint(20) NULL DEFAULT NULL COMMENT '关联房间ID',
  `category_id` bigint(20) NULL DEFAULT NULL COMMENT '关联房间分类ID',
  `guest_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '住客姓名',
  `guest_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '住客联系方式',
  `check_in_date` datetime NULL DEFAULT NULL COMMENT '入住日期',
  `check_out_date` datetime NULL DEFAULT NULL COMMENT '退房日期',
  `stay_days` int(11) NULL DEFAULT NULL COMMENT '入住天数',
  `room_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '房间单日单价',
  `total_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '订单总价',
  `order_status` tinyint(4) NULL DEFAULT NULL COMMENT '订单状态 0-待审核 1-已确认 2-已入住 3-已退房 4-用户取消 5-管理员拒绝/取消',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '取消原因',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`order_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_info
-- ----------------------------
INSERT INTO `order_info` VALUES (1, 'ORD1768207743148328', 2, 3, 2, '张三', '13800138001', '2026-01-12 00:00:00', '2026-01-22 00:00:00', 10, 188.00, 1880.00, 3, NULL, '2026-01-12 16:49:03', '2026-01-12 18:05:42', '1111');
INSERT INTO `order_info` VALUES (3, 'ORD1768210772652595', 2, 1, 1, '张三', '13800138001', '2026-01-12 00:00:00', '2026-01-22 00:00:00', 10, 128.00, 1280.00, 3, NULL, '2026-01-12 17:39:33', '2026-01-12 18:18:25', '');
INSERT INTO `order_info` VALUES (4, 'ORD1768213275840644', 2, 3, 2, '张三', '13800138001', '2026-01-12 00:00:00', '2026-01-22 00:00:00', 10, 188.00, 1880.00, 2, NULL, '2026-01-12 18:21:16', '2026-01-12 18:21:25', '123');
INSERT INTO `order_info` VALUES (5, 'ORD1768270149995129', 4, 4, 3, '李四', '15899994444', '2026-01-13 00:00:00', '2026-01-28 00:00:00', 15, 388.00, 5820.00, 3, NULL, '2026-01-13 10:09:10', '2026-01-13 10:09:46', '没有');

-- ----------------------------
-- Table structure for room_category
-- ----------------------------
DROP TABLE IF EXISTS `room_category`;
CREATE TABLE `room_category`  (
  `category_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID（自增主键）',
  `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类名称（如单人间、双人间、套房）',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '分类简要介绍',
  `price_min` decimal(10, 2) NULL DEFAULT NULL COMMENT '最低价格',
  `price_max` decimal(10, 2) NULL DEFAULT NULL COMMENT '最高价格',
  `cover_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类代表性图片（存储图片路径或URL，前端展示分类封面）',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序号（用于前端展示排序）',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态 0-禁用 1-正常',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`category_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '房间分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of room_category
-- ----------------------------
INSERT INTO `room_category` VALUES (1, '单人间', '舒适的单人住宿环境，适合商务人士', 128.01, 188.00, '/uploads/categories/1768206080349_ba5ad4402e384ff19c961c79de90561f.png', 1, 1, '2026-01-12 10:38:56', NULL, NULL);
INSERT INTO `room_category` VALUES (2, '双人间', '宽敞的双人房间，适合情侣或朋友出行', 188.00, 288.00, '/uploads/categories/1768206085050_19c4181e5617473f911137050aa908f9.png', 2, 1, '2026-01-12 10:38:56', NULL, NULL);
INSERT INTO `room_category` VALUES (3, '豪华套房', '高端豪华套房，配备完善设施', 388.00, 688.00, '/uploads/categories/1768206089803_ab5b6555f1c94066957c447d12a860e0.png', 3, 1, '2026-01-12 10:38:56', '2026-01-12 10:38:56', '豪华套房');

-- ----------------------------
-- Table structure for room_info
-- ----------------------------
DROP TABLE IF EXISTS `room_info`;
CREATE TABLE `room_info`  (
  `room_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '房间ID（自增主键）',
  `category_id` bigint(20) NULL DEFAULT NULL COMMENT '关联房间分类ID（业务逻辑维护关联）',
  `room_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '房间号（如101、202）',
  `area` decimal(8, 2) NULL DEFAULT NULL COMMENT '房间面积（单位：平方米）',
  `bed_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '床型（如单人床、双人床、大床）',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '房间单日单价',
  `facilities` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '房间配套设施（如阳台、早餐、空调、wifi，用逗号分隔存储）',
  `cover_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '房间封面图片（存储图片路径或URL，前端列表展示单张封面）',
  `detail_imgs` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '房间详情多张图片（多张图片路径/URL，用逗号分隔存储，前端详情页轮播展示）',
  `room_status` tinyint(4) NULL DEFAULT NULL COMMENT '房间状态 0-维修中 1-可预订 2-已预订 3-已入住',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`room_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '房间信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of room_info
-- ----------------------------
INSERT INTO `room_info` VALUES (1, 1, '101', 25.00, '单人床', 128.00, '空调,WIFI,电视,独立卫生间', '/uploads/rooms/1768198883903_857574428a5343d9bf60a7f8f6c9cefe.png', '/uploads/rooms/1768198888709_f5140989f58444e59611bf884c13fad8.png,/uploads/rooms/1768198890580_a08a73cbfd55448dae1a7f0c91ec3712.png,/uploads/rooms/1768198892711_8f5773161e0d44ecbde7e6ea9f12d603.png', 0, '2026-01-12 10:38:56', '2026-01-12 18:18:25', '一楼单人间');
INSERT INTO `room_info` VALUES (2, 1, '102', 25.00, '单人床', 128.00, '空调,WIFI,电视,独立卫生间', '/uploads/rooms/1768198867266_ebb16bf92ba64fe9836e16c972594d3c.png', '/uploads/rooms/1768198873117_40c7a81137714838bcef8d9916dfed51.png,/uploads/rooms/1768198874990_382caad0580944c9ad9dd8947377eb83.png,/uploads/rooms/1768198877661_8ca6cb85e45e4150a3184e95e5c7fcec.png', 1, '2026-01-12 10:38:56', '2026-01-12 10:38:56', '一楼单人间');
INSERT INTO `room_info` VALUES (3, 2, '201', 35.00, '双人床', 188.00, '空调,WIFI,电视,独立卫生间,阳台', '/uploads/rooms/1768198883903_857574428a5343d9bf60a7f8f6c9cefe.png', '/uploads/rooms/1768198888709_f5140989f58444e59611bf884c13fad8.png,/uploads/rooms/1768198890580_a08a73cbfd55448dae1a7f0c91ec3712.png,/uploads/rooms/1768198892711_8f5773161e0d44ecbde7e6ea9f12d603.png', 2, '2026-01-12 10:38:56', '2026-01-12 18:21:25', '二楼双人间');
INSERT INTO `room_info` VALUES (4, 3, '301', 65.00, '大床', 388.00, '空调,WIFI,电视,独立卫生间,阳台,浴缸,迷你吧', '/uploads/rooms/1768198867266_ebb16bf92ba64fe9836e16c972594d3c.png', '/uploads/rooms/1768198873117_40c7a81137714838bcef8d9916dfed51.png,/uploads/rooms/1768198874990_382caad0580944c9ad9dd8947377eb83.png,/uploads/rooms/1768198877661_8ca6cb85e45e4150a3184e95e5c7fcec.png', 0, '2026-01-12 10:38:56', '2026-01-13 10:09:46', '三楼豪华套房');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID（自增主键）',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户名/登录名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码（建议加密存储，如MD5/SHA256）',
  `real_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '真实姓名/住客姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号码（联系方式）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电子邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户头像（存储图片路径或URL，支持前端展示头像）',
  `user_type` tinyint(4) NULL DEFAULT NULL COMMENT '用户类型 0-前端普通用户/会员 1-后台管理员',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态 0-禁用 1-正常',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表（后台管理员+前端会员）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '123456', '系统管理员1', '13800000000', 'admin@hotel.com', NULL, 1, 1, '2026-01-12 10:38:56', '2026-01-12 15:17:27', '系统默认管理员账号');
INSERT INTO `user` VALUES (2, 'user', '123456', '张三11', '13800138001', '202228021@qq.com', '/uploads/avatars/avatar_2_1768269388967.png', 0, 1, '2026-01-12 10:38:56', '2026-01-13 10:01:23', NULL);
INSERT INTO `user` VALUES (3, 'rrr', '123456', '小白', '15899994444', '', NULL, 0, 1, '2026-01-12 15:45:34', '2026-01-12 15:45:34', NULL);
INSERT INTO `user` VALUES (4, 'www', '123456', '李四', '15899994444', '22221@qq.com', '/uploads/avatars/avatar_4_1768270254088.png', 0, 1, '2026-01-13 10:08:39', '2026-01-13 10:10:54', NULL);

SET FOREIGN_KEY_CHECKS = 1;

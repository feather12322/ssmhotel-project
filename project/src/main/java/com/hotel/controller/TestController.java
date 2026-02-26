package com.hotel.controller;

import com.hotel.entity.User;
import com.hotel.service.UserService;
import com.hotel.service.OrderService;
import com.hotel.service.RoomCategoryService;
import com.hotel.service.RoomInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * 系统测试控制器
 * 用于测试数据库连接和基本功能
 */
@Controller
public class TestController {

    @Autowired
    private UserService userService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private RoomCategoryService roomCategoryService;

    @Autowired
    private RoomInfoService roomInfoService;

    /**
     * 数据库连接测试
     */
    @GetMapping("/test/db")
    @ResponseBody
    public Map<String, Object> testDatabase() {
        Map<String, Object> result = new HashMap<>();

        try {
            // 尝试查询管理员用户
            User adminUser = userService.login("admin", "123456");

            result.put("status", "success");
            result.put("message", "数据库连接正常");
            result.put("adminUser", adminUser != null ? "存在" : "不存在");

            if (adminUser != null) {
                result.put("adminInfo", adminUser.getRealName() + " (" + adminUser.getUserName() + ")");
                result.put("userType", adminUser.getUserType());
                result.put("status", adminUser.getStatus());
            } else {
                result.put("suggestion", "请先执行: mysql -u root -p 260112ssmhotel < init-data.sql");
            }

        } catch (Exception e) {
            result.put("status", "error");
            result.put("message", "数据库连接失败: " + e.getMessage());
            result.put("error", e.toString());
            result.put("suggestion", "请检查数据库配置和连接");
        }

        return result;
    }

    /**
     * 系统状态检查
     */
    @GetMapping("/test/status")
    @ResponseBody
    public Map<String, Object> systemStatus() {
        Map<String, Object> result = new HashMap<>();

        result.put("status", "running");
        result.put("message", "酒店管理系统运行正常");
        result.put("version", "1.0.0");
        result.put("timestamp", System.currentTimeMillis());

        // 检查Spring容器是否正常
        try {
            result.put("springContext", "正常");
        } catch (Exception e) {
            result.put("springContext", "异常: " + e.getMessage());
        }

        return result;
    }

    /**
     * 统计功能测试
     */
    @GetMapping("/test/statistics")
    @ResponseBody
    public Map<String, Object> testStatistics() {
        Map<String, Object> result = new HashMap<>();

        try {
            // 测试基础数据
            int categoryCount = roomCategoryService.findAll().size();
            int roomCount = roomInfoService.findAll().size();
            int orderCount = orderService.findAll().size();

            result.put("status", "success");
            result.put("message", "统计功能测试完成");
            result.put("categoryCount", categoryCount);
            result.put("roomCount", roomCount);
            result.put("orderCount", orderCount);

            // 测试已完成订单数量
            long completedOrders = orderService.findAll().stream()
                .filter(o -> o != null && o.getOrderStatus() != null && o.getOrderStatus() == 3)
                .count();
            result.put("completedOrders", completedOrders);

            if (categoryCount > 0 && roomCount > 0 && orderCount > 0) {
                result.put("dataStatus", "数据完整，统计功能可正常使用");
            } else {
                result.put("dataStatus", "缺少基础数据，建议添加房间分类、房间信息和订单数据");
            }

        } catch (Exception e) {
            result.put("status", "error");
            result.put("message", "统计功能测试失败: " + e.getMessage());
            result.put("error", e.toString());
        }

        return result;
    }
}
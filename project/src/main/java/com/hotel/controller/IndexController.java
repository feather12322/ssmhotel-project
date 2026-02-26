package com.hotel.controller;

import com.hotel.entity.Order;
import com.hotel.entity.RoomInfo;
import com.hotel.service.OrderService;
import com.hotel.service.RoomInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class IndexController {

    @Autowired
    private RoomInfoService roomInfoService;

    @Autowired
    private OrderService orderService;

    /**
     * 系统主页，重定向到管理员登录
     */
    @GetMapping("/")
    public String index() {
        return "redirect:/admin/login";
    }

    /**
     * 获取首页统计数据
     */
    @GetMapping("/admin/statistics/dashboard")
    @ResponseBody
    public Map<String, Object> getDashboardStatistics() {
        Map<String, Object> result = new HashMap<>();

        try {
            // 1. 总房间数
            List<RoomInfo> allRooms = roomInfoService.findAll();
            int totalRooms = allRooms.size();

            // 2. 今日入住数
            Calendar today = Calendar.getInstance();
            today.set(Calendar.HOUR_OF_DAY, 0);
            today.set(Calendar.MINUTE, 0);
            today.set(Calendar.SECOND, 0);
            today.set(Calendar.MILLISECOND, 0);
            Date todayStart = today.getTime();

            today.add(Calendar.DAY_OF_MONTH, 1);
            Date todayEnd = today.getTime();

            List<Order> allOrders = orderService.findAll();
            int todayCheckIns = 0;
            BigDecimal todayRevenue = BigDecimal.ZERO;

            for (Order order : allOrders) {
                // 今日入住的订单（状态为已入住或已完成，且入住日期为今天）
                if ((order.getOrderStatus() == 2 || order.getOrderStatus() == 3) &&
                    order.getCheckInDate() != null &&
                    !order.getCheckInDate().before(todayStart) &&
                    order.getCheckInDate().before(todayEnd)) {
                    todayCheckIns++;
                }

                // 今日完成的订单收入
                if (order.getOrderStatus() == 3 &&
                    order.getUpdateTime() != null &&
                    !order.getUpdateTime().before(todayStart) &&
                    order.getUpdateTime().before(todayEnd)) {
                    todayRevenue = todayRevenue.add(order.getTotalPrice());
                }
            }

            // 3. 待审核订单数（待确认状态）
            int pendingOrders = 0;
            for (Order order : allOrders) {
                if (order.getOrderStatus() == 0) {
                    pendingOrders++;
                }
            }

            Map<String, Object> data = new HashMap<>();
            data.put("totalRooms", totalRooms);
            data.put("todayCheckIns", todayCheckIns);
            data.put("pendingOrders", pendingOrders);
            data.put("todayRevenue", todayRevenue);

            result.put("success", true);
            result.put("data", data);

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取统计数据失败：" + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }
}
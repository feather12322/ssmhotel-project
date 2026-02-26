package com.hotel.controller;

import com.hotel.entity.Order;
import com.hotel.entity.RoomCategory;
import com.hotel.entity.RoomInfo;
import com.hotel.service.OrderService;
import com.hotel.service.RoomCategoryService;
import com.hotel.service.RoomInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/admin/statistics")
public class StatisticsController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private RoomInfoService roomInfoService;

    @Autowired
    private RoomCategoryService roomCategoryService;

    /**
     * 入住统计页面
     */
    @GetMapping("/occupancy")
    public String occupancy(Model model) {
        // 获取所有房间分类
        List<RoomCategory> categories = roomCategoryService.findAll();
        model.addAttribute("categories", categories);

        return "admin/statistics/occupancy";
    }

    /**
     * 收入统计页面
     */
    @GetMapping("/revenue")
    public String revenue(Model model) {
        // 获取所有房间分类
        List<RoomCategory> categories = roomCategoryService.findAll();
        model.addAttribute("categories", categories);

        return "admin/statistics/revenue";
    }

    /**
     * 获取入住统计数据
     */
    @GetMapping("/occupancy/data")
    @ResponseBody
    public Map<String, Object> getOccupancyData(String period) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 设置时间范围
            Calendar cal = Calendar.getInstance();
            Date end = new Date();
            Date start = new Date();

            // 根据period设置时间范围
            switch (period != null ? period : "month") {
                case "day":
                    // 当天：从今天0点到明天0点
                    cal.set(Calendar.HOUR_OF_DAY, 0);
                    cal.set(Calendar.MINUTE, 0);
                    cal.set(Calendar.SECOND, 0);
                    cal.set(Calendar.MILLISECOND, 0);
                    start = cal.getTime();
                    cal.add(Calendar.DAY_OF_MONTH, 1);
                    end = cal.getTime();
                    break;
                case "week":
                    // 最近七天：包括今天
                    cal.add(Calendar.DAY_OF_MONTH, -6);
                    cal.set(Calendar.HOUR_OF_DAY, 0);
                    cal.set(Calendar.MINUTE, 0);
                    cal.set(Calendar.SECOND, 0);
                    cal.set(Calendar.MILLISECOND, 0);
                    start = cal.getTime();
                    break;
                case "month":
                    // 最近一月：30天
                    cal.add(Calendar.DAY_OF_MONTH, -29);
                    cal.set(Calendar.HOUR_OF_DAY, 0);
                    cal.set(Calendar.MINUTE, 0);
                    cal.set(Calendar.SECOND, 0);
                    cal.set(Calendar.MILLISECOND, 0);
                    start = cal.getTime();
                    break;
                case "year":
                    // 最近一年：365天
                    cal.add(Calendar.DAY_OF_MONTH, -364);
                    cal.set(Calendar.HOUR_OF_DAY, 0);
                    cal.set(Calendar.MINUTE, 0);
                    cal.set(Calendar.SECOND, 0);
                    cal.set(Calendar.MILLISECOND, 0);
                    start = cal.getTime();
                    break;
            }

            // 获取统计数据
            List<Map<String, Object>> occupancyData = calculateOccupancyData(start, end, period);
            result.put("success", true);
            result.put("data", occupancyData);

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取数据失败：" + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    /**
     * 获取收入统计数据
     */
    @GetMapping("/revenue/data")
    @ResponseBody
    public Map<String, Object> getRevenueData(String period) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 设置时间范围
            Calendar cal = Calendar.getInstance();
            Date end = new Date();
            Date start = new Date();

            // 根据period设置时间范围
            switch (period != null ? period : "month") {
                case "day":
                    // 当天：从今天0点到明天0点
                    cal.set(Calendar.HOUR_OF_DAY, 0);
                    cal.set(Calendar.MINUTE, 0);
                    cal.set(Calendar.SECOND, 0);
                    cal.set(Calendar.MILLISECOND, 0);
                    start = cal.getTime();
                    cal.add(Calendar.DAY_OF_MONTH, 1);
                    end = cal.getTime();
                    break;
                case "week":
                    // 最近七天：包括今天
                    cal.add(Calendar.DAY_OF_MONTH, -6);
                    cal.set(Calendar.HOUR_OF_DAY, 0);
                    cal.set(Calendar.MINUTE, 0);
                    cal.set(Calendar.SECOND, 0);
                    cal.set(Calendar.MILLISECOND, 0);
                    start = cal.getTime();
                    break;
                case "month":
                    // 最近一月：30天
                    cal.add(Calendar.DAY_OF_MONTH, -29);
                    cal.set(Calendar.HOUR_OF_DAY, 0);
                    cal.set(Calendar.MINUTE, 0);
                    cal.set(Calendar.SECOND, 0);
                    cal.set(Calendar.MILLISECOND, 0);
                    start = cal.getTime();
                    break;
                case "year":
                    // 最近一年：365天
                    cal.add(Calendar.DAY_OF_MONTH, -364);
                    cal.set(Calendar.HOUR_OF_DAY, 0);
                    cal.set(Calendar.MINUTE, 0);
                    cal.set(Calendar.SECOND, 0);
                    cal.set(Calendar.MILLISECOND, 0);
                    start = cal.getTime();
                    break;
            }

            // 获取统计数据
            List<Map<String, Object>> revenueData = calculateRevenueData(start, end, period);
            result.put("success", true);
            result.put("data", revenueData);

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取数据失败：" + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    /**
     * 计算入住统计数据
     */
    private List<Map<String, Object>> calculateOccupancyData(Date startDate, Date endDate, String period) {
        List<Map<String, Object>> result = new ArrayList<>();

        try {
            // 获取所有房间分类
            List<RoomCategory> categories = roomCategoryService.findAll();

            // 获取所有订单用于统计
            List<Order> allOrders = orderService.findAll();

            // 按房间分类统计
            int totalAllRooms = 0;
            int totalOccupiedRooms = 0;
            BigDecimal totalAllRevenue = BigDecimal.ZERO;

            for (RoomCategory category : categories) {
                if (category == null || category.getCategoryId() == null) {
                    continue; // 跳过无效的分类
                }

                Map<String, Object> categoryData = new HashMap<>();
                categoryData.put("categoryName", category.getCategoryName() != null ? category.getCategoryName() : "未命名");
                categoryData.put("categoryId", category.getCategoryId());

                // 获取该分类的所有房间
                List<RoomInfo> rooms = roomInfoService.findByCategoryId(category.getCategoryId());
                int categoryRoomCount = rooms != null ? rooms.size() : 0;

                // 计算该分类在时间段内的入住率
                double categoryOccupancyRate = calculateCategoryOccupancyRate(rooms, allOrders, startDate, endDate);

                // 统计该分类在时间段内的收入（已完成订单）
                BigDecimal categoryRevenue = BigDecimal.ZERO;
                int categoryOrderCount = 0;

                if (allOrders != null) {
                    for (Order order : allOrders) {
                        if (order != null && order.getCategoryId() != null &&
                            order.getCategoryId().equals(category.getCategoryId()) &&
                            order.getOrderStatus() != null && order.getOrderStatus() == 3 && // 已完成
                            order.getCreateTime() != null &&
                            !order.getCreateTime().before(startDate) &&
                            !order.getCreateTime().after(endDate)) {
                            if (order.getTotalPrice() != null) {
                                categoryRevenue = categoryRevenue.add(order.getTotalPrice());
                                categoryOrderCount++;
                            }
                        }
                    }
                }

                categoryData.put("totalRooms", categoryRoomCount);
                categoryData.put("occupancyRate", Math.round(categoryOccupancyRate * 100.0) / 100.0);
                categoryData.put("totalRevenue", categoryRevenue);
                categoryData.put("orderCount", categoryOrderCount);

                result.add(categoryData);

                // 累计总数据
                totalAllRooms += categoryRoomCount;
                totalOccupiedRooms += Math.round(categoryOccupancyRate / 100.0 * categoryRoomCount);
                totalAllRevenue = totalAllRevenue.add(categoryRevenue);
            }

            // 添加汇总数据
            Map<String, Object> summaryData = new HashMap<>();
            summaryData.put("categoryName", "总体统计");
            summaryData.put("categoryId", "summary");
            summaryData.put("totalRooms", totalAllRooms);
            double overallOccupancyRate = totalAllRooms > 0 ? (double) totalOccupiedRooms / totalAllRooms * 100 : 0;
            summaryData.put("occupancyRate", Math.round(overallOccupancyRate * 100.0) / 100.0);
            summaryData.put("totalRevenue", totalAllRevenue);
            
            // 计算总订单数
            long totalCompletedOrders = 0;
            if (allOrders != null) {
                totalCompletedOrders = allOrders.stream()
                    .filter(o -> o != null && o.getOrderStatus() != null && o.getOrderStatus() == 3 &&
                            o.getCreateTime() != null && !o.getCreateTime().before(startDate) && !o.getCreateTime().after(endDate))
                    .count();
            }
            summaryData.put("orderCount", totalCompletedOrders);

            result.add(0, summaryData); // 将汇总数据放在第一位

            // 计算入住率趋势数据
            List<Map<String, Object>> occupancyTrend = calculateOccupancyTrend(startDate, endDate, allOrders, period);
            if (!occupancyTrend.isEmpty()) {
                Map<String, Object> trendSummary = new HashMap<>();
                trendSummary.put("trend", occupancyTrend);
                result.add(0, trendSummary); // 将趋势数据放在最前面
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    /**
     * 计算分类的入住率
     */
    private double calculateCategoryOccupancyRate(List<RoomInfo> rooms, List<Order> orders, Date startDate, Date endDate) {
        if (rooms == null || rooms.isEmpty()) {
            return 0.0;
        }

        int totalRoomDays = 0;
        int occupiedRoomDays = 0;

        // 计算时间段的总天数
        long totalDays = (endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24) + 1;

        for (RoomInfo room : rooms) {
            if (room == null) continue;

            totalRoomDays += totalDays;

            // 计算该房间在时间段内的入住天数
            occupiedRoomDays += calculateRoomOccupiedDays(room, orders, startDate, endDate);
        }

        return totalRoomDays > 0 ? (double) occupiedRoomDays / totalRoomDays * 100 : 0;
    }

    /**
     * 计算房间在指定时间段内的入住天数
     */
    private int calculateRoomOccupiedDays(RoomInfo room, List<Order> orders, Date startDate, Date endDate) {
        int occupiedDays = 0;

        if (orders == null) return occupiedDays;

        for (Order order : orders) {
            if (order != null && order.getRoomId() != null &&
                order.getRoomId().equals(room.getRoomId()) &&
                (order.getOrderStatus() == 2 || order.getOrderStatus() == 3) && // 已入住或已完成
                order.getCheckInDate() != null && order.getCheckOutDate() != null) {

                // 计算订单入住时间与统计时间段的交集
                Date orderStart = order.getCheckInDate();
                Date orderEnd = order.getCheckOutDate();

                // 找到重叠的时间段
                Date overlapStart = orderStart.after(startDate) ? orderStart : startDate;
                Date overlapEnd = orderEnd.before(endDate) ? orderEnd : endDate;

                if (!overlapStart.after(overlapEnd)) {
                    long overlapDays = (overlapEnd.getTime() - overlapStart.getTime()) / (1000 * 60 * 60 * 24) + 1;
                    occupiedDays += overlapDays;
                }
            }
        }

        return occupiedDays;
    }

    /**
     * 计算入住率趋势数据
     */
    private List<Map<String, Object>> calculateOccupancyTrend(Date startDate, Date endDate, List<Order> allOrders, String period) {
        List<Map<String, Object>> trend = new ArrayList<>();
        Calendar cal = Calendar.getInstance();
        cal.setTime(startDate);

        SimpleDateFormat sdf = null;
        int calendarField = 0;

        // 根据周期设置格式化和分组方式
        switch (period) {
            case "day":
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                calendarField = Calendar.DAY_OF_MONTH;
                break;
            case "week":
                sdf = new SimpleDateFormat("yyyy年第w周");
                calendarField = Calendar.WEEK_OF_YEAR;
                break;
            case "month":
                sdf = new SimpleDateFormat("yyyy-MM");
                calendarField = Calendar.MONTH;
                break;
            case "year":
                sdf = new SimpleDateFormat("yyyy年");
                calendarField = Calendar.YEAR;
                break;
            default:
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                calendarField = Calendar.DAY_OF_MONTH;
        }

        // 获取所有房间
        List<RoomInfo> allRooms = roomInfoService.findAll();
        int totalRooms = allRooms != null ? allRooms.size() : 0;

        while (!cal.getTime().after(endDate)) {
            String periodStr = sdf.format(cal.getTime());
            Map<String, Object> periodData = new HashMap<>();
            periodData.put("period", periodStr);

            // 计算该周期内的入住订单数（作为入住率的近似值）
            int occupiedOrders = 0;
            if (allOrders != null) {
                for (Order order : allOrders) {
                    if (order != null && order.getOrderStatus() != null &&
                        (order.getOrderStatus() == 2 || order.getOrderStatus() == 3) && // 已入住或已完成
                        order.getCreateTime() != null &&
                        isInPeriod(order.getCreateTime(), cal.getTime(), period)) {
                        occupiedOrders++;
                    }
                }
            }

            // 入住率 = 入住订单数 / 总房间数 * 100%
            // 这里简化处理，实际应该考虑订单的入住天数和房间容量
            double occupancyRate = totalRooms > 0 ? (double) occupiedOrders / totalRooms * 100 : 0;
            periodData.put("occupancyRate", Math.round(occupancyRate * 100.0) / 100.0);
            periodData.put("totalRooms", totalRooms);
            periodData.put("occupiedOrders", occupiedOrders);

            trend.add(periodData);
            cal.add(calendarField, 1);
        }

        return trend;
    }


    /**
     * 计算收入统计数据
     */
    private List<Map<String, Object>> calculateRevenueData(Date startDate, Date endDate, String period) {
        List<Map<String, Object>> result = new ArrayList<>();

        try {
            // 获取所有房间分类
            List<RoomCategory> categories = roomCategoryService.findAll();

            // 获取时间范围内的所有订单（状态为已完成）
            List<Order> allOrders = orderService.findAll();

            BigDecimal totalRevenue = BigDecimal.ZERO;
            int totalOrderCount = 0;

            // 按房间分类统计收入
            for (RoomCategory category : categories) {
                if (category == null || category.getCategoryId() == null) {
                    continue; // 跳过无效的分类
                }

                Map<String, Object> categoryData = new HashMap<>();
                categoryData.put("categoryName", category.getCategoryName() != null ? category.getCategoryName() : "未命名");
                categoryData.put("categoryId", category.getCategoryId());

                BigDecimal categoryRevenue = BigDecimal.ZERO;
                int orderCount = 0;

                if (allOrders != null) {
                    for (Order order : allOrders) {
                        if (order != null && order.getCategoryId() != null &&
                            order.getCategoryId().equals(category.getCategoryId()) &&
                            order.getOrderStatus() != null && order.getOrderStatus() == 3 && // 已完成
                            order.getCreateTime() != null &&
                            !order.getCreateTime().before(startDate) &&
                            !order.getCreateTime().after(endDate)) {
                            if (order.getTotalPrice() != null) {
                                categoryRevenue = categoryRevenue.add(order.getTotalPrice());
                                orderCount++;
                            }
                        }
                    }
                }

                categoryData.put("revenue", categoryRevenue);
                categoryData.put("orderCount", orderCount);

                result.add(categoryData);
                totalRevenue = totalRevenue.add(categoryRevenue);
                totalOrderCount += orderCount;
            }

            // 计算各分类的收入占比
            for (Map<String, Object> categoryData : result) {
                BigDecimal categoryRevenue = (BigDecimal) categoryData.get("revenue");
                BigDecimal percentage = totalRevenue.compareTo(BigDecimal.ZERO) > 0 ?
                    categoryRevenue.divide(totalRevenue, 4, BigDecimal.ROUND_HALF_UP).multiply(BigDecimal.valueOf(100)) :
                    BigDecimal.ZERO;
                categoryData.put("percentage", percentage);
            }

            // 按时间段统计收入趋势
            List<Map<String, Object>> trendData = calculateRevenueTrend(startDate, endDate, allOrders, period);
            
            // 创建汇总数据
            Map<String, Object> summary = new HashMap<>();
            summary.put("totalRevenue", totalRevenue);
            summary.put("totalOrders", totalOrderCount);
            summary.put("trend", trendData);

            result.add(0, summary); // 将汇总数据放在第一位

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    /**
     * 计算收入趋势数据
     */
    private List<Map<String, Object>> calculateRevenueTrend(Date startDate, Date endDate, List<Order> allOrders, String period) {
        List<Map<String, Object>> trend = new ArrayList<>();
        Calendar cal = Calendar.getInstance();
        cal.setTime(startDate);

        SimpleDateFormat sdf = null;
        int calendarField = 0;

        // 根据周期设置格式化和分组方式
        switch (period) {
            case "day":
                sdf = new SimpleDateFormat("MM-dd");
                calendarField = Calendar.DAY_OF_MONTH;
                break;
            case "week":
                sdf = new SimpleDateFormat("第w周");
                calendarField = Calendar.WEEK_OF_YEAR;
                break;
            case "month":
                sdf = new SimpleDateFormat("MM月");
                calendarField = Calendar.MONTH;
                break;
            case "year":
                sdf = new SimpleDateFormat("yyyy年");
                calendarField = Calendar.YEAR;
                break;
            default:
                sdf = new SimpleDateFormat("MM-dd");
                calendarField = Calendar.DAY_OF_MONTH;
        }

        while (!cal.getTime().after(endDate)) {
            String periodStr = sdf.format(cal.getTime());
            BigDecimal periodRevenue = BigDecimal.ZERO;
            int periodOrderCount = 0;

            // 计算当前周期内的收入
            if (allOrders != null) {
                for (Order order : allOrders) {
                    if (order != null && order.getOrderStatus() != null && order.getOrderStatus() == 3 && // 已完成
                        order.getCreateTime() != null &&
                        isInPeriod(order.getCreateTime(), cal.getTime(), period)) {
                        if (order.getTotalPrice() != null) {
                            periodRevenue = periodRevenue.add(order.getTotalPrice());
                            periodOrderCount++;
                        }
                    }
                }
            }

            Map<String, Object> periodData = new HashMap<>();
            periodData.put("date", periodStr);
            periodData.put("period", periodStr);
            periodData.put("revenue", periodRevenue);
            periodData.put("orderCount", periodOrderCount);
            trend.add(periodData);

            cal.add(calendarField, 1);
        }

        return trend;
    }

    /**
     * 判断订单时间是否在指定的周期内
     */
    private boolean isInPeriod(Date orderDate, Date periodStart, String period) {
        Calendar orderCal = Calendar.getInstance();
        orderCal.setTime(orderDate);

        Calendar periodCal = Calendar.getInstance();
        periodCal.setTime(periodStart);

        switch (period) {
            case "day":
                return orderCal.get(Calendar.YEAR) == periodCal.get(Calendar.YEAR) &&
                       orderCal.get(Calendar.DAY_OF_YEAR) == periodCal.get(Calendar.DAY_OF_YEAR);
            case "week":
                return orderCal.get(Calendar.YEAR) == periodCal.get(Calendar.YEAR) &&
                       orderCal.get(Calendar.WEEK_OF_YEAR) == periodCal.get(Calendar.WEEK_OF_YEAR);
            case "month":
                return orderCal.get(Calendar.YEAR) == periodCal.get(Calendar.YEAR) &&
                       orderCal.get(Calendar.MONTH) == periodCal.get(Calendar.MONTH);
            case "year":
                return orderCal.get(Calendar.YEAR) == periodCal.get(Calendar.YEAR);
            default:
                return false;
        }
    }
}
package com.hotel.controller;

import com.hotel.entity.Order;
import com.hotel.entity.RoomInfo;
import com.hotel.entity.User;
import com.hotel.service.OrderService;
import com.hotel.service.RoomCategoryService;
import com.hotel.service.RoomInfoService;
import com.hotel.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserService userService;

    @Autowired
    private RoomInfoService roomInfoService;

    @Autowired
    private RoomCategoryService roomCategoryService;

    /**
     * 订单列表页面
     */
    @GetMapping("/list")
    public String list(@RequestParam(required = false) String orderNo,
                      @RequestParam(required = false) String guestName,
                      @RequestParam(required = false) String phone,
                      @RequestParam(required = false) String userName,
                      @RequestParam(required = false) Integer orderStatus,
                      @RequestParam(defaultValue = "1") int page,
                      @RequestParam(defaultValue = "10") int limit,
                      Model model) {
        int offset = (page - 1) * limit;
        List<Order> orders = orderService.findPageByConditions(orderNo, guestName, phone, userName, orderStatus, offset, limit);
        int total = orderService.countByConditions(orderNo, guestName, phone, userName, orderStatus);

        // 为每个订单添加房间信息和用户信息
        for (Order order : orders) {
            // 获取用户信息
            User user = userService.findById(order.getUserId());
            if (user != null) {
                order.setUserName(user.getUserName());
            }

            // 获取房间信息
            RoomInfo room = roomInfoService.findById(order.getRoomId());
            if (room != null) {
                // 将房间信息存储在remark字段中，格式：roomNo-bedType
                order.setRemark(room.getRoomNo() + "-" + room.getBedType());
            }
        }

        model.addAttribute("orders", orders);
        model.addAttribute("searchOrderNo", orderNo);
        model.addAttribute("searchGuestName", guestName);
        model.addAttribute("searchPhone", phone);
        model.addAttribute("searchUserName", userName);
        model.addAttribute("searchOrderStatus", orderStatus);
        model.addAttribute("page", page);
        model.addAttribute("limit", limit);
        model.addAttribute("total", total);

        return "admin/order/list";
    }

    /**
     * 订单详情页面
     */
    @GetMapping("/detail/{orderId}")
    public String detail(@PathVariable Long orderId, Model model) {
        Order order = orderService.findById(orderId);
        if (order == null) {
            return "redirect:/admin/order/list";
        }

        // 获取关联的用户信息
        User user = userService.findById(order.getUserId());
        // 获取关联的房间信息
        RoomInfo room = roomInfoService.findById(order.getRoomId());

        model.addAttribute("order", order);
        model.addAttribute("user", user);
        model.addAttribute("room", room);

        return "admin/order/detail";
    }

    /**
     * 确认订单
     */
    @PostMapping("/confirm/{orderId}")
    @ResponseBody
    public Map<String, Object> confirmOrder(@PathVariable Long orderId) {
        Map<String, Object> result = new HashMap<>();

        try {
            Order order = orderService.findById(orderId);
            if (order == null) {
                result.put("success", false);
                result.put("message", "订单不存在");
                return result;
            }

            if (order.getOrderStatus() != 0) {
                result.put("success", false);
                result.put("message", "订单状态不允许确认");
                return result;
            }

            order.setOrderStatus(1); // 已确认
            order.setUpdateTime(new Date());

            boolean success = orderService.updateSelective(order);
            if (success) {
                result.put("success", true);
                result.put("message", "订单确认成功");
            } else {
                result.put("success", false);
                result.put("message", "订单确认失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    /**
     * 取消订单
     */
    @PostMapping("/cancel/{orderId}")
    @ResponseBody
    public Map<String, Object> cancelOrder(@PathVariable Long orderId,
                                          @RequestParam(required = false) String cancelReason) {
        Map<String, Object> result = new HashMap<>();

        try {
            Order order = orderService.findById(orderId);
            if (order == null) {
                result.put("success", false);
                result.put("message", "订单不存在");
                return result;
            }

            if (order.getOrderStatus() != 0 && order.getOrderStatus() != 1) {
                result.put("success", false);
                result.put("message", "订单状态不允许取消");
                return result;
            }

            order.setOrderStatus(4); // 已取消
            order.setCancelReason(cancelReason);
            order.setUpdateTime(new Date());

            boolean success = orderService.updateSelective(order);
            if (success) {
                result.put("success", true);
                result.put("message", "订单取消成功");
            } else {
                result.put("success", false);
                result.put("message", "订单取消失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    /**
     * 确认入住
     */
    @PostMapping("/checkin/{orderId}")
    @ResponseBody
    public Map<String, Object> checkInOrder(@PathVariable Long orderId) {
        Map<String, Object> result = new HashMap<>();

        try {
            Order order = orderService.findById(orderId);
            if (order == null) {
                result.put("success", false);
                result.put("message", "订单不存在");
                return result;
            }

            if (order.getOrderStatus() != 1) {
                result.put("success", false);
                result.put("message", "订单状态不允许入住");
                return result;
            }

            order.setOrderStatus(2); // 已入住
            order.setUpdateTime(new Date());

            // 更新订单状态
            boolean orderSuccess = orderService.updateSelective(order);

            // 更新房间状态为已入住
            RoomInfo room = roomInfoService.findById(order.getRoomId());
            if (room != null) {
                room.setRoomStatus(2); // 已入住
                room.setUpdateTime(new Date());
                boolean roomSuccess = roomInfoService.update(room);
                if (orderSuccess && roomSuccess) {
                    result.put("success", true);
                    result.put("message", "确认入住成功");
                } else {
                    result.put("success", false);
                    result.put("message", "确认入住失败");
                }
            } else {
                result.put("success", false);
                result.put("message", "房间信息不存在");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    /**
     * 确认完成
     */
    @PostMapping("/complete/{orderId}")
    @ResponseBody
    public Map<String, Object> completeOrder(@PathVariable Long orderId) {
        Map<String, Object> result = new HashMap<>();

        try {
            Order order = orderService.findById(orderId);
            if (order == null) {
                result.put("success", false);
                result.put("message", "订单不存在");
                return result;
            }

            if (order.getOrderStatus() != 2) {
                result.put("success", false);
                result.put("message", "订单状态不允许完成");
                return result;
            }

            order.setOrderStatus(3); // 已完成
            order.setUpdateTime(new Date());

            // 更新订单状态
            boolean orderSuccess = orderService.updateSelective(order);

            // 更新房间状态为可预订
            RoomInfo room = roomInfoService.findById(order.getRoomId());
            if (room != null) {
                room.setRoomStatus(0); // 可预订
                room.setUpdateTime(new Date());
                boolean roomSuccess = roomInfoService.update(room);
                if (orderSuccess && roomSuccess) {
                    result.put("success", true);
                    result.put("message", "确认完成成功");
                } else {
                    result.put("success", false);
                    result.put("message", "确认完成失败");
                }
            } else {
                result.put("success", false);
                result.put("message", "房间信息不存在");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    /**
     * 删除订单
     */
    @PostMapping("/delete/{orderId}")
    @ResponseBody
    public Map<String, Object> deleteOrder(@PathVariable Long orderId) {
        Map<String, Object> result = new HashMap<>();

        try {
            Order order = orderService.findById(orderId);
            if (order == null) {
                result.put("success", false);
                result.put("message", "订单不存在");
                return result;
            }

            // 只有已取消或已完成的订单才能删除
            if (order.getOrderStatus() != 3 && order.getOrderStatus() != 4) {
                result.put("success", false);
                result.put("message", "只有已完成或已取消的订单才能删除");
                return result;
            }

            boolean success = orderService.deleteById(orderId);
            if (success) {
                result.put("success", true);
                result.put("message", "订单删除成功");
            } else {
                result.put("success", false);
                result.put("message", "订单删除失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    /**
     * 批量操作订单
     */
    @PostMapping("/batch")
    @ResponseBody
    public Map<String, Object> batchOperation(@RequestParam String operation,
                                             @RequestParam String orderIds) {
        Map<String, Object> result = new HashMap<>();

        try {
            String[] ids = orderIds.split(",");
            int successCount = 0;
            int failCount = 0;

            for (String idStr : ids) {
                try {
                    Long orderId = Long.parseLong(idStr.trim());
                    boolean success = false;

                    switch (operation) {
                        case "confirm":
                            success = confirmBatchOrder(orderId);
                            break;
                        case "checkin":
                            success = checkInBatchOrder(orderId);
                            break;
                        case "complete":
                            success = completeBatchOrder(orderId);
                            break;
                        case "delete":
                            success = deleteBatchOrder(orderId);
                            break;
                    }

                    if (success) {
                        successCount++;
                    } else {
                        failCount++;
                    }
                } catch (Exception e) {
                    failCount++;
                }
            }

            result.put("success", true);
            result.put("message", String.format("操作完成：成功%d个，失败%d个", successCount, failCount));
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "批量操作失败：" + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    private boolean confirmBatchOrder(Long orderId) {
        Order order = orderService.findById(orderId);
        if (order != null && order.getOrderStatus() == 0) {
            order.setOrderStatus(1);
            order.setUpdateTime(new Date());
            return orderService.updateSelective(order);
        }
        return false;
    }

    private boolean cancelBatchOrder(Long orderId, String reason) {
        Order order = orderService.findById(orderId);
        if (order != null && (order.getOrderStatus() == 0 || order.getOrderStatus() == 1)) {
            order.setOrderStatus(4);
            order.setCancelReason(reason);
            order.setUpdateTime(new Date());
            return orderService.updateSelective(order);
        }
        return false;
    }

    private boolean checkInBatchOrder(Long orderId) {
        Order order = orderService.findById(orderId);
        if (order != null && order.getOrderStatus() == 1) {
            order.setOrderStatus(2);
            order.setUpdateTime(new Date());
            return orderService.updateSelective(order);
        }
        return false;
    }

    private boolean completeBatchOrder(Long orderId) {
        Order order = orderService.findById(orderId);
        if (order != null && order.getOrderStatus() == 2) {
            order.setOrderStatus(3);
            order.setUpdateTime(new Date());
            return orderService.updateSelective(order);
        }
        return false;
    }

    private boolean deleteBatchOrder(Long orderId) {
        Order order = orderService.findById(orderId);
        if (order != null && (order.getOrderStatus() == 3 || order.getOrderStatus() == 4)) {
            return orderService.deleteById(orderId);
        }
        return false;
    }
}
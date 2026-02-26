package com.hotel.controller;

import com.hotel.entity.Order;
import com.hotel.entity.RoomCategory;
import com.hotel.entity.RoomInfo;
import com.hotel.entity.User;
import com.hotel.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Controller
@RequestMapping("/user")
public class UserRoomController {

    @Autowired
    private RoomInfoService roomInfoService;

    @Autowired
    private RoomCategoryService roomCategoryService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserService userService;

    /**
     * 房间列表页面
     */
    @GetMapping("/rooms")
    public String rooms(@RequestParam(required = false) String roomNo,
                       @RequestParam(required = false) Long categoryId,
                       @RequestParam(required = false) BigDecimal priceMin,
                       @RequestParam(required = false) BigDecimal priceMax,
                       HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        // 获取查询条件
        List<RoomInfo> rooms;
        if (roomNo != null || categoryId != null || priceMin != null || priceMax != null) {
            rooms = roomInfoService.findByConditions(roomNo, categoryId, priceMin, priceMax, null);
        } else {
            rooms = roomInfoService.findAll();
        }

        List<RoomCategory> categories = roomCategoryService.findAll();

        model.addAttribute("user", user);
        model.addAttribute("rooms", rooms);
        model.addAttribute("categories", categories);
        // 回显查询条件
        model.addAttribute("searchRoomNo", roomNo);
        model.addAttribute("searchCategoryId", categoryId);
        model.addAttribute("searchPriceMin", priceMin);
        model.addAttribute("searchPriceMax", priceMax);

        return "user/rooms";
    }

    /**
     * 房间详情页面
     */
    @GetMapping("/room/{roomId}")
    public String roomDetail(@PathVariable("roomId") Long roomId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        RoomInfo room = roomInfoService.findById(roomId);
        if (room == null) {
            return "redirect:/user/rooms";
        }

        List<RoomCategory> categories = roomCategoryService.findAll();
        String categoryName = "";
        for (RoomCategory category : categories) {
            if (category.getCategoryId().equals(room.getCategoryId())) {
                categoryName = category.getCategoryName();
                break;
            }
        }

        model.addAttribute("user", user);
        model.addAttribute("room", room);
        model.addAttribute("categoryName", categoryName);

        return "user/room_detail";
    }

    /**
     * 预订房间页面
     */
    @GetMapping("/book/{roomId}")
    public String bookRoom(@PathVariable("roomId") Long roomId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        RoomInfo room = roomInfoService.findById(roomId);
        if (room == null || room.getRoomStatus() != 1) {
            return "redirect:/user/rooms";
        }

        List<RoomCategory> categories = roomCategoryService.findAll();
        String categoryName = "";
        for (RoomCategory category : categories) {
            if (category.getCategoryId().equals(room.getCategoryId())) {
                categoryName = category.getCategoryName();
                break;
            }
        }

        model.addAttribute("user", user);
        model.addAttribute("room", room);
        model.addAttribute("categoryName", categoryName);

        return "user/book";
    }

    /**
     * 提交预订订单
     */
    @PostMapping("/submitBooking")
    @ResponseBody
    public Object submitBooking(@RequestParam Long roomId,
                               @RequestParam String guestName,
                               @RequestParam String phone,
                               @RequestParam String checkInDate,
                               @RequestParam String checkOutDate,
                               @RequestParam Integer guestCount,
                               @RequestParam(required = false) String specialRequests,
                               HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            // 验证房间
            RoomInfo room = roomInfoService.findById(roomId);
            if (room == null || room.getRoomStatus() != 1) {
                result.put("success", false);
                result.put("message", "房间不存在或不可预订");
                return result;
            }

            // 计算天数和价格
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date checkIn = sdf.parse(checkInDate);
            Date checkOut = sdf.parse(checkOutDate);
            long diffInMillies = checkOut.getTime() - checkIn.getTime();
            int stayDays = (int) (diffInMillies / (1000 * 60 * 60 * 24));

            if (stayDays <= 0) {
                result.put("success", false);
                result.put("message", "退房日期必须晚于入住日期");
                return result;
            }

            BigDecimal totalPrice = BigDecimal.valueOf(room.getPrice()).multiply(BigDecimal.valueOf(stayDays));

            // 获取房间分类信息
            RoomCategory category = roomCategoryService.findById(room.getCategoryId());

            // 创建订单
            Order order = new Order();
            order.setOrderNo(generateOrderNo());
            order.setUserId(user.getUserId());
            order.setRoomId(roomId);
            order.setCategoryId(room.getCategoryId());
            order.setGuestName(guestName);
            order.setPhone(phone);
            order.setCheckInDate(checkIn);
            order.setCheckOutDate(checkOut);
            order.setStayDays(stayDays);
            order.setRoomPrice(BigDecimal.valueOf(room.getPrice()));
            order.setTotalPrice(totalPrice);
            order.setOrderStatus(0); // 待确认
            order.setCreateTime(new Date());
            order.setUpdateTime(new Date());
            order.setRemark(specialRequests);

            // 保存订单到数据库
            boolean saveSuccess = orderService.create(order);
            if (saveSuccess) {
                result.put("success", true);
                result.put("message", "预订成功");
                result.put("orderNo", order.getOrderNo());
            } else {
                result.put("success", false);
                result.put("message", "订单保存失败，请重试");
            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "预订失败：" + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 用户订单列表页面
     */
    @GetMapping("/orders")
    public String orders(@RequestParam(required = false) Integer status,
                        @RequestParam(defaultValue = "1") int page,
                        @RequestParam(defaultValue = "5") int limit,
                        HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        int offset = (page - 1) * limit;

        // 根据状态筛选获取用户的订单（分页）
        List<Order> orders;
        int total;

        if (status != null) {
            // 有状态筛选
            orders = orderService.findByUserIdAndStatus(user.getUserId(), status, offset, limit);
            total = orderService.countByUserIdAndStatus(user.getUserId(), status);
        } else {
            // 全部订单
            orders = orderService.findByUserIdPaged(user.getUserId(), offset, limit);
            total = orderService.countByUserId(user.getUserId());
        }

        // 获取所有房间信息，用于显示订单中的房间详情
        List<RoomInfo> rooms = roomInfoService.findAll();

        model.addAttribute("user", user);
        model.addAttribute("orders", orders);
        model.addAttribute("rooms", rooms);
        model.addAttribute("currentStatus", status);
        model.addAttribute("page", page);
        model.addAttribute("limit", limit);
        model.addAttribute("total", total);

        return "user/orders";
    }

    /**
     * 取消订单
     */
    @PostMapping("/cancelOrder")
    @ResponseBody
    public Object cancelOrder(@RequestParam Long orderId,
                             @RequestParam(required = false) String cancelReason,
                             HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            // 查找订单
            Order order = orderService.findById(orderId);
            if (order == null) {
                result.put("success", false);
                result.put("message", "订单不存在");
                return result;
            }

            // 验证订单所属用户
            if (!order.getUserId().equals(user.getUserId())) {
                result.put("success", false);
                result.put("message", "无权操作此订单");
                return result;
            }

            // 只能取消待确认的订单
            if (order.getOrderStatus() != 0) {
                result.put("success", false);
                result.put("message", "只能取消待确认的订单");
                return result;
            }

            // 更新订单状态为已取消
            order.setOrderStatus(4); // 4: 用户取消
            order.setCancelReason(cancelReason);
            order.setUpdateTime(new Date());

            boolean success = orderService.update(order);
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
     * 获取用户信息（用于个人中心）
     */
    @GetMapping("/profile")
    @ResponseBody
    public Map<String, Object> getProfile(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            result.put("success", true);
            result.put("data", user);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取用户信息失败：" + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 更新用户信息
     */
    @PostMapping("/updateProfile")
    @ResponseBody
    public Map<String, Object> updateProfile(@RequestParam String realName,
                                           @RequestParam String phone,
                                           @RequestParam(required = false) String email,
                                           HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            // 只更新允许修改的字段
            User updateUser = new User();
            updateUser.setUserId(user.getUserId());
            updateUser.setRealName(realName);
            updateUser.setPhone(phone);
            if (email != null && !email.trim().isEmpty()) {
                updateUser.setEmail(email);
            }
            updateUser.setUpdateTime(new Date());

            boolean success = userService.updateUserSelective(updateUser);
            if (success) {
                // 更新session中的用户信息
                User updatedUser = userService.findById(user.getUserId());
                session.setAttribute("user", updatedUser);

                result.put("success", true);
                result.put("message", "资料更新成功");
            } else {
                result.put("success", false);
                result.put("message", "资料更新失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 上传头像
     */
    @PostMapping("/uploadAvatar")
    @ResponseBody
    public Map<String, Object> uploadAvatar(@RequestParam("file") org.springframework.web.multipart.MultipartFile file,
                                          HttpSession session,
                                          javax.servlet.http.HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            if (file == null || file.isEmpty()) {
                result.put("success", false);
                result.put("message", "请选择头像文件");
                return result;
            }

            // 检查文件类型
            String originalFilename = file.getOriginalFilename();
            if (originalFilename == null) {
                result.put("success", false);
                result.put("message", "文件名不能为空");
                return result;
            }

            String ext = originalFilename.substring(originalFilename.lastIndexOf('.') + 1).toLowerCase();
            if (!"jpg,jpeg,png,gif".contains(ext)) {
                result.put("success", false);
                result.put("message", "只支持jpg、jpeg、png、gif格式的图片");
                return result;
            }

            // 检查文件大小（限制为2MB）
            if (file.getSize() > 2 * 1024 * 1024) {
                result.put("success", false);
                result.put("message", "头像文件大小不能超过2MB");
                return result;
            }

            // 创建用户头像目录
            String uploadPath = System.getProperty("user.home") + "/hotel-uploads/avatars";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 生成新文件名
            String filename = "avatar_" + user.getUserId() + "_" + System.currentTimeMillis() + "." + ext;
            File targetFile = new File(uploadDir, filename);
            file.transferTo(targetFile);

            // 构建访问URL
            String contextPath = request.getContextPath();
            String avatarUrl = contextPath + "/uploads/avatars/" + filename;

            // 更新用户头像
            User updateUser = new User();
            updateUser.setUserId(user.getUserId());
            updateUser.setAvatar(avatarUrl);
            updateUser.setUpdateTime(new Date());

            boolean success = userService.updateUserSelective(updateUser);
            if (success) {
                // 更新session中的用户信息
                User updatedUser = userService.findById(user.getUserId());
                session.setAttribute("user", updatedUser);

                result.put("success", true);
                result.put("message", "头像上传成功");
                result.put("avatarUrl", avatarUrl);
            } else {
                result.put("success", false);
                result.put("message", "头像保存失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "头像上传失败：" + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 修改密码
     */
    @PostMapping("/changePassword")
    @ResponseBody
    public Map<String, Object> changePassword(@RequestParam String oldPassword,
                                            @RequestParam String newPassword,
                                            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                return result;
            }

            // 验证旧密码
            if (!user.getPassword().equals(oldPassword)) {
                result.put("success", false);
                result.put("message", "原密码不正确");
                return result;
            }

            // 更新密码
            User updateUser = new User();
            updateUser.setUserId(user.getUserId());
            updateUser.setPassword(newPassword);
            updateUser.setUpdateTime(new Date());

            boolean success = userService.updateUserSelective(updateUser);
            if (success) {
                result.put("success", true);
                result.put("message", "密码修改成功");
            } else {
                result.put("success", false);
                result.put("message", "密码修改失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 生成订单号
     */
    private String generateOrderNo() {
        return "ORD" + System.currentTimeMillis() + (int)(Math.random() * 1000);
    }
}
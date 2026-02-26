package com.hotel.controller;

import com.hotel.entity.User;
import com.hotel.service.RoomCategoryService;
import com.hotel.service.RoomInfoService;
import com.hotel.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/profile")
public class ProfileController {

    @Autowired
    private UserService userService;

    @Autowired
    private RoomInfoService roomInfoService;

    @Autowired
    private RoomCategoryService roomCategoryService;

    /**
     * 个人中心首页
     */
    @GetMapping("")
    public String profile(Model model, HttpSession session) {
        User adminUser = (User) session.getAttribute("adminUser");
        if (adminUser == null) {
            return "redirect:/admin/login";
        }

        // 统计信息
        int totalUsers = userService.findAll().size();
        long activeUsers = userService.findAll().stream()
                .filter(user -> user.getStatus() == 1)
                .count();
        int totalRooms = roomInfoService.findAll().size();
        long availableRooms = roomInfoService.findAll().stream()
                .filter(room -> room.getRoomStatus() == 1)
                .count();

        model.addAttribute("adminUser", adminUser);
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("activeUsers", (int) activeUsers);
        model.addAttribute("totalRooms", totalRooms);
        model.addAttribute("availableRooms", (int) availableRooms);

        return "admin/profile";
    }

    /**
     * 编辑个人信息页面
     */
    @GetMapping("/edit")
    public String editProfile(Model model, HttpSession session) {
        User adminUser = (User) session.getAttribute("adminUser");
        if (adminUser == null) {
            return "redirect:/admin/login";
        }

        model.addAttribute("user", adminUser);
        return "admin/profile_edit";
    }

    /**
     * 修改密码页面
     */
    @GetMapping("/changePassword")
    public String changePassword() {
        return "admin/profile_password";
    }

    /**
     * 更新个人信息
     */
    @PostMapping("/update")
    @ResponseBody
    public Map<String, Object> update(User user, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            User currentUser = (User) session.getAttribute("adminUser");
            if (currentUser == null) {
                result.put("success", false);
                result.put("message", "用户未登录");
                return result;
            }

            // 只允许修改自己的信息
            user.setUserId(currentUser.getUserId());
            // 不允许修改用户名和用户类型
            user.setUserName(currentUser.getUserName());
            user.setUserType(currentUser.getUserType());
            // 设置更新时间
            user.setUpdateTime(new Date());

            boolean success = userService.updateUserSelective(user);
            if (success) {
                // 更新session中的用户信息
                User updatedUser = userService.findById(currentUser.getUserId());
                session.setAttribute("adminUser", updatedUser);
                result.put("success", true);
                result.put("message", "更新成功");
            } else {
                result.put("success", false);
                result.put("message", "更新失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "系统异常：" + e.getMessage());
        }
        return result;
    }

    /**
     * 修改密码
     */
    @PostMapping("/updatePassword")
    @ResponseBody
    public Map<String, Object> updatePassword(String oldPassword, String newPassword, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            User currentUser = (User) session.getAttribute("adminUser");
            if (currentUser == null) {
                result.put("success", false);
                result.put("message", "用户未登录");
                return result;
            }

            // 验证旧密码
            User loginUser = userService.login(currentUser.getUserName(), oldPassword);
            if (loginUser == null) {
                result.put("success", false);
                result.put("message", "旧密码错误");
                return result;
            }

            // 更新密码
            boolean success = userService.resetPassword(currentUser.getUserId(), newPassword);
            if (success) {
                result.put("success", true);
                result.put("message", "密码修改成功");
            } else {
                result.put("success", false);
                result.put("message", "密码修改失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "系统异常：" + e.getMessage());
        }
        return result;
    }

}
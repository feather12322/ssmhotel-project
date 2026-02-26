package com.hotel.controller;

import com.hotel.entity.RoomCategory;
import com.hotel.entity.RoomInfo;
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserLoginController {

    @Autowired
    private UserService userService;

    @Autowired
    private RoomCategoryService roomCategoryService;

    @Autowired
    private RoomInfoService roomInfoService;

    /**
     * 用户登录页面
     */
    @GetMapping("/login")
    public String login() {
        return "user/login";
    }

    /**
     * 用户注册页面
     */
    @GetMapping("/register")
    public String register() {
        return "user/register";
    }

    /**
     * 处理用户登录
     */
    @PostMapping("/doLogin")
    @ResponseBody
    public Map<String, Object> doLogin(String userName, String password, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            User user = userService.login(userName, password);
            if (user != null && user.getUserType() == 0) { // 只允许普通用户登录
                if (user.getStatus() == 0) {
                    result.put("success", false);
                    result.put("message", "账号已被禁用，请联系管理员");
                    return result;
                }

                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                String contextPath = request.getContextPath();
                String redirectUrl = contextPath + "/user/index";
                result.put("success", true);
                result.put("message", "登录成功");
                result.put("redirectUrl", redirectUrl);
            } else {
                result.put("success", false);
                result.put("message", "用户名或密码错误");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "登录失败：" + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 处理用户注册
     */
    @PostMapping("/doRegister")
    @ResponseBody
    public Map<String, Object> doRegister(User user, String confirmPassword) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 验证密码一致性
            if (!user.getPassword().equals(confirmPassword)) {
                result.put("success", false);
                result.put("message", "两次输入的密码不一致");
                return result;
            }

            // 检查用户名是否已存在
            User existingUser = userService.findByUserName(user.getUserName());
            if (existingUser != null) {
                result.put("success", false);
                result.put("message", "用户名已存在");
                return result;
            }

            // 设置用户类型为普通用户
            user.setUserType(0);
            user.setStatus(1); // 默认启用
            user.setCreateTime(new Date());
            user.setUpdateTime(new Date());

            boolean success = userService.createUser(user);
            if (success) {
                result.put("success", true);
                result.put("message", "注册成功，请登录");
            } else {
                result.put("success", false);
                result.put("message", "注册失败，请重试");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "注册失败：" + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 用户退出登录
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/user/login";
    }

    /**
     * 用户首页（登录后跳转）
     */
    @GetMapping("/index")
    public String index(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        // 获取房间分类
        List<RoomCategory> categories = roomCategoryService.findAll();

        // 获取可预订的房间（状态为1:可预订）
        List<RoomInfo> rooms = roomInfoService.findByConditions(null, null, null, null, 1);

        model.addAttribute("user", user);
        model.addAttribute("categories", categories);
        model.addAttribute("rooms", rooms);

        return "user/index";
    }
}
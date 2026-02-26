package com.hotel.controller;

import com.hotel.entity.User;
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
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminLoginController {

    @Autowired
    private UserService userService;

    /**
     * 管理员登录页面
     */
    @GetMapping("/login")
    public String login() {
        return "admin/login";
    }

    /**
     * 处理管理员登录
     */
    @PostMapping("/doLogin")
    @ResponseBody
    public Map<String, Object> doLogin(String userName, String password, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        try {
            User user = userService.login(userName, password);
            if (user != null && user.getUserType() == 1) { // 确保是管理员
                // 登录成功，保存到session
                HttpSession session = request.getSession();
                session.setAttribute("adminUser", user);

                // 获取跳转URL
                String contextPath = request.getContextPath();
                String redirectUrl = contextPath + "/admin/index";

                result.put("success", true);
                result.put("message", "登录成功");
                result.put("redirectUrl", redirectUrl);

                System.out.println("登录成功，用户: " + userName + ", 跳转URL: " + redirectUrl);
            } else {
                result.put("success", false);
                result.put("message", "用户名或密码错误，或不是管理员账户");
                System.out.println("登录失败，用户: " + userName + ", 用户不存在或不是管理员");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "登录失败：" + e.getMessage());
            System.err.println("登录异常: " + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    /**
     * 管理员主页
     */
    @GetMapping("/index")
    public String index(Model model, HttpServletRequest request) {
        HttpSession session = request.getSession();
        User adminUser = (User) session.getAttribute("adminUser");

        System.out.println("访问后台管理页面");
        System.out.println("Session ID: " + session.getId());
        System.out.println("Admin User: " + adminUser);

        // 临时调试：如果没有session，创建一个测试用户
        if (adminUser == null) {
            System.out.println("警告：Session中没有找到管理员信息，创建临时测试用户");
            adminUser = new User();
            adminUser.setUserId(1L);
            adminUser.setUserName("admin");
            adminUser.setRealName("测试管理员");
            adminUser.setUserType(1);

            // 重新设置到session
            session.setAttribute("adminUser", adminUser);
        }

        model.addAttribute("adminUser", adminUser);
        return "admin/index";
    }

    /**
     * 测试后台页面（开发环境使用）
     */
    @GetMapping("/test/index")
    public String testIndex(Model model, HttpServletRequest request) {
        // 创建测试管理员用户
        User testAdmin = new User();
        testAdmin.setUserId(1L);
        testAdmin.setUserName("admin");
        testAdmin.setRealName("测试管理员");
        testAdmin.setUserType(1);

        // 保存到session（仅用于测试）
        HttpSession session = request.getSession();
        session.setAttribute("adminUser", testAdmin);

        model.addAttribute("adminUser", testAdmin);
        return "admin/index";
    }

    /**
     * 退出登录
     */
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession();
        session.invalidate();
        return "redirect:/admin/login";
    }
}
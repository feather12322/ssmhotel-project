package com.hotel.config;

import com.hotel.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminLoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        // 获取请求路径
        String requestURI = request.getRequestURI();

        // 允许访问登录页面和登录接口
        if (requestURI.contains("/admin/login") || requestURI.contains("/admin/doLogin")) {
            return true;
        }

        // 检查管理员登录状态
        HttpSession session = request.getSession();
        User adminUser = (User) session.getAttribute("adminUser");

        if (adminUser == null || adminUser.getUserType() != 1) {
            // 未登录或不是管理员，重定向到登录页面
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return false;
        }

        return true;
    }
}
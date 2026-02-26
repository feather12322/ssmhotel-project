package com.hotel.config;

import com.hotel.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UserLoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        // 获取请求路径
        String requestURI = request.getRequestURI();

        // 允许访问登录页面、注册页面和登录/注册接口
        if (requestURI.contains("/user/login") ||
            requestURI.contains("/user/register") ||
            requestURI.contains("/user/doLogin") ||
            requestURI.contains("/user/doRegister")) {
            return true;
        }

        // 检查用户登录状态
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getUserType() != 0) {
            // 未登录或不是普通用户，重定向到登录页面
            response.sendRedirect(request.getContextPath() + "/user/login");
            return false;
        }

        return true;
    }
}
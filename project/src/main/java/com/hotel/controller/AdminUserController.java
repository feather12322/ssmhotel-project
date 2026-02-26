package com.hotel.controller;

import com.hotel.entity.User;
import com.hotel.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/admin/system/admin")
public class AdminUserController {

    @Autowired
    private UserService userService;

    @GetMapping("/list")
    public String list(@RequestParam(required = false) String userName,
                      @RequestParam(required = false) String realName,
                      @RequestParam(required = false) String phone,
                      @RequestParam(required = false) Integer status,
                      @RequestParam(defaultValue = "1") int page,
                      @RequestParam(defaultValue = "10") int limit,
                      Model model) {
        // 获取分页数据
        List<User> users = userService.findByConditionsPaged(userName, realName, phone, status, 1, page, limit);
        int total = userService.countByConditions(userName, realName, phone, status, 1);

        model.addAttribute("users", users);
        model.addAttribute("total", total);
        model.addAttribute("page", page);
        model.addAttribute("limit", limit);
        model.addAttribute("pages", (int) Math.ceil((double) total / limit));

        // 回显查询条件
        model.addAttribute("searchUserName", userName);
        model.addAttribute("searchRealName", realName);
        model.addAttribute("searchPhone", phone);
        model.addAttribute("searchStatus", status);
        return "admin/system/admin_list";
    }

    @GetMapping("/add")
    public String addForm(Model model) {
        model.addAttribute("user", new User());
        return "admin/system/admin_form";
    }

    @PostMapping("/save")
    @ResponseBody
    public Object save(User user) {
        user.setUserType(1); // admin
        user.setCreateTime(new Date());
        boolean ok = userService.createUser(user);
        return ok ? "{\"success\":true}" : "{\"success\":false}";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, Model model) {
        User u = userService.findById(id);
        model.addAttribute("user", u);
        return "admin/system/admin_form";
    }

    @PostMapping("/update")
    @ResponseBody
    public Object update(User user) {
        user.setUpdateTime(new Date());
        boolean ok = userService.updateUserSelective(user);
        return ok ? "{\"success\":true}" : "{\"success\":false}";
    }

    @PostMapping("/delete")
    @ResponseBody
    public Object delete(Long userId) {
        boolean ok = userService.deleteUser(userId);
        return ok ? "{\"success\":true}" : "{\"success\":false}";
    }

    @PostMapping("/resetPassword")
    @ResponseBody
    public Object resetPassword(Long userId) {
        boolean ok = userService.resetPassword(userId, "123456");
        return ok ? "{\"success\":true}" : "{\"success\":false}";
    }
}


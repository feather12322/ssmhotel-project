package com.hotel.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 系统诊断控制器
 */
@Controller
public class DiagnoseController {

    /**
     * 系统诊断页面
     */
    @GetMapping("/diagnose")
    public String diagnose() {
        return "diagnose";
    }
}
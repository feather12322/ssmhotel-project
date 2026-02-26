package com.hotel.controller;

import com.hotel.entity.RoomCategory;
import com.hotel.service.RoomCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.math.BigDecimal;

@Controller
@RequestMapping("/admin/room/category")
public class RoomCategoryController {

    @Autowired
    private RoomCategoryService roomCategoryService;

    @Value("${upload.path}")
    private String uploadBasePath;

    @GetMapping("/list")
    public String list(@RequestParam(required = false) String categoryName,
                      @RequestParam(required = false) BigDecimal priceMin,
                      @RequestParam(required = false) BigDecimal priceMax,
                      @RequestParam(defaultValue = "1") int page,
                      @RequestParam(defaultValue = "10") int limit,
                      Model model) {
        // 获取分页数据
        List<RoomCategory> categories = roomCategoryService.findByConditionsPaged(categoryName, priceMin, priceMax, page, limit);
        int total = roomCategoryService.countByConditions(categoryName, priceMin, priceMax);

        model.addAttribute("categories", categories);
        model.addAttribute("total", total);
        model.addAttribute("page", page);
        model.addAttribute("limit", limit);
        model.addAttribute("pages", (int) Math.ceil((double) total / limit));

        // 回显查询条件
        model.addAttribute("searchCategoryName", categoryName);
        model.addAttribute("searchPriceMin", priceMin);
        model.addAttribute("searchPriceMax", priceMax);
        return "admin/room/category_list";
    }

    @GetMapping("/add")
    public String addForm(Model model) {
        model.addAttribute("category", new RoomCategory());
        return "admin/room/category_form";
    }

    @PostMapping("/save")
    @ResponseBody
    public Object save(RoomCategory category) {
        // 设置默认值
        if (category.getStatus() == null) {
            category.setStatus(1); // 默认启用
        }
        if (category.getCreateTime() == null) {
            category.setCreateTime(new java.util.Date());
        }
        if (category.getSort() == null) {
            category.setSort(0); // 默认排序
        }
        
        boolean ok = roomCategoryService.create(category);
        return ok ? "{\"success\":true}" : "{\"success\":false}";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Long id, Model model) {
        RoomCategory category = roomCategoryService.findById(id);
        model.addAttribute("category", category);
        return "admin/room/category_form";
    }

    @PostMapping("/update")
    @ResponseBody
    public Object update(RoomCategory category) {
        // 设置更新时间
        category.setUpdateTime(new java.util.Date());
        
        boolean ok = roomCategoryService.update(category);
        return ok ? "{\"success\":true}" : "{\"success\":false}";
    }

    @PostMapping("/delete")
    @ResponseBody
    public Object delete(Long categoryId) {
        boolean ok = roomCategoryService.deleteById(categoryId);
        return ok ? "{\"success\":true}" : "{\"success\":false}";
    }

    @PostMapping("/uploadImage")
    @ResponseBody
    public Object uploadImage(@RequestParam("file") MultipartFile file, HttpServletRequest request) {
        if (file == null || file.isEmpty()) {
            return java.util.Collections.singletonMap("success", false);
        }
        try {
            // store to external upload path configured in db.properties -> upload.path
            String imagesDir = uploadBasePath;
            if (imagesDir == null || imagesDir.trim().isEmpty()) {
                imagesDir = request.getServletContext().getRealPath("/images/categories");
            }
            java.io.File dir = new java.io.File(imagesDir, "categories");
            if (!dir.exists()) dir.mkdirs();

            String original = file.getOriginalFilename();
            String ext = "";
            if (original != null && original.contains(".")) {
                ext = original.substring(original.lastIndexOf('.'));
            }
            String filename = System.currentTimeMillis() + "_" + java.util.UUID.randomUUID().toString().replaceAll("-", "") + ext;
            java.io.File target = new java.io.File(dir, filename);
            file.transferTo(target);

            String contextPath = request.getContextPath();
            // expose via /uploads/** mapping configured in spring-mvc.xml
            String url = contextPath + "/uploads/categories/" + filename;

            java.util.Map<String, Object> result = new java.util.HashMap<>();
            result.put("success", true);
            result.put("url", url);
            result.put("filename", filename);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return java.util.Collections.singletonMap("success", false);
        }
    }

    @PostMapping("/deleteImage")
    @ResponseBody
    public Object deleteImage(String imageUrl, HttpServletRequest request) {
        try {
            if (imageUrl != null && imageUrl.contains("/uploads/categories/")) {
                String filename = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
                String imagesDir = uploadBasePath;
                if (imagesDir == null || imagesDir.trim().isEmpty()) {
                    imagesDir = request.getServletContext().getRealPath("/images/categories");
                }
                java.io.File file = new java.io.File(imagesDir, "categories/" + filename);
                if (file.exists()) {
                    file.delete();
                }
            }
            return java.util.Collections.singletonMap("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            return java.util.Collections.singletonMap("success", false);
        }
    }
}


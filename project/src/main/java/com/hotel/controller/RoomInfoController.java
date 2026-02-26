package com.hotel.controller;

import com.hotel.entity.RoomInfo;
import com.hotel.service.RoomInfoService;
import com.hotel.service.RoomCategoryService;
import com.hotel.entity.RoomCategory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.math.BigDecimal;

@Controller
@RequestMapping("/admin/room")
public class RoomInfoController {

    @Autowired
    private RoomInfoService roomInfoService;

    @Autowired
    private RoomCategoryService roomCategoryService;

    @GetMapping("/list")
    public String list(@RequestParam(required = false) String roomNo,
                      @RequestParam(required = false) Long categoryId,
                      @RequestParam(required = false) BigDecimal priceMin,
                      @RequestParam(required = false) BigDecimal priceMax,
                      @RequestParam(required = false) Integer roomStatus,
                      @RequestParam(defaultValue = "1") int page,
                      @RequestParam(defaultValue = "10") int limit,
                      Model model) {
        // 获取分页数据
        List<RoomInfo> rooms = roomInfoService.findByConditionsPaged(roomNo, categoryId, priceMin, priceMax, roomStatus, page, limit);
        int total = roomInfoService.countByConditions(roomNo, categoryId, priceMin, priceMax, roomStatus);

        List<RoomCategory> categories = roomCategoryService.findAll();
        model.addAttribute("rooms", rooms);
        model.addAttribute("categories", categories);
        model.addAttribute("total", total);
        model.addAttribute("page", page);
        model.addAttribute("limit", limit);
        model.addAttribute("pages", (int) Math.ceil((double) total / limit));

        // 回显查询条件
        model.addAttribute("searchRoomNo", roomNo);
        model.addAttribute("searchCategoryId", categoryId);
        model.addAttribute("searchPriceMin", priceMin);
        model.addAttribute("searchPriceMax", priceMax);
        model.addAttribute("searchRoomStatus", roomStatus);
        return "admin/room/list";
    }

    @GetMapping("/add")
    public String addForm(Model model) {
        model.addAttribute("room", new RoomInfo());
        model.addAttribute("categories", roomCategoryService.findAll());
        return "admin/room/form";
    }

    @PostMapping("/save")
    @ResponseBody
    public Object save(RoomInfo room) {
        // 设置默认值
        if (room.getRoomStatus() == null) {
            room.setRoomStatus(1); // 默认可预订
        }
        if (room.getCreateTime() == null) {
            room.setCreateTime(new java.util.Date());
        }
        if (room.getUpdateTime() == null) {
            room.setUpdateTime(new java.util.Date());
        }
        boolean ok = roomInfoService.create(room);
        return ok ? "{\"success\":true}" : "{\"success\":false}";
    }

    /**
     * 上传房间图片（封面或详情图片），返回图片访问路径
     */
    @Value("${upload.path}")
    private String uploadBasePath;

    @PostMapping("/uploadImage")
    @ResponseBody
    public Object uploadImage(@RequestParam("file") org.springframework.web.multipart.MultipartFile file,
                              HttpServletRequest request) {
        if (file == null || file.isEmpty()) {
            return java.util.Collections.singletonMap("success", false);
        }
        try {
            // store to external upload path configured in db.properties -> upload.path
            String imagesDir = uploadBasePath;
            if (imagesDir == null || imagesDir.trim().isEmpty()) {
                imagesDir = request.getServletContext().getRealPath("/images/rooms");
            }
            java.io.File dir = new java.io.File(imagesDir, "rooms");
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
            String url = contextPath + "/uploads/rooms/" + filename;
            java.util.Map<String,Object> res = new java.util.HashMap<>();
            res.put("success", true);
            res.put("url", url);
            return res;
        } catch (Exception e) {
            e.printStackTrace();
            return java.util.Collections.singletonMap("success", false);
        }
    }

    /**
     * 删除已上传的图片（根据 URL 中的文件名删除外部目录文件）
     */
    @PostMapping("/deleteImage")
    @ResponseBody
    public Object deleteImage(@RequestParam("url") String url, HttpServletRequest request) {
        if (url == null || url.trim().isEmpty()) {
            return java.util.Collections.singletonMap("success", false);
        }
        try {
            // url 形如: contextPath + /uploads/rooms/filename
            String filename = url.substring(url.lastIndexOf('/') + 1);
            if (filename == null || filename.trim().isEmpty()) {
                return java.util.Collections.singletonMap("success", false);
            }
            String base = uploadBasePath;
            if (base == null || base.trim().isEmpty()) {
                base = request.getServletContext().getRealPath("/images/rooms");
            }
            java.io.File f = new java.io.File(new java.io.File(base, "rooms"), filename);
            boolean ok = false;
            if (f.exists() && f.isFile()) {
                ok = f.delete();
            }
            return java.util.Collections.singletonMap("success", ok);
        } catch (Exception e) {
            e.printStackTrace();
            return java.util.Collections.singletonMap("success", false);
        }
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Long id, Model model) {
        RoomInfo room = roomInfoService.findById(id);
        model.addAttribute("room", room);
        model.addAttribute("categories", roomCategoryService.findAll());
        return "admin/room/form";
    }

    @PostMapping("/update")
    @ResponseBody
    public Object update(RoomInfo room) {
        boolean ok = roomInfoService.update(room);
        return ok ? "{\"success\":true}" : "{\"success\":false}";
    }

    @PostMapping("/delete")
    @ResponseBody
    public Object delete(Long roomId) {
        boolean ok = roomInfoService.deleteById(roomId);
        return ok ? "{\"success\":true}" : "{\"success\":false}";
    }
}


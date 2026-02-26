package com.hotel.entity;

import lombok.Data;
import java.util.Date;

@Data
public class User {
    private Long userId;
    private String userName;
    private String password;
    private String realName;
    private String phone;
    private String email;
    private String avatar;
    private Integer userType; // 0-前端普通用户/会员 1-后台管理员
    private Integer status;   // 0-禁用 1-正常
    private Date createTime;
    private Date updateTime;
    private String remark;
}
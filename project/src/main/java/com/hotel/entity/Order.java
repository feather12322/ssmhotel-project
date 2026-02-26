package com.hotel.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

@Data
public class Order {
    private Long orderId;
    private String orderNo;        // 订单号
    private Long userId;          // 用户ID
    private String userName;       // 用户名（关联查询字段）
    private Long roomId;          // 房间ID
    private Long categoryId;      // 房间分类ID
    private String guestName;     // 入住人姓名
    private String phone;         // 联系电话
    private Date checkInDate;     // 入住日期
    private Date checkOutDate;    // 退房日期
    private Integer stayDays;     // 入住天数
    private BigDecimal roomPrice; // 房间单价
    private BigDecimal totalPrice; // 订单总价
    private Integer orderStatus;  // 订单状态 (0:待确认, 1:已确认, 2:已入住, 3:已完成, 4:已取消)
    private String specialRequests; // 特殊要求
    private String cancelReason;  // 取消原因
    private Date createTime;      // 创建时间
    private Date updateTime;      // 更新时间
    private String remark;        // 备注
}
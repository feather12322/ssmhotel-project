package com.hotel.entity;

import lombok.Data;
import java.util.Date;

@Data
public class RoomCategory {
    private Long categoryId;
    private String categoryName;
    private String description;
    private Double priceMin;
    private Double priceMax;
    private String coverImg;
    private Integer sort;
    private Integer status;
    private Date createTime;
    private Date updateTime;
    private String remark;
}


package com.hotel.entity;

import lombok.Data;
import java.util.Date;

@Data
public class RoomInfo {
    private Long roomId;
    private Long categoryId;
    private String roomNo;
    private Double area;
    private String bedType;
    private Double price;
    private String facilities;
    private String coverImg;
    private String detailImgs;
    private Integer roomStatus;
    private Date createTime;
    private Date updateTime;
    private String remark;
}


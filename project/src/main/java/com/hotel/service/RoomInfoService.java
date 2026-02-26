package com.hotel.service;

import com.hotel.entity.RoomInfo;
import java.util.List;
import java.math.BigDecimal;

public interface RoomInfoService {
    RoomInfo findById(Long roomId);
    List<RoomInfo> findAll();
    List<RoomInfo> findByCategoryId(Long categoryId);
    List<RoomInfo> findByConditions(String roomNo, Long categoryId, BigDecimal priceMin, BigDecimal priceMax, Integer roomStatus);
    List<RoomInfo> findByConditionsPaged(String roomNo, Long categoryId, BigDecimal priceMin, BigDecimal priceMax, Integer roomStatus, int pageNum, int pageSize);
    int countByConditions(String roomNo, Long categoryId, BigDecimal priceMin, BigDecimal priceMax, Integer roomStatus);
    boolean create(RoomInfo roomInfo);
    boolean update(RoomInfo roomInfo);
    boolean deleteById(Long roomId);
}


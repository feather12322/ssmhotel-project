package com.hotel.service;

import com.hotel.entity.RoomCategory;
import java.util.List;
import java.math.BigDecimal;

public interface RoomCategoryService {
    RoomCategory findById(Long categoryId);
    List<RoomCategory> findAll();
    List<RoomCategory> findByConditions(String categoryName, BigDecimal priceMin, BigDecimal priceMax);
    List<RoomCategory> findByConditionsPaged(String categoryName, BigDecimal priceMin, BigDecimal priceMax, int pageNum, int pageSize);
    int countByConditions(String categoryName, BigDecimal priceMin, BigDecimal priceMax);
    boolean create(RoomCategory category);
    boolean update(RoomCategory category);
    boolean deleteById(Long categoryId);
}


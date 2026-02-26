package com.hotel.dao;

import com.hotel.entity.RoomCategory;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.math.BigDecimal;

public interface RoomCategoryDao {
    RoomCategory findById(@Param("categoryId") Long categoryId);
    List<RoomCategory> findAll();
    List<RoomCategory> findByConditions(@Param("categoryName") String categoryName,
                                       @Param("priceMin") BigDecimal priceMin,
                                       @Param("priceMax") BigDecimal priceMax);
    List<RoomCategory> findByConditionsPaged(@Param("categoryName") String categoryName,
                                           @Param("priceMin") BigDecimal priceMin,
                                           @Param("priceMax") BigDecimal priceMax,
                                           @Param("offset") int offset,
                                           @Param("pageSize") int pageSize);
    int countByConditions(@Param("categoryName") String categoryName,
                         @Param("priceMin") BigDecimal priceMin,
                         @Param("priceMax") BigDecimal priceMax);
    int insert(RoomCategory category);
    int update(RoomCategory category);
    int updateSelective(RoomCategory category);
    int deleteById(@Param("categoryId") Long categoryId);
}


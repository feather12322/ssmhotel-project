package com.hotel.dao;

import com.hotel.entity.RoomInfo;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.math.BigDecimal;

public interface RoomInfoDao {
    RoomInfo findById(@Param("roomId") Long roomId);
    List<RoomInfo> findByCategoryId(@Param("categoryId") Long categoryId);
    List<RoomInfo> findAll();
    List<RoomInfo> findByConditions(@Param("roomNo") String roomNo,
                                   @Param("categoryId") Long categoryId,
                                   @Param("priceMin") BigDecimal priceMin,
                                   @Param("priceMax") BigDecimal priceMax,
                                   @Param("roomStatus") Integer roomStatus);
    List<RoomInfo> findByConditionsPaged(@Param("roomNo") String roomNo,
                                       @Param("categoryId") Long categoryId,
                                       @Param("priceMin") BigDecimal priceMin,
                                       @Param("priceMax") BigDecimal priceMax,
                                       @Param("roomStatus") Integer roomStatus,
                                       @Param("offset") int offset,
                                       @Param("pageSize") int pageSize);
    int countByConditions(@Param("roomNo") String roomNo,
                         @Param("categoryId") Long categoryId,
                         @Param("priceMin") BigDecimal priceMin,
                         @Param("priceMax") BigDecimal priceMax,
                         @Param("roomStatus") Integer roomStatus);
    int insert(RoomInfo roomInfo);
    int update(RoomInfo roomInfo);
    int updateSelective(RoomInfo roomInfo);
    int deleteById(@Param("roomId") Long roomId);
}


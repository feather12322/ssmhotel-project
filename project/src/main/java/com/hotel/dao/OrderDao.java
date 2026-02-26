package com.hotel.dao;

import com.hotel.entity.Order;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderDao {
    Order findById(@Param("orderId") Long orderId);
    Order findByOrderNo(@Param("orderNo") String orderNo);
    List<Order> findByUserId(@Param("userId") Long userId);
    List<Order> findByUserIdPaged(@Param("userId") Long userId,
                                  @Param("offset") int offset,
                                  @Param("limit") int limit);
    int countByUserId(@Param("userId") Long userId);
    List<Order> findByUserIdAndStatus(@Param("userId") Long userId,
                                      @Param("status") int status,
                                      @Param("offset") int offset,
                                      @Param("limit") int limit);
    int countByUserIdAndStatus(@Param("userId") Long userId,
                               @Param("status") int status);
    List<Order> findAll();
    List<Order> findPageByConditions(@Param("orderNo") String orderNo,
                                    @Param("guestName") String guestName,
                                    @Param("phone") String phone,
                                    @Param("userName") String userName,
                                    @Param("orderStatus") Integer orderStatus,
                                    @Param("offset") int offset,
                                    @Param("limit") int limit);
    int countByConditions(@Param("orderNo") String orderNo,
                         @Param("guestName") String guestName,
                         @Param("phone") String phone,
                         @Param("userName") String userName,
                         @Param("orderStatus") Integer orderStatus);
    int insert(Order order);
    int update(Order order);
    int updateSelective(Order order);
    int deleteById(@Param("orderId") Long orderId);
}
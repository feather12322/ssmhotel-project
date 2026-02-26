package com.hotel.service;

import com.hotel.entity.Order;

import java.util.List;

public interface OrderService {
    Order findById(Long orderId);
    Order findByOrderNo(String orderNo);
    List<Order> findByUserId(Long userId);
    List<Order> findByUserIdPaged(Long userId, int offset, int limit);
    int countByUserId(Long userId);
    List<Order> findByUserIdAndStatus(Long userId, int status, int offset, int limit);
    int countByUserIdAndStatus(Long userId, int status);
    List<Order> findAll();
    List<Order> findPageByConditions(String orderNo, String guestName, String phone,
                                   String userName, Integer orderStatus, int offset, int limit);
    int countByConditions(String orderNo, String guestName, String phone,
                         String userName, Integer orderStatus);
    boolean create(Order order);
    boolean update(Order order);
    boolean updateSelective(Order order);
    boolean deleteById(Long orderId);
}
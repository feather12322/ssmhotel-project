package com.hotel.service.impl;

import com.hotel.dao.OrderDao;
import com.hotel.entity.Order;
import com.hotel.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao orderDao;

    @Override
    public Order findById(Long orderId) {
        return orderDao.findById(orderId);
    }

    @Override
    public Order findByOrderNo(String orderNo) {
        return orderDao.findByOrderNo(orderNo);
    }

    @Override
    public List<Order> findByUserId(Long userId) {
        return orderDao.findByUserId(userId);
    }

    @Override
    public List<Order> findByUserIdPaged(Long userId, int offset, int limit) {
        return orderDao.findByUserIdPaged(userId, offset, limit);
    }

    @Override
    public int countByUserId(Long userId) {
        return orderDao.countByUserId(userId);
    }

    @Override
    public List<Order> findByUserIdAndStatus(Long userId, int status, int offset, int limit) {
        return orderDao.findByUserIdAndStatus(userId, status, offset, limit);
    }

    @Override
    public int countByUserIdAndStatus(Long userId, int status) {
        return orderDao.countByUserIdAndStatus(userId, status);
    }

    @Override
    public List<Order> findAll() {
        return orderDao.findAll();
    }

    @Override
    public List<Order> findPageByConditions(String orderNo, String guestName, String phone,
                                          String userName, Integer orderStatus, int offset, int limit) {
        return orderDao.findPageByConditions(orderNo, guestName, phone, userName, orderStatus, offset, limit);
    }

    @Override
    public int countByConditions(String orderNo, String guestName, String phone,
                                String userName, Integer orderStatus) {
        return orderDao.countByConditions(orderNo, guestName, phone, userName, orderStatus);
    }

    @Override
    public boolean create(Order order) {
        return orderDao.insert(order) > 0;
    }

    @Override
    public boolean update(Order order) {
        return orderDao.updateSelective(order) > 0;
    }

    @Override
    public boolean updateSelective(Order order) {
        return orderDao.updateSelective(order) > 0;
    }

    @Override
    public boolean deleteById(Long orderId) {
        return orderDao.deleteById(orderId) > 0;
    }
}
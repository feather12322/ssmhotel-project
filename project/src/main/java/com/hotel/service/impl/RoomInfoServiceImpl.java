package com.hotel.service.impl;

import com.hotel.dao.RoomInfoDao;
import com.hotel.entity.RoomInfo;
import com.hotel.service.RoomInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.math.BigDecimal;

@Service
@Transactional
public class RoomInfoServiceImpl implements RoomInfoService {

    @Autowired
    private RoomInfoDao roomInfoDao;

    @Override
    public RoomInfo findById(Long roomId) {
        return roomInfoDao.findById(roomId);
    }

    @Override
    public List<RoomInfo> findAll() {
        return roomInfoDao.findAll();
    }

    @Override
    public List<RoomInfo> findByCategoryId(Long categoryId) {
        return roomInfoDao.findByCategoryId(categoryId);
    }

    @Override
    public List<RoomInfo> findByConditions(String roomNo, Long categoryId, BigDecimal priceMin, BigDecimal priceMax, Integer roomStatus) {
        return roomInfoDao.findByConditions(roomNo, categoryId, priceMin, priceMax, roomStatus);
    }

    @Override
    public List<RoomInfo> findByConditionsPaged(String roomNo, Long categoryId, BigDecimal priceMin, BigDecimal priceMax, Integer roomStatus, int pageNum, int pageSize) {
        int offset = (pageNum - 1) * pageSize;
        return roomInfoDao.findByConditionsPaged(roomNo, categoryId, priceMin, priceMax, roomStatus, offset, pageSize);
    }

    @Override
    public int countByConditions(String roomNo, Long categoryId, BigDecimal priceMin, BigDecimal priceMax, Integer roomStatus) {
        return roomInfoDao.countByConditions(roomNo, categoryId, priceMin, priceMax, roomStatus);
    }

    @Override
    public boolean create(RoomInfo roomInfo) {
        return roomInfoDao.insert(roomInfo) > 0;
    }

    @Override
    public boolean update(RoomInfo roomInfo) {
        return roomInfoDao.updateSelective(roomInfo) > 0;
    }

    @Override
    public boolean deleteById(Long roomId) {
        return roomInfoDao.deleteById(roomId) > 0;
    }
}


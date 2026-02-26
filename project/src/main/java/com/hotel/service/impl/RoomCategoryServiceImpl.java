package com.hotel.service.impl;

import com.hotel.dao.RoomCategoryDao;
import com.hotel.entity.RoomCategory;
import com.hotel.service.RoomCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.math.BigDecimal;

@Service
@Transactional
public class RoomCategoryServiceImpl implements RoomCategoryService {

    @Autowired
    private RoomCategoryDao roomCategoryDao;

    @Override
    public RoomCategory findById(Long categoryId) {
        return roomCategoryDao.findById(categoryId);
    }

    @Override
    public List<RoomCategory> findAll() {
        return roomCategoryDao.findAll();
    }

    @Override
    public List<RoomCategory> findByConditions(String categoryName, BigDecimal priceMin, BigDecimal priceMax) {
        return roomCategoryDao.findByConditions(categoryName, priceMin, priceMax);
    }

    @Override
    public List<RoomCategory> findByConditionsPaged(String categoryName, BigDecimal priceMin, BigDecimal priceMax, int pageNum, int pageSize) {
        int offset = (pageNum - 1) * pageSize;
        return roomCategoryDao.findByConditionsPaged(categoryName, priceMin, priceMax, offset, pageSize);
    }

    @Override
    public int countByConditions(String categoryName, BigDecimal priceMin, BigDecimal priceMax) {
        return roomCategoryDao.countByConditions(categoryName, priceMin, priceMax);
    }

    @Override
    public boolean create(RoomCategory category) {
        return roomCategoryDao.insert(category) > 0;
    }

    @Override
    public boolean update(RoomCategory category) {
        return roomCategoryDao.updateSelective(category) > 0;
    }

    @Override
    public boolean deleteById(Long categoryId) {
        return roomCategoryDao.deleteById(categoryId) > 0;
    }
}


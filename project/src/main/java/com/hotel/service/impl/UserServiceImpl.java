package com.hotel.service.impl;

import com.hotel.dao.UserDao;
import com.hotel.entity.User;
import com.hotel.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public User login(String userName, String password) {
        return userDao.findByUserNameAndPassword(userName, password);
    }

    @Override
    public User findByUserName(String userName) {
        return userDao.findByUserName(userName);
    }

    @Override
    public User findById(Long userId) {
        return userDao.findById(userId);
    }

    @Override
    public boolean updateUser(User user) {
        return userDao.update(user) > 0;
    }

    @Override
    public boolean updateUserSelective(User user) {
        return userDao.updateSelective(user) > 0;
    }

    @Override
    public java.util.List<User> findAll() {
        return userDao.findAll();
    }

    @Override
    public java.util.List<User> findByUserType(int userType) {
        return userDao.findByUserType(userType);
    }

    @Override
    public java.util.List<User> findByConditions(String userName, String realName, String phone, Integer status, int userType) {
        return userDao.findByConditions(userName, realName, phone, status, userType);
    }

    @Override
    public java.util.List<User> findByConditionsPaged(String userName, String realName, String phone, Integer status, int userType, int pageNum, int pageSize) {
        int offset = (pageNum - 1) * pageSize;
        return userDao.findByConditionsPaged(userName, realName, phone, status, userType, offset, pageSize);
    }

    @Override
    public int countByConditions(String userName, String realName, String phone, Integer status, int userType) {
        return userDao.countByConditions(userName, realName, phone, status, userType);
    }

    @Override
    public boolean createUser(User user) {
        return userDao.insert(user) > 0;
    }

    @Override
    public boolean deleteUser(Long userId) {
        return userDao.deleteById(userId) > 0;
    }

    @Override
    public boolean resetPassword(Long userId, String newPassword) {
        User u = userDao.findById(userId);
        if (u == null) return false;
        u.setPassword(newPassword);
        u.setUpdateTime(new java.util.Date());
        return userDao.update(u) > 0;
    }
}
package com.hotel.service;

import com.hotel.entity.User;

public interface UserService {
    /**
     * 用户登录
     * @param userName 用户名
     * @param password 密码
     * @return 用户信息
     */
    User login(String userName, String password);

    /**
     * 根据用户名查询用户
     * @param userName 用户名
     * @return 用户信息
     */
    User findByUserName(String userName);

    /**
     * 根据ID查询用户
     * @param userId 用户ID
     * @return 用户信息
     */
    User findById(Long userId);

    /**
     * 更新用户信息
     * @param user 用户信息
     * @return 更新结果
     */
    boolean updateUser(User user);

    /**
     * 选择性更新用户信息（只更新非null字段）
     * @param user 用户信息
     * @return 更新结果
     */
    boolean updateUserSelective(User user);
    
    /**
     * 查询所有用户
     */
    java.util.List<User> findAll();

    /**
     * 根据用户类型查询用户
     * @param userType 用户类型 (0:普通会员, 1:管理员)
     * @return 用户列表
     */
    java.util.List<User> findByUserType(int userType);

    /**
     * 根据条件查询用户
     * @param userName 用户名
     * @param realName 真实姓名
     * @param phone 手机号
     * @param status 状态
     * @param userType 用户类型
     * @return 用户列表
     */
    java.util.List<User> findByConditions(String userName, String realName, String phone, Integer status, int userType);

    /**
     * 根据条件分页查询用户
     * @param userName 用户名
     * @param realName 真实姓名
     * @param phone 手机号
     * @param status 状态
     * @param userType 用户类型
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @return 用户列表
     */
    java.util.List<User> findByConditionsPaged(String userName, String realName, String phone, Integer status, int userType, int pageNum, int pageSize);

    /**
     * 根据条件统计用户数量
     * @param userName 用户名
     * @param realName 真实姓名
     * @param phone 手机号
     * @param status 状态
     * @param userType 用户类型
     * @return 用户数量
     */
    int countByConditions(String userName, String realName, String phone, Integer status, int userType);

    /**
     * 创建用户
     */
    boolean createUser(User user);

    /**
     * 删除用户
     */
    boolean deleteUser(Long userId);

    /**
     * 重置用户密码
     */
    boolean resetPassword(Long userId, String newPassword);
}
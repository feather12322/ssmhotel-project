package com.hotel.dao;

import com.hotel.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserDao {
    /**
     * 根据用户名查询用户
     */
    User findByUserName(@Param("userName") String userName);

    /**
     * 根据用户名和密码查询用户（登录验证）
     */
    User findByUserNameAndPassword(@Param("userName") String userName, @Param("password") String password);

    /**
     * 根据用户ID查询用户
     */
    User findById(@Param("userId") Long userId);

    /**
     * 插入用户
     */
    int insert(User user);

    /**
     * 更新用户
     */
    int update(User user);

    /**
     * 选择性更新用户（只更新非null字段）
     */
    int updateSelective(User user);
    
    /**
     * 删除用户（物理删除）
     */
    int deleteById(@Param("userId") Long userId);

    /**
     * 查询所有用户
     */
    List<User> findAll();

    /**
     * 根据用户类型查询用户
     * @param userType 用户类型 (0:普通会员, 1:管理员)
     * @return 用户列表
     */
    List<User> findByUserType(@Param("userType") int userType);

    /**
     * 根据条件查询用户
     * @param userName 用户名
     * @param realName 真实姓名
     * @param phone 手机号
     * @param status 状态
     * @param userType 用户类型
     * @return 用户列表
     */
    List<User> findByConditions(@Param("userName") String userName,
                               @Param("realName") String realName,
                               @Param("phone") String phone,
                               @Param("status") Integer status,
                               @Param("userType") int userType);

    /**
     * 根据条件分页查询用户
     * @param userName 用户名
     * @param realName 真实姓名
     * @param phone 手机号
     * @param status 状态
     * @param userType 用户类型
     * @param offset 偏移量
     * @param pageSize 每页大小
     * @return 用户列表
     */
    List<User> findByConditionsPaged(@Param("userName") String userName,
                                   @Param("realName") String realName,
                                   @Param("phone") String phone,
                                   @Param("status") Integer status,
                                   @Param("userType") int userType,
                                   @Param("offset") int offset,
                                   @Param("pageSize") int pageSize);

    /**
     * 根据条件统计用户数量
     * @param userName 用户名
     * @param realName 真实姓名
     * @param phone 手机号
     * @param status 状态
     * @param userType 用户类型
     * @return 用户数量
     */
    int countByConditions(@Param("userName") String userName,
                         @Param("realName") String realName,
                         @Param("phone") String phone,
                         @Param("status") Integer status,
                         @Param("userType") int userType);
}
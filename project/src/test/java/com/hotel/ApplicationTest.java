package com.hotel;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Spring上下文测试类
 * 用于验证Spring配置是否正确
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "classpath:spring-mvc.xml"})
public class ApplicationTest {

    @Test
    public void testContextLoad() {
        // 如果Spring上下文能正常加载，此测试就会通过
        System.out.println("Spring上下文加载成功！");
    }
}
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>操作日志</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
    <style>
        .container { padding: 20px; }
        .log-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 20px;
        }
        .log-section h3 {
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #009688;
            padding-bottom: 10px;
        }
        .log-item {
            padding: 15px;
            border-left: 4px solid #009688;
            margin-bottom: 15px;
            background: #f8f9fa;
            border-radius: 6px;
        }
        .log-time {
            color: #666;
            font-size: 12px;
            margin-bottom: 5px;
        }
        .log-action {
            font-weight: 500;
            color: #333;
            margin-bottom: 5px;
        }
        .log-details {
            color: #777;
            font-size: 14px;
        }
        .no-logs {
            text-align: center;
            color: #999;
            padding: 40px;
            font-size: 16px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="log-section">
        <h3><i class="fas fa-history" style="margin-right: 10px;"></i>操作日志</h3>

        <c:choose>
            <c:when test="${not empty logs}">
                <c:forEach var="log" items="${logs}">
                    <div class="log-item">
                        <div class="log-time">
                            <fmt:formatDate value="${log.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </div>
                        <div class="log-action">${log.action}</div>
                        <div class="log-details">${log.details}</div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="no-logs">
                    <i class="fas fa-info-circle" style="font-size: 48px; color: #ddd; margin-bottom: 15px;"></i>
                    <p>暂无操作日志</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
</body>
</html>
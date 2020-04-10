<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Vector" %><%--
  Created by IntelliJ IDEA.
  User: seanliu
  Date: 10/4/2020
  Time: 2:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<html>
<head>
    <title>WebCrawler</title>
    <%@ page isELIgnored="false" %>
</head>
<body>
    <h1>Retrived Words</h1>
    <h2>${words}</h2>
    <h1>Retrived Linkss</h1>
    <h2>${links}</h2>
</body>
</html>

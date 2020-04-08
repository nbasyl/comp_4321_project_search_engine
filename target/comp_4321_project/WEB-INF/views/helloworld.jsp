<%--
  Created by IntelliJ IDEA.
  User: seanliu
  Date: 8/4/2020
  Time: 7:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Spring 4 MVC -HelloWorld</title>
    <%@ page isELIgnored="false" %>
</head>
<body>
<center>
    <h2>Hello World</h2>
    <h2>${message} ${name}</h2>
    <% java.util.Date date = new java.util.Date(); %>

    Hello!  The time is now <%= date %> <br>


    <%!
        String print_hour(Date date)
        {
            return "It is now "+date.getHours()%12+" o\'clock<BR>" ;
        }
    %>

    <%=print_hour(date)%>

    <%
        out.println( "<BR>Your machine's address is " );
        out.println( request.getRemoteHost());
    %>
</center>
</body>
</html>
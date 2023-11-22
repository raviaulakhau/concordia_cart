<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.shashi.service.impl.*,
                 com.shashi.service.*,
                 com.shashi.beans.*,
                 java.util.*,
                 javax.servlet.ServletOutputStream,
                 java.io.*"%>

<!DOCTYPE html>
<html>
<head>
    <title>Products Less Than Three</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

    <style>
        body {
            background-color: #D8BFD8;
        }
        img {
            height: 150px;
            max-width: 180px;
        }
    </style>
</head>
<body>
    <%
        String userType = (String) session.getAttribute("usertype");
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");
        } else if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
        }
    %>

    <jsp:include page="header.jsp" />

    <style>
    .product-table {
        width: 100%;
        margin: 20px 0;
        border-collapse: collapse;
    }
    .product-table th, .product-table td {
        border: 1px solid #e0e0e0;
        padding: 8px 15px;
        text-align: left;
    }
    .product-table th {
        background-color: #f5f5f5;
        font-weight: bold;
    }
    .product-table img {
        width: 100px;  /* or whatever you prefer */
        height: auto;
        max-width: 100%;
    }
</style>

<table class="product-table">
    <thead>
        <tr>
            <th>Product ID</th>
            <th>Image</th>
            <th>Name</th>
            <th>Type</th>
            <th>Info</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Rating</th>
        </tr>
    </thead>
    <tbody>
        <% 
           ProductServiceImpl prodDao = new ProductServiceImpl();
           List<ProductBean> lowQuantityProducts = prodDao.getProductLessThanThree();
           for(ProductBean product : lowQuantityProducts) { 
        %>
            <tr>
                <td><%= product.getProdId() %></td>
                <td><img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"></td>
                <td><%= product.getProdName() %></td>
                <td><%= product.getProdType() %></td>
                <td><%= product.getProdInfo() %></td>
                <td><%= product.getProdPrice() %></td>
                <td><%= product.getProdQuantity() %></td>
                <td><%= product.getRating() %></td>
            </tr>
        <% 
           } 
        %>
    </tbody>
</table>
    

    <%@ include file="footer.html"%>
</body>
</html>


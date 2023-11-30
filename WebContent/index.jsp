<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Concordia Cart</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <style>
        .thumbnail {
            animation: fadeIn 1s;
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
    </style>
</head>
<body style="background-color: #D8BFD8;">

<%
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");
    String userType = (String) session.getAttribute("usertype");
    boolean isValidUser = true;

    if (userType == null || userName == null || password == null || !userType.equals("customer")) {
        isValidUser = false;
    }

    ProductServiceImpl prodDao = new ProductServiceImpl();
    List<ProductBean> products = new ArrayList<ProductBean>();

    String search = request.getParameter("search");
    String type = request.getParameter("type");
    String sort = request.getParameter("sort");
    String usedParam = request.getParameter("used");

    String message = "All Products";
    if ("1".equals(usedParam)) {
        products = prodDao.getAllUsedProducts(); // Ensure this method is implemented in your service
        message = "Showing All Used Products";
    } else if (search != null) {
        products = prodDao.searchAllProducts(search);
        message = "Showing Results for '" + search + "'";
    } else if (type != null) {
        products = prodDao.getAllProductsByType(type);
        message = "Showing Results for '" + type + "'";
    } else if (sort != null) {
        products = prodDao.getAllProducts(sort);
    } else {
        products = prodDao.getAllProducts("none");
    }

    if (products.isEmpty()) {
        message = "No items found for the search '" + (search != null ? search : type) + "'";
        products = prodDao.getAllProducts("none");
    }
%>

<jsp:include page="header.jsp" />

<div class="text-center" style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>
<div class="text-center" id="message" style="color: black; font-size: 14px; font-weight: bold;"></div>

<div class="container">
    <div class="pull-right" style="margin-bottom: 20px;">
        <button class="btn" style="background-color: #0000FF; color: white;" onclick="window.location.href='index.jsp?sort=asc'">Sort Price Asc</button>
        <button class="btn" style="background-color: #0000FF; color: white;" onclick="window.location.href='index.jsp?sort=desc'">Sort Price Desc</button>
        <button class="btn" style="background-color: #008000; color: white;" onclick="window.location.href='index.jsp?used=1'">Show Used Products</button>
    </div>
</div>

<div class="container">
    <div class="row text-center">
        <% for (ProductBean product : products) {
            int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId()); %>
        <div class="col-sm-4" style='height: 365px;'>
            <div class="thumbnail">
                <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px">
                <p class="productname"><%=product.getProdName()%></p>
                <% String description = product.getProdInfo();
                   description = description.substring(0, Math.min(description.length(), 100)); %>
                <p class="productinfo"><%=description%>..</p>
                <% if (product.getProdQuantity() == 0) { %>
                	<p class="price">Out of Stock</p>
               <% } else { %>
                <p class="price">Rs <%=product.getProdPrice()%></p>
                <% }  %>
                <p class="rating">Rating <%=product.getRating()%></p>
                <form method="post">
                    <% if (cartQty == 0) { %>
                    <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1" class="btn btn-success">Add to Cart</button>
                    <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1" class="btn btn-primary">Buy Now</button>
                    <% } else { %>
                    <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0" class="btn btn-danger">Remove From Cart</button>
                    <button type="submit" formaction="cartDetails.jsp" class="btn btn-success">Checkout</button>
                    <% } %>
                </form>
                <br />
            </div>
        </div>
        <% } %>
    </div>
</div>

<%@ include file="footer.html"%>

</body>
</html>

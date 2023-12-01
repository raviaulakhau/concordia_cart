<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Concordia Cart</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: #D8BFD8;">

	<%
	/* Checking the user credentials */
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	if (userName == null || password == null) {

		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
	}

	ProductServiceImpl prodDao = new ProductServiceImpl();
	List<ProductBean> products = new ArrayList<ProductBean>();

	String search = request.getParameter("search");
	String type = request.getParameter("type");
	String sort = request.getParameter("sort");
	String usedParam = request.getParameter("used");
	String message = "All Products";
	
	if ("discount".equals(type) || DiscountServiceImpl.madeOrders(userName)) 
	{
		products = prodDao.getAllProductsOnSale();
		message = "Showing Results for 'discounts'";
	} else if ("1".equals(usedParam)) {
		products = prodDao.getAllUsedProducts(); 
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
		products = prodDao.getAllProducts();
	}
	if (products.isEmpty()) {
		message = "No items found for the search '" + (search != null ? search : type) + "'";
		products = prodDao.getAllProducts();
	}

	//Recommend Products: Most selling item and Least selling item

	OrderService dao = new OrderServiceImpl();
	List<OrderBean> orders = dao.getOrdersByUserId(userName);
	%>



	<jsp:include page="header.jsp" />

	<div class="text-center"
		style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>
	<!-- <script>document.getElementById('mycart').innerHTML='<i data-count="20" class="fa fa-shopping-cart fa-3x icon-white badge" style="background-color:#333;margin:0px;padding:0px; margin-top:5px;"></i>'</script>
 -->
	<div class="container">
		<div class="pull-right" style="margin-bottom: 20px;">
			<button class="btn" style="background-color: #0000FF; color: white;"
				onclick="window.location.href='userHome.jsp?sort=asc'">Sort
				Price Asc</button>
			<button class="btn" style="background-color: #0000FF; color: white;"
				onclick="window.location.href='userHome.jsp?sort=desc'">Sort
				Price Desc</button>
			<button class="btn" style="background-color: #008000; color: white;"
				onclick="window.location.href='userHome.jsp?used=1'">Show
				Used Products</button>

		</div>
	</div>
	<!-- Start of Product Items List -->
	<div class="container">
		<div class="row text-center">

<%
for (ProductBean product : products) {
    int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
%>
<div class="col-sm-4" style='height: 350px;'>
    <div class="thumbnail">
        <% if (product.getUsed() == 1) { %>
            <p class="used-tag" style="width: 100px; background-color: blue; color: white; z-index: 1; position: absolute; top: 0px;">Used</p>
        <% } %>
        <% if (product.getDiscount() > 0.0) { %>
            <p class="discount-tag" style="width: 100px; background-color: green; color: white; z-index: 1; position: absolute; top: 20px;">Discount</p>
        <% } %>
        <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px">
        <p class="productname"><%=product.getProdName()%></p>
        
        <% String description = product.getProdInfo();
           description = description.substring(0, Math.min(description.length(), 100));
        %>
        <p class="productinfo"><%=description%>..</p>

        <% if (product.getProdQuantity() == 0) { %>
            <p class="price">Out of Stock</p>
        <% } else { %>
            <% if (product.getDiscount() > 0.0) { %>
                <p class="price" style="margin: 0; text-decoration: line-through;">
                    Rs <%=product.getProdPrice()%>
                </p>
                <p class="discounted-price" style="margin: 0; color: red; font-weight: bold;">
                    Rs <%=Math.min((100 - DiscountServiceImpl.suggestDiscountBasedOnCart(userName)) * product.getProdPrice()/100, ((100 - DiscountServiceImpl.suggestDiscountBasedOnSpending(userName)) * product.getProdPrice()/100)) %>
                </p>
            <% } else { %>
                <p class="price" style="font-size: 20px;">Rs <%=product.getProdPrice()%></p>
            <% } %>
        <% } %>

        <p class="rating">rating <%=product.getRating()%></p>

        <form method="post">
            <% if (cartQty == 0) { %>
                <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1" class="btn btn-success">Add to Cart</button>
                &nbsp;&nbsp;&nbsp;
                <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1" class="btn btn-primary">Buy Now</button>
            <% } else { %>
                <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0" class="btn btn-danger">Remove From Cart</button>
                &nbsp;&nbsp;&nbsp;
                <button type="submit" formaction="cartDetails.jsp" class="btn btn-success">Checkout</button>
            <% } %>
        </form>
        <br />
    </div>
</div>
<%
}
%>

			

		</div>
	</div>
	<!-- ENd of Product Items List -->


	<%@ include file="footer.html"%>

</body>
</html>
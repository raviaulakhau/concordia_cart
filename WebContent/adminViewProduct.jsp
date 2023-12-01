<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>View Products</title>
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
	String userType = (String) session.getAttribute("usertype");

	if (userType == null || !userType.equals("admin")) {

		response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");

	}

	else if (userName == null || password == null) {

		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");

	}
	%>

	<%
	ProductServiceImpl prodDao = new ProductServiceImpl();
	%>


	<%
	List<ProductBean> products = new ArrayList<ProductBean>();

	String search = request.getParameter("search");
	String type = request.getParameter("type");
	String usedParam = request.getParameter("used");

	String message = "Most Selling to Least Selling Products";

	products = DiscountServiceImpl.getAllProductsSortedByTotalNumberOfSales();
	
	
	%>

	<jsp:include page="header.jsp" />


	<div class="text-center"
		style="color: black; font-size: 19px; font-weight: bold;"><%=message%></div>
	<div class="container">
		<div class="pull-right" style="margin-bottom: 20px;">
			<button class="btn" style="background-color: #008000; color: white;"
				onclick="window.location.href='adminViewProduct.jsp?used=1'">Show
				Used Products</button>

		</div>
	</div>
	<!-- Start of Product Items List -->
	<div class="container" style="background-color: #E6F9E6;">
		<div class="row text-center">

			<%
			for (ProductBean product : products) {
			%>
			<div class="col-sm-4" style='height: 350px;'>
				<div class="thumbnail">
					<%
					if (product.getUsed() == 1) {
					%>
					<p class="used-tag"
						style="width: 100px; background-color: blue; color: white; z-index: 1; position: absolute; top: 0px;">Used</p>
					<%
					}
					%>
					<%
					if (product.getDiscount() > 0) {
					%>
					<p class="used-tag"
						style="width: 100px; background-color: green; color: black; z-index: 1; position: absolute; top: 25px;">Discounted</p>
					<%
					}
					%>
					<img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
						style="height: 150px; max-width: 180px;">
					<p class="productname"><%=product.getProdName()%>
						(
						<%=product.getProdId()%>
						)
					</p>
					<p class="productinfo"><%=product.getProdInfo()%></p>
					<%
					if (product.getProdQuantity() == 0) {
					%>
					<p class="price">Out of Stock</p>
					<%
					} else if (product.getDiscount() == 0.0) {
					%>
					<p class="price" style="font-size: 20px;">
						Rs
						<%=product.getProdPrice()%></p>
					<%
					} else {
					%>
					<p class="discounted-price"
						style="color: red; font-weight: bold; font-size: 20px;">
						Rs
						<%=(100 - product.getDiscount()) * product.getProdPrice() / 100%>
					</p>
					<%
					}
					%>
					<form method="post">
						<button type="submit"
							formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>"
							class="btn btn-danger">Remove Product</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit"
							formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>"
							class="btn btn-primary">Update Product</button>
					</form>
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
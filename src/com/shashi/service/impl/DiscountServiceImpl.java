package com.shashi.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.shashi.beans.ProductBean;
import com.shashi.service.DiscountService;
import com.shashi.service.OrderService;
import com.shashi.utility.DBUtil;

public class DiscountServiceImpl {

	/**
	 * Suggests a discount based on the total quantity of items in the user's cart.
	 * 
	 * @param username The username of the user.
	 * @return A suggested discount rate.
	 */
	public static double suggestDiscountBasedOnCart(String username) {
		double discount = 0.0;
		int totalQuantity = 0;

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			con = DBUtil.provideConnection();
			String sql = "SELECT SUM(quantity) as totalQuantity FROM `shopping-cart`.`usercart` WHERE username = ?";
			ps = con.prepareStatement(sql);
			ps.setString(1, username);
			rs = ps.executeQuery();

			if (rs.next()) {
				totalQuantity = rs.getInt("totalQuantity");
			}

			if (totalQuantity >= 1 && totalQuantity < 2) {
				discount = 1.0; // 1% discount
			} else if (totalQuantity >= 2 && totalQuantity < 5) {
				discount = 5.0; // 5% discount
			} else if (totalQuantity >= 10) {
				discount = 10.0; // 10% discount
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.closeConnection(rs);
			DBUtil.closeConnection(ps);
			DBUtil.closeConnection(con);
		}

		return discount;
	}

	/**
	 * Suggests a discount based on the total amount spent by the user in past
	 * transactions.
	 * 
	 * @param username The username of the user.
	 * @return A suggested discount rate.
	 */
	public static double suggestDiscountBasedOnSpending(String username) {
		double discount = 0.0;
		double totalSpent = 0.0;

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			con = DBUtil.provideConnection();
			String sql = "SELECT SUM(amount) as totalSpent FROM `shopping-cart`.`transactions` WHERE username = ?";
			ps = con.prepareStatement(sql);
			ps.setString(1, username);
			rs = ps.executeQuery();

			if (rs.next()) {
				totalSpent = rs.getDouble("totalSpent");
			}

			// Discount logic based on total spending
			if (totalSpent >= 1000 && totalSpent < 5000) {
				discount = 5.0; // 5% discount
			} else if (totalSpent >= 5000 && totalSpent < 10000) {
				discount = 10.0; // 10% discount
			} else if (totalSpent >= 10000) {
				discount = 15.0; // 15% discount
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.closeConnection(rs);
			DBUtil.closeConnection(ps);
			DBUtil.closeConnection(con);
		}

		return discount;
	}

	/**
	 * Gets the sales data for all products.
	 * 
	 * @return A map of product IDs to quantities sold.
	 */
	public Map<String, Integer> getProductSalesData() {
		Map<String, Integer> salesData = new HashMap<>();

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			con = DBUtil.provideConnection();
			String sql = "SELECT prodid, SUM(quantity) as totalQuantity FROM `shopping-cart`.`orders` GROUP BY prodid";
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();

			while (rs.next()) {
				salesData.put(rs.getString("prodid"), rs.getInt("totalQuantity"));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.closeConnection(rs);
			DBUtil.closeConnection(ps);
			DBUtil.closeConnection(con);
		}

		return salesData;
	}

	/**
	 * Suggests a discount for a product based on its sales performance.
	 * 
	 * @param prodId The product ID.
	 * @return A suggested discount rate.
	 */
	public double suggestDiscountBasedOnSalesPerformance(String prodId) {
		double discount = 0.0;
		Map<String, Integer> salesData = getProductSalesData();

		int totalQuantitySold = salesData.getOrDefault(prodId, 0);

		if (totalQuantitySold <= 5) { // Least selling
			discount = 20.0; // Higher discount
		} else if (totalQuantitySold > 50) { // Best selling
			discount = 5.0; // Lower discount
		} else {
			discount = 2.0; // Standard discount
		}

		return discount;
	}

	public static boolean madeOrders(String username) {

		int totalQuantity = 0;

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			con = DBUtil.provideConnection();
			String sql = "SELECT SUM(quantity) as totalQuantity FROM `shopping-cart`.`usercart` WHERE username = ?";
			ps = con.prepareStatement(sql);
			ps.setString(1, username);
			rs = ps.executeQuery();

			if (rs.next()) {
				totalQuantity = rs.getInt("totalQuantity");
				if (totalQuantity > 0)
					return true;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.closeConnection(rs);
			DBUtil.closeConnection(ps);
			DBUtil.closeConnection(con);
		}

		return false;
	}

	public static List<ProductBean> getAllProductsSortedByTotalNumberOfSales() {
		List<ProductBean> products = new ArrayList<>();
		Map<ProductBean, Integer> productSalesMap = new HashMap<>();
		Connection con = DBUtil.provideConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			ps = con.prepareStatement("select * from product");
			rs = ps.executeQuery();

			while (rs.next()) {
				ProductBean product = new ProductBean();
				product.setProdId(rs.getString(1));
				product.setProdName(rs.getString(2));
				product.setProdType(rs.getString(3));
				product.setProdInfo(rs.getString(4));
				product.setProdPrice(rs.getDouble(5));
				product.setProdQuantity(rs.getInt(6));
				product.setProdImage(rs.getAsciiStream(7));
				product.setRating(rs.getDouble(8));
				product.setUsed(rs.getInt(9));
				product.setDiscount(rs.getDouble(10));

				int salesCount = countSoldItem(product.getProdId());
				productSalesMap.put(product, salesCount);
			}

			productSalesMap.entrySet().stream().sorted(Map.Entry.<ProductBean, Integer>comparingByValue().reversed())
					.forEachOrdered(e -> products.add(e.getKey()));

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.closeConnection(con);
			DBUtil.closeConnection(ps);
			DBUtil.closeConnection(rs);
		}

		return products;
	}

	public static int countSoldItem(String prodId) {
		int count = 0;
		Connection con = DBUtil.provideConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			ps = con.prepareStatement("select sum(quantity) from orders where prodid=?");
			ps.setString(1, prodId);
			rs = ps.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
		} catch (SQLException e) {
			count = 0;
			e.printStackTrace();
		} finally {
			DBUtil.closeConnection(con);
			DBUtil.closeConnection(ps);
			DBUtil.closeConnection(rs);
		}

		return count;
	}
}

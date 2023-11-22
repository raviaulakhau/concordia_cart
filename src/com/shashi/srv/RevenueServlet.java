package com.shashi.srv;


import com.shashi.utility.DBUtil;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/revenue")
public class RevenueServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> dates = new ArrayList<>();
        List<Integer> revenues = new ArrayList<>();

        try (Connection connection = DBUtil.provideConnection();
             PreparedStatement statement = connection.prepareStatement(
                     "SELECT DATE(time) as date, SUM(amount) as total_amount FROM transactions GROUP BY DATE(time)")) {

            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                dates.add(rs.getString("date"));
                revenues.add(rs.getInt("total_amount"));
            }

            // Closing the ResultSet after usage.
            DBUtil.closeConnection(rs);
            // Closing the PreparedStatement after usage.
            DBUtil.closeConnection(statement);

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        request.setAttribute("dates", dates);
        request.setAttribute("revenues", revenues);
       

        RequestDispatcher dispatcher = request.getRequestDispatcher("revenue.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import utils.DBUtils;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.*;

@WebServlet("/image")
public class ImageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        
        if (userIdStr == null || userIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try {
            int userId = Integer.parseInt(userIdStr);
            
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("SELECT photo FROM users WHERE id = ?");
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                byte[] imageData = resultSet.getBytes("photo");
                
                if (imageData != null && imageData.length > 0) {
                    //setting default img type
                    response.setContentType("image/jpeg");  //default imaage lai jepg rakheko
                    
                    OutputStream out = response.getOutputStream();
                    out.write(imageData);
                    out.flush();
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
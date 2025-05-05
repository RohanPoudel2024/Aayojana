package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DBUtils;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.*;

@WebServlet("/eventImage")
public class EventImageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String eventIdStr = request.getParameter("eventId");
        
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try {
            int eventId = Integer.parseInt(eventIdStr);
            
            connection = DBUtils.getConnection();
            statement = connection.prepareStatement("SELECT image FROM events WHERE id = ?");
            statement.setInt(1, eventId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                byte[] imageData = resultSet.getBytes("image");
                
                if (imageData != null && imageData.length > 0) {
                    // Set the content type
                    response.setContentType("image/jpeg");  // Default image type
                    
                    // Write the image data to the response
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
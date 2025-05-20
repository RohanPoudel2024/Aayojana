package filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import utils.DBUtils;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Logger;

/**
 * Filter for debugging database connections in servlet requests
 */
@WebFilter(urlPatterns = "/booking/*")
public class DatabaseConnectionDebugFilter implements Filter {
    
    private static final Logger logger = Logger.getLogger(DatabaseConnectionDebugFilter.class.getName());
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("DatabaseConnectionDebugFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String url = httpRequest.getRequestURL().toString();
        String method = httpRequest.getMethod();
        
        logger.info("Request URL: " + url);
        logger.info("Request Method: " + method);
        
        // Test DB connection before proceeding
        try {
            Connection connection = DBUtils.getConnection();
            boolean valid = connection.isValid(5);
            logger.info("Database connection valid: " + valid);
            connection.close();
        } catch (SQLException e) {
            logger.severe("Database connection test failed: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Continue processing the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        logger.info("DatabaseConnectionDebugFilter destroyed");
    }
}

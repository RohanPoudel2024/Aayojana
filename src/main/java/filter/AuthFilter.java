package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

@WebFilter({"/Dashboard", "/EventsServlet", "/WEB-INF/view/**"})
public class AuthFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        User user = null;
        if(session != null){
            user = (User)session.getAttribute("currentUser");
        }

        if (user == null){
            response.sendRedirect("login");
            return;
        }

        String role = user.getRole();
        String uri = request.getRequestURI();

        if (uri.contains("Dashboard") && !"admin".equals(role)) {
            response.sendRedirect("EventsServlet");
            return;
        }

        if (uri.contains("EventsServlet") && !("user".equals(role) || "admin".equals(role))) {
            response.sendRedirect("Dashboard");
            return;
        }

        chain.doFilter(req, res);
    }
}

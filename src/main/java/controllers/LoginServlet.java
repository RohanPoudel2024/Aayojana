package controllers;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.AuthService;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        User user = new User();

        try {
            user = AuthService.validateLogin(email, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);

                if ("admin".equals(user.getRole())) {
                    response.sendRedirect("Dashboard");
                } else {
                    response.sendRedirect("EventsServlet");
                }
            } else {
                request.setAttribute("error","Please Enter Correct Password");
                request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request,response);
            }
        } catch (SQLException | IOException e) {
            throw new RuntimeException(e);


        } catch (ServletException e) {
            throw new RuntimeException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user != null) {
            if ("admin".equals(user.getRole())) {
                response.sendRedirect("Dashboard");
            } else {
                response.sendRedirect("EventsServlet");
            }
        } else {
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        }
    }

}


package controllers;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import service.AuthService;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            boolean userDetails = AuthService.signUp(name,email,password);
            if (userDetails!=true) {
                request.setAttribute("error", "Email already exists! in our records");
                request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
                return;
            }
            if (userDetails) {
                request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Signup failed! Try again.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
    }
}


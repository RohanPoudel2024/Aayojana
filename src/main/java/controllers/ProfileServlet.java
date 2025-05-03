package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.User;
import service.UserActivity;

import java.io.IOException;

@WebServlet("/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    
    maxFileSize = 5 * 1024 * 1024,        
    maxRequestSize = 10 * 1024 * 1024    
)
public class ProfileServlet extends HttpServlet {
    
    private UserActivity userActivity;
    
    @Override
    public void init() {
        userActivity = new UserActivity();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/view/userprofile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        //just for debigging hai
        System.out.println("User ID: " + currentUser.getUserId());
        System.out.println("User Email: " + currentUser.getEmail());
        
        if (currentUser.getUserId() == 0 && currentUser.getEmail() != null) {
            User dbUser = userActivity.getUserByEmail(currentUser.getEmail());
            if (dbUser != null) {
                System.out.println("Found user in DB with ID: " + dbUser.getUserId());
                currentUser.setUserId(dbUser.getUserId());
                session.setAttribute("currentUser", currentUser);
            }
        }
        
        try {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            
            if (name != null) currentUser.setName(name);
            if (email != null) currentUser.setEmail(email);
            if (phone != null) currentUser.setPhone(phone);
            
            String contentType = request.getContentType();
            if (contentType != null && contentType.toLowerCase().startsWith("multipart/")) {
                try {
                    Part filePart = request.getPart("profileImage");
                    
                    if (filePart != null && filePart.getSize() > 0) {
                        boolean imageProcessed = userActivity.handleProfileImage(filePart, currentUser);
                        
                        if (!imageProcessed) {
                            session.setAttribute("errorMessage", "Failed to process the uploaded image");
                        }
                    }
                } catch (Exception e) {
                    System.err.println("Error processing file upload: " + e.getMessage());
                    e.printStackTrace();
                    session.setAttribute("errorMessage", "Failed to upload image: " + e.getMessage());
                }
            }
            
            // This will update user profile in the database hai ta
            boolean updated = userActivity.updateUserProfile(currentUser);
            
            if (updated) {
                session.setAttribute("currentUser", currentUser);
                session.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update profile information.");
            }
            
        } catch (Exception e) {
            System.err.println("Error in profile update: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
        }
        
        // Redirect instead of forward to avoid IllegalStateException
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
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
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 10 * 1024 * 1024)
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
        User freshUser = null;

        if (currentUser.getUserId() > 0) {
            freshUser = userActivity.getUserById(currentUser.getUserId());
        } else if (currentUser.getEmail() != null) {
            freshUser = userActivity.getUserByEmail(currentUser.getEmail());
        }

        if (freshUser != null) {
            session.setAttribute("currentUser", freshUser);
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

        System.out.println("User ID: " + currentUser.getUserId());
        System.out.println("User Email: " + currentUser.getEmail());

        if (currentUser.getUserId() == 0 && currentUser.getEmail() != null) {
            User dbUser = userActivity.getUserByEmail(currentUser.getEmail());
            if (dbUser != null) {
                System.out.println("Found user in DB with ID: " + dbUser.getUserId());
                currentUser = dbUser;
                session.setAttribute("currentUser", currentUser);
            }
        }

        User originalUser = new User();
        originalUser.setUserId(currentUser.getUserId());
        originalUser.setName(currentUser.getName());
        originalUser.setEmail(currentUser.getEmail());
        originalUser.setPhone(currentUser.getPhone());

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        boolean hasChanges = false;

        if (name != null && !name.isEmpty() && !name.equals(originalUser.getName())) {
            currentUser.setName(name);
            hasChanges = true;
        }

        if (email != null && !email.isEmpty() && !email.equals(originalUser.getEmail())) {
            currentUser.setEmail(email);
            hasChanges = true;
        }

        if (phone != null) {
            String currentPhone = originalUser.getPhone();
            if ((currentPhone == null && !phone.isEmpty()) ||
                    (currentPhone != null && !currentPhone.equals(phone))) {
                currentUser.setPhone(phone);
                hasChanges = true;
            }
        }

        boolean imageUploaded = false;

        String contentType = request.getContentType();
        if (contentType != null && contentType.toLowerCase().startsWith("multipart/")) {
            try {
                Part filePart = request.getPart("profileImage");

                if (filePart != null && filePart.getSize() > 0) {
                    boolean imageProcessed = userActivity.handleProfileImage(filePart, currentUser);
                    if (imageProcessed) {
                        imageUploaded = true;
                        hasChanges = true;
                    } else {
                        session.setAttribute("errorMessage", "Failed to process the uploaded image");
                    }
                }
            } catch (Exception e) {
                System.err.println("Error processing file upload: " + e.getMessage());
                e.printStackTrace();
                session.setAttribute("errorMessage", "Failed to upload image: " + e.getMessage());
            }
        }

        if (hasChanges) {
            System.out.println("Changes detected, updating user profile in database");
            boolean updated = userActivity.updateUserProfile(currentUser);

            if (updated) {
                session.setAttribute("currentUser", currentUser);
                session.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                session.setAttribute("currentUser", originalUser);
                session.setAttribute("errorMessage", "Failed to update profile information.");
            }
        } else {
            session.setAttribute("infoMessage", "No changes were made to your profile.");
        }

        // Redirect instead of forward to avoid IllegalStateException
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
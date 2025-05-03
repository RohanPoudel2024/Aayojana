// package controllers;

// import jakarta.servlet.ServletException;
// import jakarta.servlet.annotation.WebServlet;
// import jakarta.servlet.annotation.MultipartConfig;
// import jakarta.servlet.http.HttpServlet;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import jakarta.servlet.http.HttpSession;
// import jakarta.servlet.http.Part;
// import model.User;
// import service.UserActivity;

// import java.io.IOException;
// import java.util.logging.Level;
// import java.util.logging.Logger;

// @WebServlet("/profile")
// @MultipartConfig(
//     fileSizeThreshold = 1024 * 1024,    // 1 MB
//     maxFileSize = 1024 * 1024 * 10,     // 10 MB
//     maxRequestSize = 1024 * 1024 * 50    // 50 MB
// )
// public class ProfileServlet extends HttpServlet {
    
//     private static final Logger logger = Logger.getLogger(ProfileServlet.class.getName());
//     private UserActivity userActivity;
    
//     @Override
//     public void init() {
//         userActivity = new UserActivity();
//     }
    
//     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//         // Get the current user from session
//         HttpSession session = request.getSession();
//         User currentUser = (User) session.getAttribute("currentUser");
        
//         // If not logged in, redirect to login
//         if (currentUser == null) {
//             response.sendRedirect(request.getContextPath() + "/login");
//             return;
//         }
        
//         // Check content type for debugging
//         String contentType = request.getContentType();
//         logger.info("Request content type: " + contentType);
        
//         // Get form data
//         String name = request.getParameter("name");
//         String email = request.getParameter("email");
//         String phone = request.getParameter("phone");
        
//         logger.info("Received form data: name=" + name + ", email=" + email + ", phone=" + phone);
        
//         // Update user object
//         currentUser.setName(name);
//         currentUser.setEmail(email);
//         currentUser.setPhone(phone);
        
//         try {
//             // Handle file upload
//             Part filePart = request.getPart("profileImage");
//             if (filePart != null) {
//                 logger.info("File part size: " + filePart.getSize() + " bytes");
//                 logger.info("File part content type: " + filePart.getContentType());
                
//                 if (filePart.getSize() > 0) {
//                     // Get upload directory path
//                     String uploadPath = getServletContext().getRealPath("/uploads/profiles");
//                     logger.info("Upload path: " + uploadPath);
                    
//                     // Process the file and get relative path
//                     String photoPath = userActivity.handleProfileImage(filePart, currentUser.getUserId(), uploadPath);
                    
//                     // Update user object with new photo path
//                     currentUser.setPhoto(photoPath);
//                     logger.info("Photo path set to: " + photoPath);
//                 }
//             } else {
//                 logger.warning("File part is null");
//             }
//         } catch (Exception e) {
//             logger.log(Level.SEVERE, "Error processing file upload", e);
//             request.setAttribute("errorMessage", "Error uploading file: " + e.getMessage());
//             request.getRequestDispatcher("/WEB-INF/view/userprofile.jsp").forward(request, response);
//             return;
//         }
        
//         // Save changes to database
//         boolean updated = userActivity.updateUserProfile(currentUser);
        
//         if (updated) {
//             // Update user in session
//             session.setAttribute("currentUser", currentUser);
//             request.setAttribute("successMessage", "Profile updated successfully!");
//             logger.info("Profile updated successfully");
//         } else {
//             request.setAttribute("errorMessage", "Failed to update profile");
//             logger.warning("Failed to update profile");
//         }
        
//         // Show the profile page
//         request.getRequestDispatcher("/WEB-INF/view/userprofile.jsp").forward(request, response);
//     }
    
//     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//         // Get current user
//         HttpSession session = request.getSession();
//         User currentUser = (User) session.getAttribute("currentUser");
        
//         if (currentUser == null) {
//             response.sendRedirect(request.getContextPath() + "/login");
//             return;
//         }
        
//         // Show profile page
//         request.getRequestDispatcher("/WEB-INF/view/userprofile.jsp").forward(request, response);
//     }
// }

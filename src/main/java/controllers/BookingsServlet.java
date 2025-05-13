//package controllers;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import model.Booking;
//import model.Event;
//import model.User;
//import service.BookingService;
//import service.EventService;
//import utils.DatabaseConnection;
//
//import java.io.IOException;
//import java.sql.Connection;
//import java.util.List;
//import java.util.Map;
//import java.util.HashMap;
//
//@WebServlet("/bookings/*")
//public class BookingsServlet extends HttpServlet {
//    private BookingService bookingService;
//    private EventService eventService;
//    private Connection connection;
//
//    @Override
//    public void init() throws ServletException {
//        try {
//            connection = DatabaseConnection.getConnection();
//            bookingService = new BookingService(connection);
//            eventService = new EventService(connection);
//        } catch (Exception e) {
//            throw new ServletException("Failed to initialize database connection", e);
//        }
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String pathInfo = request.getPathInfo();
//
//        // Check if user is logged in
//        HttpSession session = request.getSession();
//        User currentUser = (User) session.getAttribute("currentUser");
//        if (currentUser == null) {
//            response.sendRedirect(request.getContextPath() + "/login?redirect=bookings");
//            return;
//        }
//
//        // Route to appropriate handler based on path
//        if (pathInfo == null || pathInfo.equals("/")) {
//            // Show all bookings for the user
//            listUserBookings(request, response, currentUser.getUserId());
//        } else if (pathInfo.equals("/new")) {
//            // Show booking form
//            showBookingForm(request, response);
//        } else if (pathInfo.startsWith("/view/")) {
//            // View details of a specific booking
//            int bookingId = extractIdFromPath(pathInfo, "/view/");
//            viewBooking(request, response, bookingId, currentUser.getUserId());
//        } else if (pathInfo.equals("/confirm")) {
//            // Show booking confirmation before finalizing
//            showBookingConfirmation(request, response);
//        } else {
//            response.sendError(HttpServletResponse.SC_NOT_FOUND);
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String pathInfo = request.getPathInfo();
//
//        // Check if user is logged in
//        HttpSession session = request.getSession();
//        User currentUser = (User) session.getAttribute("currentUser");
//        if (currentUser == null) {
//            response.sendRedirect(request.getContextPath() + "/login?redirect=bookings");
//            return;
//        }
//
//        // Route to appropriate handler based on path
//        if (pathInfo == null || pathInfo.equals("/")) {
//            // Create a new booking
//            createBooking(request, response, currentUser.getUserId());
//        } else if (pathInfo.startsWith("/cancel/")) {
//            // Cancel a booking
//            int bookingId = extractIdFromPath(pathInfo, "/cancel/");
//            cancelBooking(request, response, bookingId, currentUser.getUserId());
//        } else {
//            response.sendError(HttpServletResponse.SC_NOT_FOUND);
//        }
//    }
//
//    private int extractIdFromPath(String pathInfo, String prefix) {
//        try {
//            String idStr = pathInfo.substring(prefix.length());
//            return Integer.parseInt(idStr);
//        } catch (NumberFormatException | IndexOutOfBoundsException e) {
//            return -1;
//        }
//    }
//
//    private void listUserBookings(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
//        List<Booking> bookings = bookingService.getUserBookings(userId);
//
//        // Get event details for each booking
//        Map<Integer, Event> eventMap = new HashMap<>();
//        for (Booking booking : bookings) {
//            int eventId = booking.getEventId();
//            if (!eventMap.containsKey(eventId)) {
//                Event event = eventService.getEventById(eventId);
//                if (event != null) {
//                    eventMap.put(eventId, event);
//                }
//            }
//        }
//
//        request.setAttribute("bookings", bookings);
//        request.setAttribute("eventMap", eventMap);
//        request.getRequestDispatcher("/WEB-INF/view/bookings/list.jsp").forward(request, response);
//    }
//
//    private void showBookingForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String eventIdStr = request.getParameter("eventId");
//        if (eventIdStr == null || eventIdStr.isEmpty()) {
//            response.sendRedirect(request.getContextPath() + "/EventsServlet");
//            return;
//        }
//
//        try {
//            int eventId = Integer.parseInt(eventIdStr);
//            Event event = eventService.getEventById(eventId);
//
//            if (event == null) {
//                response.sendRedirect(request.getContextPath() + "/EventsServlet");
//                return;
//            }
//
//            request.setAttribute("event", event);
//            request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
//        } catch (NumberFormatException e) {
//            response.sendRedirect(request.getContextPath() + "/EventsServlet");
//        }
//    }
//
//    private void showBookingConfirmation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String eventIdStr = request.getParameter("eventId");
//        String seatsStr = request.getParameter("seats");
//
//        if (eventIdStr == null || seatsStr == null) {
//            response.sendRedirect(request.getContextPath() + "/EventsServlet");
//            return;
//        }
//
//        try {
//            int eventId = Integer.parseInt(eventIdStr);
//            int seats = Integer.parseInt(seatsStr);
//
//            Event event = eventService.getEventById(eventId);
//            if (event == null) {
//                response.sendRedirect(request.getContextPath() + "/EventsServlet");
//                return;
//            }
//
//            if (seats <= 0 || seats > event.getAvailableSeats()) {
//                request.setAttribute("errorMessage", "Invalid number of seats requested.");
//                request.setAttribute("event", event);
//                request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
//                return;
//            }
//
//            double totalPrice = event.getPrice() * seats;
//
//            request.setAttribute("event", event);
//            request.setAttribute("seats", seats);
//            request.setAttribute("totalPrice", totalPrice);
//            request.getRequestDispatcher("/WEB-INF/view/bookings/confirm.jsp").forward(request, response);
//        } catch (NumberFormatException e) {
//            response.sendRedirect(request.getContextPath() + "/EventsServlet");
//        }
//    }
//
//    private void createBooking(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
//        String eventIdStr = request.getParameter("eventId");
//        String seatsStr = request.getParameter("seats");
//
//        if (eventIdStr == null || seatsStr == null) {
//            response.sendRedirect(request.getContextPath() + "/EventsServlet");
//            return;
//        }
//
//        try {
//            int eventId = Integer.parseInt(eventIdStr);
//            int seats = Integer.parseInt(seatsStr);
//
//            int bookingId = bookingService.processBooking(userId, eventId, seats);
//
//            if (bookingId > 0) {
//                // Booking successful
//                request.setAttribute("bookingSuccess", true);
//                request.setAttribute("bookingId", bookingId);
//                response.sendRedirect(request.getContextPath() + "/bookings/view/" + bookingId);
//            } else {
//                // Booking failed
//                Event event = eventService.getEventById(eventId);
//                request.setAttribute("errorMessage", "Booking failed. Please try again.");
//                request.setAttribute("event", event);
//                request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
//            }
//        } catch (NumberFormatException e) {
//            response.sendRedirect(request.getContextPath() + "/EventsServlet");
//        }
//    }
//
//    private void viewBooking(HttpServletRequest request, HttpServletResponse response, int bookingId, int userId) throws ServletException, IOException {
//        if (bookingId < 0) {
//            response.sendRedirect(request.getContextPath() + "/bookings");
//            return;
//        }
//
//        Booking booking = bookingService.getBookingDetails(bookingId);
//
//        if (booking == null || booking.getUserId() != userId) {
//            // Either booking doesn't exist or doesn't belong to this user
//            response.sendRedirect(request.getContextPath() + "/bookings");
//            return;
//        }
//
//        Event event = eventService.getEventById(booking.getEventId());
//
//        request.setAttribute("booking", booking);
//        request.setAttribute("event", event);
//        request.getRequestDispatcher("/WEB-INF/view/bookings/view.jsp").forward(request, response);
//    }
//
//    private void cancelBooking(HttpServletRequest request, HttpServletResponse response, int bookingId, int userId) throws ServletException, IOException {
//        if (bookingId < 0) {
//            response.sendRedirect(request.getContextPath() + "/bookings");
//            return;
//        }
//
//        Booking booking = bookingService.getBookingDetails(bookingId);
//
//        if (booking == null || booking.getUserId() != userId) {
//            // Either booking doesn't exist or doesn't belong to this user
//            response.sendRedirect(request.getContextPath() + "/bookings");
//            return;
//        }
//
//        boolean cancelled = bookingService.cancelBooking(bookingId);
//
//        if (cancelled) {
//            request.getSession().setAttribute("message", "Booking cancelled successfully!");
//        } else {
//            request.getSession().setAttribute("errorMessage", "Failed to cancel booking. Please try again.");
//        }
//
//        response.sendRedirect(request.getContextPath() + "/bookings");
//    }
//
//    @Override
//    public void destroy() {
//        try {
//            if (connection != null && !connection.isClosed()) {
//                connection.close();
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//}

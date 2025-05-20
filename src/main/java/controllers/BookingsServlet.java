package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Event;
import model.User;
import service.BookingService;
import service.EventService;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/booking/*")
public class BookingsServlet extends HttpServlet {
    private BookingService bookingService;
    private EventService eventService;
    
    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
        eventService = new EventService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        // Check if user is logged in
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI());
            return;
        }
        
        if (action == null) {
            // Show booking form
            showBookingForm(request, response);
        } else if (action.equals("confirm")) {
            // Show booking confirmation
            showBookingConfirmation(request, response);
        } else if (action.equals("list")) {
            // Show user's bookings
            listUserBookings(request, response, currentUser.getUserId());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI());
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.equals("create")) {
            // Process booking creation
            createBooking(request, response, currentUser.getUserId());
        } else if (action.equals("cancel")) {
            // Process booking cancellation
            cancelBooking(request, response, currentUser.getUserId());
        }
    }
    
    private void showBookingForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String eventIdStr = request.getParameter("eventId");
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventService.getEventById(eventId);
            
            if (event == null || event.getAvailableSeats() <= 0) {
                response.sendRedirect(request.getContextPath() + "/EventsServlet");
                return;
            }
            
            request.setAttribute("event", event);
            request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
        }
    }
    
    private void showBookingConfirmation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String eventIdStr = request.getParameter("eventId");
        String seatsStr = request.getParameter("seats");
        
        if (eventIdStr == null || seatsStr == null) {
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(eventIdStr);
            int seats = Integer.parseInt(seatsStr);
            
            Event event = eventService.getEventById(eventId);
            if (event == null) {
                response.sendRedirect(request.getContextPath() + "/EventsServlet");
                return;
            }
            
            if (seats <= 0 || seats > event.getAvailableSeats()) {
                request.setAttribute("errorMessage", "Invalid number of seats requested.");
                request.setAttribute("event", event);
                request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
                return;
            }
            
            double totalPrice = event.getPrice() * seats;
            
            request.setAttribute("event", event);
            request.setAttribute("seats", seats);
            request.setAttribute("totalPrice", totalPrice);
            request.getRequestDispatcher("/WEB-INF/view/bookings/confirm.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
        }
    }
    
    private void createBooking(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        String eventIdStr = request.getParameter("eventId");
        String seatsStr = request.getParameter("seats");
        
        if (eventIdStr == null || seatsStr == null) {
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(eventIdStr);
            int seats = Integer.parseInt(seatsStr);
            
            // Create booking object
            Booking booking = new Booking();
            booking.setUserId(userId);
            booking.setEventId(eventId);
            booking.setBookingDate(Date.valueOf(LocalDate.now()));
            booking.setSeatsBooked(seats);
            
            Event event = eventService.getEventById(eventId);
            if (event == null) {
                response.sendRedirect(request.getContextPath() + "/EventsServlet");
                return;
            }
            
            booking.setTotalPrice(event.getPrice() * seats);
            
            // Process booking
            int bookingId = bookingService.createBooking(booking);
            
            if (bookingId > 0) {
                // Booking successful
                request.setAttribute("message", "Booking successful! Your booking ID is " + bookingId);
                response.sendRedirect(request.getContextPath() + 
                    "/booking?action=list&message=Booking successful! Your booking ID is " + bookingId);
            } else {
                // Booking failed
                request.setAttribute("errorMessage", "Booking failed. Please try again.");
                request.setAttribute("event", event);
                request.getRequestDispatcher("/WEB-INF/view/bookings/form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/EventsServlet");
        }
    }
    
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            
            // Get booking to verify ownership
            Booking booking = bookingService.getBookingById(bookingId);
            if (booking == null || booking.getUserId() != userId) {
                response.sendRedirect(request.getContextPath() + "/booking?action=list");
                return;
            }
            
            // Cancel booking
            boolean success = bookingService.cancelBooking(bookingId);
            
            if (success) {
                request.setAttribute("message", "Booking cancelled successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to cancel booking.");
            }
            
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
        }
    }
    
    private void listUserBookings(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        List<Booking> bookings = bookingService.getBookingsByUserId(userId);
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/WEB-INF/view/bookings/list.jsp").forward(request, response);
    }
}

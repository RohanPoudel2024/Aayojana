// package service;

// import dao.BookingDAO;
// import dao.EventDAO;
// import model.Booking;
// import model.Event;

// import java.sql.Connection;
// import java.sql.Date;
// import java.time.LocalDate;
// import java.util.List;

// public class BookingService {
//     private BookingDAO bookingDAO;
//     private EventDAO eventDAO;

//     public BookingService(Connection connection) {
//         this.bookingDAO = new BookingDAO(connection);
//         this.eventDAO = new EventDAO(connection);
//     }
    
//     public boolean validateBooking(int eventId, int seatsRequested) {
//         if (seatsRequested <= 0) {
//             return false;
//         }
        
//         Event event = eventDAO.getEventById(eventId);
//         if (event == null) {
//             return false;
//         }
        
//         return event.getAvailableSeats() >= seatsRequested;
//     }
    
//     public double calculateTotalPrice(int eventId, int seatsRequested) {
//         Event event = eventDAO.getEventById(eventId);
//         if (event == null) {
//             return 0;
//         }
        
//         return event.getPrice() * seatsRequested;
//     }
    
//     public int processBooking(int userId, int eventId, int seatsRequested) {
//         if (!validateBooking(eventId, seatsRequested)) {
//             return -1;
//         }
        
//         double totalPrice = calculateTotalPrice(eventId, seatsRequested);
        
//         Booking booking = new Booking();
//         booking.setUserId(userId);
//         booking.setEventId(eventId);
//         booking.setBookingDate(Date.valueOf(LocalDate.now()));
//         booking.setSeatsBooked(seatsRequested);
//         booking.setTotalPrice(totalPrice);
        
//         // Begin transaction operations
//         int bookingId = bookingDAO.createBooking(booking);
//         if (bookingId > 0) {
//             boolean seatsUpdated = bookingDAO.updateEventSeats(eventId, seatsRequested);
//             if (!seatsUpdated) {
//                 // If seat update fails, we should ideally roll back the booking
//                 // This would be handled by database transaction in a real implementation
//                 return -1;
//             }
//         }
        
//         return bookingId;
//     }
    
//     public boolean cancelBooking(int bookingId) {
//         Booking booking = bookingDAO.getBookingById(bookingId);
//         if (booking == null) {
//             return false;
//         }
        
//         return bookingDAO.cancelBooking(bookingId, booking.getEventId(), booking.getSeatsBooked());
//     }
    
//     public List<Booking> getUserBookings(int userId) {
//         return bookingDAO.getBookingsByUserId(userId);
//     }
    
//     public Booking getBookingDetails(int bookingId) {
//         return bookingDAO.getBookingById(bookingId);
//     }
    
//     public List<Booking> getEventBookings(int eventId) {
//         return bookingDAO.getBookingsByEventId(eventId);
//     }
// }
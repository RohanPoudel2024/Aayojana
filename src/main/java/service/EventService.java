package service;

import dao.EventsDAO;
import model.Event;
import jakarta.servlet.http.Part;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public class EventService {
    private EventsDAO eventsDAO;
    
    public EventService() {
        this.eventsDAO = new EventsDAO();
    }
    
    public List<Event> getAllEvents() {
        try {
            return eventsDAO.getAllEvents();
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of(); // Return empty list on error
        }
    }
    
    public Event getEventById(int eventId) {
        try {
            return eventsDAO.getEventById(eventId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // Handle entire event creation process from form data
    public boolean processEventCreation(String title, String location, String dateStr, 
                                      String time, String seatsStr, String priceStr, Part filePart) {
        try {
            // First validate the input data
            if (!validateEventData(title, location, dateStr, time, seatsStr, priceStr)) {
                return false;
            }
            
            // Create event object
            Event event = createEventFromFormData(title, location, dateStr, time, seatsStr, priceStr);
            
            // Process image if provided
            if (filePart != null && filePart.getSize() > 0) {
                handleEventImage(filePart, event);
            }
            
            // Create event in database
            return eventsDAO.createEvent(event);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Handle entire event update process
    public boolean processEventUpdate(int eventId, String title, String location, String dateStr, 
                                    String time, String seatsStr, String priceStr, Part filePart) {
        try {
            // Validate the input data
            if (!validateEventData(title, location, dateStr, time, seatsStr, priceStr)) {
                return false;
            }
            
            // Get existing event
            Event event = getEventById(eventId);
            if (event == null) {
                return false;
            }
            
            // Update event properties
            updateEventFromFormData(event, title, location, dateStr, time, seatsStr, priceStr);
            
            // Process image if provided
            if (filePart != null && filePart.getSize() > 0) {
                handleEventImage(filePart, event);
            }
            
            // Update event in database
            return eventsDAO.updateEvent(event);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteEvent(int eventId) {
        try {
            return eventsDAO.deleteEvent(eventId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Event> searchEvents(String keyword) {
        try {
            return eventsDAO.searchEvents(keyword);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    // Validate event data
    public boolean validateEventData(String title, String location, String dateStr, 
                                  String time, String seatsStr, String priceStr) {
        // Check for null or empty values
        if (title == null || title.trim().isEmpty() || 
            location == null || location.trim().isEmpty() || 
            dateStr == null || dateStr.trim().isEmpty() || 
            time == null || time.trim().isEmpty() || 
            seatsStr == null || seatsStr.trim().isEmpty() || 
            priceStr == null || priceStr.trim().isEmpty()) {
            return false;
        }
        
        try {
            // Validate numeric inputs
            int seats = Integer.parseInt(seatsStr);
            double price = Double.parseDouble(priceStr);
            
            if (seats <= 0 || price < 0) {
                return false;
            }
            
            // Validate date format and logic
            Date eventDate = Date.valueOf(dateStr);
            Date today = Date.valueOf(LocalDate.now());
            
            // Event date should not be in the past
            if (eventDate.before(today)) {
                return false;
            }
            
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
    
    // Create Event object from form data
    private Event createEventFromFormData(String title, String location, String dateStr, 
                                        String time, String seatsStr, String priceStr) {
        Event event = new Event();
        event.setTitle(title);
        event.setLocation(location);
        event.setDate(Date.valueOf(dateStr));
        event.setTime(time);
        event.setAvailableSeats(Integer.parseInt(seatsStr));
        event.setPrice(Double.parseDouble(priceStr));
        return event;
    }
    
    // Update existing Event object with form data
    private void updateEventFromFormData(Event event, String title, String location, 
                                      String dateStr, String time, String seatsStr, String priceStr) {
        event.setTitle(title);
        event.setLocation(location);
        event.setDate(Date.valueOf(dateStr));
        event.setTime(time);
        event.setAvailableSeats(Integer.parseInt(seatsStr));
        event.setPrice(Double.parseDouble(priceStr));
    }
    
    // Handle event image processing
    private boolean handleEventImage(Part filePart, Event event) throws IOException {
        if (filePart != null && filePart.getSize() > 0) {
            try {
                // Read the file data
                byte[] imageData = readAllBytes(filePart.getInputStream());
                
                // Reduce size if necessary
                if (imageData.length > 1024 * 1024) { // If larger than 1MB
                    imageData = reduceImageSize(imageData, 1024 * 1024);
                }
                
                // Set the image data in the event object
                event.setImageData(imageData);
                return true;
            } catch (Exception e) {
                throw new IOException("Failed to process image data: " + e.getMessage(), e);
            }
        }
        return false;
    }
    
    private byte[] readAllBytes(InputStream inputStream) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        int nRead;
        byte[] data = new byte[16384];
        
        while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
        }
        
        return buffer.toByteArray();
    }
    
    private byte[] reduceImageSize(byte[] originalData, int targetSize) {
        // If data is already smaller than target, no need to reduce
        if (originalData.length <= targetSize) {
            return originalData;
        }
        
        // Simple approach - reduce by skipping bytes
        double ratio = (double) targetSize / originalData.length;
        ByteArrayOutputStream result = new ByteArrayOutputStream(targetSize);
        
        // Keep header bytes (important for image format)
        int headerSize = Math.min(512, originalData.length / 10);
        result.write(originalData, 0, headerSize);
        
        // Skip some bytes in the middle
        int skipFactor = (int) Math.ceil(1.0 / ratio);
        for (int i = headerSize; i < originalData.length - headerSize; i += skipFactor) {
            if (result.size() < targetSize - headerSize) {
                result.write(originalData[i]);
            }
        }
        
        // Keep footer bytes
        if (originalData.length > headerSize * 2) {
            int remaining = targetSize - result.size();
            if (remaining > 0) {
                result.write(originalData, originalData.length - remaining, remaining);
            }
        }
        
        return result.toByteArray();
    }
}
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
import java.util.ArrayList;
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
            return List.of(); 
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
    
    
    public boolean createEvent(Event event) {
        try {
            return eventsDAO.createEvent(event);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
    public boolean updateEvent(Event event) {
        try {
            return eventsDAO.updateEvent(event);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
    public boolean processEventCreation(String title, String location, String dateStr, 
                                      String time, String seatsStr, String priceStr, Part filePart) {
        try {
            
            if (!validateEventData(title, location, dateStr, time, seatsStr, priceStr)) {
                return false;
            }
            
            
            Event event = createEventFromFormData(title, location, dateStr, time, seatsStr, priceStr, null);
            
            
            if (filePart != null && filePart.getSize() > 0) {
                handleEventImage(filePart, event);
            }
            
            
            return eventsDAO.createEvent(event);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
    public boolean processEventUpdate(int eventId, String title, String location, String dateStr, 
                                    String time, String seatsStr, String priceStr, Part filePart) {
        try {
            
            if (!validateEventData(title, location, dateStr, time, seatsStr, priceStr)) {
                return false;
            }
            
            
            Event event = getEventById(eventId);
            if (event == null) {
                return false;
            }
            
            
            updateEventFromFormData(event, title, location, dateStr, time, seatsStr, priceStr, null);
            
            
            if (filePart != null && filePart.getSize() > 0) {
                handleEventImage(filePart, event);
            }
            
            
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

    public List<Event> searchEvents(String keyword, String location, String categoryId) {
        try {
            return eventsDAO.searchEvents(keyword, location, categoryId);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    
    public boolean validateEventData(String title, String location, String dateStr, 
                                  String time, String seatsStr, String priceStr) {
        
        if (title == null || title.trim().isEmpty() || 
            location == null || location.trim().isEmpty() || 
            dateStr == null || dateStr.trim().isEmpty() || 
            time == null || time.trim().isEmpty() || 
            seatsStr == null || seatsStr.trim().isEmpty() || 
            priceStr == null || priceStr.trim().isEmpty()) {
            return false;
        }
        
        try {
            
            int seats = Integer.parseInt(seatsStr);
            double price = Double.parseDouble(priceStr);
            
            if (seats <= 0 || price < 0) {
                return false;
            }
            
            
            Date eventDate = Date.valueOf(dateStr);
            Date today = Date.valueOf(LocalDate.now());
            
            
            if (eventDate.before(today)) {
                return false;
            }
            
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
    
    
    private Event createEventFromFormData(String title, String location, String dateStr, 
                                        String time, String seatsStr, String priceStr, String categoryIdStr) {
        Event event = new Event();
        event.setTitle(title);
        event.setLocation(location);
        event.setDate(Date.valueOf(dateStr));
        event.setTime(time);
        event.setAvailableSeats(Integer.parseInt(seatsStr));
        event.setPrice(Double.parseDouble(priceStr));
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            event.setCategoryId(Integer.parseInt(categoryIdStr));
        }
        return event;
    }
    
    
    private void updateEventFromFormData(Event event, String title, String location, 
                                      String dateStr, String time, String seatsStr, String priceStr, String categoryIdStr) {
        event.setTitle(title);
        event.setLocation(location);
        event.setDate(Date.valueOf(dateStr));
        event.setTime(time);
        event.setAvailableSeats(Integer.parseInt(seatsStr));
        event.setPrice(Double.parseDouble(priceStr));
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            event.setCategoryId(Integer.parseInt(categoryIdStr));
        }
    }
    
    
    public boolean handleEventImage(Part filePart, Event event) throws IOException {
        if (filePart != null && filePart.getSize() > 0) {
            try {
                
                byte[] imageData = readAllBytes(filePart.getInputStream());
                
                
                event.setImageData(imageData);
                return true;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
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
        
        if (originalData.length <= targetSize) {
            return originalData;
        }
        
        
        double ratio = (double) targetSize / originalData.length;
        ByteArrayOutputStream result = new ByteArrayOutputStream(targetSize);
        
        
        int headerSize = Math.min(512, originalData.length / 10);
        result.write(originalData, 0, headerSize);
        
        
        int skipFactor = (int) Math.ceil(1.0 / ratio);
        for (int i = headerSize; i < originalData.length - headerSize; i += skipFactor) {
            if (result.size() < targetSize - headerSize) {
                result.write(originalData[i]);
            }
        }
        
        
        if (originalData.length > headerSize * 2) {
            int remaining = targetSize - result.size();
            if (remaining > 0) {
                result.write(originalData, originalData.length - remaining, remaining);
            }
        }
        
        return result.toByteArray();
    }
    
    public List<Event> getEventsByCategory(int categoryId, int limit, int excludeEventId) {
        try {
            // Get all events
            List<Event> allEvents = getAllEvents();
            
            // Create a list for filtered events
            List<Event> similarEvents = new ArrayList<>();
            int count = 0;
            
            // Go through all events and filter
            for (Event event : allEvents) {
                // Only include events that:
                // 1. Are in the same category
                // 2. Are not the current event
                if (event.getCategoryId() == categoryId && event.getEventId() != excludeEventId) {
                    similarEvents.add(event);
                    count++;
                    
                    // Stop when we reach the limit
                    if (count >= limit) {
                        break;
                    }
                }
            }
            
            return similarEvents;
        } catch (Exception e) {
            e.printStackTrace();
            // Return empty list if there's an error
            return List.of();
        }
    }
    
    public int getEventCountByCategory(int categoryId) {
        try {
            return eventsDAO.getEventCountByCategory(categoryId);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * Gets a list of upcoming events (events with dates on or after the current date)
     * @return List of upcoming events, ordered by date
     */
    public List<Event> getUpcomingEvents() {
        try {
            return eventsDAO.getUpcomingEvents();
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of(); 
        }
    }
}
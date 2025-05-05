package model;

import java.sql.Date;

public class Event {
    private int eventId;
    private String title;
    private String location;
    private Date date;
    private String time;
    private int availableSeats;
    private double price;
    private int categoryId;  // Direct reference to a single category
    private byte[] imageData;
    
    // Default constructor
    public Event() {
    }

    // Constructor with fields
    public Event(int eventId, String title, String location, Date date, String time, 
                int availableSeats, double price, int categoryId) {
        this.eventId = eventId;
        this.title = title;
        this.location = location;
        this.date = date;
        this.time = time;
        this.availableSeats = availableSeats;
        this.price = price;
        this.categoryId = categoryId;
    }
    
    // Getters and setters
    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public int getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public byte[] getImageData() {
        return imageData;
    }
    
    public void setImageData(byte[] imageData) {
        this.imageData = imageData;
    }
    
    public boolean hasImage() {
        return imageData != null && imageData.length > 0;
    }
}


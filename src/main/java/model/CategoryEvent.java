package model;

/**
 * Represents the relationship between a category and an event.
 */
public class CategoryEvent {
    private int categoryId;
    private int eventId;

    // Default constructor
    public CategoryEvent() {
    }

    // Parameterized constructor
    public CategoryEvent(int categoryId, int eventId) {
        this.categoryId = categoryId;
        this.eventId = eventId;
    }

    // Getters and Setters
    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }
}

package model;

public class CategoryEvent {
    private int categoryId;
    private int eventId;

    public CategoryEvent() {}

    public CategoryEvent(int categoryId, int eventId) {
        this.categoryId = categoryId;
        this.eventId = eventId;
    }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }
}

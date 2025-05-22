package model;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class DashboardActivity {
    private String type;          // Type of activity (user, booking, event, etc.)
    private int id;               // ID of the related entity
    private String title;         // Title or name of the activity
    private String description;   // Description of the activity
    private Timestamp timestamp;  // When the activity occurred
    private String iconClass;     // Font Awesome icon class
    
    public DashboardActivity() {
    }
    
    public DashboardActivity(String type, int id, String title, String description, Timestamp timestamp) {
        this.type = type;
        this.id = id;
        this.title = title;
        this.description = description;
        this.timestamp = timestamp;
        setIconClassBasedOnType();
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
        setIconClassBasedOnType();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public String getIconClass() {
        return iconClass;
    }

    public void setIconClass(String iconClass) {
        this.iconClass = iconClass;
    }
    
    private void setIconClassBasedOnType() {
        if (this.type == null) return;
        
        switch (this.type.toLowerCase()) {
            case "user":
                this.iconClass = "fas fa-user-plus";
                break;
            case "booking":
                this.iconClass = "fas fa-ticket-alt";
                break;
            case "event":
                this.iconClass = "fas fa-calendar-plus";
                break;
            case "category":
                this.iconClass = "fas fa-tags";
                break;
            case "system":
                this.iconClass = "fas fa-cog";
                break;
            default:
                this.iconClass = "fas fa-bell";
        }
    }
    
    public String getTimeAgo() {
        if (timestamp == null) return "unknown time";
        
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime activityTime = timestamp.toLocalDateTime();
        
        long minutes = java.time.Duration.between(activityTime, now).toMinutes();
        
        if (minutes < 1) {
            return "just now";
        } else if (minutes < 60) {
            return minutes + " minute" + (minutes > 1 ? "s" : "") + " ago";
        } else if (minutes < 1440) { // less than a day
            long hours = minutes / 60;
            return hours + " hour" + (hours > 1 ? "s" : "") + " ago";
        } else if (minutes < 10080) { // less than a week
            long days = minutes / 1440;
            return days + " day" + (days > 1 ? "s" : "") + " ago";
        } else {
            long weeks = minutes / 10080;
            return weeks + " week" + (weeks > 1 ? "s" : "") + " ago";
        }
    }
}

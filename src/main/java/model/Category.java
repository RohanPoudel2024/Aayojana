package model;

import java.time.LocalDateTime;

public class Category {
    private int categoryId;
    private String name;
    private String description;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isActive;

    public Category() {}

    public Category(int categoryId, String name, String description, LocalDateTime createdAt, LocalDateTime updatedAt, boolean isActive) {
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.isActive = isActive;
    }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
}

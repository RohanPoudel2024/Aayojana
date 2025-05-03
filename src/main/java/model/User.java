package model;

public class User {
    private int userId;
    private String name;
    private String email;
    private String password;
    private String role;
    private String phone;
    private byte[] imageData; // Changed from String photo to byte[] imageData

    public User(int id, String name, String email, String phone, byte[] imageData, String password) {
        this.userId = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.imageData = imageData;
        this.password = password;
    }

    public User() {

    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public byte[] getImageData() {
        return imageData;
    }

    public void setImageData(byte[] imageData) {
        this.imageData = imageData;
    }

    // Method to check if user has profile image
    public boolean hasProfileImage() {
        return imageData != null && imageData.length > 0;
    }
}


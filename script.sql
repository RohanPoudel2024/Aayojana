-- Create users table with BLOB for photo
CREATE TABLE users (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(100),
                       email VARCHAR(100) UNIQUE,
                       password VARCHAR(100),
                       role VARCHAR(50),
                       phone VARCHAR(20),
                       photo BLOB
);

-- Create events table
CREATE TABLE events (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        title VARCHAR(100),
                        location VARCHAR(100),
                        date DATE,
                        time TIME,
                        available_seats INT,
                        price DECIMAL(10,2)
);

-- Create category table
CREATE TABLE category (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          name VARCHAR(100)
);

-- Create bookings table with status column
CREATE TABLE bookings (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          user_id INT,
                          event_id INT,
                          booking_date DATE,
                          seats_booked INT,
                          total_price DECIMAL(10,2),
                          status VARCHAR(20),
                          FOREIGN KEY (user_id) REFERENCES users(id),
                          FOREIGN KEY (event_id) REFERENCES events(id)
);
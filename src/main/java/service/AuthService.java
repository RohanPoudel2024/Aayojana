package service;

import dao.UserDAO;
import model.User;
import utils.PasswordHasher;

import java.sql.SQLException;

public class AuthService {
    public static User validateLogin(String email, String password) throws SQLException {
        UserDAO dao = new UserDAO();
        User user = dao.validateUser(email);
        if (user!=null && PasswordHasher.checkPassword(password, user.getPassword())){
            return user;
        }
        return null;
    }
}

package service;

import dao.UserActivityDAO;

public class UserActivity {
    public boolean updateDetails(String name, String email, String phone, String photo, int Userid){
        UserActivityDAO activity = new UserActivityDAO();
        activity.getUserById(1,int UserId);

    }
}

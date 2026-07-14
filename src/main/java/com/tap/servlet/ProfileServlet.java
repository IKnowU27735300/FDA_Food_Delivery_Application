package com.tap.servlet;

import com.tap.dao.UserDAO;
import com.tap.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.setAttribute("activePage", "profile");
        request.getRequestDispatcher("/jsp/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        if (fullName == null || fullName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            address == null || address.trim().isEmpty()) {
            session.setAttribute("profileError", "All details are required.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        currentUser.setFullName(fullName);
        currentUser.setPhone(phone);
        currentUser.setAddress(address);
        
        boolean success = userDAO.updateUser(currentUser);
        if (success) {
            session.setAttribute("currentUser", currentUser);
            session.setAttribute("profileSuccess", "Your profile details have been updated successfully!");
        } else {
            session.setAttribute("profileError", "Failed to update profile due to database error.");
        }
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}

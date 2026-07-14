package com.tap.servlet;

import com.tap.dao.UserDAO;
import com.tap.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // If already logged in as admin, go straight to panel
        if (session != null && session.getAttribute("adminUser") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/panel");
            return;
        }
        request.getRequestDispatcher("/jsp/admin/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.verifyLogin(email, password);

        if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) {
            HttpSession session = request.getSession(true);
            session.setAttribute("adminUser", user);
            response.sendRedirect(request.getContextPath() + "/admin/panel");
        } else {
            request.setAttribute("error", "Invalid admin credentials. Access denied.");
            request.getRequestDispatcher("/jsp/admin/admin-login.jsp").forward(request, response);
        }
    }
}

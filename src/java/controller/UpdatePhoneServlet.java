package controller;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UpdatePhoneServlet", urlPatterns = { "/update-phone" })
public class UpdatePhoneServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User pendingUser = (User) session.getAttribute("pendingUser");
        if (pendingUser == null) {
            response.sendRedirect("login");
            return;
        }
        request.getRequestDispatcher("views/auth/updatePhone.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User pendingUser = (User) session.getAttribute("pendingUser");
        if (pendingUser == null) {
            response.sendRedirect("login");
            return;
        }

        String phoneNumber = request.getParameter("phoneNumber");
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            request.setAttribute("error", "Phone number is required!");
            request.getRequestDispatcher("views/auth/updatePhone.jsp").forward(request, response);
            return;
        }

        UserDAO db = new UserDAO();
        db.updatePhone(pendingUser.getUserID(), phoneNumber);
        
        pendingUser.setPhoneNumber(phoneNumber);
        session.setAttribute("user", pendingUser);
        session.removeAttribute("pendingUser");

        String redirect = (String) session.getAttribute("redirectAfterLogin");
        if (redirect != null) {
            session.removeAttribute("redirectAfterLogin");
            response.sendRedirect(redirect);
        } else {
            response.sendRedirect("home");
        }
    }
}

package controller;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = { "/register" })
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        String cp = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");

        if (u == null || u.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui long nhap day du thong tin.");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        if (!p.equals(cp)) {
            request.setAttribute("error", "Mat khau xac nhan khong khop.");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        UserDAO db = new UserDAO();
        User existingUsername = db.checkUserExist(u.trim());
        User existingEmail = db.checkEmailExist(email.trim());

        if (existingUsername != null) {
            request.setAttribute("error", "Ten dang nhap da ton tai.");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        if (existingEmail != null) {
            request.setAttribute("error", "Email da duoc su dung.");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        db.register(u.trim(), p, email.trim(), fullName, phoneNumber);
        response.sendRedirect("login");
    }
}

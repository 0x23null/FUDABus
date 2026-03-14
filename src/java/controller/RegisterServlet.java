package controller;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

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
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        if (!p.equals(cp)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        UserDAO db = new UserDAO();
        User existingUsername = db.checkUserExist(u.trim());
        User existingEmail = db.checkEmailExist(email.trim());

        if (existingUsername != null) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại.");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        if (existingEmail != null) {
            request.setAttribute("error", "Email đã được sử dụng.");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        db.register(u.trim(), p, email.trim(), fullName, phoneNumber);
        response.sendRedirect("login");
    }
}

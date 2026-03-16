package controller;

import dal.UserDAO;
import java.io.IOException;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebServlet(name = "RegisterServlet", urlPatterns = { "/register" })
public class RegisterServlet extends HttpServlet {
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[A-Za-z0-9._]{4,24}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\d{9,11}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("registerStep", 1);
        request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String u = trim(request.getParameter("username"));
        String p = request.getParameter("password");
        String cp = request.getParameter("confirmPassword");
        String email = trim(request.getParameter("email"));
        String fullName = trim(request.getParameter("fullName"));
        String phoneNumber = trim(request.getParameter("phoneNumber"));

        setFormValues(request, u, fullName, email, phoneNumber);

        if (u.isEmpty() || fullName.isEmpty() || email.isEmpty()) {
            forwardWithError(request, response, "Vui lòng nhập đầy đủ thông tin ở bước 1.", 1);
            return;
        }

        if (!USERNAME_PATTERN.matcher(u).matches()) {
            forwardWithError(request, response,
                    "Tên đăng nhập chỉ được gồm chữ cái không dấu, số, dấu chấm hoặc dấu gạch dưới, dài 4 đến 24 ký tự.",
                    1);
            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            forwardWithError(request, response, "Email không đúng định dạng.", 1);
            return;
        }

        if (phoneNumber.isEmpty() || p == null || p.isBlank() || cp == null || cp.isBlank()) {
            forwardWithError(request, response, "Vui lòng nhập đầy đủ thông tin ở bước 2.", 2);
            return;
        }

        if (!PHONE_PATTERN.matcher(phoneNumber).matches()) {
            forwardWithError(request, response, "Số điện thoại chỉ nên gồm 9 đến 11 chữ số.", 2);
            return;
        }

        if (p.contains(" ")) {
            forwardWithError(request, response, "Mật khẩu không được chứa khoảng trắng.", 2);
            return;
        }

        if (p.length() < 8) {
            forwardWithError(request, response, "Mật khẩu cần có ít nhất 8 ký tự.", 2);
            return;
        }

        if (!p.equals(cp)) {
            forwardWithError(request, response, "Mật khẩu xác nhận không khớp.", 2);
            return;
        }

        UserDAO db = new UserDAO();
        User existingUsername = db.checkUserExist(u);
        User existingEmail = db.checkEmailExist(email);

        if (existingUsername != null && (existingEmail == null || existingUsername.getUserID() != existingEmail.getUserID())) {
            forwardWithError(request, response, "Tên đăng nhập đã tồn tại.", 1);
            return;
        }

        if (existingEmail != null) {
            if ("Guest".equalsIgnoreCase(existingEmail.getRole())) {
                db.upgradeGuestToCustomer(existingEmail.getUserID(), u, p, fullName, phoneNumber);
                response.sendRedirect("login");
                return;
            }

            forwardWithError(request, response, "Email đã được sử dụng.", 1);
            return;
        }

        db.register(u, p, email, fullName, phoneNumber);
        response.sendRedirect("login");
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String error, int step)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("registerStep", step);
        request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
    }

    private void setFormValues(HttpServletRequest request, String username, String fullName, String email, String phoneNumber) {
        request.setAttribute("usernameValue", username);
        request.setAttribute("fullNameValue", fullName);
        request.setAttribute("emailValue", email);
        request.setAttribute("phoneNumberValue", phoneNumber);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}

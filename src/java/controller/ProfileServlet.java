package controller;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.PasswordUtils;

@WebServlet(name = "ProfileServlet", urlPatterns = { "/profile" })
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = requireLogin(request, response);
        if (user == null) {
            return;
        }

        UserDAO userDAO = new UserDAO();
        User freshUser = userDAO.getUserById(user.getUserID());
        if (freshUser == null) {
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/login?error=LoginRequired");
            return;
        }

        request.getSession().setAttribute("user", freshUser);
        request.setAttribute("activeTab", resolveActiveTab(request));
        populateProfileForm(request, freshUser);

        String updated = request.getParameter("updated");
        if ("info".equals(updated)) {
            request.setAttribute("profileSuccess", "Thông tin tài khoản đã được cập nhật.");
        } else if ("password".equals(updated)) {
            request.setAttribute("passwordSuccess", "Mật khẩu đã được cập nhật thành công.");
        }

        request.getRequestDispatcher("views/public/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = requireLogin(request, response);
        if (user == null) {
            return;
        }

        String action = request.getParameter("action");
        if ("profile".equals(action)) {
            handleProfileUpdate(request, response, user);
            return;
        }

        if ("password".equals(action)) {
            handlePasswordUpdate(request, response, user);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, User sessionUser)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        User currentUser = userDAO.getUserById(sessionUser.getUserID());
        if (currentUser == null) {
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/login?error=LoginRequired");
            return;
        }

        String fullName = safeTrim(request.getParameter("fullName"));
        String email = safeTrim(request.getParameter("email"));
        String phoneNumber = safeTrim(request.getParameter("phoneNumber"));

        if (fullName.isEmpty() || email.isEmpty()) {
            request.setAttribute("profileError", "Vui lòng nhập đầy đủ họ tên và email.");
            request.setAttribute("activeTab", "profile");
            request.setAttribute("profileFormFullName", fullName);
            request.setAttribute("profileFormEmail", email);
            request.setAttribute("profileFormPhoneNumber", phoneNumber);
            request.getRequestDispatcher("views/public/profile.jsp").forward(request, response);
            return;
        }

        boolean googleLinked = currentUser.getGoogleID() != null && !currentUser.getGoogleID().trim().isEmpty();
        if (googleLinked && !currentUser.getEmail().equalsIgnoreCase(email)) {
            request.setAttribute("profileError", "Tài khoản đăng nhập bằng Google không thể thay đổi email tại đây.");
            request.setAttribute("activeTab", "profile");
            request.setAttribute("profileFormFullName", fullName);
            request.setAttribute("profileFormEmail", currentUser.getEmail());
            request.setAttribute("profileFormPhoneNumber", phoneNumber);
            request.getRequestDispatcher("views/public/profile.jsp").forward(request, response);
            return;
        }

        if (userDAO.isEmailUsedByAnotherUser(email, currentUser.getUserID())) {
            request.setAttribute("profileError", "Email này đã được sử dụng bởi tài khoản khác.");
            request.setAttribute("activeTab", "profile");
            request.setAttribute("profileFormFullName", fullName);
            request.setAttribute("profileFormEmail", email);
            request.setAttribute("profileFormPhoneNumber", phoneNumber);
            request.getRequestDispatcher("views/public/profile.jsp").forward(request, response);
            return;
        }

        userDAO.updateProfile(currentUser.getUserID(), fullName, email, phoneNumber);
        User refreshedUser = userDAO.getUserById(currentUser.getUserID());
        request.getSession().setAttribute("user", refreshedUser);
        response.sendRedirect(request.getContextPath() + "/profile?updated=info");
    }

    private void handlePasswordUpdate(HttpServletRequest request, HttpServletResponse response, User sessionUser)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        User currentUser = userDAO.getUserById(sessionUser.getUserID());
        if (currentUser == null) {
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/login?error=LoginRequired");
            return;
        }

        if (currentUser.getGoogleID() != null && !currentUser.getGoogleID().trim().isEmpty()) {
            request.setAttribute("passwordError", "Tài khoản Google hiện chưa hỗ trợ đổi mật khẩu tại đây.");
            request.setAttribute("activeTab", "password");
            populateProfileForm(request, currentUser);
            request.getRequestDispatcher("views/public/profile.jsp").forward(request, response);
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (isBlank(currentPassword) || isBlank(newPassword) || isBlank(confirmPassword)) {
            request.setAttribute("passwordError", "Vui lòng nhập đầy đủ thông tin đổi mật khẩu.");
            request.setAttribute("activeTab", "password");
            populateProfileForm(request, currentUser);
            request.getRequestDispatcher("views/public/profile.jsp").forward(request, response);
            return;
        }

        if (!PasswordUtils.matches(currentPassword, currentUser.getPassword())) {
            request.setAttribute("passwordError", "Mật khẩu hiện tại không đúng.");
            request.setAttribute("activeTab", "password");
            populateProfileForm(request, currentUser);
            request.getRequestDispatcher("views/public/profile.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 8) {
            request.setAttribute("passwordError", "Mật khẩu mới cần ít nhất 8 ký tự.");
            request.setAttribute("activeTab", "password");
            populateProfileForm(request, currentUser);
            request.getRequestDispatcher("views/public/profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("passwordError", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
            request.setAttribute("activeTab", "password");
            populateProfileForm(request, currentUser);
            request.getRequestDispatcher("views/public/profile.jsp").forward(request, response);
            return;
        }

        if (PasswordUtils.matches(newPassword, currentUser.getPassword())) {
            request.setAttribute("passwordError", "Mật khẩu mới cần khác mật khẩu hiện tại.");
            request.setAttribute("activeTab", "password");
            populateProfileForm(request, currentUser);
            request.getRequestDispatcher("views/public/profile.jsp").forward(request, response);
            return;
        }

        userDAO.changePassword(currentUser.getUserID(), newPassword);
        User refreshedUser = userDAO.getUserById(currentUser.getUserID());
        request.getSession().setAttribute("user", refreshedUser);
        response.sendRedirect(request.getContextPath() + "/profile?updated=password&tab=password");
    }

    private User requireLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            session.setAttribute("redirectAfterLogin", "profile");
            response.sendRedirect(request.getContextPath() + "/login?error=LoginRequired");
            return null;
        }
        return user;
    }

    private String resolveActiveTab(HttpServletRequest request) {
        String tab = request.getParameter("tab");
        if ("password".equals(tab)) {
            return "password";
        }
        return "profile";
    }

    private void populateProfileForm(HttpServletRequest request, User user) {
        request.setAttribute("profileFormFullName", user.getFullName());
        request.setAttribute("profileFormEmail", user.getEmail());
        request.setAttribute("profileFormPhoneNumber", user.getPhoneNumber());
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

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

@WebServlet(name = "LoginServlet", urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String errorCode = request.getParameter("error");
        if (errorCode != null && request.getAttribute("error") == null) {
            request.setAttribute("error", mapErrorMessage(errorCode));
        }
        request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String u = request.getParameter("username");
        String p = request.getParameter("password");

        UserDAO db = new UserDAO();
        User user = db.login(u, p);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            if ("Admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("admin");
            } else {
                String redirect = (String) session.getAttribute("redirectAfterLogin");
                if (redirect != null) {
                    session.removeAttribute("redirectAfterLogin");
                    response.sendRedirect(redirect);
                } else {
                    response.sendRedirect("home");
                }
            }
        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
        }
    }

    private String mapErrorMessage(String errorCode) {
        if ("LoginRequired".equals(errorCode)) {
            return "Vui lòng đăng nhập để tiếp tục.";
        }
        if ("AccessDenied".equals(errorCode)) {
            return "Bạn không có quyền truy cập trang này.";
        }
        if ("GoogleAuthFailed".equals(errorCode)) {
            return "Đăng nhập Google thất bại.";
        }
        if ("TokenExchangeFailed".equals(errorCode)) {
            return "Không thể xác thực Google. Vui lòng thử lại.";
        }
        if ("UserInfoFailed".equals(errorCode)) {
            return "Không thể lấy thông tin tài khoản Google.";
        }
        if ("DatabaseError".equals(errorCode)) {
            return "Hệ thống tạm thời gặp lỗi. Vui lòng thử lại sau.";
        }
        return errorCode;
    }
}

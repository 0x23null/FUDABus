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
            request.setAttribute("error", "Ten dang nhap hoac mat khau khong dung.");
            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
        }
    }

    private String mapErrorMessage(String errorCode) {
        if ("LoginRequired".equals(errorCode)) {
            return "Vui long dang nhap de tiep tuc.";
        }
        if ("AccessDenied".equals(errorCode)) {
            return "Ban khong co quyen truy cap trang nay.";
        }
        if ("GoogleAuthFailed".equals(errorCode)) {
            return "Dang nhap Google that bai.";
        }
        if ("TokenExchangeFailed".equals(errorCode)) {
            return "Khong the xac thuc Google. Vui long thu lai.";
        }
        if ("UserInfoFailed".equals(errorCode)) {
            return "Khong the lay thong tin tai khoan Google.";
        }
        if ("DatabaseError".equals(errorCode)) {
            return "He thong tam thoi gap loi. Vui long thu lai sau.";
        }
        return errorCode;
    }
}

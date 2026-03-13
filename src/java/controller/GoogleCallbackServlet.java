package controller;

import dal.GoogleUtils;
import dal.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "GoogleCallbackServlet", urlPatterns = { "/login-google-callback" })
public class GoogleCallbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            response.sendRedirect("login?error=GoogleAuthFailed");
            return;
        }

        String accessToken = GoogleUtils.getToken(code);
        if (accessToken == null) {
            response.sendRedirect("login?error=TokenExchangeFailed");
            return;
        }

        User googleUser = GoogleUtils.getUserInfo(accessToken);
        if (googleUser == null) {
            response.sendRedirect("login?error=UserInfoFailed");
            return;
        }

        UserDAO dao = new UserDAO();
        User user = dao.checkUserExist(googleUser.getUsername()); // Check by temp username or email?

        // Better to check by Email because Username "google_ID" is internal
        // But for this simple implementation, let's use checkByEmail if we had it.
        // Let's modify UserDAO to support "loginWithGoogle" or just check
        // checkUserExist logic.

        // Actually, let's assume checkUserExist checks username.
        // We really need checkByEmail. Let's add it or work around.
        // Workaround: We'll just define a "loginGoogle" method on DAO.

        User loggedInUser = dao.loginGoogle(googleUser.getEmail(), googleUser.getFullName(), googleUser.getUsername());

        if (loggedInUser != null) {
            HttpSession session = request.getSession();
            
            if (loggedInUser.getPhoneNumber() == null || loggedInUser.getPhoneNumber().trim().isEmpty()) {
                session.setAttribute("pendingUser", loggedInUser);
                response.sendRedirect("update-phone");
            } else {
                session.setAttribute("user", loggedInUser);

                String redirect = (String) session.getAttribute("redirectAfterLogin");
                if (redirect != null) {
                    session.removeAttribute("redirectAfterLogin");
                    response.sendRedirect(redirect);
                } else {
                    response.sendRedirect("home");
                }
            }
        } else {
            response.sendRedirect("login?error=DatabaseError");
        }
    }
}

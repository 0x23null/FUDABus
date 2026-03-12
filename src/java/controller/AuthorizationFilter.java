package controller;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebFilter(filterName = "AuthorizationFilter", urlPatterns = { "/admin/*", "/login", "/register" })
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        String path = req.getServletPath();

        // 1. Protect Admin Routes
        if (path.startsWith("/admin")) {
            if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
                // Store intended destination (though usually for public pages, not admin)
                // session.setAttribute("redirectAfterLogin", path);
                res.sendRedirect(req.getContextPath() + "/login?error=AccessDenied");
                return;
            }
        }

        // 2. Prevent Logged-in Users from accessing Login/Register
        if ((path.equals("/login") || path.equals("/register")) && user != null) {
            if ("Admin".equalsIgnoreCase(user.getRole())) {
                res.sendRedirect(req.getContextPath() + "/admin");
            } else {
                res.sendRedirect(req.getContextPath() + "/home");
            }
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}

package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SupportServlet", urlPatterns = { "/support" })
public class SupportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/public/support.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        request.setAttribute("message", "Cảm ơn " + name
                + ". Yêu cầu hỗ trợ đã được ghi nhận. Chúng tôi sẽ phản hồi qua " + email + " trong thời gian sớm nhất.");
        request.getRequestDispatcher("views/public/support.jsp").forward(request, response);
    }
}

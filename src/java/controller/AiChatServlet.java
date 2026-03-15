package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.AiAssistantService;

@WebServlet(name = "AiChatServlet", urlPatterns = { "/ai-chat" })
public class AiChatServlet extends HttpServlet {
    private final AiAssistantService aiAssistantService = new AiAssistantService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String message = request.getParameter("message");
        String page = request.getParameter("page");
        if (message == null || message.trim().isEmpty()) {
            response.getWriter().write("{\"ok\":false,\"reply\":\"Bạn hãy nhập nội dung cần hỗ trợ nhé.\"}");
            return;
        }

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String reply = aiAssistantService.reply(message, page, currentUser, session);
        response.getWriter().write("{\"ok\":true,\"reply\":\"" + escapeJson(reply) + "\"}");
    }

    private String escapeJson(String text) {
        if (text == null) {
            return "";
        }

        StringBuilder escaped = new StringBuilder();
        for (int i = 0; i < text.length(); i++) {
            char current = text.charAt(i);
            switch (current) {
                case '\\':
                    escaped.append("\\\\");
                    break;
                case '"':
                    escaped.append("\\\"");
                    break;
                case '\n':
                    escaped.append("\\n");
                    break;
                case '\r':
                    escaped.append("\\r");
                    break;
                case '\t':
                    escaped.append("\\t");
                    break;
                default:
                    if (current < 32) {
                        escaped.append(String.format("\\u%04x", (int) current));
                    } else {
                        escaped.append(current);
                    }
                    break;
            }
        }
        return escaped.toString();
    }
}

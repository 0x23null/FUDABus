package service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;
import model.AiChatMessage;
import util.ConfigUtils;

public class ZaiChatClient {

    public String chat(List<AiChatMessage> messages) throws IOException {
        if (ConfigUtils.ZAI_API_KEY == null || ConfigUtils.ZAI_API_KEY.isBlank()) {
            return null;
        }

        HttpURLConnection connection = null;
        try {
            URL url = new URL(ConfigUtils.ZAI_API_URL);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Authorization", "Bearer " + ConfigUtils.ZAI_API_KEY);
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setDoOutput(true);

            String payload = buildPayload(messages);
            try (OutputStream outputStream = connection.getOutputStream()) {
                outputStream.write(payload.getBytes(StandardCharsets.UTF_8));
            }

            int status = connection.getResponseCode();
            if (status >= 200 && status < 300) {
                String body = readBody(connection.getInputStream());
                return extractAssistantContent(body);
            }

            String errorBody = connection.getErrorStream() == null
                    ? ""
                    : readBody(connection.getErrorStream());
            throw new IOException("Z.AI request failed with status " + status + ": " + errorBody);
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    private String buildPayload(List<AiChatMessage> messages) {
        StringBuilder payload = new StringBuilder();
        payload.append("{")
                .append("\"model\":\"").append(escapeJson(ConfigUtils.ZAI_MODEL)).append("\",")
                .append("\"stream\":false,")
                .append("\"temperature\":0.4,")
                .append("\"messages\":[");

        for (int i = 0; i < messages.size(); i++) {
            AiChatMessage message = messages.get(i);
            if (i > 0) {
                payload.append(',');
            }
            payload.append("{")
                    .append("\"role\":\"").append(escapeJson(message.getRole())).append("\",")
                    .append("\"content\":\"").append(escapeJson(message.getContent())).append("\"")
                    .append("}");
        }

        payload.append("]}");
        return payload.toString();
    }

    private String readBody(java.io.InputStream inputStream) throws IOException {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            StringBuilder body = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                body.append(line);
            }
            return body.toString();
        }
    }

    private String extractAssistantContent(String json) {
        int choicesIndex = json.indexOf("\"choices\"");
        if (choicesIndex < 0) {
            return null;
        }

        int messageIndex = json.indexOf("\"message\"", choicesIndex);
        if (messageIndex < 0) {
            return null;
        }

        int contentIndex = json.indexOf("\"content\"", messageIndex);
        if (contentIndex < 0) {
            return null;
        }

        int colonIndex = json.indexOf(':', contentIndex);
        if (colonIndex < 0) {
            return null;
        }

        int valueStart = skipWhitespace(json, colonIndex + 1);
        if (valueStart >= json.length()) {
            return null;
        }

        if (json.charAt(valueStart) == '"') {
            return parseJsonString(json, valueStart);
        }

        return null;
    }

    private int skipWhitespace(String text, int index) {
        int current = index;
        while (current < text.length() && Character.isWhitespace(text.charAt(current))) {
            current++;
        }
        return current;
    }

    private String parseJsonString(String json, int quoteIndex) {
        StringBuilder value = new StringBuilder();
        for (int i = quoteIndex + 1; i < json.length(); i++) {
            char current = json.charAt(i);
            if (current == '\\') {
                if (i + 1 >= json.length()) {
                    break;
                }
                char escaped = json.charAt(++i);
                switch (escaped) {
                    case '"':
                        value.append('"');
                        break;
                    case '\\':
                        value.append('\\');
                        break;
                    case '/':
                        value.append('/');
                        break;
                    case 'b':
                        value.append('\b');
                        break;
                    case 'f':
                        value.append('\f');
                        break;
                    case 'n':
                        value.append('\n');
                        break;
                    case 'r':
                        value.append('\r');
                        break;
                    case 't':
                        value.append('\t');
                        break;
                    case 'u':
                        if (i + 4 < json.length()) {
                            String unicode = json.substring(i + 1, i + 5);
                            value.append((char) Integer.parseInt(unicode, 16));
                            i += 4;
                        }
                        break;
                    default:
                        value.append(escaped);
                        break;
                }
            } else if (current == '"') {
                return value.toString();
            } else {
                value.append(current);
            }
        }
        return value.toString();
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

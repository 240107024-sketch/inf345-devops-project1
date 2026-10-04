import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;

public class Main {

    public static void main(String[] args) throws IOException {
        String portEnv = System.getenv("PORT");
        int port = portEnv != null ? Integer.parseInt(portEnv) : 8080;

        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);

        server.createContext("/", exchange -> {
            sendResponse(exchange, 200, "Hello from INF 345 Notes API");
        });

        server.createContext("/healthz", exchange -> {
            sendResponse(exchange, 200, "OK");
        });

        server.createContext("/notes", exchange -> {
            sendResponse(exchange, 200,
                    "[\"Study DevOps\",\"Learn Git\",\"Build API\"]");
        });

        server.start();

        System.out.println("Server running on port " + port);
    }

    private static void sendResponse(
            HttpExchange exchange,
            int status,
            String response
    ) throws IOException {

        byte[] body = response.getBytes(StandardCharsets.UTF_8);

        exchange.sendResponseHeaders(status, body.length);

        try (OutputStream os = exchange.getResponseBody()) {
            os.write(body);
        }
    }
}
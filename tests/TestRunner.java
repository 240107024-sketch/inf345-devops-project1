import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class TestRunner {

    private static int passed = 0;
    private static int total = 0;

    public static void main(String[] args) throws Exception {
        String port = System.getenv("PORT");

        if (port == null) {
            port = "8080";
        }

        HttpClient client = HttpClient.newHttpClient();

        test(client, port, "/", "Hello from INF 345 Notes API");
        test(client, port, "/healthz", "OK");
        test(client, port, "/notes", "Study DevOps");

        System.out.println("TESTS: " + passed + "/" + total);

        if (passed != total) {
            System.exit(1);
        }
    }

    private static void test(
            HttpClient client,
            String port,
            String path,
            String expected
    ) throws Exception {

        total++;

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("http://localhost:" + port + path))
                .GET()
                .build();

        HttpResponse<String> response =
                client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200 &&
                response.body().contains(expected)) {
            passed++;
            System.out.println("PASS: " + path);
        } else {
            System.out.println("FAIL: " + path);
        }
    }
}
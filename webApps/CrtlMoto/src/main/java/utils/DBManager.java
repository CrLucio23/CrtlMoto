package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBManager {

    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/crtlmoto?serverTimezone=UTC";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "root123";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver MySQL non trovato.", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        String url = getEnvOrDefault("CRTLMOTO_DB_URL", DEFAULT_URL);
        String user = getEnvOrDefault("CRTLMOTO_DB_USER", DEFAULT_USER);
        String password = getEnvOrDefault("CRTLMOTO_DB_PASSWORD", DEFAULT_PASSWORD);
        return DriverManager.getConnection(url, user, password);
    }

    private static String getEnvOrDefault(String name, String defaultValue) {
        String value = System.getenv(name);
        return value == null || value.isBlank() ? defaultValue : value;
    }
}

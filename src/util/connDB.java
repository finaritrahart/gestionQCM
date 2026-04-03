package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class connDB {

    public static Connection getConnection() {

        Connection conn = null;

        try {
            Class.forName("org.postgresql.Driver");

            conn = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/gestQCM",
                "postgres",
                "hart80"
            );

        } catch (Exception e) {
            e.printStackTrace();
        }

        return conn;
    }
}
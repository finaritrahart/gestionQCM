package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

	 private static final String URL = "jdbc:postgresql://localhost:5432/gestionQCM";
	 private static final String USER =  "postgres";
	 private static final String PASS ="1234";
	 
	 public static Connection getConnection() throws SQLException {
		 try {
			 Class.forName("org.postgresql.Driver");
			 return DriverManager.getConnection(URL,USER,PASS);
		 }catch (ClassNotFoundException e) {
			 throw new SQLException("DRIVER PostegreSQL non trouvé !Vérifie que le JAR est dans WEB-INF/lib", e);
		 }
	 }
}

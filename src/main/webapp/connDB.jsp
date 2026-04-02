<%@ page import="java.sql.*" %>
<%

 try{
        Class.forName("org.postgresql.Driver");

        String conn;
        conn= DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/gestQCM",
            "postgres","hart80"
        );
        return conn;
}
catch(Exception e){
        out.println("erreur du connexion!");
}
%>
<%@ page import="java.sql.*" %>

<%
String id = request.getParameter("id");

try{
    Class.forName("org.postgresql.Driver");
    Connection conn = DriverManager.getConnection(
        "jdbc:postgresql://localhost:5432/gestQCM",
        "postgres","hart80"
    );

    Statement st = conn.createStatement();
    st.executeUpdate("DELETE FROM etudiant WHERE num_etudiant='"+id+"'");

    response.sendRedirect("liste.jsp");

    conn.close();
}catch(Exception e){
    out.println(e.getMessage());
}
%>
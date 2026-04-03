<%@ page import="java.sql.*" %>

<table border="1">
<tr>
    <th>Numéro</th><th>Nom</th><th>Prénoms</th><th>Niveau</th><th>Email</th>
    <th>Actions</th>
</tr>

<%
try{
    Class.forName("org.postgresql.Driver");
    Connection conn = DriverManager.getConnection(
        "jdbc:postgresql://localhost:5432/gestQCM",
        "postgres","hart1234"
    );

    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM etudiant");

    while(rs.next()){
%>
<tr>
    <td><%= rs.getString("num_etudiant") %></td>
    <td><%= rs.getString("nom") %></td>
    <td><%= rs.getString("prenoms") %></td>
    <td><%= rs.getString("niveau") %></td>
    <td><%= rs.getString("adr_email") %></td>

    <td>
        <a href="modifier.jsp?id=<%= rs.getString("num_etudiant") %>">Modifier</a>
        <a href="supprimer.jsp?id=<%= rs.getString("num_etudiant") %>">Supprimer</a>
    </td>
</tr>
<%
    }
    conn.close();
}catch(Exception e){
    out.println(e.getMessage());
}
%>
</table>
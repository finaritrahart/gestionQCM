<%@ page import="java.sql.*" %>

<%
String id = request.getParameter("id");

/* ===========================
   PARTIE UPDATE (POST)
   =========================== */
if(request.getMethod().equalsIgnoreCase("POST")){

    String num = request.getParameter("num");
    String nom = request.getParameter("nom");
    String prenoms = request.getParameter("prenoms");
    String niveau = request.getParameter("niveau");
    String email = request.getParameter("email");

    try{
        Class.forName("org.postgresql.Driver");

        Connection conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/gestQCM",
            "postgres","hart80"
        );

        Statement st = conn.createStatement();

        String sql = "UPDATE etudiant SET "
        		
                + "nom='"+nom+"', "
                + "prenoms='"+prenoms+"', "
                + "niveau='"+niveau+"', "
                + "adr_email='"+email+"' "
                + "WHERE num_etudiant='"+num+"'";

        st.executeUpdate(sql);

        // Redirection après modification
        response.sendRedirect("liste.jsp");

        conn.close();

    }catch(Exception e){
        out.println("Erreur : " + e.getMessage());
    }
}


/* ===========================
   PARTIE AFFICHAGE (GET)
   =========================== */
try{
    Class.forName("org.postgresql.Driver");

    Connection conn = DriverManager.getConnection(
        "jdbc:postgresql://localhost:5432/gestQCM",
        "postgres","1234"
    );

    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery(
        "SELECT * FROM etudiant WHERE num_etudiant='"+id+"'"
    );

    if(rs.next()){
%>

<form method="post">

    <!-- Numéro NON modifiable -->
    Numero:
    <input type="text" name="num"
           value="<%= rs.getString("num_etudiant") %>" readonly><br>

    Nom:
    <input type="text" name="nom"
           value="<%= rs.getString("nom") %>"><br>

    Prenoms:
    <input type="text" name="prenoms"
           value="<%= rs.getString("prenoms") %>"><br>

    Niveau:
    <select name="niveau">

        <option <%= rs.getString("niveau").equals("L1")?"selected":"" %>>L1</option>
        <option <%= rs.getString("niveau").equals("L2")?"selected":"" %>>L2</option>
        <option <%= rs.getString("niveau").equals("L3")?"selected":"" %>>L3</option>
        <option <%= rs.getString("niveau").equals("M1")?"selected":"" %>>M1</option>
        <option <%= rs.getString("niveau").equals("M2")?"selected":"" %>>M2</option>

    </select><br>

    Email:
    <input type="text" name="email"
           value="<%= rs.getString("adr_email") %>"><br>

    <input type="submit" value="Modifier">
</form>

<%
    }

    conn.close();

}catch(Exception e){
    out.println("Erreur : " + e.getMessage());
}
%>
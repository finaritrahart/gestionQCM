<form method="post">
    <label>Numero: </label><input type="text" name="num"><br>
    Nom: <input type="text" name="nom"><br>
    Prenoms: <input type="text" name="prenoms"><br>
    Niveau:
    <select name="niveau">
        <option>L1</option>
        <option>L2</option>
        <option>L3</option>
        <option>M1</option>
        <option>M2</option>
    </select><br>
    Email: <input type="text" name="email"><br>

    <input type="submit" value="Ajouter">
</form>

<%@ page import="java.sql.*" %>

<%
if(request.getMethod().equalsIgnoreCase("POST")){

    String num_etudiant = request.getParameter("num");
    String nom = request.getParameter("nom");
    String prenom = request.getParameter("prenoms");
    String niveau = request.getParameter("niveau");
    String adr_email = request.getParameter("email");

    try{
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/gestQCM",
            "postgres","hart80"
        );

        Statement st = conn.createStatement();

        String sql = "INSERT INTO etudiant VALUES('"+num_etudiant+"','"+nom+"','"+prenom+"','"+niveau+"','"+adr_email+"')";
        st.executeUpdate(sql);

        out.println("Etudiant ajoute");

        conn.close();
    }catch(Exception e){
        out.println(e.getMessage());
    }
}
%>
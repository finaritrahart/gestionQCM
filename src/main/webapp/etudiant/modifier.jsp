<%@ page import="java.sql.*, util.DBUtil" %>



<%
String id = request.getParameter("id");

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

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
    	conn = DBUtil.getConnection();
    	
    	String sql = "UPDATE etudiant SET nom=?, prenoms=?, niveau=?, adr_email=? WHERE num_etudiant=? ";

        ps = conn.prepareStatement(sql);

        ps.setString(1, nom);
        ps.setString(2, prenoms);
        ps.setString(3, niveau);
        ps.setString(4, email);
        ps.setString(5, num);
        
        ps.executeUpdate();

        // Redirection après modification
        response.sendRedirect("liste.jsp");
        return;

    }catch(Exception e){
        out.println("Erreur Update: " + e.getMessage());
    }finally{
        try { if(ps != null) ps.close(); } catch(Exception e){}
        try { if(conn != null) conn.close(); } catch(Exception e){}
    }
}


/* ===========================
   PARTIE AFFICHAGE (GET)
   =========================== */
try{
    conn = DBUtil.getConnection();
	String sql = "SELECT * FROM etudiant WHERE num_etudiant=?";
    ps = conn.prepareStatement(sql);
    ps.setString(1, id);
    
    rs = ps.executeQuery();
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
    } else {
        out.println("Étudiant introuvable.");
    }

}catch(Exception e){
    out.println("Erreur SELECT : " + e.getMessage());
}finally{
    try { if(rs != null) rs.close(); } catch(Exception e){}
    try { if(ps != null) ps.close(); } catch(Exception e){}
    try { if(conn != null) conn.close(); } catch(Exception e){}
}%>
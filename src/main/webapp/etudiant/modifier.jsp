<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier Étudiant</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 500px;
            margin: 0 auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            border-bottom: 3px solid #4CAF50;
            padding-bottom: 10px;
        }
        label {
            display: inline-block;
            width: 100px;
            font-weight: bold;
            margin-top: 10px;
        }
        input[type="text"], select {
            width: 250px;
            padding: 8px;
            margin: 5px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        input[readonly] {
            background-color: #f0f0f0;
            cursor: not-allowed;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 15px;
        }
        button:hover {
            background-color: #45a049;
        }
        .cancel {
            background-color: #555;
            text-decoration: none;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            margin-left: 10px;
        }
        .cancel:hover {
            background-color: #333;
        }
        .error {
            color: red;
            margin: 10px 0;
        }
        .success {
            color: green;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>✏️ Modification de l'étudiant</h2>

<%
// Récupération du paramètre (recherche.jsp envoie "num" pas "id")
String num = request.getParameter("id");

// Si pas de numéro, retour à la liste
if (num == null || num.trim().isEmpty()) {
    response.sendRedirect("liste.jsp");
    return;
}
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

/* ===========================
   PARTIE UPDATE (POST)
   =========================== */
if(request.getMethod().equalsIgnoreCase("POST")){
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

        // Redirection apr�s modification
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
    ps.setString(1, num);
    
    rs = ps.executeQuery();
    if(rs.next()){
%>

        <form method="post">
            <!-- Numéro NON modifiable -->
            <label>Numéro :</label>
            <input type="text" name="num" value="<%= rs.getString("num_etudiant") %>" readonly><br>

            <label>Nom :</label>
            <input type="text" name="nom" value="<%= rs.getString("nom") %>" required><br>

            <label>Prénoms :</label>
            <input type="text" name="prenoms" value="<%= rs.getString("prenoms") %>" required><br>

            <label>Niveau :</label>
            <select name="niveau">
                <option value="L1" <%= "L1".equals(rs.getString("niveau")) ? "selected" : "" %>>L1</option>
                <option value="L2" <%= "L2".equals(rs.getString("niveau")) ? "selected" : "" %>>L2</option>
                <option value="L3" <%= "L3".equals(rs.getString("niveau")) ? "selected" : "" %>>L3</option>
                <option value="M1" <%= "M1".equals(rs.getString("niveau")) ? "selected" : "" %>>M1</option>
                <option value="M2" <%= "M2".equals(rs.getString("niveau")) ? "selected" : "" %>>M2</option>
            </select><br>

            <label>Email :</label>
            <input type="text" name="email" value="<%= rs.getString("adr_email") %>" required><br>

            <button type="submit">💾 Enregistrer les modifications</button>
            <a href="liste.jsp" class="cancel">❌ Annuler</a>
        </form>

<%
    } else {
        out.println("�tudiant introuvable.");
    }

}catch(Exception e){
    out.println("Erreur SELECT : " + e.getMessage());
}finally{
    try { if(rs != null) rs.close(); } catch(Exception e){}
    try { if(ps != null) ps.close(); } catch(Exception e){}
    try { if(conn != null) conn.close(); } catch(Exception e){}
}%>
    </div>
</body>
</html>

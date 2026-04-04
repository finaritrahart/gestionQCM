<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter QCM</title>
    <style>
        .error { color: red; }
        .success { color: green; }
        form { margin: 20px; }
        textarea { width: 400px; height: 80px; }
        input[type="text"] { width: 400px; }
        button { background-color: #4CAF50; color: white; padding: 10px 15px; 
                 border: none; cursor: pointer; margin-top: 10px; }
        button:hover { background-color: #45a049; }
        .cancel { background-color: #555; text-decoration: none; color: white; 
                  padding: 10px 15px; display: inline-block; margin-top: 10px; }
    </style>
</head>
<body>

<h2>➕ Ajouter une question QCM</h2>

<%
if (request.getMethod().equalsIgnoreCase("POST")) {
    
    String question = request.getParameter("question");
    String r1 = request.getParameter("r1");
    String r2 = request.getParameter("r2");
    String r3 = request.getParameter("r3");
    String r4 = request.getParameter("r4");
    int bonne = Integer.parseInt(request.getParameter("bonne"));
    String niveau = request.getParameter("niveau");
    
    if (question == null || question.trim().isEmpty() || 
        r1 == null || r1.trim().isEmpty()) {
        out.println("<p class='error'>❌ Tous les champs sont obligatoires !</p>");
    } else {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "INSERT INTO qcm (question, reponse1, reponse2, reponse3, reponse4, bonne_reponse, niveau) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, question);
            pstmt.setString(2, r1);
            pstmt.setString(3, r2);
            pstmt.setString(4, r3);
            pstmt.setString(5, r4);
            pstmt.setInt(6, bonne);
            pstmt.setString(7, niveau);
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                out.println("<p class='success'>✅ QCM ajouté avec succès !</p>");
            } else {
                out.println("<p class='error'>❌ Erreur lors de l'ajout</p>");
            }
            
        } catch (Exception e) {
            out.println("<p class='error'>❌ Erreur : " + e.getMessage() + "</p>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
            if (conn != null) try { conn.close(); } catch(SQLException e) {}
        }
    }
}
%>

<form method="post">
    Question : <br>
    <textarea name="question" required></textarea><br><br>

    Réponse 1 : <input type="text" name="r1" required><br>
    Réponse 2 : <input type="text" name="r2" required><br>
    Réponse 3 : <input type="text" name="r3" required><br>
    Réponse 4 : <input type="text" name="r4" required><br><br>

    Bonne réponse :
    <select name="bonne">
        <option value="1">Réponse 1</option>
        <option value="2">Réponse 2</option>
        <option value="3">Réponse 3</option>
        <option value="4">Réponse 4</option>
    </select><br><br>

    Niveau :
    <select name="niveau">
        <option>L1</option>
        <option>L2</option>
        <option>L3</option>
        <option>M1</option>
        <option>M2</option>
    </select><br><br>

    <button type="submit">➕ Ajouter QCM</button>
    <a href="liste.jsp" class="cancel">📋 Voir la liste</a>
</form>

</body>
</html>
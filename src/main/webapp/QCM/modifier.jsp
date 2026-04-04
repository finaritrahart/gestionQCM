<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier QCM</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        form { margin: 20px; }
        textarea { width: 400px; height: 80px; }
        input[type="text"] { width: 400px; }
        .error { color: red; }
        button { background-color: #4CAF50; color: white; padding: 10px 15px; 
                 border: none; cursor: pointer; margin-top: 10px; }
        .cancel { background-color: #555; text-decoration: none; color: white; 
                  padding: 10px 15px; display: inline-block; margin-top: 10px; }
    </style>
</head>
<body>

<h2>✏️ Modifier une question QCM</h2>

<%
String idParam = request.getParameter("id");
if (idParam == null) {
    response.sendRedirect("liste.jsp");
    return;
}

int id = Integer.parseInt(idParam);

// Traitement de la modification
if (request.getMethod().equalsIgnoreCase("POST")) {
    String question = request.getParameter("question");
    String r1 = request.getParameter("r1");
    String r2 = request.getParameter("r2");
    String r3 = request.getParameter("r3");
    String r4 = request.getParameter("r4");
    int bonne = Integer.parseInt(request.getParameter("bonne"));
    String niveau = request.getParameter("niveau");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBUtil.getConnection();
        String sql = "UPDATE qcm SET question=?, reponse1=?, reponse2=?, reponse3=?, reponse4=?, bonne_reponse=?, niveau=? WHERE num_quest=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, question);
        pstmt.setString(2, r1);
        pstmt.setString(3, r2);
        pstmt.setString(4, r3);
        pstmt.setString(5, r4);
        pstmt.setInt(6, bonne);
        pstmt.setString(7, niveau);
        pstmt.setInt(8, id);
        
        int result = pstmt.executeUpdate();
        if (result > 0) {
            response.sendRedirect("liste.jsp?msg=updated");
            return;
        } else {
            out.println("<p class='error'>❌ Erreur lors de la modification</p>");
        }
    } catch (Exception e) {
        out.println("<p class='error'>❌ Erreur : " + e.getMessage() + "</p>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
        if (conn != null) try { conn.close(); } catch(SQLException e) {}
    }
}

// Récupération des données actuelles
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
String question = "", r1 = "", r2 = "", r3 = "", r4 = "", niveau = "";
int bonne = 1;

try {
    conn = DBUtil.getConnection();
    String sql = "SELECT * FROM qcm WHERE num_quest = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, id);
    rs = pstmt.executeQuery();
    
    if (rs.next()) {
        question = rs.getString("question");
        r1 = rs.getString("reponse1");
        r2 = rs.getString("reponse2");
        r3 = rs.getString("reponse3");
        r4 = rs.getString("reponse4");
        bonne = rs.getInt("bonne_reponse");
        niveau = rs.getString("niveau");
    } else {
        out.println("<p class='error'>❌ QCM non trouvé</p>");
        out.println("<a href='liste.jsp'>Retour à la liste</a>");
        return;
    }
} catch (Exception e) {
    out.println("<p class='error'>❌ Erreur : " + e.getMessage() + "</p>");
} finally {
    if (rs != null) try { rs.close(); } catch(SQLException e) {}
    if (pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
    if (conn != null) try { conn.close(); } catch(SQLException e) {}
}
%>

<form method="post">
    Question : <br>
    <textarea name="question" required><%= question %></textarea><br><br>
    
    Réponse 1 : <input type="text" name="r1" value="<%= r1 %>" required><br>
    Réponse 2 : <input type="text" name="r2" value="<%= r2 %>" required><br>
    Réponse 3 : <input type="text" name="r3" value="<%= r3 %>" required><br>
    Réponse 4 : <input type="text" name="r4" value="<%= r4 %>" required><br><br>
    
    Bonne réponse :
    <select name="bonne">
        <option value="1" <%= bonne == 1 ? "selected" : "" %>>Réponse 1</option>
        <option value="2" <%= bonne == 2 ? "selected" : "" %>>Réponse 2</option>
        <option value="3" <%= bonne == 3 ? "selected" : "" %>>Réponse 3</option>
        <option value="4" <%= bonne == 4 ? "selected" : "" %>>Réponse 4</option>
    </select><br><br>
    
    Niveau :
    <select name="niveau">
        <option value="L1" <%= "L1".equals(niveau) ? "selected" : "" %>>L1</option>
        <option value="L2" <%= "L2".equals(niveau) ? "selected" : "" %>>L2</option>
        <option value="L3" <%= "L3".equals(niveau) ? "selected" : "" %>>L3</option>
        <option value="M1" <%= "M1".equals(niveau) ? "selected" : "" %>>M1</option>
        <option value="M2" <%= "M2".equals(niveau) ? "selected" : "" %>>M2</option>
    </select><br><br>
    
    <button type="submit">💾 Enregistrer</button>
    <a href="liste.jsp" class="cancel">❌ Annuler</a>
</form>

</body>
</html>
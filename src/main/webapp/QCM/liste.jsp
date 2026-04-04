<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des QCM</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        tr:hover { background-color: #ddd; }
        .action-links a { margin-right: 10px; text-decoration: none; }
        .edit { color: blue; }
        .delete { color: red; }
        .add-btn { background-color: #4CAF50; color: white; padding: 10px 15px; 
                   text-decoration: none; display: inline-block; margin-bottom: 20px; }
        .search-box { margin-bottom: 20px; padding: 10px; width: 300px; }
        .filter { margin-bottom: 20px; }
        .success { color: green; font-weight: bold; margin-bottom: 10px; }
        .error { color: red; font-weight: bold; margin-bottom: 10px; }
    </style>
    <script>
        function confirmDelete(id) {
            return confirm("Êtes-vous sûr de vouloir supprimer ce QCM ?");
        }
    </script>
</head>
<body>

<h2>📋 Liste des Questions QCM</h2>

<a href="ajouter.jsp" class="add-btn">➕ Ajouter un nouveau QCM</a>
<a href="menu.jsp" class="add-btn" style="background-color: #555;">🏠 Retour au menu</a>

<%
// Gestion de la suppression
String action = request.getParameter("action");
String message = "";
String error = "";

if ("delete".equals(action)) {
    String idParam = request.getParameter("id");
    if (idParam != null) {
        int id = Integer.parseInt(idParam);
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM qcm WHERE num_quest = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            int result = pstmt.executeUpdate();
            if (result > 0) {
                message = "✅ QCM supprimé avec succès !";
            } else {
                error = "❌ Erreur lors de la suppression";
            }
        } catch (Exception e) {
            error = "❌ Erreur : " + e.getMessage();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
            if (conn != null) try { conn.close(); } catch(SQLException e) {}
        }
    }
}

if (!message.isEmpty()) {
    out.println("<div class='success'>" + message + "</div>");
}
if (!error.isEmpty()) {
    out.println("<div class='error'>" + error + "</div>");
}
%>

<!-- Formulaire de recherche et filtre -->
<div class="filter">
    <form method="get">
        <input type="text" name="search" class="search-box" placeholder="🔍 Rechercher par question..." 
               value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
        <select name="niveauFilter">
            <option value="">Tous les niveaux</option>
            <option value="L1" <%= "L1".equals(request.getParameter("niveauFilter")) ? "selected" : "" %>>L1</option>
            <option value="L2" <%= "L2".equals(request.getParameter("niveauFilter")) ? "selected" : "" %>>L2</option>
            <option value="L3" <%= "L3".equals(request.getParameter("niveauFilter")) ? "selected" : "" %>>L3</option>
            <option value="M1" <%= "M1".equals(request.getParameter("niveauFilter")) ? "selected" : "" %>>M1</option>
            <option value="M2" <%= "M2".equals(request.getParameter("niveauFilter")) ? "selected" : "" %>>M2</option>
        </select>
        <input type="submit" value="Filtrer">
        <a href="liste.jsp">Réinitialiser</a>
    </form>
</div>

<%
String search = request.getParameter("search");
String niveauFilter = request.getParameter("niveauFilter");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    conn = DBUtil.getConnection();
    
    StringBuilder sql = new StringBuilder("SELECT * FROM qcm WHERE 1=1");
    
    if (search != null && !search.trim().isEmpty()) {
        sql.append(" AND question LIKE ?");
    }
    if (niveauFilter != null && !niveauFilter.isEmpty()) {
        sql.append(" AND niveau = ?");
    }
    
    sql.append(" ORDER BY num_quest DESC");
    
    pstmt = conn.prepareStatement(sql.toString());
    int paramIndex = 1;
    
    if (search != null && !search.trim().isEmpty()) {
        pstmt.setString(paramIndex++, "%" + search + "%");
    }
    if (niveauFilter != null && !niveauFilter.isEmpty()) {
        pstmt.setString(paramIndex++, niveauFilter);
    }
    
    rs = pstmt.executeQuery();
%>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Question</th>
            <th>Réponse 1</th>
            <th>Réponse 2</th>
            <th>Réponse 3</th>
            <th>Réponse 4</th>
            <th>Bonne réponse</th>
            <th>Niveau</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <%
        boolean hasResults = false;
        while (rs.next()) {
            hasResults = true;
            int id = rs.getInt("num_quest");
            String question = rs.getString("question");
            String rep1 = rs.getString("reponse1");
            String rep2 = rs.getString("reponse2");
            String rep3 = rs.getString("reponse3");
            String rep4 = rs.getString("reponse4");
            int bonne = rs.getInt("bonne_reponse");
            String niveau = rs.getString("niveau");
        %>
        <tr>
            <td><%= id %></td>
            <td style="max-width: 300px;"><%= question %></td>
            <td><%= rep1 %></td>
            <td><%= rep2 %></td>
            <td><%= rep3 %></td>
            <td><%= rep4 %></td>
            <td><strong>Réponse <%= bonne %></strong></td>
            <td><%= niveau != null ? niveau : "-" %></td>
            <td class="action-links">
                <a href="modifier.jsp?id=<%= id %>" class="edit">✏️ Modifier</a>
                <a href="liste.jsp?action=delete&id=<%= id %>" class="delete" onclick="return confirmDelete(<%= id %>)">🗑️ Supprimer</a>
            </td>
        </tr>
        <%
        }
        if (!hasResults) {
        %>
        <tr>
            <td colspan="9" style="text-align: center;">❌ Aucune question QCM trouvée</td>
        </tr>
        <%
        }
        %>
    </tbody>
</table>

<%
} catch (Exception e) {
    out.println("<p class='error'>❌ Erreur : " + e.getMessage() + "</p>");
    e.printStackTrace();
} finally {
    if (rs != null) try { rs.close(); } catch(SQLException e) {}
    if (pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
    if (conn != null) try { conn.close(); } catch(SQLException e) {}
}
%>

</body>
</html>
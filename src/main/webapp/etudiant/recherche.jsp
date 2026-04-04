<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Rechercher un Étudiant</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
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
        .search-form {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .search-form input, .search-form select {
            padding: 10px;
            margin: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .search-form input[type="text"] {
            width: 250px;
        }
        .search-form button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .search-form button:hover {
            background-color: #45a049;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        .no-result {
            text-align: center;
            padding: 40px;
            color: #666;
            font-size: 18px;
        }
        .action-links a {
            margin-right: 10px;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 4px;
        }
        .edit {
            background-color: #2196F3;
            color: white;
        }
        .delete {
            background-color: #f44336;
            color: white;
        }
        .edit:hover, .delete:hover {
            opacity: 0.8;
        }
        .back-btn {
            display: inline-block;
            margin-top: 20px;
            background-color: #555;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
        }
        .back-btn:hover {
            background-color: #333;
        }
        .result-count {
            margin-top: 15px;
            font-weight: bold;
            color: #4CAF50;
        }
    </style>
    <script>
        function confirmDelete(id) {
            return confirm("Êtes-vous sûr de vouloir supprimer cet étudiant ?");
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>🔍 Rechercher un Étudiant</h2>
        
        <!-- Formulaire de recherche -->
        <div class="search-form">
            <form method="get" action="recherche.jsp">
                <label>Rechercher par :</label><br><br>
                <input type="text" name="num" placeholder="Numéro étudiant" value="<%= request.getParameter("num") != null ? request.getParameter("num") : "" %>">
                <input type="text" name="nom" placeholder="Nom" value="<%= request.getParameter("nom") != null ? request.getParameter("nom") : "" %>">
                <select name="niveau">
                    <option value="">Tous les niveaux</option>
                    <option value="L1" <%= "L1".equals(request.getParameter("niveau")) ? "selected" : "" %>>L1</option>
                    <option value="L2" <%= "L2".equals(request.getParameter("niveau")) ? "selected" : "" %>>L2</option>
                    <option value="L3" <%= "L3".equals(request.getParameter("niveau")) ? "selected" : "" %>>L3</option>
                    <option value="M1" <%= "M1".equals(request.getParameter("niveau")) ? "selected" : "" %>>M1</option>
                    <option value="M2" <%= "M2".equals(request.getParameter("niveau")) ? "selected" : "" %>>M2</option>
                </select>
                <button type="submit">🔍 Rechercher</button>
                <a href="recherche.jsp" style="margin-left: 10px; text-decoration: none;">🔄 Réinitialiser</a>
            </form>
        </div>
        
        <%
        // Récupération des paramètres de recherche
        String numRecherche = request.getParameter("num");
        String nomRecherche = request.getParameter("nom");
        String niveauRecherche = request.getParameter("niveau");
        
        // Vérifier si une recherche a été effectuée
        boolean rechercheEffectuee = (numRecherche != null && !numRecherche.trim().isEmpty()) ||
                                      (nomRecherche != null && !nomRecherche.trim().isEmpty()) ||
                                      (niveauRecherche != null && !niveauRecherche.isEmpty());
        
        if (rechercheEffectuee) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = DBUtil.getConnection();
                
                // Construction de la requête dynamique avec LIKE
                StringBuilder sql = new StringBuilder("SELECT * FROM etudiant WHERE 1=1");
                
                if (numRecherche != null && !numRecherche.trim().isEmpty()) {
                    sql.append(" AND num_etudiant LIKE ?");
                }
                if (nomRecherche != null && !nomRecherche.trim().isEmpty()) {
                    sql.append(" AND nom LIKE ?");
                }
                if (niveauRecherche != null && !niveauRecherche.isEmpty()) {
                    sql.append(" AND niveau = ?");
                }
                
                sql.append(" ORDER BY nom, prenom");
                
                pstmt = conn.prepareStatement(sql.toString());
                int index = 1;
                
                if (numRecherche != null && !numRecherche.trim().isEmpty()) {
                    pstmt.setString(index++, "%" + numRecherche + "%");
                }
                if (nomRecherche != null && !nomRecherche.trim().isEmpty()) {
                    pstmt.setString(index++, "%" + nomRecherche + "%");
                }
                if (niveauRecherche != null && !niveauRecherche.isEmpty()) {
                    pstmt.setString(index++, niveauRecherche);
                }
                
                rs = pstmt.executeQuery();
                
                // Compter le nombre de résultats
                int count = 0;
                StringBuilder countSql = new StringBuilder("SELECT COUNT(*) FROM etudiant WHERE 1=1");
                // Refaire les mêmes conditions pour le count
                // (simplification: on va compter en parcourant le rs)
        %>
        
        <div class="result-count">
            <%
            // Affichage des critères recherchés
            out.print("Résultats pour : ");
            if (numRecherche != null && !numRecherche.trim().isEmpty()) {
                out.print(" numéro='" + numRecherche + "'");
            }
            if (nomRecherche != null && !nomRecherche.trim().isEmpty()) {
                out.print(" nom='" + nomRecherche + "'");
            }
            if (niveauRecherche != null && !niveauRecherche.isEmpty()) {
                out.print(" niveau=" + niveauRecherche);
            }
            %>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>Numéro</th>
                    <th>Nom</th>
                    <th>Prénoms</th>
                    <th>Niveau</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                boolean hasResults = false;
                while (rs.next()) {
                    hasResults = true;
                    count++;
                    String num = rs.getString("num_etudiant");
                    String nom = rs.getString("nom");
                    String prenoms = rs.getString("prenom");
                    String niveau = rs.getString("niveau");
                    String email = rs.getString("adr_email");
                %>
                <tr>
                    <td><%= num %></td>
                    <td><%= nom %></td>
                    <td><%= prenoms %></td>
                    <td><%= niveau %></td>
                    <td><%= email %></td>
                    <td class="action-links">
                        <a href="modifier.jsp?num=<%= num %>" class="edit">✏️ Modifier</a>
                        <a href="liste.jsp?action=delete&num=<%= num %>" class="delete" onclick="return confirmDelete('<%= num %>')">🗑️ Supprimer</a>
                    </td>
                </tr>
                <%
                }
                if (!hasResults) {
                %>
                <tr>
                    <td colspan="6" class="no-result">❌ Aucun étudiant trouvé avec ces critères</td>
                </tr>
                <%
                }
                %>
            </tbody>
        </table>
        
        <div class="result-count" style="margin-top: 10px;">
            Total : <%= count %> étudiant(s) trouvé(s)
        </div>
        
        <%
            } catch (Exception e) {
                out.println("<p style='color:red'>❌ Erreur : " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch(SQLException e) {}
                if (pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
                if (conn != null) try { conn.close(); } catch(SQLException e) {}
            }
        } else {
            // Aucune recherche effectuée - afficher un message
        %>
        <div class="no-result" style="background: #f9f9f9; border-radius: 8px;">
            <p>📝 Entrez des critères de recherche ci-dessus et cliquez sur "Rechercher".</p>
            <p>💡 Vous pouvez rechercher par :</p>
            <ul style="text-align: left; display: inline-block;">
                <li>Numéro étudiant (recherche partielle avec LIKE)</li>
                <li>Nom (recherche partielle avec LIKE)</li>
                <li>Niveau (filtre exact)</li>
            </ul>
        </div>
        <%
        }
        %>
        
        <a href="../menu.jsp" class="back-btn">🏠 Retour au menu</a>
    </div>
</body>
</html>
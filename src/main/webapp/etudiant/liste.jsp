<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des Étudiants</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1300px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            animation: slideIn 0.5s ease;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h2 {
            font-size: 28px;
            margin-bottom: 5px;
        }
        
        .header p {
            opacity: 0.9;
            font-size: 14px;
        }
        
        .content {
            padding: 30px;
        }
        
        .stats-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 25px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .stats-card .icon {
            font-size: 32px;
        }
        
        .stats-card .info {
            text-align: center;
        }
        
        .stats-card .number {
            font-size: 28px;
            font-weight: bold;
        }
        
        .stats-card .label {
            font-size: 12px;
            opacity: 0.9;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background: #218838;
            transform: translateY(-2px);
        }
        
        .btn-info {
            background: #17a2b8;
            color: white;
        }
        
        .btn-info:hover {
            background: #138496;
            transform: translateY(-2px);
        }
        
        .btn-warning {
            background: #ffc107;
            color: #333;
        }
        
        .btn-warning:hover {
            background: #e0a800;
            transform: translateY(-2px);
        }
        
        .search-bar {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 25px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }
        
        .search-bar input {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            min-width: 200px;
        }
        
        .search-bar input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .search-bar select {
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            background: white;
            cursor: pointer;
        }
        
        .table-wrapper {
            overflow-x: auto;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }
        
        th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
        }
        
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
            color: #333;
        }
        
        tr:hover {
            background: #f8f9fa;
            transition: background 0.3s ease;
        }
        
        .action-icons {
            display: flex;
            gap: 10px;
        }
        
        .action-icons a {
            text-decoration: none;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 12px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .edit-link {
            background: #2196F3;
            color: white;
        }
        
        .edit-link:hover {
            background: #0b7dda;
            transform: translateY(-2px);
        }
        
        .delete-link {
            background: #f44336;
            color: white;
        }
        
        .delete-link:hover {
            background: #da190b;
            transform: translateY(-2px);
        }
        
        .message {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            animation: slideIn 0.3s ease;
        }
        
        .message.success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .message.error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px;
            color: #999;
        }
        
        .empty-state .icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 25px;
            flex-wrap: wrap;
        }
        
        .pagination a, .pagination span {
            padding: 8px 15px;
            border-radius: 8px;
            text-decoration: none;
            color: #667eea;
            background: #f0f0f0;
            transition: all 0.3s ease;
        }
        
        .pagination a:hover {
            background: #667eea;
            color: white;
        }
        
        .pagination .active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        @media (max-width: 768px) {
            .content {
                padding: 20px;
            }
            
            .stats-bar {
                flex-direction: column;
            }
            
            .stats-card {
                width: 100%;
                justify-content: center;
            }
            
            .action-buttons {
                justify-content: center;
            }
            
            th, td {
                padding: 10px;
                font-size: 12px;
            }
            
            .action-icons a {
                padding: 4px 8px;
                font-size: 10px;
            }
        }
    </style>
    <script>
        function confirmDelete(num) {
            return confirm("Êtes-vous sûr de vouloir supprimer l'étudiant " + num + " ?");
        }
        
        function filterTable() {
            const searchInput = document.getElementById('searchInput').value.toLowerCase();
            const niveauFilter = document.getElementById('niveauFilter').value;
            const rows = document.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const nom = row.cells[1]?.textContent.toLowerCase() || '';
                const prenom = row.cells[2]?.textContent.toLowerCase() || '';
                const num = row.cells[0]?.textContent.toLowerCase() || '';
                const niveau = row.cells[3]?.textContent || '';
                
                const matchesSearch = nom.includes(searchInput) || 
                                     prenom.includes(searchInput) || 
                                     num.includes(searchInput);
                const matchesNiveau = niveauFilter === '' || niveau === niveauFilter;
                
                row.style.display = matchesSearch && matchesNiveau ? '' : 'none';
            });
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>📋 Liste des Étudiants</h2>
            <p>Gestion et suivi des étudiants inscrits</p>
        </div>
        
        <div class="content">
            <%
            // Gestion des messages
            String msg = request.getParameter("msg");
            if ("updated".equals(msg)) {
                out.println("<div class='message success'>✅ Étudiant modifié avec succès !</div>");
            } else if ("deleted".equals(msg)) {
                out.println("<div class='message success'>✅ Étudiant supprimé avec succès !</div>");
            } else if ("added".equals(msg)) {
                out.println("<div class='message success'>✅ Étudiant ajouté avec succès !</div>");
            }
            
            // Gestion de la suppression
            String action = request.getParameter("action");
            String error = "";
            
            if ("delete".equals(action)) {
                String numParam = request.getParameter("num");
                if (numParam != null) {
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    try {
                        conn = DBUtil.getConnection();
                        String sql = "DELETE FROM etudiant WHERE num_etudiant = ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, numParam);
                        int result = pstmt.executeUpdate();
                        if (result > 0) {
                            response.sendRedirect("liste.jsp?msg=deleted");
                            return;
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
            
            if (!error.isEmpty()) {
                out.println("<div class='message error'>" + error + "</div>");
            }
            %>
            
            <!-- Barre de statistiques -->
            <div class="stats-bar">
                <div class="stats-card">
                    <div class="icon">👨‍🎓</div>
                    <div class="info">
                        <div class="number">
                            <%
                            int totalEtudiants = 0;
                            try (Connection conn = DBUtil.getConnection();
                                 Statement st = conn.createStatement();
                                 ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM etudiant")) {
                                if (rs.next()) totalEtudiants = rs.getInt(1);
                            } catch(Exception e) {}
                            out.print(totalEtudiants);
                            %>
                        </div>
                        <div class="label">Total Étudiants</div>
                    </div>
                </div>
                
                <div class="action-buttons">
                    <a href="./ajouter.jsp" class="btn btn-primary">➕ Ajouter un étudiant</a>
                    <a href="recherche.jsp" class="btn btn-info">🔍 Recherche avancée</a>
                    <a href="../menu.jsp" class="btn btn-success">🏠 Menu principal</a>
                </div>
            </div>
            
            <!-- Formulaire de recherche et filtre -->
<div class="search-bar">
    <form method="get">
        <input type="text" name="search" class="search-box" placeholder="🔍 Rechercher ..." 
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
            
            <!-- Tableau des étudiants -->
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>👨‍🎓 Numéro</th>
                            <th>📝 Nom</th>
                            <th>📝 Prénoms</th>
                            <th>🎓 Niveau</th>
                            <th>📧 Email</th>
                            <th>⚙️ Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;
                        boolean hasResults = false;
                        
                        try {
                        	conn = DBUtil.getConnection();
                        	stmt = conn.createStatement();

                        	String search = request.getParameter("search");
                        	String niveauFilter = request.getParameter("niveauFilter");

                        	String sql = "SELECT * FROM etudiant WHERE 1=1";

                        	// filtre recherche
                        	if (search != null && !search.trim().isEmpty()) {
                        	    sql += " AND (LOWER(nom) LIKE '%" + search.toLowerCase() + "%'"
                        	         + " OR LOWER(prenoms) LIKE '%" + search.toLowerCase() + "%'"
                        	         + " OR LOWER(num_etudiant) LIKE '%" + search.toLowerCase() + "%')";
                        	}

                        	// filtre niveau
                        	if (niveauFilter != null && !niveauFilter.isEmpty()) {
                        	    sql += " AND niveau = '" + niveauFilter + "'";
                        	}

                        	sql += " ORDER BY nom, prenoms";

                        	rs = stmt.executeQuery(sql);
                            while (rs.next()) {
                                hasResults = true;
                                String num = rs.getString("num_etudiant");
                                String nom = rs.getString("nom");
                                String prenom = rs.getString("prenoms");
                                String niveau = rs.getString("niveau");
                                String email = rs.getString("adr_email");
                                
                                // Emoji pour le niveau
                                String niveauEmoji = "";
                                if ("L1".equals(niveau)) niveauEmoji = "📗 ";
                                else if ("L2".equals(niveau)) niveauEmoji = "📘 ";
                                else if ("L3".equals(niveau)) niveauEmoji = "📙 ";
                                else if ("M1".equals(niveau)) niveauEmoji = "📕 ";
                                else if ("M2".equals(niveau)) niveauEmoji = "📒 ";
                        %>
                        <tr>
                            <td><strong><%= num %></strong></td>
                            <td><%= nom %></td>
                            <td><%= prenom %></td>
                            <td><%= niveauEmoji + niveau %></td>
                            <td><a href="mailto:<%= email %>" style="color: #667eea; text-decoration: none;"><%= email %></a></td>
                            <td class="action-icons">
                                <a href="modifier.jsp?id=<%= rs.getString("num_etudiant") %> " class="edit-link">✏️ Modifier</a>
                                <a href="liste.jsp?action=delete&num=<%= num %>" class="delete-link" onclick="return confirmDelete('<%= num %>')">🗑️ Supprimer</a>
                            </td>
                        </tr>
                        <%
                            }
                            
                            if (!hasResults) {
                        %>
                        <tr>
                            <td colspan="6">
                                <div class="empty-state">
                                    <div class="icon">📭</div>
                                    <h3>Aucun étudiant trouvé</h3>
                                    <p>Commencez par ajouter des étudiants à la base de données.</p>
                                    <a href="ajout.jsp" class="btn btn-primary" style="margin-top: 20px;">➕ Ajouter un étudiant</a>
                                </div>
                            </td>
                        </tr>
                        <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6'><div class='message error'>❌ Erreur : " + e.getMessage() + "</div></td></tr>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch(SQLException e) {}
                            if (stmt != null) try { stmt.close(); } catch(SQLException e) {}
                            if (conn != null) try { conn.close(); } catch(SQLException e) {}
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
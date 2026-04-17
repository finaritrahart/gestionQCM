<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier Étudiant</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            backdrop-filter: blur(5px);
        }
        
        .modal {
            background: white;
            width: 90%;
            max-width: 550px;
            border-radius: 20px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.3);
            animation: modalSlideIn 0.3s ease;
            overflow: hidden;
        }
        
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px) scale(0.9);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        
        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-header h2 {
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .close-btn {
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        
        .close-btn:hover {
            background: rgba(255,255,255,0.4);
            transform: rotate(90deg);
        }
        
        .modal-body {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }
        
        .form-group label i {
            margin-right: 8px;
            color: #667eea;
        }
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            font-family: inherit;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-group input[readonly] {
            background-color: #f5f5f5;
            cursor: not-allowed;
            color: #666;
        }
        
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }
        
        .btn-primary {
            flex: 2;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            flex: 1;
            background: #6c757d;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        .message {
            padding: 12px 15px;
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
        
        .loading {
            text-align: center;
            padding: 40px;
            color: #667eea;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>

<%
String num = request.getParameter("id");
String message = "";
String error = "";

// Si pas de numéro, fermer la modal
if (num == null || num.trim().isEmpty()) {
%>
    <div class="modal">
        <div class="modal-header">
            <h2>⚠️ Erreur</h2>
            <button class="close-btn" onclick="window.close()">✕</button>
        </div>
        <div class="modal-body">
            <div class="message error">Aucun étudiant sélectionné</div>
            <div class="button-group">
                <button class="btn-secondary" onclick="window.close()">Fermer</button>
            </div>
        </div>
    </div>
<%
    return;
}

/* ===========================
   PARTIE UPDATE (POST)
   =========================== */
if (request.getMethod().equalsIgnoreCase("POST")) {
    String nom = request.getParameter("nom");
    String prenoms = request.getParameter("prenoms");
    String niveau = request.getParameter("niveau");
    String email = request.getParameter("email");
    
    // Validation
    if (nom == null || nom.trim().isEmpty() ||
        prenoms == null || prenoms.trim().isEmpty() ||
        email == null || email.trim().isEmpty()) {
        error = "Tous les champs sont obligatoires";
    } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
        error = "Email invalide";
    } else {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE etudiant SET nom=?, prenoms=?, niveau=?, adr_email=? WHERE num_etudiant=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, nom);
            ps.setString(2, prenoms);
            ps.setString(3, niveau);
            ps.setString(4, email);
            ps.setString(5, num);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                // Redirection avec message de succès
                response.sendRedirect("liste.jsp?msg=updated&close=1");
                return;
            } else {
                error = "Erreur lors de la modification";
            }
        } catch (Exception e) {
            error = "Erreur : " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch(Exception e) {}
            try { if (conn != null) conn.close(); } catch(Exception e) {}
        }
    }
}
%>

<div class="modal">
    <div class="modal-header">
        <h2>✏️ Modifier l'étudiant</h2>
        <a href="./liste.jsp" class="close-btn">✕</a>
    </div>
    <div class="modal-body">
        
        <% if (!error.isEmpty()) { %>
            <div class="message error">❌ <%= error %></div>
        <% } %>
        
        <%
        /* ===========================
           PARTIE AFFICHAGE (GET)
           =========================== */
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM etudiant WHERE num_etudiant=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, num);
            rs = ps.executeQuery();
            
            if (rs.next()) {
        %>
        
        <form method="post" id="editForm">
            <div class="form-group">
                <label><i>👨‍🎓</i> Numéro d'étudiant</label>
                <input type="text" name="num" value="<%= rs.getString("num_etudiant") %>" readonly>
            </div>
            
            <div class="form-group">
                <label><i>📝</i> Nom</label>
                <input type="text" name="nom" value="<%= rs.getString("nom") %>" required>
            </div>
            
            <div class="form-group">
                <label><i>📝</i> Prénoms</label>
                <input type="text" name="prenoms" value="<%= rs.getString("prenoms") %>" required>
            </div>
            
            <div class="form-group">
                <label><i>🎓</i> Niveau</label>
                <select name="niveau">
                    <option value="L1" <%= "L1".equals(rs.getString("niveau")) ? "selected" : "" %>>📗 L1</option>
                    <option value="L2" <%= "L2".equals(rs.getString("niveau")) ? "selected" : "" %>>📘 L2</option>
                    <option value="L3" <%= "L3".equals(rs.getString("niveau")) ? "selected" : "" %>>📙 L3</option>
                    <option value="M1" <%= "M1".equals(rs.getString("niveau")) ? "selected" : "" %>>📕 M1</option>
                    <option value="M2" <%= "M2".equals(rs.getString("niveau")) ? "selected" : "" %>>📒 M2</option>
                </select>
            </div>
            
            <div class="form-group">
                <label><i>📧</i> Email</label>
                <input type="email" name="email" value="<%= rs.getString("adr_email") %>" required>
            </div>
            
            <div class="button-group">
                <button type="submit" class="btn-primary">💾 Enregistrer</button>
                <a href="./liste.jsp" class="btn-secondary" onclick="window.close()">❌ Annuler</a>
            </div>
        </form>
        
        <%
            } else {
                out.println("<div class='message error'>❌ Étudiant non trouvé</div>");
                out.println("<div class='button-group'><button class='btn-secondary' onclick='window.close()'>Fermer</button></div>");
            }
        } catch (Exception e) {
            out.println("<div class='message error'>❌ Erreur : " + e.getMessage() + "</div>");
        } finally {
            try { if (rs != null) rs.close(); } catch(Exception e) {}
            try { if (ps != null) ps.close(); } catch(Exception e) {}
            try { if (conn != null) conn.close(); } catch(Exception e) {}
        }
        %>
    </div>
</div>

<script>
    // Fermer la modal avec la touche Echap
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            window.close();
        }
    });
</script>

</body>
</html>
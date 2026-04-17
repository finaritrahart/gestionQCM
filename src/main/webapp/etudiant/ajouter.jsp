<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter un Étudiant</title>
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
            max-width: 600px;
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
        
        .form-container {
            padding: 40px;
        }
        
        .form-group {
            margin-bottom: 25px;
            position: relative;
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
        
        .form-group input:hover, 
        .form-group select:hover {
            border-color: #764ba2;
        }
        
        .form-group .error {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        
        .btn-submit {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 14px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-submit:active {
            transform: translateY(0);
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
        
        .back-link {
            display: inline-block;
            margin-top: 20px;
            text-align: center;
            width: 100%;
            text-decoration: none;
            color: #667eea;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        
        .back-link:hover {
            color: #764ba2;
        }
        
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 20px;
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
        
        .required:after {
            content: " *";
            color: #e74c3c;
        }
        
        @media (max-width: 768px) {
            .form-container {
                padding: 25px;
            }
            
            .header h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>📚 Ajouter un Étudiant</h2>
            <p>Veuillez remplir tous les champs ci-dessous</p>
        </div>
        
        <div class="form-container">
            <%
            // Traitement de l'ajout
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String num_etudiant = request.getParameter("num");
                String nom = request.getParameter("nom");
                String prenoms = request.getParameter("prenoms");
                String niveau = request.getParameter("niveau");
                String adr_email = request.getParameter("email");
                
                // Validation des champs
                boolean hasError = false;
                StringBuilder errorMsg = new StringBuilder();
                
                if (num_etudiant == null || num_etudiant.trim().isEmpty()) {
                    hasError = true;
                    errorMsg.append("• Le numéro d'étudiant est obligatoire<br>");
                }
                if (nom == null || nom.trim().isEmpty()) {
                    hasError = true;
                    errorMsg.append("• Le nom est obligatoire<br>");
                }
                if (prenoms == null || prenoms.trim().isEmpty()) {
                    hasError = true;
                    errorMsg.append("• Le prénom est obligatoire<br>");
                }
                if (adr_email == null || adr_email.trim().isEmpty()) {
                    hasError = true;
                    errorMsg.append("• L'email est obligatoire<br>");
                } else if (!adr_email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                    hasError = true;
                    errorMsg.append("• L'email n'est pas valide<br>");
                }
                
                if (hasError) {
                    out.println("<div class='message error'>❌ Veuillez corriger les erreurs suivantes :<br>" + errorMsg.toString() + "</div>");
                } else {
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    
                    try {
                        conn = DBUtil.getConnection();
                        
                        // Vérifier si l'étudiant existe déjà
                        String checkSql = "SELECT COUNT(*) FROM etudiant WHERE num_etudiant = ?";
                        pstmt = conn.prepareStatement(checkSql);
                        pstmt.setString(1, num_etudiant);
                        ResultSet rs = pstmt.executeQuery();
                        rs.next();
                        int count = rs.getInt(1);
                        
                        if (count > 0) {
                            out.println("<div class='message error'>❌ Un étudiant avec ce numéro existe déjà !</div>");
                        } else {
                            // Insertion avec PreparedStatement (sécurisé)
                            pstmt.close();
                            String sql = "INSERT INTO etudiant (num_etudiant, nom, prenoms, niveau, adr_email) VALUES (?, ?, ?, ?, ?)";
                            pstmt = conn.prepareStatement(sql);
                            pstmt.setString(1, num_etudiant);
                            pstmt.setString(2, nom);
                            pstmt.setString(3, prenoms);
                            pstmt.setString(4, niveau);
                            pstmt.setString(5, adr_email);
                            
                            int result = pstmt.executeUpdate();
                            
                            if (result > 0) {
                                out.println("<div class='message success'>✅ Étudiant ajouté avec succès !</div>");
                                // Optionnel : vider le formulaire
                                // out.println("<script>setTimeout(function(){ window.location.href='ajout.jsp'; }, 2000);</script>");
                            } else {
                                out.println("<div class='message error'>❌ Erreur lors de l'ajout</div>");
                            }
                        }
                        rs.close();
                        
                    } catch (SQLException e) {
                        out.println("<div class='message error'>❌ Erreur SQL : " + e.getMessage() + "</div>");
                    } catch (Exception e) {
                        out.println("<div class='message error'>❌ Erreur : " + e.getMessage() + "</div>");
                    } finally {
                        if (pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
                        if (conn != null) try { conn.close(); } catch(SQLException e) {}
                    }
                }
            }
            %>
            
            <form method="post" id="studentForm">
                <div class="form-group">
                    <label for="num"><i>👨‍🎓</i> Numéro d'étudiant <span class="required"></span></label>
                    <input type="text" id="num" name="num" placeholder="Ex: ETU001" required>
                    <div class="error" id="numError"></div>
                </div>
                
                <div class="form-group">
                    <label for="nom"><i>📝</i> Nom <span class="required"></span></label>
                    <input type="text" id="nom" name="nom" placeholder="Ex: RAKOTO" required>
                    <div class="error" id="nomError"></div>
                </div>
                
                <div class="form-group">
                    <label for="prenoms"><i>📝</i> Prénoms <span class="required"></span></label>
                    <input type="text" id="prenoms" name="prenoms" placeholder="Ex: Jean Marc" required>
                    <div class="error" id="prenomsError"></div>
                </div>
                
                <div class="form-group">
                    <label for="niveau"><i>🎓</i> Niveau d'étude</label>
                    <select id="niveau" name="niveau">
                        <option value="L1">📗 Licence 1 (L1)</option>
                        <option value="L2">📘 Licence 2 (L2)</option>
                        <option value="L3">📙 Licence 3 (L3)</option>
                        <option value="M1">📕 Master 1 (M1)</option>
                        <option value="M2">📒 Master 2 (M2)</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="email"><i>📧</i> Email <span class="required"></span></label>
                    <input type="email" id="email" name="email" placeholder="exemple@universite.mg" required>
                    <div class="error" id="emailError"></div>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="btn-primary">➕ Ajouter l'étudiant</button>
                    <a href="liste.jsp" class="btn-secondary">📋 Voir la liste</a>
                </div>
            </form>
            
            <a href="../menu.jsp" class="back-link">🏠 Retour au menu principal</a>
        </div>
    </div>
    
    <script>
        // Validation côté client
        document.getElementById('studentForm').addEventListener('submit', function(e) {
            let isValid = true;
            
            // Validation du numéro
            const num = document.getElementById('num').value.trim();
            if (num === '') {
                showError('numError', 'Le numéro d\'étudiant est obligatoire');
                isValid = false;
            } else {
                hideError('numError');
            }
            
            // Validation du nom
            const nom = document.getElementById('nom').value.trim();
            if (nom === '') {
                showError('nomError', 'Le nom est obligatoire');
                isValid = false;
            } else {
                hideError('nomError');
            }
            
            // Validation des prénoms
            const prenoms = document.getElementById('prenoms').value.trim();
            if (prenoms === '') {
                showError('prenomsError', 'Le prénom est obligatoire');
                isValid = false;
            } else {
                hideError('prenomsError');
            }
            
            // Validation de l'email
            const email = document.getElementById('email').value.trim();
            const emailRegex = /^[^\s@]+@([^\s@.,]+\.)+[^\s@.,]{2,}$/;
            if (email === '') {
                showError('emailError', 'L\'email est obligatoire');
                isValid = false;
            } else if (!emailRegex.test(email)) {
                showError('emailError', 'Veuillez entrer un email valide');
                isValid = false;
            } else {
                hideError('emailError');
            }
            
            if (!isValid) {
                e.preventDefault();
            }
        });
        
        function showError(elementId, message) {
            const errorElement = document.getElementById(elementId);
            errorElement.textContent = message;
            errorElement.style.display = 'block';
            const input = errorElement.previousElementSibling;
            if (input && input.tagName === 'INPUT') {
                input.style.borderColor = '#e74c3c';
            }
        }
        
        function hideError(elementId) {
            const errorElement = document.getElementById(elementId);
            errorElement.style.display = 'none';
            const input = errorElement.previousElementSibling;
            if (input && input.tagName === 'INPUT') {
                input.style.borderColor = '#e0e0e0';
            }
        }
        
        // Validation en temps réel
        const inputs = document.querySelectorAll('input');
        inputs.forEach(input => {
            input.addEventListener('input', function() {
                if (this.value.trim() !== '') {
                    const errorId = this.id + 'Error';
                    hideError(errorId);
                    this.style.borderColor = '#e0e0e0';
                }
            });
        });
    </script>
</body>
</html>

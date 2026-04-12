<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Passer l'examen QCM</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg,#D3D3D3  0%,  #44556f 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            animation: slideIn 0.5s ease-out;
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
            margin-bottom: 10px;
        }
        
        .content {
            padding: 40px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        input[type="text"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s;
        }
        
        input[type="text"]:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }
        
        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 14px 30px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        
        .btn:active {
            transform: translateY(0);
        }
        
        .info-card {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .question-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s;
        }
        
        .question-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transform: translateX(5px);
        }
        
        .question-number {
            background: #667eea;
            color: white;
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 15px;
        }
        
        .question-text {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
        }
        
        .option {
            margin: 10px 0;
            padding: 10px;
            border-radius: 8px;
            transition: background 0.2s;
        }
        
        .option:hover {
            background: #f8f9fa;
        }
        
        .option input {
            margin-right: 10px;
            cursor: pointer;
        }
        
        .option label {
            display: inline;
            cursor: pointer;
            font-weight: normal;
        }
        
        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .alert-error {
            background: #fee;
            color: #c33;
            border-left: 4px solid #c33;
        }
        
        .alert-success {
            background: #efe;
            color: #3c3;
            border-left: 4px solid #3c3;
        }
        
        hr {
            margin: 20px 0;
            border: none;
            height: 2px;
            background: linear-gradient(to right, #667eea, #764ba2);
        }
        
        .submit-btn {
            text-align: center;
            margin-top: 30px;
        }
        
        @media (max-width: 768px) {
            .content {
                padding: 20px;
            }
            
            .question-text {
                font-size: 16px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>📝 Passer l'examen QCM</h2>
            <p>Système adaptatif selon votre niveau</p>
        </div>
        
        <div class="content">
    <%
    String action = request.getParameter("action");

    // === 1. Formulaire initial ===
    if (action == null || !action.equals("commencer")) {
    %>
        <form method="post">
            <input type="hidden" name="action" value="commencer">
            <div class="form-group">
            <label>Numéro étudiant :</label> <input type="text" name="num_etudiant" required><br><br>
            </div>
            <div class= "form-group">
            <label>Année universitaire (ex: 2025-2026) : </label><input type="text" name="annee_univ" value="2025-2026" required><br><br>
            </div>
            <input type="submit" class="btn" value="Commencer l'examen (10 questions)">
            <button class="btn" onclick="history.back()">◀ Retour</button>
        </form>
    <%
    } 
    // === 2. Affichage des 10 questions du même niveau que l'étudiant ===
    else {
        String numEtudiant = request.getParameter("num_etudiant");
        String anneeUniv   = request.getParameter("annee_univ");
            try (Connection conn = DBUtil.getConnection()) {

            	// 1. Vérifier étudiant + récupérer niveau
                PreparedStatement psNiveau = conn.prepareStatement(
                    "SELECT niveau FROM etudiant WHERE num_etudiant = ?"
                );
                psNiveau.setString(1, numEtudiant);
                ResultSet rsNiveau = psNiveau.executeQuery();

                String niveauEtudiant = null;
                if (rsNiveau.next()) {
                    niveauEtudiant = rsNiveau.getString("niveau");
                } else {
                	 %>
                     <div class="alert alert-error">
                         ❌ Étudiant non trouvé avec le numéro : <strong><%= numEtudiant %></strong><br>
                         Veuillez vérifier votre numéro d'étudiant.
                     </div>
                     <button class="btn" onclick="history.back()">◀ Retour</button>
                     <%
                    rsNiveau.close();
                    psNiveau.close();
                    return; 
                }
                rsNiveau.close();
                psNiveau.close();
             // Vérifier si l'étudiant a déjà passé l'examen cette année
                PreparedStatement psDejaPasse = conn.prepareStatement(
                    "SELECT note FROM examen WHERE num_etudiant = ? AND annee_univ = ?"
                );
                psDejaPasse.setString(1, numEtudiant);
                psDejaPasse.setString(2, anneeUniv);
                
                ResultSet rsDeja = psDejaPasse.executeQuery();
                
                if (rsDeja.next()) {
                    int noteDeja = rsDeja.getInt("note");
                    out.println("<p style='color:orange; font-size:18px'>");
                    out.println("⚠️ Vous avez déjà passé l'examen pour l'année <strong>" + anneeUniv + "</strong>.<br>");
                    out.println("Votre note était : <strong>" + noteDeja + " / 10</strong>");
                    out.println("</p>");
                    
                    out.println("<br><a href='../examen/passerExamen.jsp'>← Retour pour un autre examen</a>");
                    
                    rsDeja.close();
                    psDejaPasse.close();
                    return;   // On arrête tout, on n'affiche pas les questions
                }
                
                rsDeja.close();
                psDejaPasse.close();
                // 2. Vérifier format année (2025-2026)
                if (!anneeUniv.matches("^\\d{4}-\\d{4}$")) {
                	%><div class="alert alert-error">
                    ❌ Erreur : Format d'année incorrect.<br>
                    Exemple valide : 2025-2026
                </div>
                <button class="btn" onclick="history.back()">◀ Retour</button>
                <%
                    return;
                }
                // 3. Vérifier nombre de questions disponibles pour le niveau
                PreparedStatement psCount = conn.prepareStatement(
                    "SELECT COUNT(*) FROM qcm WHERE niveau = ?"
                );
                psCount.setString(1, niveauEtudiant);
                ResultSet rsCount = psCount.executeQuery();
                
                int nbQuestions = 0;
                if (rsCount.next()) {
                    nbQuestions = rsCount.getInt(1);
                }
                rsCount.close();
                psCount.close();

                if (nbQuestions < 10) {
                	%>
                    <div class="alert alert-error">
                        ⚠️ Impossible de passer l'examen : seulement <strong><%= nbQuestions %></strong> questions disponibles pour le niveau <strong><%= niveauEtudiant %></strong>.<br>
                        Veuillez consulter votre Professeur.
                    </div>
                    <button class="btn" onclick="history.back()">◀ Retour</button>
                    <%
                    
                }
                //  Tirer 10 questions au hasard du même niveau
                PreparedStatement psQuestions = conn.prepareStatement(
                    "SELECT num_quest, question, reponse1, reponse2, reponse3, reponse4 " +
                    "FROM qcm " +
                    "WHERE niveau = ? " +
                    "ORDER BY RANDOM() " +
                    "LIMIT 10"
                );
                psQuestions.setString(1, niveauEtudiant);

                ResultSet rs = psQuestions.executeQuery();

                int questionIndex = 1;
    %>
                <div class="info-card">
                    <strong>👨‍🎓 Étudiant :</strong> <%= numEtudiant %> &nbsp;|&nbsp;
                    <strong>📊 Niveau :</strong> <%= niveauEtudiant %> &nbsp;|&nbsp;
                    <strong>📅 Année :</strong> <%= anneeUniv %>
                </div>

                <form method="post" action="traiterExamen.jsp">
                    <input type="hidden" name="num_etudiant" value="<%= numEtudiant %>">
                    <input type="hidden" name="annee_univ" value="<%= anneeUniv %>">

                    <% while (rs.next()) { %>
                    <div class="question-card">
                        <p><strong>Question <%= questionIndex %> :</strong> <%= rs.getString("question") %></p>

                        <input type="hidden" name="quest_<%= questionIndex %>" value="<%= rs.getInt("num_quest") %>">

                        <div class="option"><label><input type="radio" name="rep_<%= questionIndex %>" value="1" required> <%= rs.getString("reponse1") %></label><br></div>
                        <div class="option"><label><input type="radio" name="rep_<%= questionIndex %>" value="2"> <%= rs.getString("reponse2") %></label><br></div>
                        <div class="option"><label><input type="radio" name="rep_<%= questionIndex %>" value="3"> <%= rs.getString("reponse3") %></label><br></div>
                        <div class="option"><label><input type="radio" name="rep_<%= questionIndex %>" value="4"> <%= rs.getString("reponse4") %></label><br></div>
					</div>
                        <% questionIndex++; %>
                    <% } %>
					
                    <% if (questionIndex <= 1) { %>
                        <p style="color:red">Désolé, il n'y a pas encore assez de questions pour le niveau <%= niveauEtudiant %>.</p>
                    <% } else { %>
                        <br>
                         <div class="submit-btn">
                            <button type="submit" class="btn">Terminer l'examen et voir ma note</button>
                        </div>
                    <% } %>
                </form>

    <%
                rs.close();
                psQuestions.close();

            } catch (Exception e) {
            	%>
                <div class="alert alert-error">
                    ❌ Erreur technique : <%= e.getMessage() %>
                </div>
                <%
                e.printStackTrace();
            }
        }
    %>
</div>
</div>
</body>
</html>
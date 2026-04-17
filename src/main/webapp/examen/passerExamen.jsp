<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Question, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Passer l'examen QCM</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg,#D3D3D3 0%, #44556f 100%);
            min-height: 100vh;
            padding: 20px;
            margin-top: 0;
            display: flex;
  			justify-content: center; 
  			align-items: center; 
        }
        .container {
        	
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .header h2 { font-size: 28px; margin-bottom: 10px; }
        .content { padding: 40px; }
        .form-group { margin-bottom: 25px; }
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
            margin-right: 10px;
            margin-left: 10px;
        }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(0,0,0,0.2); }

        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .alert-error { background: #fee; color: #c33; border-left: 4px solid #c33; }
        .alert-warning { background: #fff3cd; color: #856404; border-left: 4px solid #ffc107; }

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
        }
        .option {
            margin: 10px 0;
            padding: 10px;
            border-radius: 8px;
        }
        .option:hover { background: #f8f9fa; }
        .submit-btn { text-align: center; margin-top: 30px; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>Passer l'examen de QCM</h2>
        <p>Système adaptater selon votre niveau d'étude</p>
    </div>

    <div class="content">

        <%-- ==================== AFFICHAGE DES ERREURS / MESSAGES ==================== --%>
        <%
            String erreur = (String) request.getAttribute("erreur");
            Integer noteDeja = (Integer) request.getAttribute("noteDeja");
            String anneeUniv = (String) request.getAttribute("anneeUniv");
        %>

        <% if (erreur != null) { %>
            <div class="alert alert-error">
                ❌ <%= erreur %>
            </div>
            <button class="btn" onclick="history.back()">◀ Retour</button>
        <% } %>

        <% if (noteDeja != null) {  %>
            <div class="alert alert-warning">
                ⚠️ Vous avez déjà passé l'examen pour l'année <strong><%= anneeUniv %></strong>.<br>
                Votre note était : <strong><%= noteDeja %> / 10</strong>
            </div>
            <button class="btn" onclick="history.back()">Passer un autre examen (autre année)</button>
        <% } %>

        <%-- ==================== FORMULAIRE INITIAL ==================== --%>
        <%
            // Si on arrive sans attribut "questions" → on affiche le formulaire
            if (request.getAttribute("questions") == null && noteDeja == null && erreur == null) {
        %>
            <form method="post" action="${pageContext.request.contextPath}/examen/passer">
                <div class="form-group">
                    <label>Numéro étudiant :</label>
                    <input type="text" name="num_etudiant" required>
                </div>
                <div class="form-group">
                    <label>Année universitaire (ex: 2025-2026) :</label>
                    <input type="text" name="annee_univ" value="2025-2026" required>
                </div>
                <button type="submit" class="btn">Commencer l'examen (10 questions)</button>
            </form>
        <%
            }
        %>

        <%-- ==================== AFFICHAGE DES QUESTIONS ==================== --%>
        <%
            List<Question> questions = (List<Question>) request.getAttribute("questions");
            String numEtudiant = (String) request.getAttribute("numEtudiant");
            String niveau      = (String) request.getAttribute("niveau");
            anneeUniv          = (String) request.getAttribute("anneeUniv"); // re-récupération

            if (questions != null && !questions.isEmpty()) {
        %>
            <div class="info-card">
                <strong>👨‍🎓 Étudiant :</strong> <%= numEtudiant %> &nbsp;|&nbsp;
                <strong>Niveau :</strong> <%= niveau %> &nbsp;|&nbsp;
                <strong> Année :</strong> <%= anneeUniv %>
            </div>

            <form method="post" action="traiterExamen.jsp">
                <input type="hidden" name="num_etudiant" value="<%= numEtudiant %>">
                <input type="hidden" name="annee_univ" value="<%= anneeUniv %>">

                <% int index = 1; for (Question q : questions) { %>
                    <div class="question-card">
                        <p><strong>Question <%= index %> :</strong> <%= q.getQuestion() %></p>

                        <input type="hidden" name="quest_<%= index %>" value="<%= q.getNumQuest() %>">

                        <div class="option"><label><input type="radio" name="rep_<%= index %>" value="1" required> <%= q.getRep1() %></label></div>
                        <div class="option"><label><input type="radio" name="rep_<%= index %>" value="2"> <%= q.getRep2() %></label></div>
                        <div class="option"><label><input type="radio" name="rep_<%= index %>" value="3"> <%= q.getRep3() %></label></div>
                        <div class="option"><label><input type="radio" name="rep_<%= index %>" value="4"> <%= q.getRep4() %></label></div>
                    </div>
                <% index++; } %>

                <div class="submit-btn">
                    <button type="submit" class="btn">Terminer l'examen et voir ma note</button>
                </div>
            </form>
        <% } %>

    </div>
</div>
</body>
</html>
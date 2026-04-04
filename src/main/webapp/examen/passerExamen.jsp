<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Passer l'examen</title>
</head>
<body>
    <h2>Passer l'examen QCM - Niveau adapté</h2>

    <%
    String action = request.getParameter("action");

    // === 1. Formulaire initial ===
    if (action == null || !action.equals("commencer")) {
    %>
        <form method="post">
            <input type="hidden" name="action" value="commencer">
            Numéro étudiant : <input type="text" name="num_etudiant" required><br><br>
            Année universitaire (ex: 2025-2026) : <input type="text" name="annee_univ" value="2025-2026" required><br><br>
            <input type="submit" value="Commencer l'examen (10 questions)">
        </form>
    <%
    } 
    // === 2. Affichage des 10 questions du même niveau que l'étudiant ===
    else {
        String numEtudiant = request.getParameter("num_etudiant");
        String anneeUniv   = request.getParameter("annee_univ");

        if (numEtudiant == null || numEtudiant.trim().isEmpty()) {
            out.println("<p style='color:red'>Erreur : Numéro étudiant obligatoire.</p>");
        } else {
            try (Connection conn = DBUtil.getConnection()) {

                // 1. Récupérer le niveau de l'étudiant
                PreparedStatement psNiveau = conn.prepareStatement(
                    "SELECT niveau FROM etudiant WHERE num_etudiant = ?"
                );
                psNiveau.setString(1, numEtudiant);
                ResultSet rsNiveau = psNiveau.executeQuery();

                String niveauEtudiant = null;
                if (rsNiveau.next()) {
                    niveauEtudiant = rsNiveau.getString("niveau");
                } else {
                    out.println("<p style='color:red'>Étudiant non trouvé avec le numéro : " + numEtudiant + "</p>");
                    rsNiveau.close();
                    psNiveau.close();
                    return;   // on arrête ici
                }
                rsNiveau.close();
                psNiveau.close();

                // 2. Tirer 10 questions au hasard du même niveau
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
                <h3>Étudiant : <%= numEtudiant %> | Niveau : <%= niveauEtudiant %> | Année : <%= anneeUniv %></h3>

                <form method="post" action="traiterExamen.jsp">
                    <input type="hidden" name="num_etudiant" value="<%= numEtudiant %>">
                    <input type="hidden" name="annee_univ" value="<%= anneeUniv %>">

                    <% while (rs.next()) { %>
                        <hr>
                        <p><strong>Question <%= questionIndex %> :</strong> <%= rs.getString("question") %></p>

                        <input type="hidden" name="quest_<%= questionIndex %>" value="<%= rs.getInt("num_quest") %>">

                        <label><input type="radio" name="rep_<%= questionIndex %>" value="1" required> <%= rs.getString("reponse1") %></label><br>
                        <label><input type="radio" name="rep_<%= questionIndex %>" value="2"> <%= rs.getString("reponse2") %></label><br>
                        <label><input type="radio" name="rep_<%= questionIndex %>" value="3"> <%= rs.getString("reponse3") %></label><br>
                        <label><input type="radio" name="rep_<%= questionIndex %>" value="4"> <%= rs.getString("reponse4") %></label><br>

                        <% questionIndex++; %>
                    <% } %>

                    <% if (questionIndex <= 1) { %>
                        <p style="color:red">Désolé, il n'y a pas encore assez de questions pour le niveau <%= niveauEtudiant %>.</p>
                    <% } else { %>
                        <br>
                        <input type="submit" value="Terminer l'examen et voir ma note">
                    <% } %>
                </form>

    <%
                rs.close();
                psQuestions.close();

            } catch (Exception e) {
                out.println("<p style='color:red'>Erreur : " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        }
    }
    %>
</body>
</html>
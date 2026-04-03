<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Passer l'examen</title>
</head>
<body>
    <h2>Passer l'examen QCM</h2>

    <%
    String action = request.getParameter("action");

    // === 1. Formulaire de départ : numéro étudiant + année universitaire ===
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
    // === 2. Affichage des 10 questions tirées au hasard ===
    else {
        String numEtudiant = request.getParameter("num_etudiant");
        String annee = request.getParameter("annee_univ");

        try (Connection conn = DBUtil.getConnection()) {
            // On tire 10 questions au hasard (PostgreSQL RANDOM())
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT num_quest, question, reponse1, reponse2, reponse3, reponse4 " +
                "FROM qcm ORDER BY RANDOM() LIMIT 10"
            );

            int questionIndex = 1;
    %>
            <h1>numéro de d'inscription: " + numEtudiant + " année :" + annee + "</h1>
            
            <form method="post" action="traiterExamen.jsp">
                <input type="hidden" name="num_etudiant" value="<%= numEtudiant %>">
                <input type="hidden" name="annee_univ" value="<%= annee %>">
                
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
                
                <br>
                <input type="submit" value="Terminer l'examen et voir ma note">
            </form>
    <%
            rs.close();
            st.close();
        } catch (Exception e) {
            out.println("<p style='color:red'>Erreur : " + e.getMessage() + "</p>");
        }
    }
    %>
</body>
</html>
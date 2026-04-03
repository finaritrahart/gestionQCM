<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Résultat de l'examen</title>
</head>
<body>
    <h2>Résultat de votre examen</h2>

    <%
    String numEtudiant = request.getParameter("num_etudiant");
    String anneeUniv   = request.getParameter("annee_univ");

    if (numEtudiant == null || anneeUniv == null) {
        out.println("<p style='color:red'>Erreur : données manquantes.</p>");
    } else {
        int note = 0;
        int totalQuestions = 10;

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);   // On commence une transaction

            // Pour chaque question (1 à 10)
            for (int i = 1; i <= totalQuestions; i++) {
                String questParam = "quest_" + i;
                String repParam   = "rep_" + i;

                String numQuestStr = request.getParameter(questParam);
                String repChoisieStr = request.getParameter(repParam);

                if (numQuestStr == null || repChoisieStr == null) continue;

                int numQuest = Integer.parseInt(numQuestStr);
                int repChoisie = Integer.parseInt(repChoisieStr);

                // Récupérer la bonne réponse dans la table QCM
                PreparedStatement ps = conn.prepareStatement(
                    "SELECT bonne_reponse FROM qcm WHERE num_quest = ?"
                );
                ps.setInt(1, numQuest);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    int bonneRep = rs.getInt("bonne_reponse");
                    if (repChoisie == bonneRep) {
                        note++;
                    }
                }
                rs.close();
                ps.close();
            }

            // Insertion du résultat dans la table examen
            PreparedStatement psInsert = conn.prepareStatement(
                "INSERT INTO examen (num_etudiant, annee_univ, note) VALUES (?, ?, ?)"
            );
            psInsert.setString(1, numEtudiant);
            psInsert.setString(2, anneeUniv);
            psInsert.setInt(3, note);
            psInsert.executeUpdate();

            conn.commit();   // Tout s'est bien passé → on valide

            // Affichage du résultat
            out.println("<h3>Numéro étudiant : " + numEtudiant + "</h3>");
            out.println("<h3>Année universitaire : " + anneeUniv + "</h3>");
            out.println("<h1 style='color:green'>Votre note : " + note + " / 10</h1>");

            if (note >= 7) {
                out.println("<p style='color:green'><strong>Bravo ! Excellent résultat.</strong></p>");
            } else if (note >= 5) {
                out.println("<p style='color:orange'>Vous avez la moyenne.</p>");
            } else {
                out.println("<p style='color:red'>Vous devez réviser davantage.</p>");
            }

        } catch (Exception e) {
            out.println("<p style='color:red'>Erreur lors du traitement : " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }
    %>

    <br>
    <a href="passerExamen.jsp">Passer un autre examen</a> |
    <a href="../etudiant/liste.jsp">Retour à la liste des étudiants</a>
</body>
</html>
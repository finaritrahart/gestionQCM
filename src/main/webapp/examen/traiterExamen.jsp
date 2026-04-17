<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Résultat de l'examen - QCM</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .result-container {
            max-width: 600px;
            width: 100%;
            margin: 0 auto;
            animation: slideIn 0.5s ease-out;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .result-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        
        .result-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .result-header h2 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .result-header p {
            opacity: 0.9;
            font-size: 14px;
        }
        
        .result-content {
            padding: 40px;
        }
        
        .student-info {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            border-left: 4px solid #667eea;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            padding: 8px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .info-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        
        .info-label {
            font-weight: 600;
            color: #555;
        }
        
        .info-value {
            color: #333;
            font-weight: 500;
        }
        
        .note-circle {
            text-align: center;
            margin: 30px 0;
        }
        
        .note-circle-inner {
            width: 200px;
            height: 200px;
            margin: 0 auto;
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            animation: pulse 1s ease-out;
        }
        
        @keyframes pulse {
            0% {
                transform: scale(0);
                opacity: 0;
            }
            50% {
                transform: scale(1.1);
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }
        
        .note-value {
            font-size: 64px;
            font-weight: bold;
            line-height: 1;
        }
        
        .note-total {
            font-size: 24px;
            opacity: 0.9;
            margin-top: 10px;
        }
        
        .percentage {
            font-size: 18px;
            margin-top: 10px;
            opacity: 0.9;
        }
        
        .message-box {
            padding: 20px;
            border-radius: 15px;
            margin: 30px 0;
            text-align: center;
            animation: fadeIn 0.5s ease-out 0.3s both;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .message-excellent {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }
        
        .message-moyen {
            background: linear-gradient(135deg, #f2994a 0%, #f2c94c 100%);
            color: white;
        }
        
        .message-faible {
            background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%);
            color: white;
        }
        
        .message-icon {
            font-size: 48px;
            margin-bottom: 10px;
        }
        
        .message-text {
            font-size: 18px;
            font-weight: 600;
        }
        
        .message-subtext {
            font-size: 14px;
            margin-top: 8px;
            opacity: 0.9;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        .btn:active {
            transform: translateY(0);
        }
        
        .stats-container {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-top: 20px;
        }
        
        .stat-bar {
            margin: 15px 0;
        }
        
        .stat-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
            font-size: 14px;
            color: #555;
        }
        
        .bar-background {
            background: #e0e0e0;
            height: 30px;
            border-radius: 15px;
            overflow: hidden;
        }
        
        .bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding-right: 10px;
            color: white;
            font-size: 14px;
            font-weight: bold;
            transition: width 1s ease-out;
        }
        
        @media (max-width: 768px) {
            .result-content {
                padding: 20px;
            }
            
            .note-circle-inner {
                width: 150px;
                height: 150px;
            }
            
            .note-value {
                font-size: 48px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="result-container">
        <div class="result-card">
            <div class="result-header">
                <h2>📊 Résultat de l'examen</h2>
                <p>QCM adaptatif - Session en cours</p>
            </div>
            
            <div class="result-content">
                <%
                String numEtudiant = request.getParameter("num_etudiant");
                String anneeUniv   = request.getParameter("annee_univ");

                if (numEtudiant == null || anneeUniv == null) {
                %>
                    <div class="student-info">
                        <div class="alert-error" style="background:#fee; color:#c33; padding:15px; border-radius:10px;">
                            ❌ Erreur : Données manquantes. Veuillez repasser l'examen.
                        </div>
                    </div>
                    <div class="action-buttons">
                        <a href="passerExamen.jsp" class="btn btn-primary">🔄 Passer l'examen</a>
                    </div>
                <%
                } else {
                    int note = 0;
                    int totalQuestions = 10;
                    String niveauEtudiant = "";

                    try (Connection conn = DBUtil.getConnection()) {
                        conn.setAutoCommit(false);
                        
                        // Récupérer le niveau de l'étudiant
                        PreparedStatement psNiveau = conn.prepareStatement(
                            "SELECT niveau FROM etudiant WHERE num_etudiant = ?"
                        );
                        psNiveau.setString(1, numEtudiant);
                        ResultSet rsNiveau = psNiveau.executeQuery();
                        if (rsNiveau.next()) {
                            niveauEtudiant = rsNiveau.getString("niveau");
                        }
                        rsNiveau.close();
                        psNiveau.close();

                        // Calculer la note
                        for (int i = 1; i <= totalQuestions; i++) {
                            String questParam = "quest_" + i;
                            String repParam   = "rep_" + i;

                            String numQuestStr = request.getParameter(questParam);
                            String repChoisieStr = request.getParameter(repParam);

                            if (numQuestStr == null || repChoisieStr == null) continue;

                            int numQuest = Integer.parseInt(numQuestStr);
                            int repChoisie = Integer.parseInt(repChoisieStr);

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

                        // Insérer le résultat
                        PreparedStatement psInsert = conn.prepareStatement(
                            "INSERT INTO examen (num_etudiant, annee_univ, note) VALUES (?, ?, ?)"
                        );
                        psInsert.setString(1, numEtudiant);
                        psInsert.setString(2, anneeUniv);
                        psInsert.setInt(3, note);
                        psInsert.executeUpdate();
					
                        conn.commit(); 
                        int pourcentage = (note * 100) / totalQuestions;
                %>
                                        <!-- ===================== ENVOI EMAIL ===================== -->
                        <%
                        try {
                            envoyerEmail(numEtudiant, anneeUniv, note, conn);
                            out.println("<p style='color:green; text-align:center; margin:20px 0; font-weight:bold;'>");
                            out.println("✅ Un email avec votre note a été envoyé !");
                            out.println("</p>");
                        } catch (Exception mailEx) {
                            out.println("<p style='color:orange; text-align:center; margin:20px 0;'>");
                            out.println("⚠️ Note enregistrée mais échec d'envoi email : " + mailEx.getMessage());
                            out.println("</p>");
                        }
                        %>
                
                <!-- Informations étudiant -->
                <div class="student-info">
                    <div class="info-row">
                        <span class="info-label">👨‍🎓 Numéro étudiant :</span>
                        <span class="info-value"><%= numEtudiant %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">📊 Niveau :</span>
                        <span class="info-value"><%= niveauEtudiant %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">📅 Année universitaire :</span>
                        <span class="info-value"><%= anneeUniv %></span>
                    </div>
                </div>
                
                <!-- Cercle de note -->
                <div class="note-circle">
                    <div class="note-circle-inner">
                        <div class="note-value"><%= note %></div>
                        <div class="note-total">/<%= totalQuestions %></div>
                        <div class="percentage"><%= pourcentage %>%</div>
                    </div>
                </div>
                
                <!-- Message personnalisé -->
                <div class="message-box 
                    <%= (note >= 7) ? "message-excellent" : ((note >= 5) ? "message-moyen" : "message-faible") %>">
                    <div class="message-icon">
                        <%= (note >= 7) ? "🏆" : ((note >= 5) ? "👍" : "📚") %>
                    </div>
                    <div class="message-text">
                        <%= (note >= 7) ? "Bravo ! Excellent résultat !" : 
                            ((note >= 5) ? "Félicitations ! Vous avez la moyenne." : 
                            "Continuez vos efforts !") %>
                    </div>
                    <div class="message-subtext">
                        <%= (note >= 7) ? "Vous maîtrisez parfaitement le sujet." : 
                            ((note >= 5) ? "Un bon début, mais vous pouvez encore progresser." : 
                            "N'hésitez pas à réviser et réessayer.") %>
                    </div>
                </div>
                
                <!-- Barre de progression -->
                <div class="stats-container">
                    <div class="stat-bar">
                        <div class="stat-label">
                            <span>📈 Performance</span>
                            <span><%= pourcentage %>% de réussite</span>
                        </div>
                        <div class="bar-background">
                            <div class="bar-fill" style="width: <%= pourcentage %>%">
                                <%= pourcentage %>%
                            </div>
                        </div>
                    </div>
                    <div class="stat-bar">
                        <div class="stat-label">
                            <span>✅ Bonnes réponses</span>
                            <span><%= note %> / <%= totalQuestions %></span>
                        </div>
                        <div class="bar-background">
                            <div class="bar-fill" style="width: <%= (note * 100) / totalQuestions %>%">
                                <%= note %>
                            </div>
                        </div>
                    </div>
                </div>

                <%
                    } catch (Exception e) {
                %>
                    <div class="student-info">
                        <div class="alert-error" style="background:#fee; color:#c33; padding:15px; border-radius:10px;">
                            ❌ Vous avez déja passer cet examen; veuillez consulter votre note pour cet année
                        </div>
                    </div>
                <%
                        e.printStackTrace();
                    }
                %>
                
                <!-- Boutons d'action -->
                <div class="action-buttons">
                    <a href="passerExamen.jsp" class="btn btn-primary">🔄 Passer un autre examen</a>
                    <a href="../menu.jsp" class="btn btn-secondary">🏠 Retourner au menu</a>
                </div>
                
                <% } %>
            </div>
        </div>
    </div>
    
    <script>
        // Animation pour la barre de progression
        window.addEventListener('load', function() {
            const barFill = document.querySelector('.bar-fill');
            if (barFill) {
                const width = barFill.style.width;
                barFill.style.width = '0%';
                setTimeout(() => {
                    barFill.style.width = width;
                }, 100);
            }
        });
    </script>
</body>
</html>
<%!
    private void envoyerEmail(String numEtudiant, String anneeUniv, int note, Connection conn) throws Exception {
        
        // Récupérer l'email de l'étudiant
        PreparedStatement ps = conn.prepareStatement("SELECT adr_email FROM etudiant WHERE num_etudiant = ?");
        ps.setString(1, numEtudiant);
        ResultSet rs = ps.executeQuery();
        
        String email = null;
        if (rs.next()) email = rs.getString("adr_email");
        rs.close();
        ps.close();

        if (email == null || email.trim().isEmpty()) return;

        // Configuration SMTP Gmail
        java.util.Properties props = new java.util.Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        javax.mail.Session session = javax.mail.Session.getInstance(props, new javax.mail.Authenticator() {
            protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                return new javax.mail.PasswordAuthentication("andrianiainaravo19@gmail.com", "bfnbaspznlbaiagh");
            }
        });

        javax.mail.Message message = new javax.mail.internet.MimeMessage(session);
        message.setFrom(new javax.mail.internet.InternetAddress("andrianiainaravo19@gmail.com"));
        message.setRecipients(javax.mail.Message.RecipientType.TO, javax.mail.internet.InternetAddress.parse(email));
        message.setSubject("Résultat de votre Examen QCM - " + anneeUniv);

        String contenu = "Bonjour,\n\n" +
                         "Vous avez passé l'examen pour l'année " + anneeUniv + ".\n\n" +
                         "Votre note est : " + note + " / 10\n\n" +
                         "Bonne continuation dans vos études !\n\n" +
                         "Cordialement,\nL'administration";

        message.setText(contenu);
        javax.mail.Transport.send(message);
    }
%>
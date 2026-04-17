<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Questionnaires - Menu Principal</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        h1 {
            text-align: center;
            color: white;
            margin-bottom: 10px;
            font-size: 36px;
        }
        
        .subtitle {
            text-align: center;
            color: rgba(255,255,255,0.9);
            margin-bottom: 40px;
            font-size: 18px;
        }
        
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }
        
        .card h3 {
            color: #333;
            margin-top: 0;
            font-size: 24px;
            border-bottom: 3px solid #667eea;
            display: inline-block;
            padding-bottom: 5px;
        }
        
        .card p {
            color: #666;
            line-height: 1.6;
            margin: 15px 0;
        }
        
        .card .icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .btn {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            margin-top: 15px;
            transition: opacity 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn:hover {
            opacity: 0.9;
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        
        .btn-info {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        
        .footer {
            text-align: center;
            margin-top: 50px;
            color: rgba(255,255,255,0.7);
            font-size: 14px;
        }
        
        .stats {
            background: rgba(255,255,255,0.2);
            border-radius: 10px;
            padding: 15px;
            margin-top: 30px;
            text-align: center;
            color: white;
        }
        
        @media (max-width: 768px) {
            .grid {
                grid-template-columns: 1fr;
            }
            h1 { font-size: 28px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📚 Gestion des Questionnaires</h1>
        <div class="subtitle">Plateforme de gestion des QCM et examens</div>
        
        <div class="grid">
            <!-- Carte Étudiants -->
            <div class="card">
                <div class="icon">👨‍🎓</div>
                <h3>Gestion des Étudiants</h3>
                <p>Ajouter, modifier, supprimer et rechercher des étudiants. Gestion des inscriptions par niveau.</p>
                <a href="etudiant/ajouter.jsp" class="btn">➕ Ajouter un étudiant</a>
                <a href="etudiant/liste.jsp" class="btn btn-info">📋 Liste des étudiants</a>
                <a href="etudiant/recherche.jsp" class="btn btn-secondary">🔍 Rechercher</a>
            </div>
            
            <!-- Carte QCM -->
            <div class="card">
                <div class="icon">📝</div>
                <h3>Gestion des QCM</h3>
                <p>Créer des questions à choix multiples, modifier et organiser par niveau (L1, L2, L3, M1, M2).</p>
                <a href="QCM/ajouter.jsp" class="btn">➕ Ajouter une question</a>
                <a href="QCM/liste.jsp" class="btn btn-info">📋 Liste des QCM</a>
            </div>
            
            <!-- Carte Examen -->
            <div class="card">
                <div class="icon">✍️</div>
                <h3>Passer un Examen</h3>
                <p>Lancer un examen avec 10 questions aléatoires. Calcul automatique de la note sur 10.</p>
                <a href="examen/passerExamen.jsp" class="btn btn-secondary">🎯 Commencer l'examen</a>
                <a href="examen/listeNotes" class="btn btn-info">📊 Voir les notes</a>
            </div>
            
            <!-- Carte Statistiques -->
            <div class="card">
                <div class="icon">📈</div>
                <h3>Classement & Statistiques</h3>
                <p>Consulter le classement des étudiants par ordre de mérite et les statistiques par niveau.</p>
                <a href="examen/classement.jsp" class="btn btn-info">🏆 Voir le classement</a>
                <a href="etudiant/stats_niveau.jsp" class="btn">📊 Stats par niveau</a>
            </div>
        </div>
        
        <div class="stats">
            <strong>📌 Fonctionnalités disponibles :</strong><br>
            ✓ CRUD Étudiants & QCM &nbsp;|&nbsp;
            ✓ Recherche par LIKE &nbsp;|&nbsp;
            ✓ Examen aléatoire &nbsp;|&nbsp;
            ✓ Envoi d'email &nbsp;|&nbsp;
            ✓ Classement par mérite
        </div>
        
        <div class="footer">
            &copy; 2024 - Gestion des Questionnaires | Projet JSP
        </div>
    </div>
    
    <script>
        // Animation optionnelle au survol
        const cards = document.querySelectorAll('.card');
        cards.forEach(card => {
            card.addEventListener('click', (e) => {
                // Ne pas déclencher si on clique sur un lien
                if (e.target.tagName !== 'A') {
                    const firstLink = card.querySelector('a');
                    if (firstLink) window.location.href = firstLink.href;
                }
            });
        });
    </script>
</body>
</html>
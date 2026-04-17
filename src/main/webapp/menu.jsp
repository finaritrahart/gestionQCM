<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - Gestion QCM & Examens</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 20px;
            text-align: center;
        }
        h1 { color: #2c3e50; margin-bottom: 10px; }
        .subtitle { color: #555; font-size: 1.2em; margin-bottom: 60px; }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
            gap: 40px;
            max-width: 900px;
            margin: 0 auto;
        }

        .card {
            background: white;
            border-radius: 20px;
            padding: 50px 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.4s ease;
            cursor: pointer;
        }
        .card:hover {
            transform: translateY(-15px);
            box-shadow: 0 25px 50px rgba(0,0,0,0.15);
        }
        .icon {
            font-size: 5rem;
            margin-bottom: 25px;
        }
        .card h3 {
            font-size: 1.8rem;
            margin-bottom: 15px;
            color: #2c3e50;
        }
        .card p {
            color: #666;
            margin-bottom: 30px;
            line-height: 1.5;
        }
        .btn {
            display: inline-block;
            padding: 14px 32px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: bold;
            font-size: 1.1em;
            transition: 0.3s;
        }
        .btn-examen {
            background: #27ae60;
            color: white;
        }
	        .btn-notes {
	       margin-top:10px; 
	    background: #f39c12;
	    color: white;
	    padding: 16px 32px;
	    border-radius: 50px;
	    text-decoration: none;
	    font-weight: bold;
	    display: inline-block;
	    text-align: center;
	    transition: 0.3s;
		}
		
		.btn-notes:hover {
		    background: #e67e22;
		    transform: scale(1.05);
		}
        .btn-admin {
            background: #8e44ad;
            color: white;
        }
        .btn:hover { transform: scale(1.08); }
    </style>
</head>
<body>

<div class="container">
    <h1>📚 Bienvenue sur la Plateforme</h1>
    <p class="subtitle">Choisissez votre espace</p>

    <div class="main-content">
        
        <!-- Partie gauche : Les deux cartes -->
        <div class="left-panel">
            <div class="menu-grid">
                <!-- Carte Administration -->
                <div class="card" onclick="goToAdmin()">
                    <div class="icon">⚙️</div>
                    <h3>Espace Administration</h3>
                    <p>Gestion complète des étudiants<br>et des questions QCM</p>
                    <span class="btn btn-admin">🔑 Accéder à l'administration</span>
                </div>
                <!-- Carte Examen -->
                <div class="card" onclick="window.location.href='examen/passerExamen.jsp'">
                    <div class="icon">✍️</div>
                    <h3>Passer un Examen</h3>
                    <br><br><br><br>
                    <span class="btn btn-examen">🎯 Commencer l'examen</span>
                </div>

                
            </div>
        </div>

        <!-- Partie droite : Notes & Classements avec image -->
        <div class="right-panel">
            <div class="notes-card">
                <div class="notes-overlay">
                    <a href="examen/listeNotes.jsp" class="btn btn-notes">
                        Voir les notes et classements
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>


<script>
function goToAdmin() {
    // Vérifier si déjà connecté
    if (localStorage.getItem('isLoggedIn') === 'true') {
        window.location.href = 'menuAdmin.jsp';   // on créera ce fichier après
    } else {
        window.location.href = 'login.jsp';
    }
}
</script>

</body>
</html>
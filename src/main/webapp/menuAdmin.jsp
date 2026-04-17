<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace Administration</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 20px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 2px solid #eee;
        }
        h1 { color: #2c3e50; }
        .logout-btn {
            padding: 10px 20px;
            background: #e74c3c;
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-weight: bold;
        }
        .logout-btn:hover { background: #c0392b; }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
            gap: 35px;
        }
        .card {
            background: white;
            border-radius: 20px;
            padding: 45px 30px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.4s;
        }
        .card:hover {
            transform: translateY(-12px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        .icon {
            font-size: 4.8rem;
            margin-bottom: 20px;
        }
        .card h3 {
            font-size: 1.7rem;
            margin-bottom: 15px;
            color: #2c3e50;
        }
        .card p {
            color: #555;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .btn {
            display: inline-block;
            padding: 14px 32px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: bold;
            margin: 8px;
            transition: 0.3s;
        }
        .btn-qcm { background: #3498db; color: white; }
        .btn-etudiant { background: #27ae60; color: white; }
        .btn:hover { transform: scale(1.07); }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <div>
            <h1>⚙️ Espace Administration</h1>
            <p>Bienvenue, Administrateur</p>
        </div>
        <a href="#" onclick="logout()" class="logout-btn"> Déconnexion</a>
    </div>

    <div class="menu-grid">
        
        <!-- Gestion QCM -->
        <div class="card">
            <div class="icon">📝</div>
            <h3>Gestion des QCM</h3>
            <p>Créer, modifier, supprimer et organiser les questions par niveau (L1 à M2)</p>
            <a href="./QCM/liste.jsp" class="btn btn-qcm">📋 Liste des QCM</a>
            <a href="./QCM/ajouter.jsp" class="btn btn-qcm">➕ Ajouter une question</a>
        </div>

        <!-- Gestion Étudiants -->
        <div class="card">
            <div class="icon">👨‍🎓</div>
            <h3>Gestion des Étudiants</h3>
            <p>Ajouter, modifier, supprimer et rechercher les étudiants</p>
            <a href="./etudiant/liste.jsp" class="btn btn-etudiant">📋 Liste des Étudiants</a>
            <a href="./etudiant/ajouter.jsp" class="btn btn-etudiant">➕ Ajouter un étudiant</a>
        </div>

    </div>
</div>

<script>
// Vérification de sécurité (si on accède directement sans login)
if (localStorage.getItem('isLoggedIn') !== 'true') {
    window.location.href = './login.jsp';
}

function logout() {
    if (confirm("Voulez-vous vraiment vous déconnecter ?")) {
        localStorage.removeItem('isLoggedIn');
        window.location.href = './menu.jsp';
    }
}
</script>

</body>
</html>
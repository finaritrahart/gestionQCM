<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion Admin</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-box {
            background: white;
            padding: 45px 35px;
            border-radius: 20px;
            width: 100%;
            max-width: 380px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.25);
            text-align: center;
        }
        h2 { margin-bottom: 10px; color: #2c3e50; }
        p { color: #666; margin-bottom: 30px; }
        input {
            width: 100%;
            padding: 15px;
            margin: 12px 0;
            border: 1px solid #ddd;
            border-radius: 10px;
            font-size: 16px;
        }
        .btn-login {
            width: 100%;
            padding: 15px;
            background: #8e44ad;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 17px;
            cursor: pointer;
            margin-top: 10px;
        }
        .error { color: #e74c3c; margin-top: 15px; font-weight: bold; }
    </style>
</head>
<body>

<div class="login-box">
    <h2>🔑 Connexion Administrateur</h2>
    <p>Accès réservé à l'administration</p>
    
    <input type="text" id="username" placeholder="Nom d'utilisateur" >
    <input type="password" id="password" placeholder="Mot de passe">
    
    <button class="btn-login" onclick="login()">Se Connecter</button>
    <div id="error" class="error"></div>
</div>

<script>
function login() {
    const user = document.getElementById('username').value.trim();
    const pass = document.getElementById('password').value.trim();
    const err = document.getElementById('error');

    if (user === "admin" && pass === "admin123") {
        localStorage.setItem('isLoggedIn', 'true');
        window.location.href = "menuAdmin.jsp";
    } else {
        err.textContent = "❌ Identifiants incorrects";
    }
}

// Valider avec la touche Entrée
document.getElementById('password').addEventListener("keypress", e => {
    if (e.key === "Enter") login();
});
</script>
</body>
</html>
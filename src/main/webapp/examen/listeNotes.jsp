<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.NoteEtudiant, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Classement des étudiants</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            background: #f5f7fa;
            padding: 2rem;
            color: #2c3e50;
        }
        
        .container {
            margin: 0 auto;
            padding:10%;
            border-radius: 20px ;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        
        /* Header */
        .page-header {
        	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px;
            border-radius: 20px 20px 0px 0px;
            text-align: center;
            margin-bottom: 0.5rem;
            max-height : 200px

        }
        
        .page-header h2 {
            font-size: 1.8rem;
            font-weight: 600;
            color: #1a2a3a;
            margin-bottom: 0.5rem;
        }
        
        .page-header p {
            color: #6c7a89;
            font-size: 0.95rem;
        }
        
        /* Statistiques */
        .stats-badge {
            background: white;
            border-radius: 12px;
            padding: 0.75rem 1.25rem;
            margin-bottom: 1.5rem;
            display: inline-block;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
        }
        
        .stats-badge strong {
            color: #2c3e50;
            font-weight: 600;
        }
        
        /* Messages */
        .alert-error {
            background: #fee2e2;
            border-left: 3px solid #e74c3c;
            padding: 1rem;
            border-radius: 8px;
            color: #c0392b;
            margin-bottom: 1.5rem;
        }
        
        .info-message {
            background: #ecf0f1;
            padding: 1.5rem;
            border-radius: 12px;
            text-align: center;
            color: #7f8c8d;
        }
        
        /* Tableau */
        .table-wrapper {
            background: white;
            border-radius: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            overflow-x: auto;
            border: 1px solid #e2e8f0;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }
        
        th {
            background: #f8fafc;
            padding: 1rem 1rem;
            text-align: left;
            font-weight: 600;
            color: #475569;
            border-bottom: 1px solid #e2e8f0;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        td {
            padding: 0.9rem 1rem;
            border-bottom: 1px solid #f0f2f5;
        }
        
        tr:hover {
            background: #fafcff;
        }
        
        /* Rang */
        .rang {
            font-weight: 600;
            color: #3b82f6;
        }
        
        .rang-top {
            background: #fef3c7;
            color: #d97706;
            padding: 0.2rem 0.5rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }
        
        /* Note */
        .note {
            font-weight: 700;
            color: #2c3e50;
        }
        
        .note-excellent {
            color: #10b981;
        }
        
        .note-moyen {
            color: #f59e0b;
        }
        
        .note-faible {
            color: #ef4444;
        }
        
        /* Lien retour */
        .back-link {
            display: inline-block;
            margin-top: 2rem;
            margin-left : 10rem;
            color: #6c7a89;
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.2s;
        }
        
        .back-link:hover {
            color: #3b82f6;
            text-decoration: underline;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }
            
            th, td {
                padding: 0.7rem;
            }
            
            .page-header h2 {
                font-size: 1.5rem;
            }
        }
        /* Filtre */
		.filter-field {
		    flex: 1;
		    min-width: 100px;
		}
		
		.filter-label {
		    
		    font-size: 0.8rem;
		    text-transform: uppercase;
		    letter-spacing: 0.5px;
		    font-weight: 600;
		    color: #64748b;
		    margin-bottom: 8px;
		}
		
		.filter-select {
		    width: 20%;
		    padding: 10px 12px;
		    border: 1px solid #cbd5e1;
		    border-radius: 8px;
		    font-size: 0.9rem;
		    background: white;
		    color: #1e293b;
		    cursor: pointer;
		    transition: all 0.2s;
		    outline: none;
		}
		
		.filter-select:hover {
		    border-color: #3b82f6;
		}
		
		.btn-filter {
		    background: #3b82f6;
		    color: white;
		    border: none;
		    padding: 10px 24px;
		    border-radius: 8px;
		    font-size: 0.9rem;
		    font-weight: 500;
		    cursor: pointer;
		    transition: all 0.2s;
		}
		
		.btn-filter:hover {
		    background: #2563eb;
		    transform: translateY(-1px);
		}
    </style>
</head>
<body>
    <div class="container">
        <div class="page-header">
            <h2>📊 Classement des étudiants aux examens QCM</h2>
                  <form method="get" action="${pageContext.request.contextPath}/examen/listeNotes" 
              style="margin-bottom: 30px; padding: 10px; background: #f8f9fa; border-radius: 20px;">
            
            <label class="filter-label">Niveau : </label>
            <select name="niveau" class="filter-select">
                <option value="">Tous les niveaux</option>
                <option value="L1" <%= "L1".equals(request.getAttribute("niveauFiltre")) ? "selected" : "" %>>L1</option>
                <option value="L2" <%= "L2".equals(request.getAttribute("niveauFiltre")) ? "selected" : "" %>>L2</option>
                <option value="L3" <%= "L3".equals(request.getAttribute("niveauFiltre")) ? "selected" : "" %>>L3</option>
                <option value="M1" <%= "M1".equals(request.getAttribute("niveauFiltre")) ? "selected" : "" %>>M1</option>
                <option value="M2" <%= "M2".equals(request.getAttribute("niveauFiltre")) ? "selected" : "" %>>M2</option>
            </select>

            <label class="filter-label">Année universitaire : </label>
            <select name="annee" class="filter-select">
                <option value="">Toutes les années</option>
                <% 
                    List<String> annees = (List<String>) request.getAttribute("anneesDisponibles");
                    String anneeCourante = (String) request.getAttribute("anneeFiltre");
                    if (annees != null) {
                        for (String a : annees) {
                %>
                    <option value="<%= a %>" <%= a.equals(anneeCourante) ? "selected" : "" %>><%= a %></option>
                <% 
                        }
                    }
                %>
            </select>

            <button type="submit" class="btn-filter">Filtrer</button>
            <a href="../menu.jsp" class="back-link">← Retour à l'accueil</a>
        </form>
        </div>

        <%
            List<NoteEtudiant> notes = (List<NoteEtudiant>) request.getAttribute("listeNotes");
            String erreur = (String) request.getAttribute("erreur");
        %>

        <% if (erreur != null) { %>
            <div class="alert-error">
                <strong>Erreur :</strong> <%= erreur %>
            </div>
        <% } else if (notes == null || notes.isEmpty()) { %>
            <div class="info-message">
                Aucune note enregistrée pour le moment.
            </div>
        <% } else { 
            int meilleureNote = 0;
            for (NoteEtudiant n : notes) {
                if (n.getNote() > meilleureNote) meilleureNote = n.getNote();
            }
        %>
            <div class="stats-badge">
                📌 <strong><%= notes.size() %></strong> résultat(s) · Meilleure note : <strong><%= meilleureNote %>/10</strong>
            </div>
            
            <div class="table-wrapper">
                 <table>
                    <thead>
                        <tr>
                            <th>Rang</th>
                            <th>Matricule</th>
                            <th>Étudiant</th>
                            <th>Niveau</th>
                            <th>Année</th>
                            <th>Note</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int rang = 1; for (NoteEtudiant n : notes) { 
                            String noteClass = "";
                            if (n.getNote() >= 7) noteClass = "note-excellent";
                            else if (n.getNote() >= 5) noteClass = "note-moyen";
                            else noteClass = "note-faible";
                        %>
                            <tr>
                                <td class="rang">
                                    <% if (rang <= 3) { %>
                                        <span class="rang-top">#<%= rang %></span>
                                    <% } else { %>
                                        #<%= rang %>
                                    <% } %>
                                </td>
                                <td><%= n.getNumEtudiant()%></td>
                                <td><%= n.getNomComplet() %></td>
                                <td><%= n.getNiveau() %></td>
                                <td><%= n.getAnneeUniv() %></td>
                                <td class="note <%= noteClass %>"><strong><%= n.getNote() %></strong> <span style="font-weight:normal; color:#94a3b8;">/10</span></td>
                            </tr>
                        <% rang++; } %>
                    </tbody>
                </table>
            </div>
        <% } %>

        
    </div>
</body>
</html>
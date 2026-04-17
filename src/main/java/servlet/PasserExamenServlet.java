package servlet;

import DAO.ExamenDAO;
import model.Question;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/examen/passer")
public class PasserExamenServlet extends HttpServlet {

    private ExamenDAO examenDAO = new ExamenDAO();

    // Important : on gère aussi le GET (accès direct à la page)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/examen/passerExamen.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String numEtudiant = req.getParameter("num_etudiant");
        String anneeUniv   = req.getParameter("annee_univ");

        try {
            // 1. Vérification étudiant + niveau
            String niveau = examenDAO.getNiveauEtudiant(numEtudiant);
            if (niveau == null) {
                req.setAttribute("erreur", "Étudiant non trouvé avec le numéro : " + numEtudiant);
                req.getRequestDispatcher("/examen/passerExamen.jsp").forward(req, resp);
                return;
            }

            // 2. Déjà passé cette année ?
            Integer noteDeja = examenDAO.getNoteExistante(numEtudiant, anneeUniv);
            if (noteDeja != null) {
                req.setAttribute("noteDeja", noteDeja);
                req.setAttribute("anneeUniv", anneeUniv);   // nom cohérent
                req.getRequestDispatcher("/examen/passerExamen.jsp").forward(req, resp);
                return;
            }

            // 3. Format année correct ?
            if (!isAnneeUniversitaireValide(anneeUniv)) {
                req.setAttribute("erreur", "Format d'année invalide !<br>" +
                    "L'année doit être consécutive (ex: 2025-2026, 2024-2025)");
                req.getRequestDispatcher("/examen/passerExamen.jsp").forward(req, resp);
                return;
            }

            // 4. Assez de questions ?
            int nbQuestions = examenDAO.compterQuestionsParNiveau(niveau);
            if (nbQuestions < 10) {
                req.setAttribute("erreur", "Seulement " + nbQuestions + 
                    " questions disponibles pour le niveau " + niveau +"  veuillez contacter votre professeur ");
                req.getRequestDispatcher("/examen/passerExamen.jsp").forward(req, resp);
                return;
            }

            // 5. Tout est OK → charger les questions
            List<Question> questions = examenDAO.get10QuestionsAleatoires(niveau);

            req.setAttribute("numEtudiant", numEtudiant);
            req.setAttribute("niveau", niveau);
            req.setAttribute("anneeUniv", anneeUniv);
            req.setAttribute("questions", questions);

            req.getRequestDispatcher("/examen/passerExamen.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("erreur", "Erreur technique : " + e.getMessage());
            req.getRequestDispatcher("/examen/passerExamen.jsp").forward(req, resp);
        }
        
    }
    // Méthode de validation année universitaire consécutive
    private boolean isAnneeUniversitaireValide(String annee) {
        if (annee == null || !annee.matches("^\\d{4}-\\d{4}$")) {
            return false;
        }

        try {
            String[] parts = annee.split("-");
            int debut = Integer.parseInt(parts[0]);
            int fin   = Integer.parseInt(parts[1]);

            // Doit être exactement année suivante
            return fin == debut + 1;
        } catch (Exception e) {
            return false;
        }
    }
}
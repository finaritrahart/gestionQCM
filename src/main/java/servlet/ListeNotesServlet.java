package servlet;

import DAO.ExamenDAO;
import model.NoteEtudiant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/examen/listeNotes")
public class ListeNotesServlet extends HttpServlet {

    private ExamenDAO examenDAO = new ExamenDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String niveauFiltre = req.getParameter("niveau");
        String anneeFiltre  = req.getParameter("annee");

        try {
            List<NoteEtudiant> notes = examenDAO.getNotesFiltrees(niveauFiltre, anneeFiltre);
            // Récupérer les années pour le select
            List<String> anneesDisponibles = examenDAO.getAnneesDisponibles();
            req.setAttribute("listeNotes", notes);
            req.setAttribute("niveauFiltre", niveauFiltre);
            req.setAttribute("anneeFiltre", anneeFiltre);
            req.setAttribute("anneesDisponibles", anneesDisponibles);
            
            req.getRequestDispatcher("/examen/listeNotes.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("erreur", "Erreur : " + e.getMessage());
            req.getRequestDispatcher("/examen/listeNotes.jsp").forward(req, resp);
        }
    }
}
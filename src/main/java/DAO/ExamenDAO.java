package DAO;
import util.DBUtil;
import java.sql.*;
import java.util.*;
import model.Question;
import model.NoteEtudiant;

public class ExamenDAO {
	// Vérifier si étudiant existe + récupérer son niveau
    public String getNiveauEtudiant(String numEtudiant) throws SQLException {
        String sql = "SELECT niveau FROM etudiant WHERE num_etudiant = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, numEtudiant);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getString("niveau") : null;
        }
    }

    // Vérifier si déjà passé cette année
    public Integer getNoteExistante(String numEtudiant, String anneeUniv) throws SQLException {
        String sql = "SELECT note FROM examen WHERE num_etudiant = ? AND annee_univ = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, numEtudiant);
            ps.setString(2, anneeUniv);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt("note") : null;
        }
    }
    // Compter questions par niveau
    public int compterQuestionsParNiveau(String niveau) throws SQLException {
        String sql = "SELECT COUNT(*) FROM qcm WHERE niveau = ?";
        try (Connection conn = DBUtil.getConnection();
        	 PreparedStatement ps = conn.prepareStatement(sql)){
        	ps.setString(1, niveau);
        	ResultSet rs = ps.executeQuery();
        	return rs.next() ? rs.getInt(1) : 0;
        }
    }
    // Récupérer 10 questions aléatoires
	public List<Question> get10QuestionsAleatoires(String niveau) throws SQLException {
	    List<Question> questions = new ArrayList<>();
	    String sql = "SELECT num_quest, question, reponse1, reponse2, reponse3, reponse4 " +
	                 "FROM qcm WHERE niveau = ? ORDER BY RANDOM() LIMIT 10";
	
	    try (Connection conn = DBUtil.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	
	        ps.setString(1, niveau);
	        ResultSet rs = ps.executeQuery();
	
	        while (rs.next()) {
	            Question q = new Question(
	                rs.getInt("num_quest"),
	                rs.getString("question"),
	                rs.getString("reponse1"),
	                rs.getString("reponse2"),
	                rs.getString("reponse3"),
	                rs.getString("reponse4")
	            );
	            questions.add(q);
	        }
	        return questions;
	    }
}

    // Liste des notes avec infos étudiant + classement
    public List<NoteEtudiant> getToutesLesNotes() throws SQLException {
        List<NoteEtudiant> notes = new ArrayList<>();
        
        String sql = "SELECT e.num_etudiant, e.nom, e.prenoms, e.niveau, " +
                     "       ex.annee_univ, ex.note " +          
                     "FROM examen ex " +
                     "JOIN etudiant e ON ex.num_etudiant = e.num_etudiant " +
                     "ORDER BY ex.note DESC, e.nom ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            int count = 0;
            while (rs.next()) {
                count++;
                NoteEtudiant n = new NoteEtudiant(
                    rs.getString("num_etudiant"),
                    rs.getString("nom"),
                    rs.getString("prenoms"),
                    rs.getString("niveau"),
                    rs.getString("annee_univ"),
                    rs.getInt("note")
                );
                notes.add(n);
            }
            
            System.out.println("[DEBUG] Nombre de notes trouvées dans la BD : " + count);
            return notes;
        } catch (SQLException e) {
            System.err.println("[ERREUR SQL] " + e.getMessage());
            throw e;
        }
    }
    // Classement filtré par niveau et/ou année
    public List<NoteEtudiant> getNotesFiltrees(String niveau, String anneeUniv) throws SQLException {
        List<NoteEtudiant> notes = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder(
            "SELECT e.num_etudiant, e.nom, e.prenoms, e.niveau, " +
            "       ex.annee_univ, ex.note " +
            "FROM examen ex " +
            "JOIN etudiant e ON ex.num_etudiant = e.num_etudiant "
        );

        // Construction dynamique du WHERE
        boolean hasWhere = false;
        if (niveau != null && !niveau.trim().isEmpty()) {
            sql.append("WHERE e.niveau = ? ");
            hasWhere = true;
        }
        if (anneeUniv != null && !anneeUniv.trim().isEmpty()) {
            sql.append(hasWhere ? "AND " : "WHERE ");
            sql.append("ex.annee_univ = ? ");
        }

        sql.append("ORDER BY ex.note DESC, e.nom ASC");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (niveau != null && !niveau.trim().isEmpty()) {
                ps.setString(paramIndex++, niveau);
            }
            if (anneeUniv != null && !anneeUniv.trim().isEmpty()) {
                ps.setString(paramIndex++, anneeUniv);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                NoteEtudiant n = new NoteEtudiant(
                    rs.getString("num_etudiant"),
                    rs.getString("nom"),
                    rs.getString("prenoms"),
                    rs.getString("niveau"),
                    rs.getString("annee_univ"),
                    rs.getInt("note")
                );
                notes.add(n);
            }
            return notes;
        }
    }
    // Récupérer les années universitaires disponibles (triées descendantes)
    public List<String> getAnneesDisponibles() throws SQLException {
        List<String> annees = new ArrayList<>();
        
        String sql = "SELECT DISTINCT annee_univ FROM examen ORDER BY annee_univ DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                annees.add(rs.getString("annee_univ"));
            }
            return annees;
        }
    }
}
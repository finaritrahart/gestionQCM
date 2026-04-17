package model;

import java.util.Date;

public class NoteEtudiant {
	private String numEtudiant;
    private String nom;
    private String prenoms;
    private String niveau;
    private String anneeUniv;
    private int note;
    
    public NoteEtudiant(String numEtudiant, String nom, String prenoms, String niveau,
            String anneeUniv, int note) {
	this.numEtudiant = numEtudiant;
	this.nom = nom;
	this.prenoms = prenoms;
	this.niveau = niveau;
	this.anneeUniv = anneeUniv;
	this.note = note;
	}
    // Getters
    public String getNumEtudiant() { return numEtudiant; }
    public String getNomComplet() { return nom + " " + prenoms; }
    public String getNiveau() { return niveau; }
    public String getAnneeUniv() { return anneeUniv; }
    public int getNote() { return note; }; 
}

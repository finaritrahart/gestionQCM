package model;

public class Question {
	private int numQuest;
    private String question;
    private String rep1, rep2, rep3, rep4;
    
    public Question(int numQuest, String question, String r1, String r2, String r3, String r4) {
        this.numQuest = numQuest;
        this.question = question;
        this.rep1 = r1; this.rep2 = r2; this.rep3 = r3; this.rep4 = r4;
    }
 // Getters
    public int getNumQuest() { return numQuest; }
    public String getQuestion() { return question; }
    public String getRep1() { return rep1; }
    public String getRep2() { return rep2; }
    public String getRep3() { return rep3; }
    public String getRep4() { return rep4; }
}

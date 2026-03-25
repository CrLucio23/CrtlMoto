package model;

import java.time.LocalDateTime;

public class Newsletter {
    private int idNewsletter;
    private String email;
    private Integer idUtente;
    private boolean iscritto;
    private LocalDateTime dataIscrizione;

    public Newsletter() {}

    public int getIdNewsletter() {
        return idNewsletter;
    }

    public void setIdNewsletter(int idNewsletter) {
        this.idNewsletter = idNewsletter;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Integer getIdUtente() {
        return idUtente;
    }

    public void setIdUtente(Integer idUtente) {
        this.idUtente = idUtente;
    }

    public boolean isIscritto() {
        return iscritto;
    }

    public void setIscritto(boolean iscritto) {
        this.iscritto = iscritto;
    }

    public LocalDateTime getDataIscrizione() {
        return dataIscrizione;
    }

    public void setDataIscrizione(LocalDateTime dataIscrizione) {
        this.dataIscrizione = dataIscrizione;
    }
}
package model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Carrello {
    private int idCarrello;
    private LocalDateTime dataAggiornamento;
    private int idUtente;
    private List<DettaglioCarrello> articoli = new ArrayList<>();

    public Carrello() {}

    public int getIdCarrello() {
        return idCarrello;
    }

    public void setIdCarrello(int idCarrello) {
        this.idCarrello = idCarrello;
    }

    public LocalDateTime getDataAggiornamento() {
        return dataAggiornamento;
    }

    public void setDataAggiornamento(LocalDateTime dataAggiornamento) {
        this.dataAggiornamento = dataAggiornamento;
    }

    public int getIdUtente() {
        return idUtente;
    }

    public void setIdUtente(int idUtente) {
        this.idUtente = idUtente;
    }

    public List<DettaglioCarrello> getArticoli() {
        return articoli;
    }

    public void setArticoli(List<DettaglioCarrello> articoli) {
        this.articoli = articoli;
    }
}
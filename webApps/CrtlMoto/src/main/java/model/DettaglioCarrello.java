package model;

import java.math.BigDecimal;

public class DettaglioCarrello {
    private int idDettaglioCarrello;
    private int quantita;
    private int idCarrello;
    private int idProdotto;
    private Prodotto prodotto;

    public DettaglioCarrello() {}

    public int getIdDettaglioCarrello() {
        return idDettaglioCarrello;
    }

    public void setIdDettaglioCarrello(int idDettaglioCarrello) {
        this.idDettaglioCarrello = idDettaglioCarrello;
    }

    public int getQuantita() {
        return quantita;
    }

    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }

    public int getIdCarrello() {
        return idCarrello;
    }

    public void setIdCarrello(int idCarrello) {
        this.idCarrello = idCarrello;
    }

    public int getIdProdotto() {
        return idProdotto;
    }

    public void setIdProdotto(int idProdotto) {
        this.idProdotto = idProdotto;
    }

    public Prodotto getProdotto() {
        return prodotto;
    }

    public void setProdotto(Prodotto prodotto) {
        this.prodotto = prodotto;
    }

    public BigDecimal getSubtotale() {
        if (prodotto == null) {
            return BigDecimal.ZERO;
        }
        return prodotto.getPrezzoScontato().multiply(BigDecimal.valueOf(quantita));
    }
}
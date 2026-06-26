package model;

import java.math.BigDecimal;

public class DettaglioOrdine {
    private int idDettaglioOrdine;
    private int quantita;
    private BigDecimal prezzoAcquisto;
    private String nomeProdottoStorico;
    private String immagineProdottoStorica;
    private int idOrdine;
    private Integer idProdotto;
    private Prodotto prodotto;

    public DettaglioOrdine() {}

    public int getIdDettaglioOrdine() {
        return idDettaglioOrdine;
    }

    public void setIdDettaglioOrdine(int idDettaglioOrdine) {
        this.idDettaglioOrdine = idDettaglioOrdine;
    }

    public int getQuantita() {
        return quantita;
    }

    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }

    public BigDecimal getPrezzoAcquisto() {
        return prezzoAcquisto;
    }

    public void setPrezzoAcquisto(BigDecimal prezzoAcquisto) {
        this.prezzoAcquisto = prezzoAcquisto;
    }

    public String getNomeProdottoStorico() {
        return nomeProdottoStorico;
    }

    public void setNomeProdottoStorico(String nomeProdottoStorico) {
        this.nomeProdottoStorico = nomeProdottoStorico;
    }

    public String getImmagineProdottoStorica() {
        return immagineProdottoStorica;
    }

    public void setImmagineProdottoStorica(String immagineProdottoStorica) {
        this.immagineProdottoStorica = immagineProdottoStorica;
    }

    public int getIdOrdine() {
        return idOrdine;
    }

    public void setIdOrdine(int idOrdine) {
        this.idOrdine = idOrdine;
    }

    public Integer getIdProdotto() {
        return idProdotto;
    }

    public void setIdProdotto(Integer idProdotto) {
        this.idProdotto = idProdotto;
    }

    public Prodotto getProdotto() {
        return prodotto;
    }

    public void setProdotto(Prodotto prodotto) {
        this.prodotto = prodotto;
    }
}

package model;

import java.math.BigDecimal;
import java.util.List;

public class Prodotto {
    private int idProdotto;
    private String nomeProdotto;
    private String descrizione;
    private BigDecimal prezzoBase;
    private int scontoPercentuale;
    private int quantitaMagazzino;
    private String taglia;
    private String colore;
    private String compatibilita;
    private Integer idCategoria;
    private Integer idMarca;
    private boolean attivo = true;
    private List<ImmagineProdotto> immagini;

    public Prodotto() {}

    public int getIdProdotto() {
        return idProdotto;
    }

    public void setIdProdotto(int idProdotto) {
        this.idProdotto = idProdotto;
    }

    public String getNomeProdotto() {
        return nomeProdotto;
    }

    public void setNomeProdotto(String nomeProdotto) {
        this.nomeProdotto = nomeProdotto;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public BigDecimal getPrezzoBase() {
        return prezzoBase;
    }

    public void setPrezzoBase(BigDecimal prezzoBase) {
        this.prezzoBase = prezzoBase;
    }

    public int getScontoPercentuale() {
        return scontoPercentuale;
    }

    public void setScontoPercentuale(int scontoPercentuale) {
        this.scontoPercentuale = scontoPercentuale;
    }

    public int getQuantitaMagazzino() {
        return quantitaMagazzino;
    }

    public void setQuantitaMagazzino(int quantitaMagazzino) {
        this.quantitaMagazzino = quantitaMagazzino;
    }

    public String getTaglia() {
        return taglia;
    }

    public void setTaglia(String taglia) {
        this.taglia = taglia;
    }

    public String getColore() {
        return colore;
    }

    public void setColore(String colore) {
        this.colore = colore;
    }

    public String getCompatibilita() {
        return compatibilita;
    }

    public void setCompatibilita(String compatibilita) {
        this.compatibilita = compatibilita;
    }

    public Integer getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(Integer idCategoria) {
        this.idCategoria = idCategoria;
    }

    public Integer getIdMarca() {
        return idMarca;
    }

    public void setIdMarca(Integer idMarca) {
        this.idMarca = idMarca;
    }

    public boolean isAttivo() {
        return attivo;
    }

    public void setAttivo(boolean attivo) {
        this.attivo = attivo;
    }

    public List<ImmagineProdotto> getImmagini() {
        return immagini;
    }

    public void setImmagini(List<ImmagineProdotto> immagini) {
        this.immagini = immagini;
    }

    public BigDecimal getPrezzoScontato() {
        BigDecimal sconto = prezzoBase.multiply(BigDecimal.valueOf(scontoPercentuale))
                .divide(BigDecimal.valueOf(100));
        return prezzoBase.subtract(sconto);
    }
}

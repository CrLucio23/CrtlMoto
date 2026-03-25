package model;

import java.time.LocalDateTime;

public class CodiceSconto {
    private int idCodice;
    private String codice;
    private int percentualeSconto;
    private boolean attivo;
    private LocalDateTime dataCreazione;
    private LocalDateTime dataScadenza;
    private int utilizzoMassimo;
    private boolean soloNewsletter;

    public CodiceSconto() {}

    public int getIdCodice() {
        return idCodice;
    }

    public void setIdCodice(int idCodice) {
        this.idCodice = idCodice;
    }

    public String getCodice() {
        return codice;
    }

    public void setCodice(String codice) {
        this.codice = codice;
    }

    public int getPercentualeSconto() {
        return percentualeSconto;
    }

    public void setPercentualeSconto(int percentualeSconto) {
        this.percentualeSconto = percentualeSconto;
    }

    public boolean isAttivo() {
        return attivo;
    }

    public void setAttivo(boolean attivo) {
        this.attivo = attivo;
    }

    public LocalDateTime getDataCreazione() {
        return dataCreazione;
    }

    public void setDataCreazione(LocalDateTime dataCreazione) {
        this.dataCreazione = dataCreazione;
    }

    public LocalDateTime getDataScadenza() {
        return dataScadenza;
    }

    public void setDataScadenza(LocalDateTime dataScadenza) {
        this.dataScadenza = dataScadenza;
    }

    public int getUtilizzoMassimo() {
        return utilizzoMassimo;
    }

    public void setUtilizzoMassimo(int utilizzoMassimo) {
        this.utilizzoMassimo = utilizzoMassimo;
    }

    public boolean isSoloNewsletter() {
        return soloNewsletter;
    }

    public void setSoloNewsletter(boolean soloNewsletter) {
        this.soloNewsletter = soloNewsletter;
    }
}
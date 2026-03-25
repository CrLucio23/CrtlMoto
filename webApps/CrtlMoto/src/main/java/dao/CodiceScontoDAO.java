package dao;

import model.CodiceSconto;
import utils.DBManager;

import java.sql.*;
import java.time.LocalDateTime;

public class CodiceScontoDAO {

    public CodiceSconto findByCodice(String codice) throws SQLException {
        String sql = "SELECT * FROM Codice_Sconto WHERE codice = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, codice);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }

        return null;
    }

    public int countUtilizzi(int idCodice) throws SQLException {
        String sql = "SELECT COUNT(*) AS totale FROM Utilizzo_Codice_Sconto WHERE id_codice = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCodice);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("totale");
                }
            }
        }

        return 0;
    }

    public boolean utenteHaGiaUsatoCodice(int idCodice, int idUtente) throws SQLException {
        String sql = "SELECT 1 FROM Utilizzo_Codice_Sconto WHERE id_codice = ? AND id_utente = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCodice);
            ps.setInt(2, idUtente);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean isValidForUser(String codice, int idUtente) throws SQLException {
        CodiceSconto c = findByCodice(codice);
        if (c == null || !c.isAttivo()) {
            return false;
        }

        if (c.getDataScadenza() != null && c.getDataScadenza().isBefore(LocalDateTime.now())) {
            return false;
        }

        if (countUtilizzi(c.getIdCodice()) >= c.getUtilizzoMassimo()) {
            return false;
        }

        return !utenteHaGiaUsatoCodice(c.getIdCodice(), idUtente);
    }

    public void registraUtilizzo(int idCodice, int idUtente, Integer idOrdine) throws SQLException {
        String sql = "INSERT INTO Utilizzo_Codice_Sconto(id_codice, id_utente, id_ordine) VALUES (?, ?, ?)";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCodice);
            ps.setInt(2, idUtente);

            if (idOrdine != null) {
                ps.setInt(3, idOrdine);
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.executeUpdate();
        }
    }

    private CodiceSconto mapRow(ResultSet rs) throws SQLException {
        CodiceSconto c = new CodiceSconto();
        c.setIdCodice(rs.getInt("id_codice"));
        c.setCodice(rs.getString("codice"));
        c.setPercentualeSconto(rs.getInt("percentuale_sconto"));
        c.setAttivo(rs.getBoolean("attivo"));

        Timestamp dc = rs.getTimestamp("data_creazione");
        if (dc != null) {
            c.setDataCreazione(dc.toLocalDateTime());
        }

        Timestamp ds = rs.getTimestamp("data_scadenza");
        if (ds != null) {
            c.setDataScadenza(ds.toLocalDateTime());
        }

        c.setUtilizzoMassimo(rs.getInt("utilizzo_massimo"));

        try {
            c.setSoloNewsletter(rs.getBoolean("solo_newsletter"));
        } catch (SQLException e) {
            c.setSoloNewsletter(false);
        }

        return c;
    }
}
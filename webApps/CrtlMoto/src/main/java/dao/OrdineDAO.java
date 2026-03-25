package dao;

import model.Carrello;
import model.DettaglioCarrello;
import model.Ordine;
import utils.DBManager;

import java.math.BigDecimal;
import java.sql.*;

public class OrdineDAO {

    private final CarrelloDAO carrelloDAO = new CarrelloDAO();
    private final CodiceScontoDAO codiceScontoDAO = new CodiceScontoDAO();

    public int createOrderFromCart(
            int idUtente,
            String indirizzoSpedizione,
            String metodoPagamento,
            String codiceSconto
    ) throws SQLException {

        Connection con = null;

        try {
            con = DBManager.getConnection();
            con.setAutoCommit(false);

            Carrello carrello = carrelloDAO.findByUserId(idUtente);
            if (carrello == null || carrello.getArticoli().isEmpty()) {
                throw new SQLException("Carrello vuoto.");
            }

            BigDecimal totale = BigDecimal.ZERO;

            for (DettaglioCarrello dettaglio : carrello.getArticoli()) {
                if (dettaglio.getProdotto() == null) {
                    throw new SQLException("Prodotto non trovato nel carrello.");
                }

                if (dettaglio.getQuantita() > dettaglio.getProdotto().getQuantitaMagazzino()) {
                    throw new SQLException("Quantità non disponibile per il prodotto: " +
                            dettaglio.getProdotto().getNomeProdotto());
                }

                totale = totale.add(dettaglio.getSubtotale());
            }

            Integer idCodiceSconto = null;

            if (codiceSconto != null && !codiceSconto.isBlank()) {
                if (!codiceScontoDAO.isValidForUser(codiceSconto, idUtente)) {
                    throw new SQLException("Codice sconto non valido.");
                }

                var coupon = codiceScontoDAO.findByCodice(codiceSconto);
                idCodiceSconto = coupon.getIdCodice();

                BigDecimal sconto = totale.multiply(BigDecimal.valueOf(coupon.getPercentualeSconto()))
                        .divide(BigDecimal.valueOf(100));
                totale = totale.subtract(sconto);
            }

            String sqlOrdine = "INSERT INTO Ordine(totale_ordine, stato_ordine, indirizzo_spedizione, id_utente, id_codice_sconto) VALUES (?, ?, ?, ?, ?)";
            int idOrdine;

            try (PreparedStatement psOrdine = con.prepareStatement(sqlOrdine, Statement.RETURN_GENERATED_KEYS)) {
                psOrdine.setBigDecimal(1, totale);
                psOrdine.setString(2, "in_elaborazione");
                psOrdine.setString(3, indirizzoSpedizione);
                psOrdine.setInt(4, idUtente);

                if (idCodiceSconto != null) {
                    psOrdine.setInt(5, idCodiceSconto);
                } else {
                    psOrdine.setNull(5, Types.INTEGER);
                }

                psOrdine.executeUpdate();

                try (ResultSet rs = psOrdine.getGeneratedKeys()) {
                    if (!rs.next()) {
                        throw new SQLException("Creazione ordine fallita.");
                    }
                    idOrdine = rs.getInt(1);
                }
            }

            String sqlDettaglio = "INSERT INTO Dettaglio_Ordine(quantita, prezzo_acquisto, id_ordine, id_prodotto) VALUES (?, ?, ?, ?)";
            String sqlUpdateStock = "UPDATE Prodotto SET quantita_magazzino = quantita_magazzino - ? WHERE id_prodotto = ?";

            for (DettaglioCarrello dettaglio : carrello.getArticoli()) {
                try (PreparedStatement psDettaglio = con.prepareStatement(sqlDettaglio);
                     PreparedStatement psStock = con.prepareStatement(sqlUpdateStock)) {

                    psDettaglio.setInt(1, dettaglio.getQuantita());
                    psDettaglio.setBigDecimal(2, dettaglio.getProdotto().getPrezzoScontato());
                    psDettaglio.setInt(3, idOrdine);
                    psDettaglio.setInt(4, dettaglio.getIdProdotto());
                    psDettaglio.executeUpdate();

                    psStock.setInt(1, dettaglio.getQuantita());
                    psStock.setInt(2, dettaglio.getIdProdotto());
                    psStock.executeUpdate();
                }
            }

            String sqlPagamento = "INSERT INTO Pagamento(metodo_pagamento, importo, stato_pagamento, id_ordine) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psPagamento = con.prepareStatement(sqlPagamento)) {
                psPagamento.setString(1, metodoPagamento);
                psPagamento.setBigDecimal(2, totale);
                psPagamento.setString(3, "completato");
                psPagamento.setInt(4, idOrdine);
                psPagamento.executeUpdate();
            }

            if (idCodiceSconto != null) {
                String sqlUtilizzo = "INSERT INTO Utilizzo_Codice_Sconto(id_codice, id_utente, id_ordine) VALUES (?, ?, ?)";
                try (PreparedStatement psUso = con.prepareStatement(sqlUtilizzo)) {
                    psUso.setInt(1, idCodiceSconto);
                    psUso.setInt(2, idUtente);
                    psUso.setInt(3, idOrdine);
                    psUso.executeUpdate();
                }
            }

            String sqlClear = "DELETE FROM Dettaglio_Carrello WHERE id_carrello = ?";
            try (PreparedStatement psClear = con.prepareStatement(sqlClear)) {
                psClear.setInt(1, carrello.getIdCarrello());
                psClear.executeUpdate();
            }

            con.commit();
            return idOrdine;

        } catch (SQLException e) {
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

    public Ordine findById(int idOrdine) throws SQLException {
        String sql = "SELECT * FROM Ordine WHERE id_ordine = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idOrdine);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Ordine ordine = new Ordine();
                    ordine.setIdOrdine(rs.getInt("id_ordine"));
                    ordine.setTotaleOrdine(rs.getBigDecimal("totale_ordine"));
                    ordine.setStatoOrdine(rs.getString("stato_ordine"));
                    ordine.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                    ordine.setIdUtente(rs.getInt("id_utente"));

                    Timestamp ts = rs.getTimestamp("data_ordine");
                    if (ts != null) {
                        ordine.setDataOrdine(ts.toLocalDateTime());
                    }

                    try {
                        int idCodice = rs.getInt("id_codice_sconto");
                        ordine.setIdCodiceSconto(rs.wasNull() ? null : idCodice);
                    } catch (SQLException e) {
                        ordine.setIdCodiceSconto(null);
                    }

                    return ordine;
                }
            }
        }

        return null;
    }
    public java.util.List<model.Ordine> findByUtente(int idUtente) throws SQLException {
        java.util.List<model.Ordine> ordini = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Ordine WHERE id_utente = ? ORDER BY data_ordine DESC";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUtente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.Ordine ordine = new model.Ordine();
                    ordine.setIdOrdine(rs.getInt("id_ordine"));
                    ordine.setTotaleOrdine(rs.getBigDecimal("totale_ordine"));
                    ordine.setStatoOrdine(rs.getString("stato_ordine"));
                    ordine.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                    ordine.setIdUtente(rs.getInt("id_utente"));

                    Timestamp ts = rs.getTimestamp("data_ordine");
                    if (ts != null) {
                        ordine.setDataOrdine(ts.toLocalDateTime());
                    }

                    ordini.add(ordine);
                }
            }
        }

        return ordini;
    }

    public java.util.List<model.Ordine> findAll() throws SQLException {
        java.util.List<model.Ordine> ordini = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Ordine ORDER BY data_ordine DESC";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                model.Ordine ordine = new model.Ordine();
                ordine.setIdOrdine(rs.getInt("id_ordine"));
                ordine.setTotaleOrdine(rs.getBigDecimal("totale_ordine"));
                ordine.setStatoOrdine(rs.getString("stato_ordine"));
                ordine.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                ordine.setIdUtente(rs.getInt("id_utente"));

                Timestamp ts = rs.getTimestamp("data_ordine");
                if (ts != null) {
                    ordine.setDataOrdine(ts.toLocalDateTime());
                }

                ordini.add(ordine);
            }
        }

        return ordini;
    }

    public void updateStatoOrdine(int idOrdine, String nuovoStato) throws SQLException {
        String sql = "UPDATE Ordine SET stato_ordine = ? WHERE id_ordine = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nuovoStato);
            ps.setInt(2, idOrdine);
            ps.executeUpdate();
        }
    }
}
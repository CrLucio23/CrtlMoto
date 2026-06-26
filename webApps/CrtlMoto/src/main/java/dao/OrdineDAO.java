package dao;

import model.Carrello;
import model.DettaglioCarrello;
import model.DettaglioOrdine;
import model.ImmagineProdotto;
import model.Ordine;
import model.Prodotto;
import utils.DBManager;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

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
                Prodotto prodotto = dettaglio.getProdotto();
                if (prodotto == null) {
                    throw new SQLException("Prodotto non trovato nel carrello.");
                }

                if (!prodotto.isAttivo()) {
                    throw new SQLException("Prodotto non piu disponibile: " + prodotto.getNomeProdotto());
                }

                if (dettaglio.getQuantita() > prodotto.getQuantitaMagazzino()) {
                    throw new SQLException("Quantita non disponibile per il prodotto: " + prodotto.getNomeProdotto());
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

            String sqlDettaglio = "INSERT INTO Dettaglio_Ordine(quantita, prezzo_acquisto, nome_prodotto_storico, immagine_prodotto_storica, id_ordine, id_prodotto) VALUES (?, ?, ?, ?, ?, ?)";
            String sqlUpdateStock = "UPDATE Prodotto SET quantita_magazzino = quantita_magazzino - ? WHERE id_prodotto = ? AND attivo = TRUE AND quantita_magazzino >= ?";

            for (DettaglioCarrello dettaglio : carrello.getArticoli()) {
                Prodotto prodotto = dettaglio.getProdotto();
                try (PreparedStatement psDettaglio = con.prepareStatement(sqlDettaglio);
                     PreparedStatement psStock = con.prepareStatement(sqlUpdateStock)) {

                    psDettaglio.setInt(1, dettaglio.getQuantita());
                    psDettaglio.setBigDecimal(2, prodotto.getPrezzoScontato());
                    psDettaglio.setString(3, prodotto.getNomeProdotto());
                    psDettaglio.setString(4, getMainImageUrl(prodotto));
                    psDettaglio.setInt(5, idOrdine);
                    psDettaglio.setInt(6, dettaglio.getIdProdotto());
                    psDettaglio.executeUpdate();

                    psStock.setInt(1, dettaglio.getQuantita());
                    psStock.setInt(2, dettaglio.getIdProdotto());
                    psStock.setInt(3, dettaglio.getQuantita());
                    if (psStock.executeUpdate() == 0) {
                        throw new SQLException("Disponibilita prodotto cambiata durante il checkout.");
                    }
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
                    Ordine ordine = mapOrdine(rs);
                    ordine.setDettagli(findDettagliByOrdineId(ordine.getIdOrdine()));
                    return ordine;
                }
            }
        }

        return null;
    }

    public List<Ordine> findByUtente(int idUtente) throws SQLException {
        List<Ordine> ordini = new ArrayList<>();
        String sql = "SELECT * FROM Ordine WHERE id_utente = ? ORDER BY data_ordine DESC";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUtente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ordine ordine = mapOrdine(rs);
                    ordine.setDettagli(findDettagliByOrdineId(ordine.getIdOrdine()));
                    ordini.add(ordine);
                }
            }
        }

        return ordini;
    }

    public List<Ordine> findAll() throws SQLException {
        List<Ordine> ordini = new ArrayList<>();
        String sql = "SELECT * FROM Ordine ORDER BY data_ordine DESC";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Ordine ordine = mapOrdine(rs);
                ordine.setDettagli(findDettagliByOrdineId(ordine.getIdOrdine()));
                ordini.add(ordine);
            }
        }

        return ordini;
    }

    public List<DettaglioOrdine> findDettagliByOrdineId(int idOrdine) throws SQLException {
        List<DettaglioOrdine> dettagli = new ArrayList<>();
        String sql = "SELECT * FROM Dettaglio_Ordine WHERE id_ordine = ? ORDER BY id_dettaglio_ordine";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idOrdine);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DettaglioOrdine dettaglio = new DettaglioOrdine();
                    dettaglio.setIdDettaglioOrdine(rs.getInt("id_dettaglio_ordine"));
                    dettaglio.setQuantita(rs.getInt("quantita"));
                    dettaglio.setPrezzoAcquisto(rs.getBigDecimal("prezzo_acquisto"));
                    dettaglio.setNomeProdottoStorico(rs.getString("nome_prodotto_storico"));
                    dettaglio.setImmagineProdottoStorica(rs.getString("immagine_prodotto_storica"));
                    dettaglio.setIdOrdine(rs.getInt("id_ordine"));

                    int idProdotto = rs.getInt("id_prodotto");
                    dettaglio.setIdProdotto(rs.wasNull() ? null : idProdotto);
                    dettagli.add(dettaglio);
                }
            }
        }

        return dettagli;
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

    private Ordine mapOrdine(ResultSet rs) throws SQLException {
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

        int idCodice = rs.getInt("id_codice_sconto");
        ordine.setIdCodiceSconto(rs.wasNull() ? null : idCodice);
        return ordine;
    }

    private String getMainImageUrl(Prodotto prodotto) {
        if (prodotto.getImmagini() == null || prodotto.getImmagini().isEmpty()) {
            return null;
        }

        for (ImmagineProdotto immagine : prodotto.getImmagini()) {
            if (immagine.isPrincipale()) {
                return immagine.getUrlImmagine();
            }
        }

        return prodotto.getImmagini().get(0).getUrlImmagine();
    }
}

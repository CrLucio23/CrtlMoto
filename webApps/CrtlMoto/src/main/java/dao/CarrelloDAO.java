package dao;

import model.Carrello;
import model.DettaglioCarrello;
import model.Prodotto;
import utils.DBManager;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarrelloDAO {

    private final ProdottoDAO prodottoDAO = new ProdottoDAO();

    public Carrello getOrCreateByUserId(int idUtente) throws SQLException {
        Carrello carrello = findByUserId(idUtente);
        if (carrello != null) {
            return carrello;
        }

        String insert = "INSERT INTO Carrello(id_utente) VALUES (?)";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, idUtente);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int idCarrello = rs.getInt(1);
                    carrello = new Carrello();
                    carrello.setIdCarrello(idCarrello);
                    carrello.setIdUtente(idUtente);
                    carrello.setArticoli(new ArrayList<>());
                    return carrello;
                }
            }
        }

        throw new SQLException("Impossibile creare il carrello.");
    }

    public Carrello findByUserId(int idUtente) throws SQLException {
        String sql = "SELECT * FROM Carrello WHERE id_utente = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUtente);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Carrello carrello = new Carrello();
                    carrello.setIdCarrello(rs.getInt("id_carrello"));
                    carrello.setIdUtente(rs.getInt("id_utente"));

                    Timestamp ts = rs.getTimestamp("data_aggiornamento");
                    if (ts != null) {
                        carrello.setDataAggiornamento(ts.toLocalDateTime());
                    }

                    carrello.setArticoli(findDettagliByCarrelloId(carrello.getIdCarrello()));
                    return carrello;
                }
            }
        }

        return null;
    }

    public List<DettaglioCarrello> findDettagliByCarrelloId(int idCarrello) throws SQLException {
        List<DettaglioCarrello> dettagli = new ArrayList<>();
        String sql = "SELECT * FROM Dettaglio_Carrello WHERE id_carrello = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCarrello);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DettaglioCarrello d = new DettaglioCarrello();
                    d.setIdDettaglioCarrello(rs.getInt("id_dettaglio_carrello"));
                    d.setQuantita(rs.getInt("quantita"));
                    d.setIdCarrello(rs.getInt("id_carrello"));
                    d.setIdProdotto(rs.getInt("id_prodotto"));

                    Prodotto prodotto = prodottoDAO.findById(d.getIdProdotto());
                    d.setProdotto(prodotto);

                    dettagli.add(d);
                }
            }
        }

        return dettagli;
    }

    public void addProduct(int idUtente, int idProdotto, int quantita) throws SQLException {
        Carrello carrello = getOrCreateByUserId(idUtente);

        String check = "SELECT id_dettaglio_carrello, quantita FROM Dettaglio_Carrello WHERE id_carrello = ? AND id_prodotto = ?";
        String insert = "INSERT INTO Dettaglio_Carrello(quantita, id_carrello, id_prodotto) VALUES (?, ?, ?)";
        String update = "UPDATE Dettaglio_Carrello SET quantita = ? WHERE id_dettaglio_carrello = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement psCheck = con.prepareStatement(check)) {

            psCheck.setInt(1, carrello.getIdCarrello());
            psCheck.setInt(2, idProdotto);

            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next()) {
                    int idDettaglio = rs.getInt("id_dettaglio_carrello");
                    int quantitaAttuale = rs.getInt("quantita");

                    try (PreparedStatement psUpdate = con.prepareStatement(update)) {
                        psUpdate.setInt(1, quantitaAttuale + quantita);
                        psUpdate.setInt(2, idDettaglio);
                        psUpdate.executeUpdate();
                    }
                } else {
                    try (PreparedStatement psInsert = con.prepareStatement(insert)) {
                        psInsert.setInt(1, quantita);
                        psInsert.setInt(2, carrello.getIdCarrello());
                        psInsert.setInt(3, idProdotto);
                        psInsert.executeUpdate();
                    }
                }
            }
        }
    }

    public void updateQuantity(int idUtente, int idProdotto, int quantita) throws SQLException {
        Carrello carrello = getOrCreateByUserId(idUtente);

        if (quantita <= 0) {
            removeProduct(idUtente, idProdotto);
            return;
        }

        String sql = "UPDATE Dettaglio_Carrello SET quantita = ? WHERE id_carrello = ? AND id_prodotto = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quantita);
            ps.setInt(2, carrello.getIdCarrello());
            ps.setInt(3, idProdotto);
            ps.executeUpdate();
        }
    }

    public void removeProduct(int idUtente, int idProdotto) throws SQLException {
        Carrello carrello = getOrCreateByUserId(idUtente);

        String sql = "DELETE FROM Dettaglio_Carrello WHERE id_carrello = ? AND id_prodotto = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, carrello.getIdCarrello());
            ps.setInt(2, idProdotto);
            ps.executeUpdate();
        }
    }

    public void clearCart(int idUtente) throws SQLException {
        Carrello carrello = getOrCreateByUserId(idUtente);

        String sql = "DELETE FROM Dettaglio_Carrello WHERE id_carrello = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, carrello.getIdCarrello());
            ps.executeUpdate();
        }
    }
}
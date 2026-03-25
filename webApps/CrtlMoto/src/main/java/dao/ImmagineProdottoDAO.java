package dao;

import model.ImmagineProdotto;
import utils.DBManager;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ImmagineProdottoDAO {

    public List<ImmagineProdotto> findByProdotto(int idProdotto) throws SQLException {
        List<ImmagineProdotto> immagini = new ArrayList<>();
        String sql = "SELECT * FROM Immagine_Prodotto WHERE id_prodotto = ? ORDER BY is_principale DESC, id_immagine ASC";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idProdotto);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ImmagineProdotto img = new ImmagineProdotto();
                    img.setIdImmagine(rs.getInt("id_immagine"));
                    img.setUrlImmagine(rs.getString("url_immagine"));
                    img.setPrincipale(rs.getBoolean("is_principale"));
                    img.setIdProdotto(rs.getInt("id_prodotto"));
                    immagini.add(img);
                }
            }
        }

        return immagini;
    }

    public void save(ImmagineProdotto immagine) throws SQLException {
        String sql = "INSERT INTO Immagine_Prodotto(url_immagine, is_principale, id_prodotto) VALUES (?, ?, ?)";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, immagine.getUrlImmagine());
            ps.setBoolean(2, immagine.isPrincipale());
            ps.setInt(3, immagine.getIdProdotto());

            ps.executeUpdate();
        }
    }

    public void delete(int idImmagine) throws SQLException {
        String sql = "DELETE FROM Immagine_Prodotto WHERE id_immagine = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idImmagine);
            ps.executeUpdate();
        }
    }

    public void resetMainImage(int idProdotto) throws SQLException {
        String sql = "UPDATE Immagine_Prodotto SET is_principale = FALSE WHERE id_prodotto = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idProdotto);
            ps.executeUpdate();
        }
    }

    public void setMainImage(int idImmagine) throws SQLException {
        String sql = "UPDATE Immagine_Prodotto SET is_principale = TRUE WHERE id_immagine = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idImmagine);
            ps.executeUpdate();
        }
    }
}
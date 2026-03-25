package dao;

import model.Newsletter;
import utils.DBManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class NewsletterDAO {

    public boolean existsByEmail(String email) throws SQLException {
        String sql = "SELECT 1 FROM Newsletter WHERE email = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void save(Newsletter newsletter) throws SQLException {
        String sql = "INSERT INTO Newsletter(email, id_utente, iscritto) VALUES (?, ?, ?)";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newsletter.getEmail());

            if (newsletter.getIdUtente() != null) {
                ps.setInt(2, newsletter.getIdUtente());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }

            ps.setBoolean(3, newsletter.isIscritto());
            ps.executeUpdate();
        }
    }
}
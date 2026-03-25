package dao;

import model.Utente;
import utils.DBManager;

import java.sql.*;

public class UtenteDAO {

    public void save(Utente utente) throws SQLException {
        String sql = "INSERT INTO Utente(nome, cognome, email, password, telefono, indirizzo, citta, CAP, ruolo) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, utente.getNome());
            ps.setString(2, utente.getCognome());
            ps.setString(3, utente.getEmail());
            ps.setString(4, utente.getPassword());
            ps.setString(5, utente.getTelefono());
            ps.setString(6, utente.getIndirizzo());
            ps.setString(7, utente.getCitta());
            ps.setString(8, utente.getCap());
            ps.setString(9, utente.getRuolo());

            ps.executeUpdate();
        }
    }

    public Utente findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM Utente WHERE email = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }

        return null;
    }

    public Utente findById(int idUtente) throws SQLException {
        String sql = "SELECT * FROM Utente WHERE id_utente = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUtente);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }

        return null;
    }

    private Utente mapRow(ResultSet rs) throws SQLException {
        Utente u = new Utente();
        u.setIdUtente(rs.getInt("id_utente"));
        u.setNome(rs.getString("nome"));
        u.setCognome(rs.getString("cognome"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setTelefono(rs.getString("telefono"));
        u.setIndirizzo(rs.getString("indirizzo"));
        u.setCitta(rs.getString("citta"));
        u.setCap(rs.getString("CAP"));
        u.setRuolo(rs.getString("ruolo"));

        Timestamp ts = rs.getTimestamp("data_registrazione");
        if (ts != null) {
            u.setDataRegistrazione(ts.toLocalDateTime());
        }

        return u;
    }

    public void update(Utente utente) throws SQLException {
        String sql = "UPDATE Utente SET nome = ?, cognome = ?, telefono = ?, indirizzo = ?, citta = ?, CAP = ? WHERE id_utente = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, utente.getNome());
            ps.setString(2, utente.getCognome());
            ps.setString(3, utente.getTelefono());
            ps.setString(4, utente.getIndirizzo());
            ps.setString(5, utente.getCitta());
            ps.setString(6, utente.getCap());
            ps.setInt(7, utente.getIdUtente());

            ps.executeUpdate();
        }
    }

    public void updatePassword(int idUtente, String nuovaPasswordHash) throws SQLException {
        String sql = "UPDATE Utente SET password = ? WHERE id_utente = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nuovaPasswordHash);
            ps.setInt(2, idUtente);
            ps.executeUpdate();
        }
    }
}
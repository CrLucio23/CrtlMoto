package dao;

import model.Veicolo;
import utils.DBManager;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VeicoloDAO {

    public List<Veicolo> findByUtente(int idUtente) throws SQLException {
        List<Veicolo> veicoli = new ArrayList<>();
        String sql = "SELECT * FROM Veicolo WHERE id_utente = ? ORDER BY id_veicolo DESC";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUtente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    veicoli.add(mapRow(rs));
                }
            }
        }

        return veicoli;
    }

    public Veicolo findById(int idVeicolo) throws SQLException {
        String sql = "SELECT * FROM Veicolo WHERE id_veicolo = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idVeicolo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }

        return null;
    }

    public void save(Veicolo veicolo) throws SQLException {
        String sql = "INSERT INTO Veicolo(marca, modello, anno, cilindrata, id_utente) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, veicolo.getMarca());
            ps.setString(2, veicolo.getModello());

            if (veicolo.getAnno() != null) {
                ps.setInt(3, veicolo.getAnno());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.setString(4, veicolo.getCilindrata());
            ps.setInt(5, veicolo.getIdUtente());

            ps.executeUpdate();
        }
    }

    public void update(Veicolo veicolo) throws SQLException {
        String sql = "UPDATE Veicolo SET marca = ?, modello = ?, anno = ?, cilindrata = ? WHERE id_veicolo = ? AND id_utente = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, veicolo.getMarca());
            ps.setString(2, veicolo.getModello());

            if (veicolo.getAnno() != null) {
                ps.setInt(3, veicolo.getAnno());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.setString(4, veicolo.getCilindrata());
            ps.setInt(5, veicolo.getIdVeicolo());
            ps.setInt(6, veicolo.getIdUtente());

            ps.executeUpdate();
        }
    }

    public void delete(int idVeicolo, int idUtente) throws SQLException {
        String sql = "DELETE FROM Veicolo WHERE id_veicolo = ? AND id_utente = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idVeicolo);
            ps.setInt(2, idUtente);
            ps.executeUpdate();
        }
    }

    private Veicolo mapRow(ResultSet rs) throws SQLException {
        Veicolo v = new Veicolo();
        v.setIdVeicolo(rs.getInt("id_veicolo"));
        v.setMarca(rs.getString("marca"));
        v.setModello(rs.getString("modello"));

        int anno = rs.getInt("anno");
        v.setAnno(rs.wasNull() ? null : anno);

        v.setCilindrata(rs.getString("cilindrata"));
        v.setIdUtente(rs.getInt("id_utente"));
        return v;
    }
}
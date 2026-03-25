package dao;

import model.Prodotto;
import utils.DBManager;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProdottoDAO {

    private final ImmagineProdottoDAO immagineProdottoDAO = new ImmagineProdottoDAO();

    public List<Prodotto> findAll() throws SQLException {
        List<Prodotto> prodotti = new ArrayList<>();
        String sql = "SELECT * FROM Prodotto ORDER BY id_prodotto DESC";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Prodotto p = mapRow(rs);
                p.setImmagini(immagineProdottoDAO.findByProdotto(p.getIdProdotto()));
                prodotti.add(p);
            }
        }

        return prodotti;
    }

    public Prodotto findById(int id) throws SQLException {
        String sql = "SELECT * FROM Prodotto WHERE id_prodotto = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Prodotto p = mapRow(rs);
                    p.setImmagini(immagineProdottoDAO.findByProdotto(p.getIdProdotto()));
                    return p;
                }
            }
        }

        return null;
    }

    public List<Prodotto> findByCategoria(int idCategoria) throws SQLException {
        List<Prodotto> prodotti = new ArrayList<>();
        String sql = "SELECT * FROM Prodotto WHERE id_categoria = ? ORDER BY id_prodotto DESC";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCategoria);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Prodotto p = mapRow(rs);
                    p.setImmagini(immagineProdottoDAO.findByProdotto(p.getIdProdotto()));
                    prodotti.add(p);
                }
            }
        }

        return prodotti;
    }

    public List<Prodotto> searchByNome(String nome) throws SQLException {
        List<Prodotto> prodotti = new ArrayList<>();
        String sql = "SELECT * FROM Prodotto WHERE LOWER(nome_prodotto) LIKE ? ORDER BY id_prodotto DESC";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + nome.toLowerCase() + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Prodotto p = mapRow(rs);
                    p.setImmagini(immagineProdottoDAO.findByProdotto(p.getIdProdotto()));
                    prodotti.add(p);
                }
            }
        }

        return prodotti;
    }

    public int save(Prodotto prodotto) throws SQLException {
        String sql = "INSERT INTO Prodotto(nome_prodotto, descrizione, prezzo_base, sconto_percentuale, quantita_magazzino, taglia, colore, compatibilita, id_categoria, id_marca) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, prodotto.getNomeProdotto());
            ps.setString(2, prodotto.getDescrizione());
            ps.setBigDecimal(3, prodotto.getPrezzoBase());
            ps.setInt(4, prodotto.getScontoPercentuale());
            ps.setInt(5, prodotto.getQuantitaMagazzino());
            ps.setString(6, prodotto.getTaglia());
            ps.setString(7, prodotto.getColore());
            ps.setString(8, prodotto.getCompatibilita());

            if (prodotto.getIdCategoria() != null) {
                ps.setInt(9, prodotto.getIdCategoria());
            } else {
                ps.setNull(9, Types.INTEGER);
            }

            if (prodotto.getIdMarca() != null) {
                ps.setInt(10, prodotto.getIdMarca());
            } else {
                ps.setNull(10, Types.INTEGER);
            }

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        throw new SQLException("Salvataggio prodotto fallito.");
    }

    public void update(Prodotto prodotto) throws SQLException {
        String sql = "UPDATE Prodotto SET nome_prodotto=?, descrizione=?, prezzo_base=?, sconto_percentuale=?, quantita_magazzino=?, taglia=?, colore=?, compatibilita=?, id_categoria=?, id_marca=? WHERE id_prodotto=?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, prodotto.getNomeProdotto());
            ps.setString(2, prodotto.getDescrizione());
            ps.setBigDecimal(3, prodotto.getPrezzoBase());
            ps.setInt(4, prodotto.getScontoPercentuale());
            ps.setInt(5, prodotto.getQuantitaMagazzino());
            ps.setString(6, prodotto.getTaglia());
            ps.setString(7, prodotto.getColore());
            ps.setString(8, prodotto.getCompatibilita());

            if (prodotto.getIdCategoria() != null) {
                ps.setInt(9, prodotto.getIdCategoria());
            } else {
                ps.setNull(9, Types.INTEGER);
            }

            if (prodotto.getIdMarca() != null) {
                ps.setInt(10, prodotto.getIdMarca());
            } else {
                ps.setNull(10, Types.INTEGER);
            }

            ps.setInt(11, prodotto.getIdProdotto());
            ps.executeUpdate();
        }
    }

    public void delete(int idProdotto) throws SQLException {
        String sql = "DELETE FROM Prodotto WHERE id_prodotto = ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idProdotto);
            ps.executeUpdate();
        }
    }

    private Prodotto mapRow(ResultSet rs) throws SQLException {
        Prodotto p = new Prodotto();
        p.setIdProdotto(rs.getInt("id_prodotto"));
        p.setNomeProdotto(rs.getString("nome_prodotto"));
        p.setDescrizione(rs.getString("descrizione"));
        p.setPrezzoBase(rs.getBigDecimal("prezzo_base"));
        p.setScontoPercentuale(rs.getInt("sconto_percentuale"));
        p.setQuantitaMagazzino(rs.getInt("quantita_magazzino"));
        p.setTaglia(rs.getString("taglia"));
        p.setColore(rs.getString("colore"));
        p.setCompatibilita(rs.getString("compatibilita"));

        int idCategoria = rs.getInt("id_categoria");
        p.setIdCategoria(rs.wasNull() ? null : idCategoria);

        int idMarca = rs.getInt("id_marca");
        p.setIdMarca(rs.wasNull() ? null : idMarca);

        return p;
    }
    public List<Prodotto> findLatest(int limit) throws SQLException {
        List<Prodotto> prodotti = new ArrayList<>();
        String sql = "SELECT * FROM Prodotto ORDER BY id_prodotto DESC LIMIT ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Prodotto p = mapRow(rs);
                    p.setImmagini(immagineProdottoDAO.findByProdotto(p.getIdProdotto()));
                    prodotti.add(p);
                }
            }
        }

        return prodotti;
    }

    public List<Prodotto> findDiscounted(int limit) throws SQLException {
        List<Prodotto> prodotti = new ArrayList<>();
        String sql = "SELECT * FROM Prodotto WHERE sconto_percentuale > 0 ORDER BY sconto_percentuale DESC, id_prodotto DESC LIMIT ?";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Prodotto p = mapRow(rs);
                    p.setImmagini(immagineProdottoDAO.findByProdotto(p.getIdProdotto()));
                    prodotti.add(p);
                }
            }
        }

        return prodotti;
    }
}
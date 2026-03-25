package dao;

import model.Categoria;
import utils.DBManager;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {

    public List<Categoria> findAll() throws SQLException {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT * FROM Categoria ORDER BY nome_categoria";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Categoria c = new Categoria();
                c.setIdCategoria(rs.getInt("id_categoria"));
                c.setNomeCategoria(rs.getString("nome_categoria"));
                c.setDescrizione(rs.getString("descrizione"));
                lista.add(c);
            }
        }

        return lista;
    }
}
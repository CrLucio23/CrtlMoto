package dao;

import model.Marca;
import utils.DBManager;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MarcaDAO {

    public List<Marca> findAll() throws SQLException {
        List<Marca> lista = new ArrayList<>();
        String sql = "SELECT * FROM Marca ORDER BY nome_marca";

        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Marca m = new Marca();
                m.setIdMarca(rs.getInt("id_marca"));
                m.setNomeMarca(rs.getString("nome_marca"));
                lista.add(m);
            }
        }

        return lista;
    }
}
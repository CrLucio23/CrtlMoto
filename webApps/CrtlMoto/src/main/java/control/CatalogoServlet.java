package control;

import dao.CategoriaDAO;
import dao.ProdottoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Prodotto;
import utils.ValidationUtils;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/catalogo")
public class CatalogoServlet extends HttpServlet {

    private final ProdottoDAO prodottoDAO = new ProdottoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ricerca = request.getParameter("q");
        String categoria = request.getParameter("categoria");

        try {
            List<Prodotto> prodotti;

            if (ricerca != null && !ricerca.isBlank()) {
                prodotti = prodottoDAO.searchByNome(ricerca.trim());
            } else if (categoria != null && !categoria.isBlank()) {
                Integer idCategoria = ValidationUtils.parseInteger(categoria);
                if (idCategoria == null || idCategoria <= 0) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Categoria non valida");
                    return;
                }
                prodotti = prodottoDAO.findByCategoria(idCategoria);
            } else {
                prodotti = prodottoDAO.findAll();
            }

            request.setAttribute("prodotti", prodotti);
            request.setAttribute("categorie", categoriaDAO.findAll());
            request.setAttribute("ricerca", ricerca);
            request.setAttribute("categoriaSelezionata", categoria);

            request.getRequestDispatcher("/catalogo.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

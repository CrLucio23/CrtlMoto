package filter;

import control.CarrelloServlet;
import dao.CarrelloDAO;
import dao.CategoriaDAO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.Carrello;
import model.DettaglioCarrello;
import model.Utente;
import utils.SessionUtils;

import java.io.IOException;
import java.sql.SQLException;

@WebFilter("/*")
public class ViewDataFilter implements Filter {

    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    private final CarrelloDAO carrelloDAO = new CarrelloDAO();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        String path = req.getServletPath();

        if (!path.startsWith("/css/") && !path.startsWith("/images/")) {
            try {
                if (req.getAttribute("categorie") == null) {
                    req.setAttribute("categorie", categoriaDAO.findAll());
                }
                req.setAttribute("carrelloCount", countCartItems(req));
            } catch (SQLException e) {
                throw new ServletException(e);
            }
        }

        chain.doFilter(request, response);
    }

    private int countCartItems(HttpServletRequest request) throws SQLException {
        Utente utente = SessionUtils.getUtenteLoggato(request);
        Carrello carrello;

        if (utente == null) {
            HttpSession session = request.getSession(false);
            carrello = CarrelloServlet.peekGuestCart(session);
        } else if (SessionUtils.isAdmin(request)) {
            return 0;
        } else {
            carrello = carrelloDAO.findByUserId(utente.getIdUtente());
        }

        if (carrello == null || carrello.getArticoli() == null) {
            return 0;
        }

        int count = 0;
        for (DettaglioCarrello dettaglio : carrello.getArticoli()) {
            count += dettaglio.getQuantita();
        }
        return count;
    }
}

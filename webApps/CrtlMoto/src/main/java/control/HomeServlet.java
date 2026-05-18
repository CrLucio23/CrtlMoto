package control;

import dao.CategoriaDAO;
import dao.ProdottoDAO;
import dao.NewsletterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Utente;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("")
public class HomeServlet extends HttpServlet {

    private final ProdottoDAO prodottoDAO = new ProdottoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    private final NewsletterDAO newsletterDAO = new NewsletterDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setAttribute("ultimiProdotti", prodottoDAO.findLatest(8));
            request.setAttribute("prodottiScontati", prodottoDAO.findDiscounted(8));
            request.setAttribute("categorie", categoriaDAO.findAll());

            boolean mostraNewsletter = true;

            Utente utente = (Utente) request.getSession().getAttribute("utente");
            if (utente != null){
                if("admin".equalsIgnoreCase(utente.getRuolo())) {
                    mostraNewsletter = false;
                } else {
                    mostraNewsletter = !newsletterDAO.existsByEmail(utente.getEmail());
                }
            } else {
                Boolean iscritta = (Boolean) request.getSession().getAttribute("newsletterIscritta");
                if(Boolean.TRUE.equals(iscritta)) {
                    mostraNewsletter = false;
                }
            }

            request.setAttribute("mostraNewsletter", mostraNewsletter);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
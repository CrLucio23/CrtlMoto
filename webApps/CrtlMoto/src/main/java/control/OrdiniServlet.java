package control;

import dao.OrdineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Utente;
import utils.SessionUtils;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/i-miei-ordini")
public class OrdiniServlet extends HttpServlet {

    private final OrdineDAO ordineDAO = new OrdineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utente utente = SessionUtils.getUtenteLoggato(request);

        try {
            request.setAttribute("ordini", ordineDAO.findByUtente(utente.getIdUtente()));
            request.getRequestDispatcher("/i-miei-ordini.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
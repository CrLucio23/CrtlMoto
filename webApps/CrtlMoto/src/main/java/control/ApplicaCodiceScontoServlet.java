package control;

import dao.CodiceScontoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CodiceSconto;
import model.Utente;
import utils.SessionUtils;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/applica-codice")
public class ApplicaCodiceScontoServlet extends HttpServlet {

    private final CodiceScontoDAO codiceScontoDAO = new CodiceScontoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utente utente = SessionUtils.getUtenteLoggato(request);
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String codice = request.getParameter("codice");

        try {
            if (codice == null || codice.isBlank()) {
                request.getSession().removeAttribute("codiceSconto");
                request.getSession().setAttribute("erroreCheckout", "Inserisci un codice sconto.");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }

            boolean valido = codiceScontoDAO.isValidForUser(codice.trim(), utente.getIdUtente());

            if (!valido) {
                request.getSession().removeAttribute("codiceSconto");
                request.getSession().setAttribute("erroreCheckout", "Codice sconto non valido o già usato.");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }

            CodiceSconto c = codiceScontoDAO.findByCodice(codice.trim());
            request.getSession().setAttribute("codiceSconto", c.getCodice());
            request.getSession().setAttribute("messaggioCheckout", "Codice sconto applicato correttamente.");

            response.sendRedirect(request.getContextPath() + "/checkout");

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
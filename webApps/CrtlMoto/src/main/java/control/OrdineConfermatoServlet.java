package control;

import dao.OrdineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Ordine;
import model.Utente;
import utils.SessionUtils;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ordine-confermato")
public class OrdineConfermatoServlet extends HttpServlet {

    private final OrdineDAO ordineDAO = new OrdineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utente utente = SessionUtils.getUtenteLoggato(request);
        String idParam = request.getParameter("id");

        try {
            int idOrdine = Integer.parseInt(idParam);
            Ordine ordine = ordineDAO.findById(idOrdine);

            if (ordine == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Ordine non trovato");
                return;
            }

            if (ordine.getIdUtente() != utente.getIdUtente() && !"admin".equalsIgnoreCase(utente.getRuolo())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ordine non accessibile");
                return;
            }

            request.setAttribute("ordine", ordine);
            request.getRequestDispatcher("/ordine-confermato.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID ordine non valido");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
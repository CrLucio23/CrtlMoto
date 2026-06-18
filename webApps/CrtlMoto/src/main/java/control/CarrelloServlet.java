package control;

import dao.CarrelloDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Carrello;
import model.Utente;
import utils.SessionUtils;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/carrello")
public class CarrelloServlet extends HttpServlet {

    private final CarrelloDAO carrelloDAO = new CarrelloDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utente utente = SessionUtils.getUtenteLoggato(request);
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Carrello carrello = carrelloDAO.getOrCreateByUserId(utente.getIdUtente());
            request.setAttribute("carrello", carrello);
            request.getRequestDispatcher("/carrello.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utente utente = SessionUtils.getUtenteLoggato(request);
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idProdottoParam = request.getParameter("idProdotto");
        String quantitaParam = request.getParameter("quantita");

        try {
            if ("clear".equalsIgnoreCase(action)) {
                carrelloDAO.clearCart(utente.getIdUtente());
                response.sendRedirect(request.getContextPath() + "/carrello");
                return;
            }

            int idProdotto = Integer.parseInt(idProdottoParam);
            int quantita = (quantitaParam != null && !quantitaParam.isBlank())
                    ? Integer.parseInt(quantitaParam)
                    : 1;

            if ("add".equalsIgnoreCase(action)) {
                carrelloDAO.addProduct(utente.getIdUtente(), idProdotto, quantita);
            } else if ("update".equalsIgnoreCase(action)) {
                carrelloDAO.updateQuantity(utente.getIdUtente(), idProdotto, quantita);
            } else if ("remove".equalsIgnoreCase(action)) {
                carrelloDAO.removeProduct(utente.getIdUtente(), idProdotto);
            }

            response.sendRedirect(request.getContextPath() + "/carrello");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri non validi");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

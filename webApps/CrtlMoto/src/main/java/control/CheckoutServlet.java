package control;

import dao.CarrelloDAO;
import dao.CodiceScontoDAO;
import dao.OrdineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Carrello;
import model.CodiceSconto;
import model.DettaglioCarrello;
import model.Utente;
import utils.SessionUtils;
import utils.ValidationUtils;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Set;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final CarrelloDAO carrelloDAO = new CarrelloDAO();
    private final CodiceScontoDAO codiceScontoDAO = new CodiceScontoDAO();
    private final OrdineDAO ordineDAO = new OrdineDAO();

    private static final Set<String> METODI_VALIDI =
            Set.of("carta", "paypal", "bonifico", "contrassegno");

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

            if (carrello.getArticoli() == null || carrello.getArticoli().isEmpty()) {
                request.setAttribute("errore", "Il carrello è vuoto.");
                request.getRequestDispatcher("/checkout.jsp").forward(request, response);
                return;
            }

            BigDecimal totale = BigDecimal.ZERO;
            for (DettaglioCarrello d : carrello.getArticoli()) {
                totale = totale.add(d.getSubtotale());
            }

            String codice = (String) request.getSession().getAttribute("codiceSconto");
            CodiceSconto coupon = null;
            BigDecimal totaleFinale = totale;

            if (!ValidationUtils.isNullOrBlank(codice)
                    && codiceScontoDAO.isValidForUser(codice, utente.getIdUtente())) {
                coupon = codiceScontoDAO.findByCodice(codice);

                BigDecimal sconto = totale.multiply(BigDecimal.valueOf(coupon.getPercentualeSconto()))
                        .divide(BigDecimal.valueOf(100));
                totaleFinale = totale.subtract(sconto);
            }

            request.setAttribute("carrello", carrello);
            request.setAttribute("totale", totale);
            request.setAttribute("coupon", coupon);
            request.setAttribute("totaleFinale", totaleFinale);

            request.getRequestDispatcher("/checkout.jsp").forward(request, response);

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

        String indirizzoSpedizione = ValidationUtils.clean(request.getParameter("indirizzoSpedizione"));
        String metodoPagamento = ValidationUtils.clean(request.getParameter("metodoPagamento"));
        String codiceSconto = (String) request.getSession().getAttribute("codiceSconto");

        if (ValidationUtils.isNullOrBlank(indirizzoSpedizione)) {
            request.getSession().setAttribute("erroreCheckout", "L'indirizzo di spedizione è obbligatorio.");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        if (ValidationUtils.isNullOrBlank(metodoPagamento) || !METODI_VALIDI.contains(metodoPagamento)) {
            request.getSession().setAttribute("erroreCheckout", "Metodo di pagamento non valido.");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        try {
            int idOrdine = ordineDAO.createOrderFromCart(
                    utente.getIdUtente(),
                    indirizzoSpedizione,
                    metodoPagamento,
                    codiceSconto
            );

            request.getSession().removeAttribute("codiceSconto");
            request.getSession().setAttribute("messaggio", "Ordine completato con successo. ID ordine: " + idOrdine);

            response.sendRedirect(request.getContextPath() + "/ordine-confermato?id=" + idOrdine);

        } catch (SQLException e) {
            request.getSession().setAttribute("erroreCheckout", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
}
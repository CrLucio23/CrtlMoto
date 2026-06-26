package control;

import dao.CarrelloDAO;
import dao.ProdottoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Carrello;
import model.DettaglioCarrello;
import model.Prodotto;
import model.Utente;
import utils.SessionUtils;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@WebServlet("/carrello")
public class CarrelloServlet extends HttpServlet {

    private final CarrelloDAO carrelloDAO = new CarrelloDAO();
    private final ProdottoDAO prodottoDAO = new ProdottoDAO();
    private static final String GUEST_CART_SESSION_KEY = "guestCart";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utente utente = SessionUtils.getUtenteLoggato(request);
        if (SessionUtils.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/prodotti");
            return;
        }

        try {
            Carrello carrello = utente == null
                    ? getGuestCart(request.getSession())
                    : carrelloDAO.getOrCreateByUserId(utente.getIdUtente());

            setCartAttributes(request, carrello, utente == null);
            request.getRequestDispatcher("/carrello.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utente utente = SessionUtils.getUtenteLoggato(request);
        if (SessionUtils.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/prodotti");
            return;
        }

        String action = request.getParameter("action");
        String idProdottoParam = request.getParameter("idProdotto");
        String quantitaParam = request.getParameter("quantita");

        try {
            if ("clear".equalsIgnoreCase(action)) {
                if (utente == null) {
                    request.getSession().removeAttribute(GUEST_CART_SESSION_KEY);
                } else {
                    carrelloDAO.clearCart(utente.getIdUtente());
                }
                response.sendRedirect(request.getContextPath() + "/carrello");
                return;
            }

            int idProdotto = Integer.parseInt(idProdottoParam);
            int quantita = (quantitaParam != null && !quantitaParam.isBlank())
                    ? Integer.parseInt(quantitaParam)
                    : 1;

            if ("add".equalsIgnoreCase(action)) {
                if (utente == null) {
                    addGuestProduct(request.getSession(), idProdotto, quantita);
                } else {
                    carrelloDAO.addProduct(utente.getIdUtente(), idProdotto, quantita);
                }
            } else if ("update".equalsIgnoreCase(action)) {
                if (utente == null) {
                    updateGuestQuantity(request.getSession(), idProdotto, quantita);
                } else {
                    carrelloDAO.updateQuantity(utente.getIdUtente(), idProdotto, quantita);
                }
            } else if ("remove".equalsIgnoreCase(action)) {
                if (utente == null) {
                    removeGuestProduct(request.getSession(), idProdotto);
                } else {
                    carrelloDAO.removeProduct(utente.getIdUtente(), idProdotto);
                }
            }

            response.sendRedirect(request.getContextPath() + "/carrello");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri non validi");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    public static Carrello getGuestCart(HttpSession session) {
        Carrello carrello = (Carrello) session.getAttribute(GUEST_CART_SESSION_KEY);
        if (carrello == null) {
            carrello = new Carrello();
            carrello.setArticoli(new ArrayList<>());
            session.setAttribute(GUEST_CART_SESSION_KEY, carrello);
        }
        return carrello;
    }

    public static Carrello peekGuestCart(HttpSession session) {
        return session == null ? null : (Carrello) session.getAttribute(GUEST_CART_SESSION_KEY);
    }

    public static void clearGuestCart(HttpSession session) {
        if (session != null) {
            session.removeAttribute(GUEST_CART_SESSION_KEY);
        }
    }

    private void addGuestProduct(HttpSession session, int idProdotto, int quantita) throws SQLException {
        if (quantita <= 0) {
            return;
        }

        Carrello carrello = getGuestCart(session);
        for (DettaglioCarrello dettaglio : carrello.getArticoli()) {
            if (dettaglio.getIdProdotto() == idProdotto) {
                dettaglio.setQuantita(dettaglio.getQuantita() + quantita);
                return;
            }
        }

        Prodotto prodotto = prodottoDAO.findById(idProdotto);
        if (prodotto == null) {
            throw new SQLException("Prodotto non trovato.");
        }

        DettaglioCarrello dettaglio = new DettaglioCarrello();
        dettaglio.setIdProdotto(idProdotto);
        dettaglio.setProdotto(prodotto);
        dettaglio.setQuantita(quantita);
        carrello.getArticoli().add(dettaglio);
    }

    private void updateGuestQuantity(HttpSession session, int idProdotto, int quantita) {
        if (quantita <= 0) {
            removeGuestProduct(session, idProdotto);
            return;
        }

        Carrello carrello = getGuestCart(session);
        for (DettaglioCarrello dettaglio : carrello.getArticoli()) {
            if (dettaglio.getIdProdotto() == idProdotto) {
                dettaglio.setQuantita(quantita);
                return;
            }
        }
    }

    private void removeGuestProduct(HttpSession session, int idProdotto) {
        Carrello carrello = getGuestCart(session);
        Iterator<DettaglioCarrello> iterator = carrello.getArticoli().iterator();
        while (iterator.hasNext()) {
            if (iterator.next().getIdProdotto() == idProdotto) {
                iterator.remove();
                return;
            }
        }
    }

    private void setCartAttributes(HttpServletRequest request, Carrello carrello, boolean guestCart) {
        BigDecimal totale = BigDecimal.ZERO;
        int count = 0;

        List<DettaglioCarrello> articoli = carrello.getArticoli();
        if (articoli != null) {
            for (DettaglioCarrello dettaglio : articoli) {
                totale = totale.add(dettaglio.getSubtotale());
                count += dettaglio.getQuantita();
            }
        }

        request.setAttribute("carrello", carrello);
        request.setAttribute("totale", totale);
        request.setAttribute("carrelloCount", count);
        request.setAttribute("guestCart", guestCart);
    }
}

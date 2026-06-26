package control;

import dao.ProdottoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Prodotto;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/api/prodotto-disponibilita")
public class DisponibilitaProdottoServlet extends HttpServlet {

    private final ProdottoDAO prodottoDAO = new ProdottoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int quantita = Integer.parseInt(request.getParameter("quantita"));

            Prodotto prodotto = prodottoDAO.findById(id);
            if (prodotto == null || !prodotto.isAttivo()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"disponibile\":false,\"messaggio\":\"Prodotto non trovato\"}");
                return;
            }

            boolean disponibile = quantita > 0 && prodotto.getQuantitaMagazzino() >= quantita;
            String messaggio;

            if (quantita <= 0) {
                messaggio = "Inserisci una quantita valida";
            } else if (disponibile) {
                messaggio = "Quantita disponibile";
            } else if (prodotto.getQuantitaMagazzino() == 0) {
                messaggio = "Prodotto esaurito";
            } else {
                messaggio = "Disponibili solo " + prodotto.getQuantitaMagazzino() + " pezzi";
            }

            response.getWriter().write("{\"disponibile\":" + disponibile
                    + ",\"quantitaMagazzino\":" + prodotto.getQuantitaMagazzino()
                    + ",\"messaggio\":\"" + escapeJson(messaggio) + "\"}");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"disponibile\":false,\"messaggio\":\"Parametri non validi\"}");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private String escapeJson(String value) {
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}

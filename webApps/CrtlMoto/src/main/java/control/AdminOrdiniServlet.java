package control;

import dao.OrdineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Set;

@WebServlet("/admin/ordini")
public class AdminOrdiniServlet extends HttpServlet {

    private final OrdineDAO ordineDAO = new OrdineDAO();
    private static final Set<String> STATI_VALIDI =
            Set.of("in_elaborazione", "spedito", "consegnato", "annullato");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setAttribute("ordini", ordineDAO.findAll());
            request.getRequestDispatcher("/admin/ordini.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer idOrdine = utils.ValidationUtils.parseInteger(request.getParameter("idOrdine"));
            String stato = request.getParameter("statoOrdine");

            if (idOrdine == null || idOrdine <= 0 || !STATI_VALIDI.contains(stato)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri ordine non validi");
                return;
            }

            ordineDAO.updateStatoOrdine(idOrdine, stato);

            response.sendRedirect(request.getContextPath() + "/admin/ordini");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

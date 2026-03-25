package control;

import dao.OrdineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/ordini")
public class AdminOrdiniServlet extends HttpServlet {

    private final OrdineDAO ordineDAO = new OrdineDAO();

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
            int idOrdine = Integer.parseInt(request.getParameter("idOrdine"));
            String stato = request.getParameter("statoOrdine");

            ordineDAO.updateStatoOrdine(idOrdine, stato);

            response.sendRedirect(request.getContextPath() + "/admin/ordini");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
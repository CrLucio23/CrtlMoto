package control;

import dao.VeicoloDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Utente;
import model.Veicolo;
import utils.SessionUtils;
import utils.ValidationUtils;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/garage")
public class GarageServlet extends HttpServlet {

    private final VeicoloDAO veicoloDAO = new VeicoloDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utente utente = SessionUtils.getUtenteLoggato(request);

        try {
            String action = request.getParameter("action");

            if ("edit".equalsIgnoreCase(action)) {
                Integer idVeicolo = ValidationUtils.parseInteger(request.getParameter("id"));
                if (idVeicolo == null || idVeicolo <= 0) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID veicolo non valido");
                    return;
                }

                Veicolo veicolo = veicoloDAO.findById(idVeicolo);

                if (veicolo == null || veicolo.getIdUtente() != utente.getIdUtente()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Veicolo non accessibile");
                    return;
                }

                request.setAttribute("veicolo", veicolo);
            }

            request.setAttribute("veicoli", veicoloDAO.findByUtente(utente.getIdUtente()));
            request.getRequestDispatcher("/garage.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utente utente = SessionUtils.getUtenteLoggato(request);
        String action = request.getParameter("action");

        try {
            if ("delete".equalsIgnoreCase(action)) {
                Integer idVeicolo = ValidationUtils.parseInteger(request.getParameter("id"));
                if (idVeicolo == null || idVeicolo <= 0) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID veicolo non valido");
                    return;
                }

                veicoloDAO.delete(idVeicolo, utente.getIdUtente());
                response.sendRedirect(request.getContextPath() + "/garage");
                return;
            }

            String marca = ValidationUtils.clean(request.getParameter("marca"));
            String modello = ValidationUtils.clean(request.getParameter("modello"));
            String cilindrata = ValidationUtils.clean(request.getParameter("cilindrata"));
            Integer anno = ValidationUtils.parseInteger(request.getParameter("anno"));

            if (ValidationUtils.isNullOrBlank(marca)) {
                request.setAttribute("errore", "La marca è obbligatoria.");
                doGet(request, response);
                return;
            }

            if (ValidationUtils.isNullOrBlank(modello)) {
                request.setAttribute("errore", "Il modello è obbligatorio.");
                doGet(request, response);
                return;
            }

            if (!ValidationUtils.isValidYear(anno)) {
                request.setAttribute("errore", "L'anno deve essere compreso tra 1900 e 2100.");
                doGet(request, response);
                return;
            }

            Veicolo veicolo = new Veicolo();
            veicolo.setMarca(marca);
            veicolo.setModello(modello);
            veicolo.setAnno(anno);
            veicolo.setCilindrata(cilindrata);
            veicolo.setIdUtente(utente.getIdUtente());

            if ("update".equalsIgnoreCase(action)) {
                Integer id = ValidationUtils.parseInteger(request.getParameter("id"));
                if (id == null || id <= 0) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID veicolo non valido");
                    return;
                }

                veicolo.setIdVeicolo(id);
                veicoloDAO.update(veicolo);
            } else {
                veicoloDAO.save(veicolo);
            }

            response.sendRedirect(request.getContextPath() + "/garage");

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
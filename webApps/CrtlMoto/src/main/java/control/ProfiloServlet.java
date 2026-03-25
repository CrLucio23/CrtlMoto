package control;

import dao.UtenteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Utente;
import utils.PasswordUtils;
import utils.SessionUtils;
import utils.ValidationUtils;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/profilo")
public class ProfiloServlet extends HttpServlet {

    private final UtenteDAO utenteDAO = new UtenteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utente utente = SessionUtils.getUtenteLoggato(request);

        try {
            request.setAttribute("utenteProfilo", utenteDAO.findById(utente.getIdUtente()));
            request.getRequestDispatcher("/profilo.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utente utenteSessione = SessionUtils.getUtenteLoggato(request);
        String action = request.getParameter("action");

        try {
            if ("updatePassword".equalsIgnoreCase(action)) {
                String passwordAttuale = request.getParameter("passwordAttuale");
                String nuovaPassword = request.getParameter("nuovaPassword");
                String confermaPassword = request.getParameter("confermaPassword");

                Utente utenteDb = utenteDAO.findById(utenteSessione.getIdUtente());

                if (ValidationUtils.isNullOrBlank(passwordAttuale)
                        || ValidationUtils.isNullOrBlank(nuovaPassword)
                        || ValidationUtils.isNullOrBlank(confermaPassword)) {
                    request.setAttribute("errore", "Compila tutti i campi password.");
                    doGet(request, response);
                    return;
                }

                if (!PasswordUtils.checkPassword(passwordAttuale, utenteDb.getPassword())) {
                    request.setAttribute("errore", "La password attuale non è corretta.");
                    doGet(request, response);
                    return;
                }

                if (!ValidationUtils.hasMinLength(nuovaPassword, 6)) {
                    request.setAttribute("errore", "La nuova password deve contenere almeno 6 caratteri.");
                    doGet(request, response);
                    return;
                }

                if (!nuovaPassword.equals(confermaPassword)) {
                    request.setAttribute("errore", "Le nuove password non coincidono.");
                    doGet(request, response);
                    return;
                }

                utenteDAO.updatePassword(utenteSessione.getIdUtente(), PasswordUtils.hashPassword(nuovaPassword));
                request.setAttribute("successo", "Password aggiornata correttamente.");
                doGet(request, response);
                return;
            }

            String nome = ValidationUtils.clean(request.getParameter("nome"));
            String cognome = ValidationUtils.clean(request.getParameter("cognome"));
            String telefono = ValidationUtils.clean(request.getParameter("telefono"));
            String indirizzo = ValidationUtils.clean(request.getParameter("indirizzo"));
            String citta = ValidationUtils.clean(request.getParameter("citta"));
            String cap = ValidationUtils.clean(request.getParameter("cap"));

            if (ValidationUtils.isNullOrBlank(nome)) {
                request.setAttribute("errore", "Il nome è obbligatorio.");
                doGet(request, response);
                return;
            }

            if (ValidationUtils.isNullOrBlank(cognome)) {
                request.setAttribute("errore", "Il cognome è obbligatorio.");
                doGet(request, response);
                return;
            }

            if (!ValidationUtils.isValidPhone(telefono)) {
                request.setAttribute("errore", "Il numero di telefono non è valido.");
                doGet(request, response);
                return;
            }

            if (!ValidationUtils.isNullOrBlank(cap) && !ValidationUtils.isValidCAP(cap)) {
                request.setAttribute("errore", "Il CAP deve contenere 5 cifre.");
                doGet(request, response);
                return;
            }

            Utente utente = new Utente();
            utente.setIdUtente(utenteSessione.getIdUtente());
            utente.setNome(nome);
            utente.setCognome(cognome);
            utente.setTelefono(telefono);
            utente.setIndirizzo(indirizzo);
            utente.setCitta(citta);
            utente.setCap(cap);

            utenteDAO.update(utente);

            Utente aggiornato = utenteDAO.findById(utenteSessione.getIdUtente());
            request.getSession().setAttribute("utente", aggiornato);

            request.setAttribute("successo", "Profilo aggiornato correttamente.");
            doGet(request, response);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
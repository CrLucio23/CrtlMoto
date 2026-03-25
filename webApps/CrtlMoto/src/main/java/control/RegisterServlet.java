package control;

import dao.UtenteDAO;
import model.Utente;
import utils.PasswordUtils;
import utils.ValidationUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UtenteDAO utenteDAO = new UtenteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nome = ValidationUtils.clean(request.getParameter("nome"));
        String cognome = ValidationUtils.clean(request.getParameter("cognome"));
        String email = ValidationUtils.clean(request.getParameter("email"));
        String password = request.getParameter("password");

        if (ValidationUtils.isNullOrBlank(nome)) {
            request.setAttribute("errore", "Il nome è obbligatorio.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (ValidationUtils.isNullOrBlank(cognome)) {
            request.setAttribute("errore", "Il cognome è obbligatorio.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtils.isValidEmail(email)) {
            request.setAttribute("errore", "Inserisci un'email valida.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtils.hasMinLength(password, 6)) {
            request.setAttribute("errore", "La password deve contenere almeno 6 caratteri.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            if (utenteDAO.findByEmail(email) != null) {
                request.setAttribute("errore", "Email già registrata.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            Utente utente = new Utente();
            utente.setNome(nome);
            utente.setCognome(cognome);
            utente.setEmail(email);
            utente.setPassword(PasswordUtils.hashPassword(password));
            utente.setRuolo("cliente");

            utenteDAO.save(utente);

            response.sendRedirect(request.getContextPath() + "/login");

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
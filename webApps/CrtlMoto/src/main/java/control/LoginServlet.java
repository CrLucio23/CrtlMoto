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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UtenteDAO utenteDAO = new UtenteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = ValidationUtils.clean(request.getParameter("email"));
        String password = request.getParameter("password");

        if (!ValidationUtils.isValidEmail(email)) {
            request.setAttribute("errore", "Email non valida.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (ValidationUtils.isNullOrBlank(password)) {
            request.setAttribute("errore", "Inserisci la password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            Utente utente = utenteDAO.findByEmail(email);

            if (utente == null || !PasswordUtils.checkPassword(password, utente.getPassword())) {
                request.setAttribute("errore", "Credenziali non valide");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("utente", utente);

            response.sendRedirect(request.getContextPath() + "/");

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

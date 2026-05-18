package control;

import dao.NewsletterDAO;
import model.Newsletter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import utils.ValidationUtils;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/newsletter")
public class NewsletterServlet extends HttpServlet {

    private final NewsletterDAO newsletterDAO = new NewsletterDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = ValidationUtils.clean(request.getParameter("email"));

        if (!ValidationUtils.isValidEmail(email)) {
            request.getSession().setAttribute("errore", "Inserisci un'email valida per la newsletter.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            if (!newsletterDAO.existsByEmail(email)) {
                Newsletter newsletter = new Newsletter();
                newsletter.setEmail(email);
                newsletter.setIscritto(true);

                HttpSession session = request.getSession(false);
                if (session != null && session.getAttribute("utente") != null) {
                    model.Utente utente = (model.Utente) session.getAttribute("utente");
                    newsletter.setIdUtente(utente.getIdUtente());
                }

                newsletterDAO.save(newsletter);
                request.getSession().setAttribute("newsletterIscritta", true);
            }

            request.getSession().setAttribute("messaggio", "Iscrizione newsletter completata");
            response.sendRedirect(request.getContextPath() + "/");

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
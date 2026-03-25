package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Utente;
import utils.SessionUtils;

import java.io.IOException;

@WebFilter(urlPatterns = {
        "/admin/*"
})
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        Utente utente = SessionUtils.getUtenteLoggato(req);

        if (utente == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (!"admin".equalsIgnoreCase(utente.getRuolo())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Accesso riservato agli amministratori");
            return;
        }

        chain.doFilter(request, response);
    }
}
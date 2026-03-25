package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.Utente;

public class SessionUtils {

    public static Utente getUtenteLoggato(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (Utente) session.getAttribute("utente");
    }

    public static boolean isLogged(HttpServletRequest request) {
        return getUtenteLoggato(request) != null;
    }

    public static boolean isAdmin(HttpServletRequest request) {
        Utente utente = getUtenteLoggato(request);
        return utente != null && "admin".equalsIgnoreCase(utente.getRuolo());
    }
}
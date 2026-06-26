package control;

import dao.ProdottoDAO;
import model.ImmagineProdotto;
import model.Prodotto;
import model.Utente;
import utils.ImageUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/prodotto")
public class DettaglioProdottoServlet extends HttpServlet {

    private final ProdottoDAO prodottoDAO = new ProdottoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/catalogo");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Prodotto prodotto = prodottoDAO.findById(id);

            if (prodotto == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Prodotto non trovato");
                return;
            }

            request.setAttribute("prodotto", prodotto);
            request.setAttribute("admin", isAdmin(request));
            request.setAttribute("mainImage", getMainImage(request, prodotto));
            request.setAttribute("galleryImages", getGalleryImages(request, prodotto));
            request.setAttribute("availabilityText", getAvailabilityText(prodotto));
            request.getRequestDispatcher("/prodotto.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID non valido");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        Utente utente = (Utente) session.getAttribute("utente");
        return utente != null && "admin".equalsIgnoreCase(utente.getRuolo());
    }

    private String getMainImage(HttpServletRequest request, Prodotto prodotto) {
        if (prodotto.getImmagini() == null || prodotto.getImmagini().isEmpty()) {
            return request.getContextPath() + "/images/no-image.png";
        }
        return ImageUtils.resolve(request, prodotto.getImmagini().get(0).getUrlImmagine());
    }

    private List<String> getGalleryImages(HttpServletRequest request, Prodotto prodotto) {
        List<String> images = new ArrayList<>();
        if (prodotto.getImmagini() != null) {
            for (ImmagineProdotto immagine : prodotto.getImmagini()) {
                images.add(ImageUtils.resolve(request, immagine.getUrlImmagine()));
            }
        }
        return images;
    }

    private String getAvailabilityText(Prodotto prodotto) {
        if (prodotto.getQuantitaMagazzino() > 5) {
            return "Disponibile";
        }
        if (prodotto.getQuantitaMagazzino() > 0) {
            return "Ultimi pezzi";
        }
        return "Esaurito";
    }
}

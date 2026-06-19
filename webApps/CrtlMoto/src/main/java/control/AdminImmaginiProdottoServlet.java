package control;

import dao.ImmagineProdottoDAO;
import dao.ProdottoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.ImmagineProdotto;
import utils.ImageUploadUtils;
import utils.ValidationUtils;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/immagini-prodotto")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class AdminImmaginiProdottoServlet extends HttpServlet {

    private final ImmagineProdottoDAO immagineProdottoDAO = new ImmagineProdottoDAO();
    private final ProdottoDAO prodottoDAO = new ProdottoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
            request.setAttribute("prodotto", prodottoDAO.findById(idProdotto));
            request.setAttribute("immagini", immagineProdottoDAO.findByProdotto(idProdotto));
            request.getRequestDispatcher("/admin/immagini-prodotto.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("add".equalsIgnoreCase(action)) {
                Integer idProdotto = ValidationUtils.parseInteger(request.getParameter("idProdotto"));
                Part immaginePart = request.getPart("immagine");

                if (idProdotto == null || idProdotto <= 0) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Prodotto non valido");
                    return;
                }

                String urlImmagine = ImageUploadUtils.saveProductImage(getServletContext(), immaginePart, idProdotto);
                if (urlImmagine == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Immagine non valida");
                    return;
                }

                ImmagineProdotto img = new ImmagineProdotto();
                img.setUrlImmagine(urlImmagine);
                img.setIdProdotto(idProdotto);
                img.setPrincipale("true".equalsIgnoreCase(request.getParameter("principale")));

                if (img.isPrincipale()) {
                    immagineProdottoDAO.resetMainImage(img.getIdProdotto());
                }

                immagineProdottoDAO.save(img);
                response.sendRedirect(request.getContextPath() + "/admin/immagini-prodotto?idProdotto=" + img.getIdProdotto());
                return;
            }

            if ("delete".equalsIgnoreCase(action)) {
                int idImmagine = Integer.parseInt(request.getParameter("idImmagine"));
                int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
                immagineProdottoDAO.delete(idImmagine);
                response.sendRedirect(request.getContextPath() + "/admin/immagini-prodotto?idProdotto=" + idProdotto);
                return;
            }

            if ("setMain".equalsIgnoreCase(action)) {
                int idImmagine = Integer.parseInt(request.getParameter("idImmagine"));
                int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
                immagineProdottoDAO.resetMainImage(idProdotto);
                immagineProdottoDAO.setMainImage(idImmagine);
                response.sendRedirect(request.getContextPath() + "/admin/immagini-prodotto?idProdotto=" + idProdotto);
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

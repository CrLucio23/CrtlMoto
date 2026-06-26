package control;

import dao.CategoriaDAO;
import dao.ImmagineProdottoDAO;
import dao.MarcaDAO;
import dao.ProdottoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.ImmagineProdotto;
import model.Prodotto;
import utils.ImageUploadUtils;
import utils.ValidationUtils;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/admin/prodotti")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class AdminProdottiServlet extends HttpServlet {

    private final ProdottoDAO prodottoDAO = new ProdottoDAO();
    private final ImmagineProdottoDAO immagineProdottoDAO = new ImmagineProdottoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    private final MarcaDAO marcaDAO = new MarcaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            request.setAttribute("categorie", categoriaDAO.findAll());
            request.setAttribute("marche", marcaDAO.findAll());

            if ("edit".equalsIgnoreCase(action)) {
                Integer id = ValidationUtils.parseInteger(request.getParameter("id"));
                if (id == null || id <= 0) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID prodotto non valido");
                    return;
                }

                request.setAttribute("prodotto", prodottoDAO.findById(id));
                request.getRequestDispatcher("/admin/prodotto-form.jsp").forward(request, response);
                return;
            }

            if ("new".equalsIgnoreCase(action)) {
                request.getRequestDispatcher("/admin/prodotto-form.jsp").forward(request, response);
                return;
            }

            request.setAttribute("prodotti", prodottoDAO.findAllForAdmin());
            request.getRequestDispatcher("/admin/prodotti.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("delete".equalsIgnoreCase(action)) {
                Integer id = ValidationUtils.parseInteger(request.getParameter("id"));
                if (id == null || id <= 0) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID prodotto non valido");
                    return;
                }

                prodottoDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/admin/prodotti");
                return;
            }

            String nomeProdotto = ValidationUtils.clean(request.getParameter("nomeProdotto"));
            String descrizione = ValidationUtils.clean(request.getParameter("descrizione"));
            BigDecimal prezzoBase = ValidationUtils.parseBigDecimal(request.getParameter("prezzoBase"));
            Integer scontoPercentuale = ValidationUtils.parseInteger(request.getParameter("scontoPercentuale"));
            Integer quantitaMagazzino = ValidationUtils.parseInteger(request.getParameter("quantitaMagazzino"));
            String taglia = ValidationUtils.clean(request.getParameter("taglia"));
            String colore = ValidationUtils.clean(request.getParameter("colore"));
            String compatibilita = ValidationUtils.clean(request.getParameter("compatibilita"));
            Integer idCategoria = ValidationUtils.parseInteger(request.getParameter("idCategoria"));
            Integer idMarca = ValidationUtils.parseInteger(request.getParameter("idMarca"));
            Part immaginePart = request.getPart("immagine");

            if (ValidationUtils.isNullOrBlank(nomeProdotto)) {
                request.setAttribute("errore", "Il nome prodotto è obbligatorio.");
                reloadFormData(request, response);
                return;
            }

            if (prezzoBase == null || !ValidationUtils.isPositiveOrZero(prezzoBase)) {
                request.setAttribute("errore", "Il prezzo base deve essere un numero valido maggiore o uguale a 0.");
                reloadFormData(request, response);
                return;
            }

            if (scontoPercentuale == null) {
                scontoPercentuale = 0;
            }
            if (!ValidationUtils.isValidDiscount(scontoPercentuale)) {
                request.setAttribute("errore", "Lo sconto deve essere compreso tra 0 e 100.");
                reloadFormData(request, response);
                return;
            }

            if (quantitaMagazzino == null) {
                quantitaMagazzino = 0;
            }
            if (!ValidationUtils.isPositiveOrZero(quantitaMagazzino)) {
                request.setAttribute("errore", "La quantità in magazzino deve essere maggiore o uguale a 0.");
                reloadFormData(request, response);
                return;
            }

            if (!ImageUploadUtils.isValidProductImage(immaginePart)) {
                request.setAttribute("errore", "La foto prodotto deve essere un'immagine valida: JPG, PNG, WEBP o GIF.");
                reloadFormData(request, response);
                return;
            }

            Prodotto p = new Prodotto();
            p.setNomeProdotto(nomeProdotto);
            p.setDescrizione(descrizione);
            p.setPrezzoBase(prezzoBase);
            p.setScontoPercentuale(scontoPercentuale);
            p.setQuantitaMagazzino(quantitaMagazzino);
            p.setTaglia(taglia);
            p.setColore(colore);
            p.setCompatibilita(compatibilita);
            p.setIdCategoria(idCategoria);
            p.setIdMarca(idMarca);

            if ("update".equalsIgnoreCase(action)) {
                Integer id = ValidationUtils.parseInteger(request.getParameter("id"));
                if (id == null || id <= 0) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID prodotto non valido");
                    return;
                }

                p.setIdProdotto(id);
                prodottoDAO.update(p);
                saveMainImageIfPresent(immaginePart, id);
            } else {
                int idProdotto = prodottoDAO.save(p);
                saveMainImageIfPresent(immaginePart, idProdotto);
            }

            response.sendRedirect(request.getContextPath() + "/admin/prodotti");

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void reloadFormData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        request.setAttribute("categorie", categoriaDAO.findAll());
        request.setAttribute("marche", marcaDAO.findAll());
        request.getRequestDispatcher("/admin/prodotto-form.jsp").forward(request, response);
    }

    private void saveMainImageIfPresent(Part immaginePart, int idProdotto) throws IOException, SQLException {
        if (!ImageUploadUtils.hasUploadedFile(immaginePart)) {
            return;
        }

        String urlImmagine = ImageUploadUtils.saveProductImage(getServletContext(), immaginePart, idProdotto);
        if (urlImmagine == null) {
            throw new IOException("Immagine prodotto non valida");
        }

        ImmagineProdotto img = new ImmagineProdotto();
        img.setUrlImmagine(urlImmagine);
        img.setIdProdotto(idProdotto);
        img.setPrincipale(true);

        immagineProdottoDAO.resetMainImage(idProdotto);
        immagineProdottoDAO.save(img);
    }
}

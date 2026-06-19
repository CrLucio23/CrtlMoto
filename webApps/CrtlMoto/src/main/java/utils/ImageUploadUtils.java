package utils;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

public class ImageUploadUtils {

    private static final String PRODUCT_UPLOAD_DIR = "/images/products";
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of(".jpg", ".jpeg", ".png", ".webp", ".gif");
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg",
            "image/png",
            "image/webp",
            "image/gif"
    );

    public static boolean hasUploadedFile(Part imagePart) {
        return imagePart != null && imagePart.getSize() > 0;
    }

    public static boolean isValidProductImage(Part imagePart) {
        if (!hasUploadedFile(imagePart)) {
            return true;
        }

        String contentType = imagePart.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase(Locale.ROOT))) {
            return false;
        }

        String submittedFileName = imagePart.getSubmittedFileName();
        if (ValidationUtils.isNullOrBlank(submittedFileName)) {
            return false;
        }

        String submittedName = Path.of(submittedFileName).getFileName().toString();
        return getAllowedExtension(submittedName) != null;
    }

    public static String saveProductImage(ServletContext servletContext, Part imagePart, int idProdotto)
            throws IOException {
        if (!hasUploadedFile(imagePart)) {
            return null;
        }

        String contentType = imagePart.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase(Locale.ROOT))) {
            return null;
        }

        String submittedFileName = imagePart.getSubmittedFileName();
        if (ValidationUtils.isNullOrBlank(submittedFileName)) {
            return null;
        }

        String submittedName = Path.of(submittedFileName).getFileName().toString();
        String extension = getAllowedExtension(submittedName);
        if (extension == null) {
            return null;
        }

        String uploadPath = servletContext.getRealPath(PRODUCT_UPLOAD_DIR);
        if (uploadPath == null) {
            throw new IOException("Cartella upload non disponibile");
        }

        Path uploadDir = Path.of(uploadPath);
        Files.createDirectories(uploadDir);

        String fileName = "product-" + idProdotto + "-" + UUID.randomUUID() + extension;
        Path destination = uploadDir.resolve(fileName).normalize();
        if (!destination.startsWith(uploadDir)) {
            return null;
        }

        imagePart.write(destination.toString());
        return PRODUCT_UPLOAD_DIR + "/" + fileName;
    }

    private static String getAllowedExtension(String fileName) {
        if (ValidationUtils.isNullOrBlank(fileName)) {
            return null;
        }

        String lowerName = fileName.toLowerCase(Locale.ROOT);
        for (String extension : ALLOWED_EXTENSIONS) {
            if (lowerName.endsWith(extension)) {
                return extension;
            }
        }

        return null;
    }
}

package utils;

import jakarta.servlet.http.HttpServletRequest;

public class ImageUtils {

    public static String resolve(HttpServletRequest request, String imageUrl) {
        if (ValidationUtils.isNullOrBlank(imageUrl)) {
            return request.getContextPath() + "/images/no-image.png";
        }

        String url = imageUrl.trim();
        if (url.startsWith("http://") || url.startsWith("https://")) {
            return url;
        }

        String contextPath = request.getContextPath();
        if (url.startsWith(contextPath + "/")) {
            return url;
        }

        if (url.startsWith("/")) {
            return contextPath + url;
        }

        return contextPath + "/" + url;
    }
}

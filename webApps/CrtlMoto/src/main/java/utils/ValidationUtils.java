package utils;

import java.math.BigDecimal;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.regex.Pattern;

public class ValidationUtils {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private static final Pattern CAP_PATTERN =
            Pattern.compile("^\\d{5}$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^[0-9+ ]{6,20}$");

    public static boolean isNullOrBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static String clean(String value) {
        return value == null ? null : value.trim();
    }

    public static boolean isValidEmail(String email) {
        return !isNullOrBlank(email) && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidCAP(String cap) {
        return !isNullOrBlank(cap) && CAP_PATTERN.matcher(cap.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        return isNullOrBlank(phone) || PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public static boolean hasMinLength(String value, int min) {
        return value != null && value.trim().length() >= min;
    }

    public static Integer parseInteger(String value) {
        try {
            if (isNullOrBlank(value)) {
                return null;
            }
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static BigDecimal parseBigDecimal(String value) {
        try {
            if (isNullOrBlank(value)) {
                return null;
            }
            return new BigDecimal(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static boolean isPositiveOrZero(Integer value) {
        return value != null && value >= 0;
    }

    public static boolean isPositive(Integer value) {
        return value != null && value > 0;
    }

    public static boolean isValidDiscount(Integer value) {
        return value != null && value >= 0 && value <= 100;
    }

    public static boolean isPositiveOrZero(BigDecimal value) {
        return value != null && value.compareTo(BigDecimal.ZERO) >= 0;
    }

    public static boolean isValidYear(Integer year) {
        return year == null || (year >= 1900 && year <= 2100);
    }

    public static boolean isValidImageUrl(String url) {
        if (isNullOrBlank(url) || url.length() > 500) {
            return false;
        }

        try {
            URI uri = new URI(url.trim());
            String scheme = uri.getScheme();
            String path = uri.getPath() != null ? uri.getPath().toLowerCase() : "";

            boolean allowedScheme = scheme == null
                    || "https".equalsIgnoreCase(scheme)
                    || "http".equalsIgnoreCase(scheme);
            boolean allowedExtension = path.endsWith(".jpg")
                    || path.endsWith(".jpeg")
                    || path.endsWith(".png")
                    || path.endsWith(".webp")
                    || path.endsWith(".gif");

            return allowedScheme && allowedExtension && !url.contains("\"") && !url.contains("'");
        } catch (URISyntaxException e) {
            return false;
        }
    }
}
